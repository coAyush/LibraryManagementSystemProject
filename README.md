# 📚 Library Management System

A full-featured Java Web Application built with **JSP, Servlets, and MySQL**, containerized with **Docker & Docker Compose**, and managed with **Apache Maven**.

---

## 🚀 Key Features

- **Authentication & Roles:** Dedicated workflows and dashboards for **Students** and **Admins**.
- **Book Management:** Add new books with PDF uploads, manage copies of existing titles, and browse available inventory.
- **Issuing & Receipts:** Issue books with automatic receipt generation in **PDF format** (via iText).
- **Email Notifications:** Automated email receipts and notifications for book loans and librarian contacts (via JavaMail SMTP).
- **Account & Fine Calculation:** Student dashboard showing active book issues, due dates, and real-time fine calculation.
- **Password Reset:** Self-service OTP generation and email verification for resetting credentials.
- **12-Factor Ready:** Centralized configuration via environment variables (zero hardcoded database credentials or file paths).
- **Deployment Ready:** Multi-stage `Dockerfile` and `docker-compose.yml` with automated database seeding and health checks.

---

## 🛠️ Tech Stack & Requirements

| Component | Technology | Version |
| :--- | :--- | :--- |
| **Backend** | Java Servlets & JSP (Java EE 8 / `javax.servlet`) | Java 8 / 11 / 17 / 21 |
| **Build Tool** | Apache Maven | 3.6+ |
| **Application Server** | Apache Tomcat | 9.x |
| **Database** | MySQL | 8.x |
| **Containerization** | Docker & Docker Compose | Latest |
| **Frontend** | HTML5, Bootstrap 5, JavaScript | 5.3 |
| **Libraries** | iText (PDF), JavaMail, COS (Oreilly) | 5.5, 1.6 |

---

## ⚡ Quick Start: Run with Docker Compose (Recommended)

The easiest way to deploy and run the entire application (Tomcat server + MySQL database) with automated database seeding:

### 1. Clone & Navigate
```bash
git clone https://github.com/coAyush/LibraryManagementSystemProject.git
cd LibraryManagementSystem
```

### 2. Configure Environment (Optional)
A template `.env.example` is provided. Copy it to `.env` if you wish to customize ports or credentials:
```bash
cp .env.example .env
```

### 3. Build & Start Containers
```bash
docker compose up --build -d
```

### 4. Access the Application
Open your browser and navigate to:
- **Application URL:** [http://localhost:9090](http://localhost:9090)
- **Direct Login:** [http://localhost:9090/Login.jsp](http://localhost:9090/Login.jsp)

### 5. Default Credentials
The database is automatically pre-seeded with sample users and books:
- **Admin Login:**
  - **Username:** `Ayush Chowdhury`
  - **Email:** `chowdhuryayush7@gmail.com`
  - **Password:** `ayush52141`
  - **Role:** Select `Admin`
- **Student Login:**
  - **Username:** `Ayush`
  - **Email:** `chowdhuryayush9@gmail.com`
  - **Password:** `ayush52141`
  - **Role:** Select `Student`

---

## 💻 Local Development Setup (Without Docker)

If running directly on your host machine:

### 1. Prerequisites
- **JDK 8 or higher** (`java -version`)
- **Apache Maven 3.6+** (`mvn -version`)
- **MySQL Server 8.0+** running on `localhost:3306`
- **Apache Tomcat 9.x**

### 2. Database Initialization
Log into MySQL and import the schema:
```bash
mysql -u root -p < LibraryManagementDatabase.sql
```

### 3. Build with Maven
Generate the WAR file:
```bash
mvn clean package
```
The deployable archive will be created at `target/LibraryManagementSystem.war`.

### 4. Deploy to Tomcat
- Copy `target/LibraryManagementSystem.war` to `$CATALINA_HOME/webapps/ROOT.war`.
- Start Tomcat:
  ```bash
  # Windows
  %CATALINA_HOME%\bin\startup.bat

  # Linux / macOS
  $CATALINA_HOME/bin/startup.sh
  ```
- Open [http://localhost:8080](http://localhost:8080).

---

## ⚙️ Environment Variables

The application reads configuration dynamically from environment variables:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `DB_HOST` | MySQL hostname | `mydb` (or `localhost`) |
| `DB_PORT` | MySQL port | `3306` |
| `DB_NAME` | Database schema name | `library` |
| `DB_USER` | Database username | `root` |
| `DB_PASSWORD` | Database password | `ayush52141` |
| `JDBC_DATABASE_URL` | Complete JDBC URL override | *(Generated from host/port)* |
| `MAIL_USERNAME` | SMTP sender email | `librarysystemxyz@gmail.com` |
| `MAIL_PASSWORD` | Gmail App Password | `gwqs dles giwy rxvc` |
| `MAIL_HOST` | SMTP server host | `smtp.gmail.com` |
| `MAIL_PORT` | SMTP server port | `587` |
| `MAIL_ENABLED` | Enable/Disable email sending | `true` |

---

## ☁️ Cloud Deployment Guidelines

This project can be deployed to any Docker-capable cloud provider:

### Deploying to Render / Railway / Fly.io / AWS ECS:
1. Connect this repository to your platform.
2. Select **Docker** deployment (uses `Dockerfile`).
3. Attach a managed **MySQL Database**.
4. Set the following environment variables in your cloud dashboard:
   - `DB_HOST`: Your cloud database host
   - `DB_PORT`: `3306` (or your provider's port)
   - `DB_NAME`: `library`
   - `DB_USER`: Database user
   - `DB_PASSWORD`: Database password
   - `MAIL_USERNAME` & `MAIL_PASSWORD`: Your SMTP credentials
5. Run the migration script `LibraryManagementDatabase.sql` against your cloud database once.

---

## 📂 Project Architecture

```
LibraryManagementSystem/
├── src/java/LibraryManagement/   # Servlets & Core Java Classes
│   ├── DBConnection.java          # Centralized Database Connection Manager
│   ├── EmailUtil.java             # Centralized Email Dispatcher
│   ├── LoginServlet.java          # User Authentication
│   ├── RegisterServlet.java       # User Registration
│   ├── AddBooks.java              # File upload & inventory creation
│   ├── AddExisting.java           # Inventory stock increment
│   ├── BrowseBooksServlet.java    # Book catalog retrieval
│   ├── AddDB.java                 # Book issuing logic
│   ├── CreatePdf.java             # Portable PDF receipt generator
│   ├── Return.java                # Book return processor
│   ├── Refresh.java               # Application startup context listener
│   └── ...
├── web/                           # JSPs, HTML & Static Assets
│   ├── WEB-INF/
│   │   ├── web.xml                # Deployment descriptor
│   │   └── lib/                   # Runtime libraries (cos.jar, etc.)
│   ├── Images/                    # UI icons and book thumbnails
│   ├── pdf/                       # Uploaded and bundled eBooks
│   ├── Login.jsp                  # Authentication UI
│   ├── Home.jsp                   # Student Portal
│   ├── Admin.jsp                  # Admin Dashboard
│   ├── BrowseBooks.jsp            # Catalog & Issue UI
│   ├── MyAccount.jsp              # Loans, Due Dates & Fines
│   └── ...
├── Dockerfile                     # Multi-stage production build (Tomcat 9)
├── docker-compose.yml             # Full-stack orchestrator (App + MySQL)
├── LibraryManagementDatabase.sql  # Automated database seed schema
├── pom.xml                        # Apache Maven Build Descriptor
└── README.md                      # Documentation
```
