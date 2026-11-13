# 📚 Library Management System

A full-featured Java Web Application built using **Java Servlets, JSP, JDBC, and MySQL**. The application provides role-based library management workflows for administrators and students, with automated email notifications, PDF receipt generation, and containerized deployment using Docker.

<p align="center">
  <a href="https://librarymanagementsystemproject-l8aw.onrender.com/">
    <img src="https://img.shields.io/badge/Live%20Demo-Visit%20Application-success?style=for-the-badge" alt="Live Demo"/>
  </a>
  <a href="https://github.com/coAyush/LibraryManagementSystemProject">
    <img src="https://img.shields.io/badge/GitHub-Source%20Code-black?style=for-the-badge&logo=github" alt="GitHub Repository"/>
  </a>
</p>

## 🌐 Live Demo

**Live Application:** https://librarymanagementsystemproject-l8aw.onrender.com/

**Source Code:** https://github.com/coAyush/LibraryManagementSystemProject

The application is deployed on Render with a MySQL database hosted on TiDB Cloud.

Explore the application to experience authentication workflows, role-based dashboards, book inventory management, borrowing and return operations, PDF receipt generation, and account management features.

> **Note:** The application may take some time to respond to the first request if the hosting service is waking up from an idle state.

---

## 🚀 Key Features

### 🔐 Authentication & Authorization
- Dedicated authentication workflows for Admin and Student roles.
- Role-based dashboards and access control.
- OTP-based email verification for password recovery.

### 📖 Book Management
- Add new books with PDF file uploads.
- Manage inventory by adding copies of existing titles.
- Browse available books and track inventory.
- Maintain book availability across issuing and returning workflows.

### 📋 Book Issuing & Returns
- Issue books to registered students.
- Generate PDF borrowing receipts using iText.
- Process book returns and update inventory.
- Track active book issues and due dates.

### 💰 Account Management & Fine Calculation
- Student dashboard displaying currently issued books.
- Due-date tracking.
- Automatic fine calculation based on overdue books.

### 📧 Email Notifications
- Automated email receipts and notifications using JavaMail SMTP.
- Email communication for library-related activities.
- OTP-based password recovery.

### 🐳 Docker & Deployment
- Multi-stage Dockerfile for building and deploying the application.
- Docker Compose orchestration for the application and MySQL database.
- Environment-based application configuration.
- Automated database initialization and seeding.
- Database health checks and container dependency management.

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| Programming Language | Java |
| Backend | Java Servlets, JSP, JDBC |
| Architecture | MVC |
| Frontend | HTML5, CSS3, Bootstrap 5, JavaScript |
| Database | MySQL / TiDB Cloud |
| Build Tool | Apache Maven |
| Application Server | Apache Tomcat 9 |
| Containerization | Docker, Docker Compose |
| PDF Generation | iText |
| Email Integration | JavaMail SMTP |
| File Upload | O'Reilly COS Multipart Library |
| Version Control | Git, GitHub |

---

## 🏗️ Application Architecture

The application follows the **Model-View-Controller (MVC)** architectural pattern.

- **Model:** Java classes responsible for database connectivity and business logic.
- **View:** JSP pages responsible for rendering the user interface.
- **Controller:** Java Servlets responsible for handling HTTP requests, processing user actions, and coordinating application workflows.
- **Database:** MySQL stores user information, book inventory, issue records, and related application data.

---

## ⚡ Getting Started

### Option 1: Run Using Docker Compose (Recommended)

Docker Compose allows you to run the application and MySQL database together.

#### 1. Clone the Repository

```bash
git clone https://github.com/coAyush/LibraryManagementSystemProject.git

cd LibraryManagementSystemProject
```

#### 2. Configure Environment Variables

A `.env.example` file is provided as a template.

Create your local environment file:

```bash
cp .env.example .env
```

Update the environment variables with your database and email configuration.

**Never commit your `.env` file or actual credentials to GitHub.**

#### 3. Build and Start Containers

```bash
docker compose up --build -d
```

Check the running containers:

```bash
docker compose ps
```

View application logs:

```bash
docker compose logs -f app
```

#### 4. Access the Application

Once the containers are running, access:

- **Application:** http://localhost:9090/
- **Login:** http://localhost:9090/Login.jsp

#### 5. Sample Login Credentials

The database can be initialized with sample users and books through the provided SQL seed script.

Configure your own demonstration accounts locally. Do not publish real account passwords or personal email credentials in this repository.

---

## 💻 Option 2: Local Development Setup

If you prefer running the application without Docker:

### Prerequisites

