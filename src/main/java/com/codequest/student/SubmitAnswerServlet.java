
package com.codequest.student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.codequest.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check student login
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        int missionId;

        try {
            missionId = Integer.parseInt(request.getParameter("missionId"));
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid mission ID.");
            return;
        }

        String selectedAnswer = request.getParameter("selectedAnswer");

        if (selectedAnswer == null ||
                !selectedAnswer.matches("[ABCD]")) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please select a valid answer.");
            return;
        }

        String correctAnswer;
        int xpReward;
        boolean isCorrect;
        int awardedXP;

        try (Connection connection = DBConnection.getConnection()) {

            // Start database transaction
            connection.setAutoCommit(false);

            try {

                // Get the correct answer from the database
                String missionSql =
                        "SELECT correct_answer, xp_reward " +
                        "FROM missions WHERE mission_id = ?";

                try (PreparedStatement missionStatement =
                             connection.prepareStatement(missionSql)) {

                    missionStatement.setInt(1, missionId);

                    try (ResultSet result =
                                 missionStatement.executeQuery()) {

                        if (!result.next()) {
                            connection.rollback();

                            response.sendError(
                                    HttpServletResponse.SC_NOT_FOUND,
                                    "Mission not found.");
                            return;
                        }

                        correctAnswer =
                                result.getString("correct_answer");

                        xpReward = result.getInt("xp_reward");
                    }
                }

                // Compare the selected answer with the correct answer
                isCorrect = selectedAnswer.equalsIgnoreCase(
                        correctAnswer.trim());

                awardedXP = isCorrect ? xpReward : 0;

                // Save the student's submission
                String insertSql =
                        "INSERT INTO mission_submissions " +
                        "(user_id, mission_id, selected_answer, " +
                        "is_correct, xp_awarded) " +
                        "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement insertStatement =
                             connection.prepareStatement(insertSql)) {

                    insertStatement.setInt(1, studentId);
                    insertStatement.setInt(2, missionId);
                    insertStatement.setString(3, selectedAnswer);
                    insertStatement.setBoolean(4, isCorrect);
                    insertStatement.setInt(5, awardedXP);

                    insertStatement.executeUpdate();
                }

                // Award XP and update level only for correct answers
                if (isCorrect) {

                    String updateSql =
                            "UPDATE users " +
                            "SET xp = xp + ?, " +
                            "level = FLOOR((xp + ?) / 100) + 1 " +
                            "WHERE user_id = ?";

                    try (PreparedStatement updateStatement =
                                 connection.prepareStatement(updateSql)) {

                        updateStatement.setInt(1, awardedXP);
                        updateStatement.setInt(2, awardedXP);
                        updateStatement.setInt(3, studentId);

                        updateStatement.executeUpdate();
                    }
                }

                // Save all database changes together
                connection.commit();

                request.setAttribute("isCorrect", isCorrect);
                request.setAttribute("awardedXP", awardedXP);
                request.setAttribute("selectedAnswer", selectedAnswer);
                request.setAttribute("missionId", missionId);

                request.getRequestDispatcher("/mission-result.jsp")
                       .forward(request, response);

            } catch (SQLException e) {

                connection.rollback();

                // Handle duplicate mission submission
                if ("23000".equals(e.getSQLState())) {

                    response.sendRedirect(
                            request.getContextPath() +
                            "/missions?error=already_attempted");
                    return;
                }

                throw e;

            } finally {
                connection.setAutoCommit(true);
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process your answer. Please try again.");
        }
    }
}
