package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import javax.servlet.*;

public final class Login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList<String>(2);
    _jspx_dependants.add("/Header.jsp");
    _jspx_dependants.add("/Footer.jsp");
  }

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("<!DOCTYPE html>\n");
      out.write("\n");
      out.write("\n");
      out.write("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">");
      out.write('\n');
      out.write("<!-- footer.jsp -->\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js\"></script>\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <title>Login</title>\n");
      out.write("        <meta charset=\"UTF-8\">\n");
      out.write("        <style>\n");
      out.write("            .hi {\n");
      out.write("                display: grid;\n");
      out.write("                grid-template-columns: 1fr 1fr;\n");
      out.write("                column-gap: 10px;\n");
      out.write("            } \n");
      out.write("        </style>\n");
      out.write("        <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\" />\n");
      out.write("    </head>\n");
      out.write("    <body\n");
      out.write("        ");
String user = (String) session.getAttribute("name");
        String email = (String) session.getAttribute("email");
      out.write("\n");
      out.write("        <div class=\"container mt-5\" style=\"max-width: 400px;\">\n");
      out.write("            <h2 class=\"text-center mb-4\">Library Login</h2>\n");
      out.write("            <form method=\"post\" action=\"LoginServlet\">\n");
      out.write("                <div class=\"mb-3\">\n");
      out.write("                    <label class=\"form-label\">Username</label>\n");
      out.write("                    <input type=\"text\" name=\"username\" class=\"form-control\" required placeholder=\"Enter your username\" \n");
      out.write("                           value=\"");
      out.print((user != null) ? user : "");
      out.write("\">\n");
      out.write("                </div>\n");
      out.write("                <div class=\"mb-3\">\n");
      out.write("                    <label class=\"form-label\">Email</label>\n");
      out.write("                <input type=\"email\" name=\"email\" class=\"form-control\" required placeholder=\"Enter your email\" \n");
      out.write("                       value=\"");
      out.print((email != null) ? email : "");
      out.write("\">\n");
      out.write("                </div>\n");
      out.write("                <div class=\"mb-3\">\n");
      out.write("                    <label class=\"form-label\">Password</label>\n");
      out.write("                    <input type=\"password\" name=\"password\" class=\"form-control\" required placeholder=\"Enter your password\">\n");
      out.write("                </div>\n");
      out.write("\n");
      out.write("                <!-- Hidden input to capture the role -->\n");
      out.write("                <input type=\"hidden\" name=\"role\" id=\"roleInput\">\n");
      out.write("\n");
      out.write("                <!-- Login buttons for Student and Admin -->\n");
      out.write("                <div class=\"hi\">\n");
      out.write("                    <button type=\"submit\" onclick=\"setRole('Student')\" class=\"btn btn-primary w-100\" style=\"border-radius: 12px;\">Login as Student</button>\n");
      out.write("                    <button type=\"submit\" onclick=\"setRole('Admin')\" class=\"btn btn-success w-100\" style=\"border-radius: 12px;\">Login as Admin</button>\n");
      out.write("                </div>\n");
      out.write("            </form>\n");
      out.write("                <a href=\"forgotPassword.jsp\">Reset</a>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <script>\n");
      out.write("            function setRole(role) {\n");
      out.write("                document.getElementById('roleInput').value = role;\n");
      out.write("            }\n");
      out.write("        </script>\n");
      out.write("    </body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
