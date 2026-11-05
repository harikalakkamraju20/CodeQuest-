
package com.codequest.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/missions")
public class MissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check student login
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        List<Map<String, Object>> missions = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT mission_id, title, description, category, " +
                "difficulty, choice_a, choice_b, choice_c, choice_d, xp_reward " +
                "FROM missions WHERE 1=1");

        if (category != null && !category.isEmpty()) {
            sql.append(" AND category = ?");
        }

        if (difficulty != null && !difficulty.isEmpty()) {
            sql.append(" AND difficulty = ?");
        }

        sql.append(" ORDER BY mission_id DESC");

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql.toString())) {

            int parameterIndex = 1;

            if (category != null && !category.isEmpty()) {
                statement.setString(parameterIndex++, category);
            }

            if (difficulty != null && !difficulty.isEmpty()) {
                statement.setString(parameterIndex++, difficulty);
            }

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> mission = new HashMap<>();

                    mission.put("missionId", result.getInt("mission_id"));
                    mission.put("title", result.getString("title"));
                    mission.put("description", result.getString("description"));
                    mission.put("category", result.getString("category"));
                    mission.put("difficulty", result.getString("difficulty"));

                    mission.put("choiceA", result.getString("choice_a"));
                    mission.put("choiceB", result.getString("choice_b"));
                    mission.put("choiceC", result.getString("choice_c"));
                    mission.put("choiceD", result.getString("choice_d"));

                    mission.put("xpReward", result.getInt("xp_reward"));

                    missions.add(mission);
                }
            }

            request.setAttribute("missions", missions);
            request.setAttribute("selectedCategory",
                    category == null ? "" : category);
            request.setAttribute("selectedDifficulty",
                    difficulty == null ? "" : difficulty);

            request.getRequestDispatcher("/missions.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load missions. Please try again.");
        }
    }
}
