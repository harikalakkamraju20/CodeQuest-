
package com.codequest.admin;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean verifyPassword(String password, String storedHash)
            throws Exception {

        String[] parts = storedHash.split(":");

        if (parts.length != 2) {
            return false;
        }

        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[1]);

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                600000,
                256
        );

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] actualHash = factory.generateSecret(spec).getEncoded();

            return MessageDigest.isEqual(expectedHash, actualHash);

        } finally {
            spec.clearPassword();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.trim().isEmpty() || password.isEmpty()) {

            request.setAttribute("error", "Please enter username and password.");
            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "SELECT admin_id, username, password_hash "
                   + "FROM admins WHERE username = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username.trim());

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    String storedHash = result.getString("password_hash");

                    if (verifyPassword(password, storedHash)) {

                        HttpSession oldSession = request.getSession(false);

                        if (oldSession != null) {
                            oldSession.invalidate();
                        }

                        HttpSession session = request.getSession(true);

                        session.setAttribute(
                                "adminId",
                                result.getInt("admin_id")
                        );

                        session.setAttribute(
                                "adminUsername",
                                result.getString("username")
                        );

                        session.setMaxInactiveInterval(30 * 60);

                        response.sendRedirect(
                                request.getContextPath() + "/admin-dashboard.jsp"
                        );

                        return;
                    }
                }
            }

            request.setAttribute("error", "Invalid admin username or password.");

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log("Admin login database error", e);

            request.setAttribute(
                    "error",
                    "Unable to process login. Please try again."
            );

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log("Admin password verification error", e);

            request.setAttribute(
                    "error",
                    "Unable to verify login. Please contact the administrator."
            );

            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);
        }
    }
}
