package LibraryManagement;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet(name = "CreatePdf", urlPatterns = {"/CreatePdf"})
public class CreatePdf extends HttpServlet {

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

            Document doc = new Document();
            PdfWriter.getInstance(doc, new FileOutputStream(filePath));
            doc.open();
            doc.add(new Paragraph("Book Issued Successfully\n\n"));
            PdfPTable table = new PdfPTable(4);
            table.addCell("Name");
            table.addCell("Title");
            table.addCell("Issue Date");
            table.addCell("Due Date");

            table.addCell(name);
            table.addCell(title);
            table.addCell(issue != null ? issue.toString() : LocalDate.now().toString());
            table.addCell(due != null ? due.toString() : LocalDate.now().plusDays(20).toString());
            doc.add(table);
            doc.close();

            ses.setAttribute("pdfPath", filePath);
            RequestDispatcher rd = request.getRequestDispatcher("SendUserMail.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("BrowseBooksServlet?status=notdone");
        }
    }
}
