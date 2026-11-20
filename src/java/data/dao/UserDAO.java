/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package data.dao;

import java.util.List;
import model.User;

/**
 *
 * @author Admin
 */
public interface UserDAO {
    User login(String email, String password);
    boolean checkEmailEXists(String email);
    boolean register(User user);
    List<User> getAll();
    
}
