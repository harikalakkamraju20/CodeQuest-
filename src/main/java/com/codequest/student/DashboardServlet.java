
package com.codequest.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the student is logged in
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        String sql = "SELECT username, xp, level FROM users WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, studentId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    int xp = result.getInt("xp");
                    int level = result.getInt("level");

                    // Count correctly completed missions
                    String countSql =
                            "SELECT COUNT(*) FROM mission_submissions " +
                            "WHERE user_id = ? AND is_correct = TRUE";

                    try (PreparedStatement countStatement =
                                 connection.prepareStatement(countSql)) {

                        countStatement.setInt(1, studentId);

                        try (ResultSet countResult =
                                     countStatement.executeQuery()) {

                            if (countResult.next()) {
                                request.setAttribute(
                                        "completedMissions",
                                        countResult.getInt(1));
                            }
                        }
                    }

                    request.setAttribute("username",
                            result.getString("username"));

                    request.setAttribute("xp", xp);
                    request.setAttribute("level", level);

                    // Progress towards the next level
                    int xpPerLevel = 100;
                    int progress = xp % xpPerLevel;

                    request.setAttribute("progress", progress);

                    request.getRequestDispatcher("/dashboard.jsp")
                           .forward(request, response);

                } else {
                    session.invalidate();
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load student dashboard. Please try again.");
        }
    }
}
