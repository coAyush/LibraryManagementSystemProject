/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;

/**
 *
 * @author User
 */
public class Book {
    private String title;
    private String author;
    private String pdf;
    private int count;
    public Book(String title,String author,String pdf,int count){
     this.title=title;
     this.author=author;
     this.pdf=pdf;
     this.count=count;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getPdf() {
        return pdf;
    }

    public int getCount() {
        return count;
    }
    
}