- JDK 8 or later (subject to the project's configured Java compatibility).
- Apache Maven 3.6+.
- MySQL Server 8.x.
- Apache Tomcat 9.x.

### 1. Clone the Repository

```bash
git clone https://github.com/coAyush/LibraryManagementSystemProject.git

cd LibraryManagementSystemProject
```

### 2. Initialize the Database

Start your MySQL server and import the provided SQL script:

```bash
mysql -u root -p < LibraryManagementDatabase.sql
```

Configure the database connection using the environment variables described below.

### 3. Build the Application

Generate the deployable WAR file:

```bash
mvn clean package
```

The generated WAR file will be available at:

```text
target/LibraryManagementSystem.war
```

### 4. Deploy to Apache Tomcat

Copy the generated WAR file into the Tomcat webapps directory.

For a root deployment:

```text
target/LibraryManagementSystem.war
    ↓
$CATALINA_HOME/webapps/ROOT.war
```

Start Tomcat.

**Windows:**

```bash
%CATALINA_HOME%\bin\startup.bat
```

**Linux/macOS:**

```bash
$CATALINA_HOME/bin/startup.sh
```

Access the application:

```text
http://localhost:8080/
```

---

## ⚙️ Environment Variables

The application supports environment-based configuration for database connectivity and email services.

| Variable | Description |
|---|---|
| `DB_HOST` | MySQL database hostname |
| `DB_PORT` | MySQL database port |
| `DB_NAME` | Database schema name |
| `DB_USER` | Database username |
| `DB_PASSWORD` | Database password |
| `JDBC_DATABASE_URL` | Optional complete JDBC connection URL override |
| `MAIL_USERNAME` | SMTP sender email address |
| `MAIL_PASSWORD` | SMTP app password |
| `MAIL_HOST` | SMTP server hostname |
| `MAIL_PORT` | SMTP server port |
| `MAIL_ENABLED` | Enable or disable email functionality |

### Example Configuration

```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=library
DB_USER=root
DB_PASSWORD=your_local_password

MAIL_USERNAME=your_email@example.com
MAIL_PASSWORD=your_email_app_password
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_ENABLED=true
```

Use appropriate environment-specific values when running through Docker Compose or deploying to a cloud platform.

---

## ☁️ Cloud Deployment

The application is containerized and can be deployed to Docker-compatible hosting environments.

### Current Deployment

| Component | Platform |
|---|---|
| Application Hosting | Render |
| Database Hosting | TiDB Cloud |
| Containerization | Docker |
| Application Server | Apache Tomcat 9 |

### Live Application

https://librarymanagementsystemproject-l8aw.onrender.com/

### Other Potential Deployment Platforms

- Render
- Railway
- Fly.io
- AWS ECS

### Deployment Steps

1. Connect the GitHub repository to your chosen deployment platform.
2. Configure Docker-based deployment using the project's Dockerfile.
3. Provision a managed MySQL-compatible database.
4. Configure the required database and SMTP environment variables.
5. Initialize the database using `LibraryManagementDatabase.sql` where required.
6. Deploy the application and verify database connectivity and application functionality.

**Note:** Cloud deployment requires compatible database networking, persistent file storage where needed, and appropriate environment configuration.

---

## 📂 Project Structure

```text
LibraryManagementSystemProject/
│
├── src/
│   └── java/
│       └── LibraryManagement/
│           ├── DBConnection.java
│           ├── EmailUtil.java
│           ├── LoginServlet.java
│           ├── RegisterServlet.java
│           ├── AddBooks.java
│           ├── AddExisting.java
│           ├── BrowseBooksServlet.java
│           ├── AddDB.java
│           ├── CreatePdf.java
│           ├── Return.java
│           ├── Refresh.java
│           └── ...
│
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/
│   ├── Images/
│   ├── pdf/
│   ├── Login.jsp
│   ├── Home.jsp
│   ├── Admin.jsp
│   ├── BrowseBooks.jsp
│   ├── MyAccount.jsp
│   └── ...
│
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
├── LibraryManagementDatabase.sql
├── pom.xml
└── README.md
```

---

## 🔮 Future Improvements

- Migrate the existing backend to Spring Boot.
- Introduce Spring Security for centralized authentication and authorization.
- Add automated unit and integration testing.
- Implement Redis caching for frequently accessed catalog data.
- Improve monitoring and application logging.

---

## 👨‍💻 Author

**Ayush Chowdhury**

- GitHub: https://github.com/coAyush
- LinkedIn: https://linkedin.com/in/ayush-chowdhury-6a7858293

---

## 📄 License

This project is available for educational and demonstration purposes. Add an explicit open-source license if you intend to permit reuse and redistribution.
