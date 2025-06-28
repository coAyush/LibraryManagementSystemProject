📚 Library Management System (JSP + Servlets + MySQL)

A beginner-level Library Management System built using JSP, Java Servlets, and MySQL. Users can browse and issue books, generate receipts in PDF format, and receive email notifications. The system also calculates fines for late returns and supports file upload for book PDFs.

## 🚀 Features
- User Registration & Login
- Admin book upload with PDF file
- Book browsing and issuing
- Issue receipt as PDF (iText)
- Email alert on issue (JavaMail)
- Fine calculation for late returns
- Otp generation for reseting the password
- Contact to Admin via email
## ⚙️ Setup Instructions

1. **Import the project** into NetBeans.
2. **Create a MySQL database** named:
3. Create necessary tables** (`Users`, `Books`, `Issue`, etc.)
4. Replace placeholders** in your code:
 -final String url = "YOUR_DB_URL_HERE";
 -final String dbUser = "YOUR_DB_USERNAME";
 -final String dbPass = "YOUR_DB_PASSWORD";
 -final String pass = "YOUR_16_DIGIT_APP_PASSWORD";

 ## Jar Files/Folders needed(include these in your libraries folder of project)
1. activation.jar ,mail.jar : for sendig mails
2. itextpdf-5.5.13.3.jar : for pdf generation
3. cos.jar : for receiving the file
4. mysql-connector-j-9.2.0.jar,protobuf-java-3.11.4_1.jar: for connecting to database
5. bootstrap-4.3.1-dist

Author:
Ayush Chowdhury,MCA student
