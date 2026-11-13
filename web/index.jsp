<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page session="true"%>
<%
    String currentUser = (String) session.getAttribute("USER");
    String currentRole = (String) session.getAttribute("Role");
    boolean isLoggedIn = (currentUser != null && !currentUser.trim().isEmpty());
    String dashboardUrl = "Admin".equalsIgnoreCase(currentRole) ? "Admin.jsp" : "Home.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Management System - Discover, Learn & Borrow</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0f172a 0%, #1e3a8a 50%, #2563eb 100%);
            --card-hover-trans: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
        }
        .hero-section {
            background: var(--primary-gradient);
            color: #ffffff;
            padding: 85px 0 75px;
            position: relative;
            overflow: hidden;
        }
        .hero-badge {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 0.85rem;
            display: inline-block;
            margin-bottom: 20px;
        }
        .feature-card {
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            background: #ffffff;
            transition: var(--card-hover-trans);
        }
        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 28px rgba(15, 23, 42, 0.08);
            border-color: #cbd5e1;
        }
        .feature-icon-wrapper {
            width: 54px;
            height: 54px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 16px;
        }
        .step-bubble {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #2563eb;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.1rem;
            margin: 0 auto 14px;
        }
        .cta-banner {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            border-radius: 16px;
            padding: 40px;
        }
    </style>
