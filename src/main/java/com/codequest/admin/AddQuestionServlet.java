
package com.codequest.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/add-question")
public class AddQuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether the administrator is logged in
        if (request.getSession(false) == null
                || request.getSession(false).getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        String choiceA = request.getParameter("choiceA");
        String choiceB = request.getParameter("choiceB");
        String choiceC = request.getParameter("choiceC");
        String choiceD = request.getParameter("choiceD");

        String correctAnswer = request.getParameter("correctAnswer");
        String xpText = request.getParameter("xpReward");

        // Validate required fields
        if (title == null || description == null
                || category == null || difficulty == null
                || choiceA == null || choiceB == null
                || choiceC == null || choiceD == null
                || correctAnswer == null || xpText == null
                || title.trim().isEmpty()
                || description.trim().isEmpty()
                || choiceA.trim().isEmpty()
                || choiceB.trim().isEmpty()
                || choiceC.trim().isEmpty()
                || choiceD.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all the fields.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        title = title.trim();
        description = description.trim();
        category = category.trim();
        difficulty = difficulty.trim();
        choiceA = choiceA.trim();
        choiceB = choiceB.trim();
        choiceC = choiceC.trim();
        choiceD = choiceD.trim();
        correctAnswer = correctAnswer.trim().toUpperCase();

        // Validate category
        if (!category.equals("Java")
                && !category.equals("SQL")
                && !category.equals("DSA")) {

            request.setAttribute("error", "Please select a valid category.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        // Validate difficulty
        if (!difficulty.equals("Easy")
                && !difficulty.equals("Medium")
                && !difficulty.equals("Hard")) {

            request.setAttribute("error", "Please select a valid difficulty.");
            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        // Correct answer must be A, B, C, or D
        if (!correctAnswer.matches("[ABCD]")) {

            request.setAttribute(
                    "error",
                    "Correct answer must be A, B, C, or D."
            );

            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        int xpReward;

        try {
            xpReward = Integer.parseInt(xpText);

            if (xpReward <= 0 || xpReward > 10000) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "XP reward must be a number between 1 and 10000."
            );

            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "INSERT INTO missions "
                + "(title, description, category, difficulty, "
                + "choice_a, choice_b, choice_c, choice_d, "
                + "correct_answer, xp_reward) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, title);
            statement.setString(2, description);
            statement.setString(3, category);
            statement.setString(4, difficulty);
            statement.setString(5, choiceA);
            statement.setString(6, choiceB);
            statement.setString(7, choiceC);
            statement.setString(8, choiceD);
            statement.setString(9, correctAnswer);
            statement.setInt(10, xpReward);

            statement.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/add-question.jsp?success=added"
            );

        } catch (SQLException e) {

            getServletContext().log("Error adding mission", e);

            request.setAttribute(
                    "error",
                    "Unable to add the question. Please try again."
            );

            request.getRequestDispatcher("/add-question.jsp")
                   .forward(request, response);
        }
    }
}
