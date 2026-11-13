package LibraryManagement;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet(name = "CreatePdf", urlPatterns = {"/CreatePdf"})
public class CreatePdf extends HttpServlet {

    private static final BaseColor NAVY = new BaseColor(15, 23, 42);       // #0F172A
    private static final BaseColor BLUE = new BaseColor(37, 99, 235);      // #2563EB
    private static final BaseColor GREEN = new BaseColor(22, 163, 74);     // #16A34A
    private static final BaseColor LIGHT_BG = new BaseColor(248, 250, 252);
    private static final BaseColor BORDER_COLOR = new BaseColor(226, 232, 240);
    private static final BaseColor TEXT_DARK = new BaseColor(30, 41, 59);

    private static final Font FONT_HEADER_TITLE = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, NAVY);
    private static final Font FONT_HEADER_SUB = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.DARK_GRAY);
    private static final Font FONT_LABEL = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, BaseColor.GRAY);
    private static final Font FONT_VAL = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, TEXT_DARK);
    private static final Font FONT_TH = new Font(Font.FontFamily.HELVETICA, 9.5f, Font.BOLD, BaseColor.WHITE);
    private static final Font FONT_TD = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, TEXT_DARK);
    private static final Font FONT_TD_BOLD = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, TEXT_DARK);
    private static final Font FONT_SMALL = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, BaseColor.DARK_GRAY);
    private static final Font FONT_BADGE = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, BaseColor.WHITE);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses = request.getSession(false);
        if (ses == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String title = (String) ses.getAttribute("title");
        String name = (String) ses.getAttribute("USER");
        String email = (String) ses.getAttribute("email");
        LocalDate issue = (LocalDate) ses.getAttribute("Issue");
        LocalDate due = (LocalDate) ses.getAttribute("Due");

        if (title == null || name == null) {
            response.sendRedirect("BrowseBooksServlet");
            return;
        }

        try {
            String dirPath = getServletContext().getRealPath("/Issue");
            if (dirPath == null) {
                dirPath = System.getProperty("java.io.tmpdir") + File.separator + "Issue";
            }
            File folder = new File(dirPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }

            String safeTitle = title.replaceAll("[^a-zA-Z0-9.-]", "_");
            String fileName = safeTitle + "_" + System.currentTimeMillis() + ".pdf";
            File pdfFile = new File(folder, fileName);
            String filePath = pdfFile.getAbsolutePath();

            String issueStr = (issue != null) ? issue.toString() : LocalDate.now().toString();
            String dueStr = (due != null) ? due.toString() : LocalDate.now().plusDays(20).toString();

            createReceipt(filePath, name, email, title, issueStr, dueStr);

            ses.setAttribute("pdfPath", filePath);
            RequestDispatcher rd = request.getRequestDispatcher("SendUserMail.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BrowseBooksServlet?status=notdone");
        }
    }

    public static void createReceipt(String filePath, String studentName, String studentEmail, String bookTitle, String issueDateStr, String dueDateStr) throws Exception {
        Document doc = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter.getInstance(doc, new FileOutputStream(filePath));
        doc.open();

        long recId = System.currentTimeMillis() % 1000000;
        String receiptNo = "LMS-" + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE) + "-" + recId;

        // Top Header Banner
        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{65f, 35f});

        PdfPCell headerLeft = new PdfPCell();
        headerLeft.setBorder(Rectangle.NO_BORDER);
        Paragraph brand = new Paragraph("LIBRARY MANAGEMENT SYSTEM", FONT_HEADER_TITLE);
        brand.setSpacingAfter(2);
        Paragraph docType = new Paragraph("OFFICIAL BORROWING TRANSACTION RECEIPT", FONT_HEADER_SUB);
        docType.setSpacingAfter(4);
        Paragraph portal = new Paragraph("Live Portal: librarymanagementsystemproject-l8aw.onrender.com", FONT_SMALL);
        headerLeft.addElement(brand);
        headerLeft.addElement(docType);
        headerLeft.addElement(portal);

        PdfPCell headerRight = new PdfPCell();
        headerRight.setBorder(Rectangle.NO_BORDER);
        headerRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
        Paragraph rNo = new Paragraph("RECEIPT NO:\n" + receiptNo, new Font(Font.FontFamily.COURIER, 9, Font.BOLD, NAVY));
        rNo.setAlignment(Element.ALIGN_RIGHT);
        rNo.setSpacingAfter(6);

        PdfPTable badgeTable = new PdfPTable(1);
        badgeTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
        badgeTable.setWidthPercentage(60);
        PdfPCell badge = new PdfPCell(new Phrase("ACTIVE LOAN", FONT_BADGE));
        badge.setBackgroundColor(GREEN);
        badge.setHorizontalAlignment(Element.ALIGN_CENTER);
        badge.setVerticalAlignment(Element.ALIGN_MIDDLE);
        badge.setPadding(4);
        badge.setBorder(Rectangle.NO_BORDER);
        badgeTable.addCell(badge);

        headerRight.addElement(rNo);
        headerRight.addElement(badgeTable);

        headerTable.addCell(headerLeft);
        headerTable.addCell(headerRight);
        doc.add(headerTable);

        // Divider Line
        doc.add(new Paragraph(" "));
        PdfPTable divider = new PdfPTable(1);
        divider.setWidthPercentage(100);
        divider.setSpacingAfter(14);
        PdfPCell lineCell = new PdfPCell();
        lineCell.setBorder(Rectangle.BOTTOM);
        lineCell.setBorderColor(BLUE);
        lineCell.setBorderWidth(2f);
        lineCell.setFixedHeight(2);
        divider.addCell(lineCell);
        doc.add(divider);

        // Info Cards (Borrower Details & Loan Terms)
        PdfPTable infoGrid = new PdfPTable(2);
        infoGrid.setWidthPercentage(100);
        infoGrid.setWidths(new float[]{50f, 50f});
        infoGrid.setSpacingAfter(16);

        PdfPCell col1 = new PdfPCell();
        col1.setBackgroundColor(LIGHT_BG);
        col1.setBorderColor(BORDER_COLOR);
        col1.setPadding(10);
        col1.addElement(new Paragraph("BORROWER INFORMATION", FONT_LABEL));
        col1.addElement(new Paragraph(studentName, FONT_VAL));
        col1.addElement(new Paragraph((studentEmail != null && !studentEmail.isEmpty()) ? studentEmail : "Registered Student", FONT_TD));

        PdfPCell col2 = new PdfPCell();
        col2.setBackgroundColor(LIGHT_BG);
        col2.setBorderColor(BORDER_COLOR);
        col2.setPadding(10);
        col2.addElement(new Paragraph("LOAN DURATION & TERMS", FONT_LABEL));
        col2.addElement(new Paragraph("20 Calendar Days Standard Loan", FONT_VAL));
        col2.addElement(new Paragraph("Return on or before due date to avoid fines", FONT_TD));

        infoGrid.addCell(col1);
        infoGrid.addCell(col2);
        doc.add(infoGrid);

        // Transaction Table
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{8f, 44f, 16f, 16f, 16f});
        table.setSpacingAfter(18);

        String[] headers = {"#", "Book Title", "Issue Date", "Due Date", "Status"};
        for (String h : headers) {
            PdfPCell c = new PdfPCell(new Phrase(h, FONT_TH));
            c.setBackgroundColor(NAVY);
            c.setPadding(7);
            c.setBorderColor(NAVY);
            table.addCell(c);
        }

        PdfPCell c1 = new PdfPCell(new Phrase("1", FONT_TD));
        PdfPCell c2 = new PdfPCell(new Phrase(bookTitle, FONT_TD_BOLD));
        PdfPCell c3 = new PdfPCell(new Phrase(issueDateStr, FONT_TD));
        PdfPCell c4 = new PdfPCell(new Phrase(dueDateStr, new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, BLUE)));
        PdfPCell c5 = new PdfPCell(new Phrase("Issued", new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, GREEN)));

        for (PdfPCell cell : new PdfPCell[]{c1, c2, c3, c4, c5}) {
            cell.setPadding(8);
            cell.setBorderColor(BORDER_COLOR);
            table.addCell(cell);
        }
        doc.add(table);

        // Guidelines Card
        PdfPTable noteTable = new PdfPTable(1);
        noteTable.setWidthPercentage(100);
        noteTable.setSpacingAfter(20);
        PdfPCell noteCell = new PdfPCell();
        noteCell.setBackgroundColor(new BaseColor(254, 243, 199)); // amber light
        noteCell.setBorderColor(new BaseColor(245, 158, 11));
        noteCell.setBorderWidth(1f);
        noteCell.setPadding(10);
        Paragraph noteHead = new Paragraph("IMPORTANT RETURN INSTRUCTIONS", new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, new BaseColor(180, 83, 9)));
        noteHead.setSpacingAfter(3);
        Paragraph noteBody = new Paragraph(
                "• Please preserve this receipt for your records.\n"
                + "• Return the book to the library desk or use the 'Return Book' feature in your online Student Portal.\n"
                + "• Books must be returned in good condition. Late returns or damages are subject to institutional library regulations.",
                FONT_SMALL);
        noteCell.addElement(noteHead);
        noteCell.addElement(noteBody);
        noteTable.addCell(noteCell);
        doc.add(noteTable);

        // Footer signature
        PdfPTable footer = new PdfPTable(2);
        footer.setWidthPercentage(100);
        footer.setWidths(new float[]{70f, 30f});

        PdfPCell fLeft = new PdfPCell(new Phrase("Digitally authorized transaction by Library Management System\nGenerated: " + LocalDate.now(), FONT_SMALL));
        fLeft.setBorder(Rectangle.NO_BORDER);

        PdfPCell fRight = new PdfPCell(new Phrase("[ Verified Digital Record ]", new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, NAVY)));
        fRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
        fRight.setBorder(Rectangle.NO_BORDER);

        footer.addCell(fLeft);
        footer.addCell(fRight);
        doc.add(footer);

        doc.close();
    }
}