</head>
<body>

    <!-- Responsive Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="index.jsp">
                <span class="fs-4">📚</span>
                <span>Library Portal</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#landingNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="landingNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                    <li class="nav-item"><a class="nav-link active" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Features</a></li>
                    <li class="nav-item"><a class="nav-link" href="#how-it-works">How It Works</a></li>
                    <li class="nav-item"><a class="nav-link" href="BrowseBooksServlet">Browse Books</a></li>
                </ul>
                <div class="d-flex align-items-center gap-2 mt-3 mt-lg-0">
                    <% if (isLoggedIn) { %>
                        <span class="text-light small me-2 d-none d-md-inline">Welcome, <strong><%= currentUser %></strong> (<%= currentRole %>)</span>
                        <a href="<%= dashboardUrl %>" class="btn btn-warning btn-sm fw-bold px-3">
                            <i class="fa-solid fa-gauge me-1"></i> Dashboard
                        </a>
                        <a href="Logout" class="btn btn-outline-danger btn-sm px-3">Logout</a>
                    <% } else { %>
                        <a href="Login.jsp" class="btn btn-outline-light btn-sm px-3">
                            <i class="fa-solid fa-right-to-bracket me-1"></i> Sign In
                        </a>
                        <a href="Register.html" class="btn btn-primary btn-sm px-3 fw-bold">
                            <i class="fa-solid fa-user-plus me-1"></i> Register Free
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero-section text-center text-lg-start">
        <div class="container">
            <div class="row align-items-center gy-5">
                <div class="col-lg-7">
                    <div class="hero-badge">
                        <i class="fa-solid fa-bolt text-warning me-1"></i> Cloud-Native Academic Library Platform
                    </div>
                    <h1 class="display-4 fw-bold lh-sm mb-3">
                        Empower Your Learning With Smart Book Management
                    </h1>
                    <p class="lead opacity-90 mb-4" style="max-width: 600px;">
                        Explore our extensive catalog, issue titles in one click, and receive instant digital PDF receipts. Built for students, researchers, and administrators.
                    </p>
                    <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                        <% if (isLoggedIn) { %>
                            <a href="<%= dashboardUrl %>" class="btn btn-warning btn-lg px-4 fw-bold shadow">
                                <i class="fa-solid fa-arrow-right me-1"></i> Go to Your Dashboard
                            </a>
                            <a href="BrowseBooksServlet" class="btn btn-outline-light btn-lg px-4">
                                <i class="fa-solid fa-book-open me-1"></i> Browse Catalog
                            </a>
                        <% } else { %>
                            <a href="Register.html" class="btn btn-primary btn-lg px-4 fw-bold shadow">
                                <i class="fa-solid fa-user-plus me-1"></i> Create Free Account
                            </a>
                            <a href="Login.jsp" class="btn btn-light btn-lg px-4 fw-semibold text-primary">
                                <i class="fa-solid fa-right-to-bracket me-1"></i> Member Login
                            </a>
                            <a href="BrowseBooksServlet" class="btn btn-outline-light btn-lg px-4">
                                <i class="fa-solid fa-book-open me-1"></i> View Books
                            </a>
                        <% } %>
                    </div>
                    <div class="mt-4 pt-2 text-white-50 small d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                        <span><i class="fa-solid fa-check text-success me-1"></i> Instant 2FA Email OTP</span>
                        <span><i class="fa-solid fa-check text-success me-1"></i> Automated iText PDF Receipts</span>
                        <span><i class="fa-solid fa-check text-success me-1"></i> 100% Cloud Hosted</span>
                    </div>
                </div>
                <div class="col-lg-5 text-center">
                    <div class="p-4 bg-white bg-opacity-10 rounded-4 backdrop-blur border border-white border-opacity-25 shadow-lg">
                        <div class="fs-1 mb-2">📚 📖 🎓</div>
                        <h4 class="fw-bold text-white mb-2">Live Digital Portal</h4>
                        <p class="text-white-50 small mb-4">Fast, responsive, and available 24/7 on any mobile, tablet, or desktop device.</p>
                        <div class="row g-2 text-dark">
                            <div class="col-6">
                                <div class="bg-white p-3 rounded-3 shadow-sm text-center">
                                    <div class="fs-4 fw-bold text-primary">500+</div>
                                    <div class="small text-muted">Books Available</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="bg-white p-3 rounded-3 shadow-sm text-center">
                                    <div class="fs-4 fw-bold text-success">20 Days</div>
                                    <div class="small text-muted">Loan Duration</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Key Features Section -->
    <section id="features" class="py-5">
        <div class="container py-4">
            <div class="text-center mb-5">
                <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill mb-2">Modern Capabilities</span>
                <h2 class="fw-bold">Everything You Need In A Modern Library</h2>
                <p class="text-muted" style="max-width: 600px; margin: 0 auto;">Engineered with Java EE, MySQL, and Docker for high reliability and instantaneous catalog operations.</p>
            </div>

            <div class="row g-4">
                <div class="col-12 col-md-6 col-lg-3">
                    <div class="feature-card p-4 h-100">
                        <div class="feature-icon-wrapper bg-primary-subtle text-primary">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Instant Search</h5>
                        <p class="text-muted small mb-0">Live client-side filtering lets you find titles, authors, and topics across technical disciplines in milliseconds.</p>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-3">
                    <div class="feature-card p-4 h-100">
                        <div class="feature-icon-wrapper bg-success-subtle text-success">
                            <i class="fa-solid fa-hand-holding-hand"></i>
                        </div>
                        <h5 class="fw-bold mb-2">1-Click Issuing</h5>
                        <p class="text-muted small mb-0">Borrow books effortlessly with real-time stock counters that prevent overdrafts and ensure inventory integrity.</p>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-3">
                    <div class="feature-card p-4 h-100">
                        <div class="feature-icon-wrapper bg-warning-subtle text-warning">
                            <i class="fa-solid fa-file-pdf"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Automated PDF Receipts</h5>
                        <p class="text-muted small mb-0">Powered by the iText engine, official transaction receipts with due dates are dynamically generated and emailed.</p>
                    </div>
                </div>

                <div class="col-12 col-md-6 col-lg-3">
                    <div class="feature-card p-4 h-100">
                        <div class="feature-icon-wrapper bg-danger-subtle text-danger">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Cloud Security & 2FA</h5>
                        <p class="text-muted small mb-0">Role-based authentication with two-factor email OTP recovery delivered via Brevo HTTPS REST API.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="py-5 bg-white border-top border-bottom">
        <div class="container py-4">
            <div class="text-center mb-5">
                <span class="badge bg-secondary-subtle text-secondary fw-semibold px-3 py-2 rounded-pill mb-2">Simple Workflow</span>
                <h2 class="fw-bold">How It Works in 3 Steps</h2>
                <p class="text-muted">Start borrowing your favorite textbooks in less than a minute.</p>
            </div>

            <div class="row g-4 text-center">
                <div class="col-12 col-md-4">
                    <div class="p-3">
                        <div class="step-bubble">1</div>
                        <h5 class="fw-bold mb-2">Register Your Account</h5>
                        <p class="text-muted small">Sign up with your student email and get immediate access to the member portal without manual approval.</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="p-3">
                        <div class="step-bubble">2</div>
                        <h5 class="fw-bold mb-2">Explore & Issue Books</h5>
                        <p class="text-muted small">Filter by topic, check available physical copies, and click Issue Book to reserve your copy instantly.</p>
                    </div>
                </div>
                <div class="col-12 col-md-4">
                    <div class="p-3">
                        <div class="step-bubble">3</div>
                        <h5 class="fw-bold mb-2">Receive Receipt & Return</h5>
                        <p class="text-muted small">Download your official borrowing PDF receipt and return books easily through your personalized profile.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action Banner -->
    <section class="py-5">
        <div class="container">
            <div class="cta-banner text-center text-lg-start shadow">
                <div class="row align-items-center gy-4">
                    <div class="col-lg-8">
                        <h3 class="fw-bold mb-2 text-white">Ready to Start Exploring Books?</h3>
                        <p class="text-light opacity-75 mb-0">Join our academic library platform today or sign in to manage your active loans.</p>
                    </div>
                    <div class="col-lg-4 text-lg-end">
                        <% if (isLoggedIn) { %>
                            <a href="<%= dashboardUrl %>" class="btn btn-warning btn-lg fw-bold px-4">Open Dashboard</a>
                        <% } else { %>
                            <a href="Register.html" class="btn btn-primary btn-lg fw-bold px-4 me-2">Register Now</a>
                            <a href="Login.jsp" class="btn btn-outline-light btn-lg px-4">Sign In</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white-50 py-4 border-top border-secondary border-opacity-25">
        <div class="container text-center">
            <div class="d-flex flex-wrap justify-content-center gap-3 mb-2 small">
                <a href="index.jsp" class="text-white-50 text-decoration-none">Home</a>
                <span>•</span>
                <a href="BrowseBooksServlet" class="text-white-50 text-decoration-none">Book Catalog</a>
                <span>•</span>
                <a href="Login.jsp" class="text-white-50 text-decoration-none">Login</a>
                <span>•</span>
                <a href="Register.html" class="text-white-50 text-decoration-none">Register</a>
                <span>•</span>
                <a href="forgotPassword.jsp" class="text-white-50 text-decoration-none">Forgot Password</a>
            </div>
            <p class="small mb-1">📚 <strong>Library Management System</strong> &copy; <%= java.time.Year.now() %> Ayush Chowdhury. All rights reserved.</p>
            <p class="small text-muted mb-0"><span class="badge bg-success-subtle text-success me-1">● Online</span> Live Production on Render | Backed by TiDB Cloud Serverless MySQL</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

