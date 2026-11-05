
package com.codequest.student;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.codequest.DBConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean verifyPassword(String password,
                                  String storedHash) throws Exception {

        String[] parts = storedHash.split(":");

        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] originalHash = Base64.getDecoder().decode(parts[1]);

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(), salt, 600000, 256);

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] newHash = factory.generateSecret(spec).getEncoded();

        return MessageDigest.isEqual(originalHash, newHash);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail =
                request.getParameter("usernameOrEmail");

        String password = request.getParameter("password");

        String rememberMe = request.getParameter("rememberMe");

        String sql = "SELECT user_id, username, password_hash "
                   + "FROM users WHERE username=? OR email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() &&
                    verifyPassword(password, rs.getString("password_hash"))) {

                    int userId = rs.getInt("user_id");
                    String username = rs.getString("username");

                    // Create student session
                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = request.getSession(true);

                    session.setAttribute("studentId", userId);
                    session.setAttribute("username", username);
                    session.setMaxInactiveInterval(30 * 60);

                    // Remember Username Cookie
                    Cookie cookie;

                    if ("yes".equals(rememberMe)) {

                        String encodedUsername = URLEncoder.encode(
                                usernameOrEmail,
                                StandardCharsets.UTF_8);

                        cookie = new Cookie("cq_username",
                                           encodedUsername);

                        cookie.setMaxAge(30 * 24 * 60 * 60);

                    } else {

                        cookie = new Cookie("cq_username", "");
                        cookie.setMaxAge(0);
                    }

                    cookie.setPath(request.getContextPath());
                    cookie.setHttpOnly(true);
                    cookie.setSecure(request.isSecure());

                    response.addCookie(cookie);

                    response.sendRedirect(
                            request.getContextPath() + "/dashboard");

                } else {

                    request.setAttribute(
                            "error", "Invalid username or password.");

                    request.getRequestDispatcher("/login.jsp")
                           .forward(request, response);
                }
            }

        } catch (SQLException e) {

            getServletContext().log("Login database error", e);

            request.setAttribute(
                    "error", "Database error. Please try again.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log("Login error", e);

            request.setAttribute(
                    "error", "Login failed. Please try again.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
        }
    }
}
