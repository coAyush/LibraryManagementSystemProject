import java.io.FileOutputStream;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class GenerateDocumentationPDF {

    private static final BaseColor COLOR_PRIMARY = new BaseColor(24, 43, 73);      // Navy #182B49
    private static final BaseColor COLOR_SECONDARY = new BaseColor(41, 98, 160);   // Steel Blue #2962A0
    private static final BaseColor COLOR_TEXT_DARK = new BaseColor(45, 55, 72);    // Charcoal #2D3748
    private static final BaseColor COLOR_BG_LIGHT = new BaseColor(248, 249, 250);  // Off-white
    private static final BaseColor COLOR_BORDER = new BaseColor(226, 232, 240);    // Light Gray
    private static final BaseColor COLOR_ACCENT = new BaseColor(34, 139, 34);      // Forest Green
    private static final BaseColor COLOR_WARN_BG = new BaseColor(254, 243, 199);   // Amber bg
    private static final BaseColor COLOR_WARN_BORDER = new BaseColor(245, 158, 11);
    private static final BaseColor COLOR_CODE_BG = new BaseColor(241, 245, 249);

    private static Font FONT_DOC_TITLE = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD, COLOR_PRIMARY);
    private static Font FONT_DOC_SUBTITLE = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.DARK_GRAY);
    private static Font FONT_H1 = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, COLOR_PRIMARY);
    private static Font FONT_H2 = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, COLOR_SECONDARY);
    private static Font FONT_H3 = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, COLOR_TEXT_DARK);
    private static Font FONT_BODY = new Font(Font.FontFamily.HELVETICA, 9.5f, Font.NORMAL, COLOR_TEXT_DARK);
    private static Font FONT_BODY_BOLD = new Font(Font.FontFamily.HELVETICA, 9.5f, Font.BOLD, COLOR_TEXT_DARK);
    private static Font FONT_CODE = new Font(Font.FontFamily.COURIER, 8.5f, Font.NORMAL, new BaseColor(30, 41, 59));
    private static Font FONT_TH = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, BaseColor.WHITE);
    private static Font FONT_TD = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.NORMAL, COLOR_TEXT_DARK);
    private static Font FONT_TD_BOLD = new Font(Font.FontFamily.HELVETICA, 8.5f, Font.BOLD, COLOR_TEXT_DARK);
    private static Font FONT_FOOTER = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, BaseColor.GRAY);

    public static void main(String[] args) {
        String dest = "Library_Management_System_Complete_Guide_and_Interview_Handbook.pdf";
        try {
            Document doc = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(doc, new FileOutputStream(dest));
            writer.setPageEvent(new HeaderFooterPageEvent());

            doc.open();

            // 1. Title Banner
            addTitleBanner(doc);

            // 2. Section 1: Executive Overview & Live Production Architecture
            addSection1_ExecutiveOverview(doc);

            // 3. Section 2: Complete Transformation & Changes Made (Before vs After)
            addSection2_TransformationDetails(doc);

            // 4. Section 3: End-to-End System Mechanisms & User Flows
            addSection3_SystemFlows(doc);

            // 5. Section 4: Module-by-Module Technical Deep Dive
            addSection4_ModuleDeepDive(doc);

            // 6. Section 5: Database Schema & Entity Relationships
            addSection5_DatabaseSchema(doc);

            // 7. Section 6: Interview Preparation Guide & FAQs
            addSection6_InterviewPlaybook(doc);

            doc.close();
            System.out.println("SUCCESS: PDF generated at " + dest);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void addTitleBanner(Document doc) throws DocumentException {
        PdfPTable banner = new PdfPTable(1);
        banner.setWidthPercentage(100);
        banner.setSpacingAfter(15);

        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(COLOR_BG_LIGHT);
        cell.setBorderColor(COLOR_SECONDARY);
        cell.setBorderWidth(1.5f);
        cell.setPadding(14);

        Paragraph p1 = new Paragraph("LIBRARY MANAGEMENT SYSTEM", FONT_DOC_TITLE);
        p1.setSpacingAfter(4);
        Paragraph p2 = new Paragraph("Full-Stack Enterprise Architecture, Cloud Modernization & Interview Handbook", FONT_DOC_SUBTITLE);
        p2.setSpacingAfter(8);

        Paragraph meta = new Paragraph();
        meta.add(new Chunk("Live Deployment: ", FONT_BODY_BOLD));
        meta.add(new Chunk("https://librarymanagementsystemproject-l8aw.onrender.com\n", FONT_CODE));
        meta.add(new Chunk("Database: ", FONT_BODY_BOLD));
        meta.add(new Chunk("TiDB Cloud Serverless (AWS Tokyo) | ", FONT_BODY));
        meta.add(new Chunk("Email Gateway: ", FONT_BODY_BOLD));
        meta.add(new Chunk("Brevo v3 HTTPS REST API | ", FONT_BODY));
        meta.add(new Chunk("Container: ", FONT_BODY_BOLD));
        meta.add(new Chunk("Docker (Tomcat 9 / JRE 11)\n", FONT_BODY));
        meta.add(new Chunk("Generated for: ", FONT_BODY_BOLD));
        meta.add(new Chunk("Ayush Chowdhury | " + new SimpleDateFormat("MMMM yyyy").format(new Date()), FONT_BODY));

        cell.addElement(p1);
        cell.addElement(p2);
        cell.addElement(meta);
        banner.addCell(cell);
        doc.add(banner);
    }

    private static void addSection1_ExecutiveOverview(Document doc) throws DocumentException {
        addHeading1(doc, "1. Executive Summary & Live Cloud Architecture");

        addParagraph(doc, "The Library Management System (LMS) is an enterprise Java web application engineered to automate academic library operations: member registration, role-based authentication, real-time book catalog search, dynamic book issuing, automatic inventory decrement/increment, iText PDF receipt generation, and two-factor email OTP password recovery.");

        addParagraph(doc, "Originally authored as a legacy NetBeans/Ant project bound to a desktop MySQL server, the application underwent a complete cloud transformation. It was containerized with a multi-stage Docker build, modernized with Maven, and deployed onto Render with TiDB Cloud Serverless MySQL and Brevo Transactional Email REST API.");

        addSubHeading(doc, "High-Level Cloud Topology");

        PdfPTable archTable = new PdfPTable(3);
        archTable.setWidthPercentage(100);
        archTable.setSpacingBefore(6);
        archTable.setSpacingAfter(12);
        archTable.setWidths(new float[]{28f, 32f, 40f});

        addTableHeader(archTable, new String[]{"Tier / Component", "Technology / Provider", "Operational Role & Configuration"});
        addTableRow(archTable, new String[]{"Frontend Client", "Bootstrap 5 Responsive UI", "Mobile-first, dynamic grid cards, live JS filtering, modal alerts"});
        addTableRow(archTable, new String[]{"Application Tier", "Apache Tomcat 9 / JRE 11", "Render Web Service, multi-stage Docker container, dynamic $PORT"});
        addTableRow(archTable, new String[]{"Database Tier", "TiDB Cloud Serverless (MySQL 8)", "Cloud managed relational DB, SSL/TLS, auto-scaling, persistent tables"});
        addTableRow(archTable, new String[]{"Email Delivery", "Brevo v3 HTTPS REST API", "Bypasses cloud SMTP port 587 block, delivers OTPs & PDF receipts"});
        addTableRow(archTable, new String[]{"Document Engine", "iText PDF 5.5.13", "Dynamic transaction receipt generator embedded directly in servlets"});
        addTableRow(archTable, new String[]{"Build & Packaging", "Apache Maven 3.9", "Standardized pom.xml, automated WAR packaging, CI/CD ready"});
        doc.add(archTable);
    }

    private static void addSection2_TransformationDetails(Document doc) throws DocumentException {
        addHeading1(doc, "2. Comprehensive Changelog: Before vs After Modernization");

        addParagraph(doc, "The codebase was comprehensively refactored from a rigid legacy local desktop app to a resilient, production-ready cloud service. The table below documents every key architectural and functional change made:");

        PdfPTable t = new PdfPTable(3);
        t.setWidthPercentage(100);
        t.setSpacingBefore(6);
        t.setSpacingAfter(12);
        t.setWidths(new float[]{22f, 38f, 40f});

        addTableHeader(t, new String[]{"Area", "Legacy State (Before)", "Modernized State (After)"});

        addTableRow(t, new String[]{
            "Database Connectivity",
            "Hardcoded DriverManager.getConnection(\"jdbc:mysql://localhost:3306/library\",\"root\",\"...\") scattered inside every servlet.",
            "Centralized DBConnection.java. Auto-parses DATABASE_URL, JDBC_DATABASE_URL, DB_HOST/PORT, and provider aliases (TiDB, Aiven, Railway). Automatically enables SSL with trustServerCertificate=true."
        });

        addTableRow(t, new String[]{
            "Build Automation",
            "Apache Ant build.xml tied to NetBeans IDE paths. Could not build on CI/CD or Docker without NetBeans runtime.",
            "Created clean Maven pom.xml with standard dependencies (mysql-connector-j, itextpdf, javax.mail, cos). Standard 'mvn clean package' builds 44MB self-contained WAR in seconds."
        });

        addTableRow(t, new String[]{
            "Containerization",
            "No Dockerfile or Compose file. Manual deployment on desktop Tomcat only.",
            "Multi-stage Dockerfile: Stage 1 builds WAR using Eclipse Temurin 11 + Maven; Stage 2 deploys to tomcat:9.0-jre11-temurin with dynamic $PORT binding for Render and memory limits (-Xmx384m)."
        });

        addTableRow(t, new String[]{
            "Mobile UI / Responsive Design",
            "Rigid desktop-only CSS grids (grid-template-columns: 200px 200px 200px 200px), fixed pixel tables, cut off on smartphones.",
            "Upgraded all 12 JSP/HTML pages to responsive Bootstrap 5: mobile drawer toggler, responsive card grids (col-12 col-sm-6 col-lg-3), touch-friendly inputs, overflow-x auto tables."
        });

        addTableRow(t, new String[]{
            "Inventory & Stock Consistency",
            "Race conditions during book issue/return. Returning a book did not verify whether the user actually borrowed it. Case-sensitive title updates.",
            "Enforced atomic count decrement/increment. Return.java validates loan record in 'issue' table before adjusting stock. AddExisting.java uses case-insensitive LOWER(TRIM(title)) matching."
        });

        addTableRow(t, new String[]{
            "Email & Cloud SMTP Blocks",
            "JavaMail SMTP over port 587. Render Free Tier blocks outbound SMTP ports 25, 465, and 587, causing socket timeout and breaking OTP.",
            "Integrated Brevo v3 Transactional Email REST API over HTTPS (Port 443). Also added on-screen dev OTP fallback and Render server logging for instant zero-config testing."
        });

        addTableRow(t, new String[]{
            "Error Diagnostics",
            "LoginServlet masked all database exceptions behind generic alert('Server error occurred. Please try again.').",
            "Sanitized explicit error feedback: catches SQLException, reports connection/credential details safely, and advises exact remediation steps."
        });

        addTableRow(t, new String[]{
            "Memory & Resource Leaks",
            "Tomcat shutdown threw IllegalStateException from AbandonedConnectionCleanupThread and un-deregistered JDBC drivers.",
            "Refresh.java ServletContextListener shuts down AbandonedConnectionCleanupThread and deregisters all JDBC drivers gracefully on contextDestroyed."
        });

        doc.add(t);
    }

    private static void addSection3_SystemFlows(Document doc) throws DocumentException {
        addHeading1(doc, "3. End-to-End System Mechanisms & Execution Flows");

        addSubHeading(doc, "3.1 Authentication & Role-Based Authorization Flow");
        addParagraph(doc, "1. Client submits credentials via Login.jsp to LoginServlet (POST).\n"
                + "2. LoginServlet queries users table using parameterized PreparedStatement (WHERE Name=? AND email=? AND Role=?).\n"
                + "3. On credential match, session is initialized: session.setAttribute(\"USER\", user), session.setAttribute(\"Role\", role), session.setAttribute(\"ID\", id).\n"
                + "4. Role-based dispatch: Admin is redirected to Admin.jsp; Student is redirected to Home.jsp.\n"
                + "5. All protected pages (Home.jsp, Admin.jsp, MyAccount.jsp, Return.jsp) enforce session guards at top: if session.getAttribute(\"USER\") == null, redirect to Login.jsp immediately.");

        addSubHeading(doc, "3.2 Two-Factor Password Recovery & OTP Verification Flow");
        addParagraph(doc, "1. User enters registered email on forgotPassword.jsp and submits to GenerateOtp servlet.\n"
                + "2. GenerateOtp creates a 4-digit cryptographically random code (1000-9999), stores it in session, logs it to server stdout, and redirects to OtpVerification.jsp.\n"
                + "3. OtpVerification invokes EmailUtil.sendEmail(to, subject, text):\n"
                + "   - If BREVO_API_KEY is configured, sends HTTPS POST to https://api.brevo.com/v3/smtp/email (Port 443).\n"
                + "   - If SMTP is used locally, sends via smtp.gmail.com.\n"
                + "4. User enters 4-digit OTP on forgotPassword.jsp; VerifyOtp validates session OTP against user input.\n"
                + "5. Upon verification, Step 3 form is revealed. User enters new password, which is updated in TiDB by PasswordReset servlet.");

        addSubHeading(doc, "3.3 Book Browsing, Issuing & iText PDF Receipt Flow");
        addParagraph(doc, "1. Student accesses BrowseBooksServlet: servlet executes SELECT * FROM books, caches list in ServletContext, and renders BrowseBooks.jsp.\n"
                + "2. Student clicks 'Issue Book' on any available title (count > 0). Request submits to Issue.jsp.\n"
                + "3. Issue.jsp decrements book inventory (UPDATE books SET count = count - 1 WHERE book_id = ?), generates issue record with today's date and due date (+20 days), and inserts into 'issue' table.\n"
                + "4. Forward to CreatePdf servlet: CreatePdf uses iText PDF engine to construct a transaction receipt PDF containing student name, title, issue date, and due date in a styled PdfPTable.\n"
                + "5. CreatePdf forwards to SendUserMail.jsp, which dispatches the generated receipt PDF as an email attachment via EmailUtil to student's inbox.");

        addSubHeading(doc, "3.4 Book Return & Inventory Restocking Flow");
        addParagraph(doc, "1. Student opens Return.jsp: dropdown dynamically populates ONLY titles the student has currently borrowed (querying issue JOIN books WHERE U_ID = ?).\n"
                + "2. Student selects title and clicks 'Return Book', submitting to Return.java servlet.\n"
                + "3. Return.java validates loan record existence, removes record from 'issue' table, and increments inventory (UPDATE books SET count = count + 1 WHERE book_id = ?).\n"
                + "4. Refreshes ServletContext 'booklist' so catalog displays real-time stock across all active sessions.");
    }

    private static void addSection4_ModuleDeepDive(Document doc) throws DocumentException {
        addHeading1(doc, "4. Codebase Anatomy & Module Deep Dive");

        PdfPTable mt = new PdfPTable(3);
        mt.setWidthPercentage(100);
        mt.setSpacingBefore(6);
        mt.setSpacingAfter(12);
        mt.setWidths(new float[]{25f, 25f, 50f});

        addTableHeader(mt, new String[]{"Class / File", "Type", "Core Responsibilities & Implementation"});

        addTableRow(mt, new String[]{
            "DBConnection.java",
            "Database Utility",
            "Universal connection factory. Reads DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD, DATABASE_URL, and cloud aliases (MYSQLHOST, etc.). Configures autoReconnect, SSL, and trustServerCertificate."
        });

        addTableRow(mt, new String[]{
            "EmailUtil.java",
            "Communication Engine",
            "Multi-channel dispatcher: uses Brevo v3 HTTPS REST API (Port 443) or Resend API when cloud keys exist; falls back to JavaMail SMTP. Supports HTML email, base64 attachments, and detailed error logging."
        });

        addTableRow(mt, new String[]{
            "LoginServlet.java",
            "Controller",
            "Validates user credentials against TiDB database. Establishes HTTP sessions, enforces role-based routing (Admin/Student), and returns explicit diagnostic alerts upon failure."
        });

        addTableRow(mt, new String[]{
            "RegisterServlet.java",
            "Controller",
            "Performs duplicate email/name checks. Inserts new student/admin records, retrieves generated keys, sets session state, and forwards to Login.jsp."
        });

        addTableRow(mt, new String[]{
            "AddBooks.java",
            "Admin Controller",
            "Handles multipart form data via com.oreilly.servlet.MultipartRequest for uploading cover PDFs and images. Validates inventory count, inserts into books table, and updates catalog cache."
        });

        addTableRow(mt, new String[]{
            "AddExisting.java",
            "Admin Controller",
            "Performs case-insensitive title lookup (LOWER(TRIM(title)) = LOWER(TRIM(?))) and adds incremental copies to existing inventory."
        });

        addTableRow(mt, new String[]{
            "Return.java",
            "Student Controller",
            "Validates active loan in issue table for logged-in student, removes issue row, increments available book count, and triggers real-time stock refresh."
        });

        addTableRow(mt, new String[]{
            "CreatePdf.java",
            "Report Controller",
            "Employs iText PDF library to dynamically synthesize official borrowing receipts with table layout, timestamps, and return deadlines, saving to /Issue folder."
        });

        addTableRow(mt, new String[]{
            "Refresh.java",
            "WebListener",
            "ServletContextListener. In contextInitialized(), pre-populates application scope with books and user lists. In contextDestroyed(), terminates AbandonedConnectionCleanupThread to prevent memory leaks."
        });

        addTableRow(mt, new String[]{
            "BrowseBooks.jsp",
            "View (Presentation)",
            "Responsive catalog view featuring real-time client-side JavaScript search filter, stock badges (In Stock / Out of Stock), and touch-friendly issue actions."
        });

        doc.add(mt);
    }

    private static void addSection5_DatabaseSchema(Document doc) throws DocumentException {
        addHeading1(doc, "5. Database Schema & Relational Integrity");

        addParagraph(doc, "The database is hosted on TiDB Cloud Serverless (MySQL 8 dialect) with InnoDB engine for ACID transaction guarantees, foreign key constraints, and row-level locking:");

        PdfPTable dt = new PdfPTable(4);
        dt.setWidthPercentage(100);
        dt.setSpacingBefore(6);
        dt.setSpacingAfter(12);
        dt.setWidths(new float[]{18f, 18f, 22f, 42f});

        addTableHeader(dt, new String[]{"Table", "Column", "Data Type", "Constraints & Description"});

        addTableRow(dt, new String[]{"users", "ID", "INT", "PRIMARY KEY, AUTO_INCREMENT. Unique member ID."});
        addTableRow(dt, new String[]{"users", "Name", "VARCHAR(50)", "NOT NULL. User display name."});
        addTableRow(dt, new String[]{"users", "password", "VARCHAR(50)", "NOT NULL. Account credential."});
        addTableRow(dt, new String[]{"users", "Role", "VARCHAR(30)", "NOT NULL. Role ('Admin' or 'student')."});
        addTableRow(dt, new String[]{"users", "email", "VARCHAR(50)", "Member email used for OTPs and notifications."});

        addTableRow(dt, new String[]{"books", "book_id", "INT", "PRIMARY KEY, AUTO_INCREMENT. Unique book ID."});
        addTableRow(dt, new String[]{"books", "title", "VARCHAR(250)", "NOT NULL. Book title."});
        addTableRow(dt, new String[]{"books", "author", "VARCHAR(250)", "Author name."});
        addTableRow(dt, new String[]{"books", "pdf", "VARCHAR(250)", "Uploaded PDF/cover filename."});
        addTableRow(dt, new String[]{"books", "count", "INT", "Current available physical stock on shelf."});

        addTableRow(dt, new String[]{"issue", "Issue_id", "INT", "PRIMARY KEY, AUTO_INCREMENT. Transaction ID."});
        addTableRow(dt, new String[]{"issue", "U_ID", "INT", "FOREIGN KEY -> users(ID) ON DELETE CASCADE."});
        addTableRow(dt, new String[]{"issue", "B_ID", "INT", "FOREIGN KEY -> books(book_id) ON DELETE CASCADE."});
        addTableRow(dt, new String[]{"issue", "Issue_date", "DATE", "Date on which book was borrowed."});
        addTableRow(dt, new String[]{"issue", "Due_Date", "DATE", "Return deadline (default: Issue_date + 20 days)."});

        doc.add(dt);
    }

    private static void addSection6_InterviewPlaybook(Document doc) throws DocumentException {
        addHeading1(doc, "6. Interview Playbook: How to Explain This Project");

        addSubHeading(doc, "6.1 The 2-Minute Elevator Pitch");
        addCallout(doc, "What to say when asked: 'Tell me about this project'",
                "\"I developed and deployed a cloud-native Library Management System built with Java EE Servlets, JSP, MySQL, and Docker, currently live on Render at librarymanagementsystemproject-l8aw.onrender.com.\n\n"
                + "The system handles member registration, role-based access for Admins and Students, inventory management with real-time stock counters, transaction receipt generation using iText PDF, and two-factor password recovery.\n\n"
                + "A major engineering highlight was modernizing the app from a local desktop prototype to a resilient cloud deployment: I migrated the build from NetBeans Ant to Maven, containerized it with multi-stage Docker builds, connected it to a cloud TiDB Serverless MySQL database with SSL/TLS, and engineered an HTTPS REST email dispatcher with Brevo to bypass cloud SMTP port blocks.\"",
                COLOR_BG_LIGHT, COLOR_SECONDARY);

        addSubHeading(doc, "6.2 Top Technical Questions & Model Answers");

        addQnA(doc, "Q1: Why did you choose Java Servlets and JSP instead of Spring Boot?",
                "Answer: Servlets and JSP provide foundational mastery of the Java Enterprise web specifications, HTTP lifecycle, ServletContext, HttpSession, and request dispatching without framework magic. While Spring Boot abstracts these mechanics behind annotations like @RestController and @Autowired, building this project on native Servlets demonstrated a deep understanding of connection management, thread safety, classloaders, and manual transaction control.");

        addQnA(doc, "Q2: How did you solve the SMTP port 587 block on Render?",
                "Answer: Cloud platforms like Render block raw outbound SMTP ports (25, 465, 587) on free tiers to prevent spam. Instead of being blocked by network firewalls, I re-engineered EmailUtil to communicate with Brevo's Transactional Email REST API over HTTPS on Port 443. Port 443 is standard web traffic and never blocked. I also added a fallback mechanism that prints OTPs to server stdout so development and testing can proceed seamlessly.");

        addQnA(doc, "Q3: How do you prevent race conditions when two users issue the last copy of a book?",
                "Answer: At the database level, inventory count updates are executed using atomic SQL statements ('UPDATE books SET count = count - 1 WHERE book_id = ? AND count > 0'). If the count has already reached 0, executeUpdate() returns 0 rows affected, allowing the servlet to rollback or reject the transaction and notify the user that the book is out of stock.");

        addQnA(doc, "Q4: How did you fix the Tomcat classloader memory leak on shutdown?",
                "Answer: When MySQL Connector/J registers AbandonedConnectionCleanupThread, it remains active even after webapp context stops, causing Catalina classloader warnings. I implemented a ServletContextListener in Refresh.java that intercepts contextDestroyed(), explicitly shuts down AbandonedConnectionCleanupThread, and deregisters all JDBC drivers from DriverManager.");

        addQnA(doc, "Q5: How does your Docker multi-stage build optimize deployment?",
                "Answer: In Stage 1 (builder), Maven packages the source code and dependencies into a WAR file using eclipse-temurin:11. In Stage 2 (runtime), we discard the Maven SDK and build tools, copying only the resulting exploded webapp into tomcat:9.0-jre11-temurin. This reduces container image size, avoids exposing build tooling in production, and enables fast container boot times.");

        addSubHeading(doc, "6.3 Live Interview Demo Walkthrough Checklist");
        addParagraph(doc, "When demonstrating the live project to an interviewer:\n"
                + "1. Open live link: https://librarymanagementsystemproject-l8aw.onrender.com\n"
                + "2. Show responsive design: Press F12, toggle mobile device view (iPhone/Pixel), show navbar drawer and responsive book cards.\n"
                + "3. Log in as Student (Ayush / ayush52141): Browse books, use the live JavaScript filter bar, issue a book, and show the iText PDF receipt generated.\n"
                + "4. Log in as Admin (Ayush Chowdhury / ayush52141): Open Admin portal, restock existing books or add a new book title, and inspect active user list.\n"
                + "5. Demonstrate Password Recovery: Enter email on forgotPassword.jsp, receive OTP via Brevo, verify, and update password live in TiDB database.");
    }

    // ==========================================
    // UI & FORMATTING HELPERS
    // ==========================================

    private static void addHeading1(Document doc, String text) throws DocumentException {
        Paragraph p = new Paragraph(text, FONT_H1);
        p.setSpacingBefore(14);
        p.setSpacingAfter(6);
        doc.add(p);

        // Underline divider
        PdfPTable line = new PdfPTable(1);
        line.setWidthPercentage(100);
        line.setSpacingAfter(8);
        PdfPCell c = new PdfPCell();
        c.setBorder(Rectangle.BOTTOM);
        c.setBorderColor(COLOR_SECONDARY);
        c.setBorderWidth(1.2f);
        c.setFixedHeight(2);
        line.addCell(c);
        doc.add(line);
    }

    private static void addSubHeading(Document doc, String text) throws DocumentException {
        Paragraph p = new Paragraph(text, FONT_H2);
        p.setSpacingBefore(10);
        p.setSpacingAfter(4);
        doc.add(p);
    }

    private static void addParagraph(Document doc, String text) throws DocumentException {
        Paragraph p = new Paragraph(text, FONT_BODY);
        p.setLeading(13);
        p.setSpacingAfter(6);
        doc.add(p);
    }

    private static void addQnA(Document doc, String q, String a) throws DocumentException {
        Paragraph qP = new Paragraph(q, FONT_H3);
        qP.setSpacingBefore(6);
        qP.setSpacingAfter(2);
        doc.add(qP);

        Paragraph aP = new Paragraph(a, FONT_BODY);
        aP.setLeading(13);
        aP.setSpacingAfter(8);
        doc.add(aP);
    }

    private static void addCallout(Document doc, String title, String body, BaseColor bg, BaseColor border) throws DocumentException {
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);
        table.setSpacingBefore(6);
        table.setSpacingAfter(10);

        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(bg);
        cell.setBorderColor(border);
        cell.setBorderWidth(1.2f);
        cell.setPadding(10);

        Paragraph pTitle = new Paragraph(title, FONT_H3);
        pTitle.setSpacingAfter(4);
        cell.addElement(pTitle);

        Paragraph pBody = new Paragraph(body, FONT_BODY);
        pBody.setLeading(13);
        cell.addElement(pBody);

        table.addCell(cell);
        doc.add(table);
    }

    private static void addTableHeader(PdfPTable table, String[] headers) {
        for (String h : headers) {
            PdfPCell c = new PdfPCell(new Phrase(h, FONT_TH));
            c.setBackgroundColor(COLOR_PRIMARY);
            c.setPadding(6);
            c.setHorizontalAlignment(Element.ALIGN_LEFT);
            c.setBorderColor(COLOR_PRIMARY);
            table.addCell(c);
        }
    }

    private static void addTableRow(PdfPTable table, String[] values) {
        for (int i = 0; i < values.length; i++) {
            Font f = (i == 0) ? FONT_TD_BOLD : FONT_TD;
            PdfPCell c = new PdfPCell(new Phrase(values[i], f));
            c.setPadding(5);
            c.setBorderColor(COLOR_BORDER);
            table.addCell(c);
        }
    }

    // Page numbers & running header
    static class HeaderFooterPageEvent extends PdfPageEventHelper {
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfPTable footer = new PdfPTable(2);
            try {
                footer.setWidths(new int[]{70, 30});
                footer.setTotalWidth(document.right() - document.left());

                PdfPCell left = new PdfPCell(new Phrase("Library Management System - Architecture & Interview Handbook", FONT_FOOTER));
                left.setBorder(Rectangle.TOP);
                left.setBorderColor(COLOR_BORDER);
                left.setPaddingTop(4);

                PdfPCell right = new PdfPCell(new Phrase("Page " + document.getPageNumber(), FONT_FOOTER));
                right.setHorizontalAlignment(Element.ALIGN_RIGHT);
                right.setBorder(Rectangle.TOP);
                right.setBorderColor(COLOR_BORDER);
                right.setPaddingTop(4);

                footer.addCell(left);
                footer.addCell(right);
                footer.writeSelectedRows(0, -1, document.left(), document.bottom() - 10, writer.getDirectContent());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
