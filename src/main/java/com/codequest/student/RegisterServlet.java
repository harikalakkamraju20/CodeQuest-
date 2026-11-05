
package com.codequest.student;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final int ITERATIONS = 600000;
    private static final int KEY_LENGTH = 256;

    private String hashPassword(String password) throws Exception {

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        KeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] hash = factory.generateSecret(spec).getEncoded();

        return Base64.getEncoder().encodeToString(salt)
                + ":"
                + Base64.getEncoder().encodeToString(hash);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || email == null ||
                password == null || confirmPassword == null ||
                username.trim().isEmpty() ||
                email.trim().isEmpty() ||
                password.isEmpty() ||
                confirmPassword.isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
            return;
        }

        username = username.trim();
        email = email.trim().toLowerCase();

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("error",
                    "Password must contain at least 8 characters.");
            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "Enter a valid email address.");
            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
            return;
        }

        try {
            String hashedPassword = hashPassword(password);

            String sql = "INSERT INTO users "
                    + "(username, email, password_hash, xp, level) "
                    + "VALUES (?, ?, ?, 0, 1)";

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setString(1, username);
                statement.setString(2, email);
                statement.setString(3, hashedPassword);

                statement.executeUpdate();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?registered=success"
            );

        } catch (SQLException e) {

            if ("23000".equals(e.getSQLState())) {
                request.setAttribute("error",
                        "Username or email already exists.");
            } else {
                log("Student registration database error", e);
                request.setAttribute("error",
                        "Registration failed. Please try again.");
            }

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            log("Password hashing error", e);
            request.setAttribute("error",
                    "Unable to process registration.");

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
        }
    }
}
