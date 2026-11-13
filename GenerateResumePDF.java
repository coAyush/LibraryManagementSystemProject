import java.io.FileOutputStream;
import java.io.File;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class GenerateResumePDF {

    private static final BaseColor COLOR_PRIMARY = new BaseColor(15, 23, 42);     // #0F172A
    private static final BaseColor COLOR_HEADING = new BaseColor(30, 58, 138);    // #1E3A8A Navy
    private static final BaseColor COLOR_LINK = new BaseColor(37, 99, 235);       // #2563EB Blue
    private static final BaseColor COLOR_LINE = new BaseColor(203, 213, 225);     // #CBD5E1
    private static final BaseColor COLOR_TEXT = new BaseColor(30, 41, 59);        // #1E293B Charcoal

    private static final Font FONT_NAME = new Font(Font.FontFamily.HELVETICA, 17, Font.BOLD, COLOR_PRIMARY);
    private static final Font FONT_CONTACT = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_TEXT);
    private static final Font FONT_CONTACT_LINK = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_LINK);
    private static final Font FONT_SEC_HEAD = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, COLOR_HEADING);
    private static final Font FONT_BODY = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_TEXT);
    private static final Font FONT_BODY_BOLD = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, COLOR_TEXT);
    private static final Font FONT_BODY_ITALIC = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.ITALIC, COLOR_TEXT);
    private static final Font FONT_ITEM_TITLE = new Font(Font.FontFamily.HELVETICA, 9f, Font.BOLD, COLOR_PRIMARY);
    private static final Font FONT_DATE = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.ITALIC, BaseColor.DARK_GRAY);
    private static final Font FONT_TECH = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.ITALIC, new BaseColor(71, 85, 105));
    private static final Font FONT_LINK = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_LINK);

    public static void main(String[] args) {
        String dest = "Ayush_Chowdhury_Resume.pdf";
        try {
            // Tight margins to ensure strict 1-page fit
            Document doc = new Document(PageSize.A4, 34, 34, 28, 28);
            PdfWriter writer = PdfWriter.getInstance(doc, new FileOutputStream(dest));
            doc.open();

            // HEADER: Name
            Paragraph nameP = new Paragraph("AYUSH CHOWDHURY", FONT_NAME);
            nameP.setAlignment(Element.ALIGN_CENTER);
            nameP.setSpacingAfter(3);
            doc.add(nameP);

            // Contact Info with Clickable Links
            Paragraph contactP = new Paragraph();
            contactP.setAlignment(Element.ALIGN_CENTER);
            contactP.setSpacingAfter(4);
            contactP.add(new Chunk("Kolkata, West Bengal  |  +91-9123846264  |  ", FONT_CONTACT));

            Chunk mailChunk = new Chunk("chowdhuryayush7@gmail.com", FONT_CONTACT_LINK);
            mailChunk.setAnchor("mailto:chowdhuryayush7@gmail.com");
            contactP.add(mailChunk);
            contactP.add(new Chunk("  |  ", FONT_CONTACT));

            Chunk liChunk = new Chunk("linkedin.com/in/ayush-chowdhury-6a7858293", FONT_CONTACT_LINK);
            liChunk.setAnchor("https://linkedin.com/in/ayush-chowdhury-6a7858293");
            contactP.add(liChunk);
            contactP.add(new Chunk("  |  ", FONT_CONTACT));

            Chunk ghChunk = new Chunk("github.com/coAyush", FONT_CONTACT_LINK);
            ghChunk.setAnchor("https://github.com/coAyush");
            contactP.add(ghChunk);
            doc.add(contactP);

            // Divider under contact
            addDivider(doc);

            // 1. PROFESSIONAL SUMMARY
            addSectionHeader(doc, "PROFESSIONAL SUMMARY");
            Paragraph sumP = new Paragraph(
                    "Adaptable and detail-oriented Software Engineer and MCA graduate with strong foundational knowledge in object-oriented programming, relational databases, RESTful web services, and cloud integration. Experienced in developing backend modules, designing secure APIs, containerizing applications with Docker, and collaborating across full-stack environments. A fast learner with solid problem-solving abilities and a strong commitment to building clean, maintainable software across diverse engineering roles.",
                    FONT_BODY);
            sumP.setLeading(11.5f);
            sumP.setSpacingAfter(6);
            doc.add(sumP);

            // 2. TECHNICAL SKILLS
            addSectionHeader(doc, "TECHNICAL SKILLS");
            PdfPTable skillsTable = new PdfPTable(2);
            skillsTable.setWidthPercentage(100);
            skillsTable.setWidths(new float[]{22f, 78f});
            skillsTable.setSpacingAfter(6);

            addSkillRow(skillsTable, "Languages:", "Java, SQL, JavaScript, HTML5, CSS3");
            addSkillRow(skillsTable, "Frameworks & Web:", "Spring Boot, Spring MVC, REST APIs, React, Tailwind CSS, JSP, Servlets");
            addSkillRow(skillsTable, "Databases:", "PostgreSQL, MySQL, Flyway Database Migrations");
            addSkillRow(skillsTable, "Tools & Practices:", "Git, GitHub, Docker, Postman, Maven, Swagger/OpenAPI");
            doc.add(skillsTable);

            // 3. WORK EXPERIENCE
            addSectionHeader(doc, "WORK EXPERIENCE");

            // Job 1: Keross
            addEntryHeader(doc, "Junior Software Engineer Trainee — Keross R&D Center Pvt. Ltd.", "Jun 2026 – Present");
            addBullet(doc, "Engineered core application modules using Spring Boot, PostgreSQL, and AWS S3, implementing phone OTP authentication with JWT tokens, configurable expiration limits, and Flyway migrations.");
            addBullet(doc, "Developed prescription-processing workflows utilizing Spring AI ChatClient to extract and structure information from uploaded medical documents.");
            addBullet(doc, "Implemented secure REST APIs for dosage management, health metrics, and utility bill tracking using DTO patterns and scheduled background jobs for automated notifications.");

            // Job 2: MR2K
            addEntryHeader(doc, "Software Developer Intern — MR2K Solutions LLP", "Mar 2026 – Jun 2026");
            Paragraph subP = new Paragraph("BWDP Construction Platform — Production App (1K+ Play Store Downloads)", FONT_TECH);
            subP.setLeading(10.5f);
            subP.setSpacingAfter(2);
            doc.add(subP);
            addBullet(doc, "Developed backend REST APIs for the BWDP Construction platform (1K+ Play Store downloads), powering contractor, seller, and admin modules for project workflows and quotation management.");
            addBullet(doc, "Implemented multi-tier inventory verification pipelines using PostgreSQL and MyBatis, ensuring verified catalog items across mobile and web clients.");
            addBullet(doc, "Containerized backend services using Docker for uniform deployment environments and documented all endpoints using Swagger/OpenAPI.");

            // 4. PROJECTS
            addSectionHeader(doc, "PROJECTS");

            // Project 1: DevToolBox
            addProjectHeader(doc, "DevToolBox — Developer Utilities Web Platform", "GitHub", "https://github.com/coAyush");
            Paragraph dtbTech = new Paragraph("Spring Boot, REST APIs, Maven, Postman", FONT_TECH);
            dtbTech.setLeading(10.5f);
            dtbTech.setSpacingAfter(2);
            doc.add(dtbTech);
            addBullet(doc, "Built a collection of web utility services (URL shortener, QR code generator, UUID generator) with centralized error handling, request validation, and clean RESTful design.");
            addBullet(doc, "Configured automated Postman test suites to validate edge cases and guarantee response integrity across all endpoints.");

            // Project 2: Library Management System (UPDATED & ENHANCED)
            addProjectHeaderWithTwoLinks(doc,
                    "Library Management System — Full-Stack Web Application",
                    "GitHub", "https://github.com/coAyush/LibraryManagementSystemProject",
                    "Live Demo", "https://librarymanagementsystemproject-l8aw.onrender.com");

            Paragraph lmsTech = new Paragraph("Java, JSP, Servlets, JDBC, MySQL (TiDB Cloud), Docker, Maven, Brevo API, iText, Bootstrap 5", FONT_TECH);
            lmsTech.setLeading(10.5f);
            lmsTech.setSpacingAfter(2);
            doc.add(lmsTech);
            addBullet(doc, "Architected and deployed an MVC web app on Render with TiDB Cloud MySQL, featuring role-based access control (Admin/Student), real-time inventory tracking, and a responsive Bootstrap 5 catalog.");
            addBullet(doc, "Engineered automated iText PDF borrowing receipt generation and integrated Brevo HTTPS REST API for 2FA email OTP password recovery, containerized with multi-stage Docker builds.");

            // 5. EDUCATION
            addSectionHeader(doc, "EDUCATION");
            addEntryHeader(doc, "Master of Computer Applications (MCA) — Heritage Institute of Technology", "2024 – 2026 | CGPA: 8.32");
            addEntryHeader(doc, "Bachelor of Science in Physics — University of Calcutta", "2020 – 2023 | CGPA: 7.89");

            // 6. CERTIFICATIONS
            addSectionHeader(doc, "CERTIFICATIONS");
            addEntryHeader(doc, "Aptech Smart Pro Java Web Application Development", "Aug 2025");

            doc.close();

            // Verify page count
            PdfReader reader = new PdfReader(dest);
            int pages = reader.getNumberOfPages();
            reader.close();

            System.out.println("SUCCESS: Resume generated at " + dest + " | Total Pages: " + pages);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void addSectionHeader(Document doc, String title) throws DocumentException {
        Paragraph p = new Paragraph(title, FONT_SEC_HEAD);
        p.setSpacingBefore(5);
        p.setSpacingAfter(2);
        doc.add(p);
        addDivider(doc);
    }

    private static void addDivider(Document doc) throws DocumentException {
        PdfPTable line = new PdfPTable(1);
        line.setWidthPercentage(100);
        line.setSpacingAfter(4);
        PdfPCell c = new PdfPCell();
        c.setBorder(Rectangle.BOTTOM);
        c.setBorderColor(COLOR_LINE);
        c.setBorderWidth(0.8f);
        c.setFixedHeight(1);
        line.addCell(c);
        doc.add(line);
    }

    private static void addSkillRow(PdfPTable table, String label, String value) {
        PdfPCell c1 = new PdfPCell(new Phrase(label, FONT_BODY_BOLD));
        c1.setBorder(Rectangle.NO_BORDER);
        c1.setPaddingTop(1f);
        c1.setPaddingBottom(1f);

        PdfPCell c2 = new PdfPCell(new Phrase(value, FONT_BODY));
        c2.setBorder(Rectangle.NO_BORDER);
        c2.setPaddingTop(1f);
        c2.setPaddingBottom(1f);

        table.addCell(c1);
        table.addCell(c2);
    }

    private static void addEntryHeader(Document doc, String left, String right) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{72f, 28f});
        table.setSpacingBefore(2);
        table.setSpacingAfter(1);

        PdfPCell cLeft = new PdfPCell(new Phrase(left, FONT_ITEM_TITLE));
        cLeft.setBorder(Rectangle.NO_BORDER);
        cLeft.setPadding(0);

        PdfPCell cRight = new PdfPCell(new Phrase(right, FONT_DATE));
        cRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cRight.setBorder(Rectangle.NO_BORDER);
        cRight.setPadding(0);

        table.addCell(cLeft);
        table.addCell(cRight);
        doc.add(table);
    }

    private static void addProjectHeader(Document doc, String title, String linkText, String url) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{82f, 18f});
        table.setSpacingBefore(3);
        table.setSpacingAfter(1);

        PdfPCell cLeft = new PdfPCell(new Phrase(title, FONT_ITEM_TITLE));
        cLeft.setBorder(Rectangle.NO_BORDER);
        cLeft.setPadding(0);

        Chunk linkChunk = new Chunk(linkText, FONT_LINK);
        linkChunk.setAnchor(url);
        Paragraph rP = new Paragraph();
        rP.setAlignment(Element.ALIGN_RIGHT);
        rP.add(linkChunk);

        PdfPCell cRight = new PdfPCell(rP);
        cRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cRight.setBorder(Rectangle.NO_BORDER);
        cRight.setPadding(0);

        table.addCell(cLeft);
        table.addCell(cRight);
        doc.add(table);
    }

    private static void addProjectHeaderWithTwoLinks(Document doc, String title, String link1Text, String url1, String link2Text, String url2) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{74f, 26f});
        table.setSpacingBefore(3);
        table.setSpacingAfter(1);

        PdfPCell cLeft = new PdfPCell(new Phrase(title, FONT_ITEM_TITLE));
        cLeft.setBorder(Rectangle.NO_BORDER);
        cLeft.setPadding(0);

        Paragraph rP = new Paragraph();
        rP.setAlignment(Element.ALIGN_RIGHT);
        Chunk c1 = new Chunk(link1Text, FONT_LINK);
        c1.setAnchor(url1);
        rP.add(c1);
        rP.add(new Chunk(" | ", FONT_BODY));
        Chunk c2 = new Chunk(link2Text, FONT_LINK);
        c2.setAnchor(url2);
        rP.add(c2);

        PdfPCell cRight = new PdfPCell(rP);
        cRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cRight.setBorder(Rectangle.NO_BORDER);
        cRight.setPadding(0);

        table.addCell(cLeft);
        table.addCell(cRight);
        doc.add(table);
    }

    private static void addBullet(Document doc, String text) throws DocumentException {
        Paragraph p = new Paragraph();
        p.setLeading(11.5f);
        p.setIndentationLeft(12);
        p.setSpacingAfter(2.5f);
        p.add(new Chunk("•  ", FONT_BODY_BOLD));
        p.add(new Chunk(text, FONT_BODY));
        doc.add(p);
    }
}

