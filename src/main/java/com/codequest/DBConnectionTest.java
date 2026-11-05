
package com.codequest;

import java.sql.Connection;

public class DBConnectionTest {

    public static void main(String[] args) {

        try {
            Connection connection = DBConnection.getConnection();

            if (connection != null) {
                System.out.println("================================");
                System.out.println("CODEQUEST DATABASE CONNECTED!");
                System.out.println("MySQL connection successful.");
                System.out.println("================================");

                connection.close();
            }

        } catch (Exception e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
