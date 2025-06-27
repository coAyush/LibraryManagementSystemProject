/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package LibraryManagement;
public class User {
    int ID;
    String Name, email, pass, Role;
    public User(int ID,String Name,String email,String pass,String Role){
        this.ID=ID;
        this.Name=Name;
        this.email=email;
        this.pass=pass;
        this.Role=Role;
    }

    public int getID() {
        return ID;
    }

    public String getName() {
        return Name;
    }

    public String getEmail() {
        return email;
    }

    public String getPass() {
        return pass;
    }

    public String getRole() {
        return Role;
    }
    
}
