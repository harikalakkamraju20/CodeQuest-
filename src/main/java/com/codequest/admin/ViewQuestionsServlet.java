
package com.codequest.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/view-questions")
public class ViewQuestionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin login
        if (request.getSession(false) == null
                || request.getSession(false).getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        List<Map<String, Object>> questions = new ArrayList<>();

        String sql = "SELECT mission_id, title, description, category, "
                + "difficulty, choice_a, choice_b, choice_c, choice_d, "
                + "xp_reward FROM missions ORDER BY mission_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Map<String, Object> question = new HashMap<>();

                question.put("missionId", result.getInt("mission_id"));
                question.put("title", result.getString("title"));
                question.put("description", result.getString("description"));
                question.put("category", result.getString("category"));
                question.put("difficulty", result.getString("difficulty"));

                question.put("choiceA", result.getString("choice_a"));
                question.put("choiceB", result.getString("choice_b"));
                question.put("choiceC", result.getString("choice_c"));
                question.put("choiceD", result.getString("choice_d"));

                question.put("xpReward", result.getInt("xp_reward"));

                questions.add(question);
            }

            request.setAttribute("questions", questions);

            // Forward the questions to the JSP page
            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            getServletContext().log("Unable to load questions", e);

            request.setAttribute(
                    "error",
                    "Unable to load questions. Please try again."
            );

            request.getRequestDispatcher("/view-questions.jsp")
                   .forward(request, response);
        }
    }
}
