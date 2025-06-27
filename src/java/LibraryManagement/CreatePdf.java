/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.text.* ;
import com.itextpdf.text.pdf.*;
import java.io.FileOutputStream;
import java.time.LocalDate;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpSession;
@WebServlet(name = "CreatePdf", urlPatterns = {"/CreatePdf"})
public class CreatePdf extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession ses=request.getSession(false);
        String title=(String)ses.getAttribute("title");
        String name=(String) ses.getAttribute("USER");
        LocalDate issue=(LocalDate)ses.getAttribute("Issue");
        LocalDate due=(LocalDate)ses.getAttribute("Due");
       try{
          String filePath = "E:\\Servelet\\Servlet_SSSA\\LibraryManagementSystem\\web\\Issue\\" + title + "_" + System.currentTimeMillis() + ".pdf";
           Document doc=new Document();
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
                table.addCell(issue.toString());
                table.addCell(due.toString());
                doc.add(table);
                doc.close();
                ses.setAttribute("pdfPath", filePath);
                RequestDispatcher rd=request.getRequestDispatcher("SendUserMail.jsp");
                rd.forward(request, response);
       }catch(Exception e){
           e.printStackTrace();
       }
    }

}
