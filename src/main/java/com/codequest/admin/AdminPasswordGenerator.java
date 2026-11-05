package com.codequest.admin;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class AdminPasswordGenerator {

    public static void main(String[] args) throws Exception {

        String password = "Admin@123";

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        KeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                600000,
                256
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] hash = factory.generateSecret(spec).getEncoded();

        String saltText = Base64.getEncoder().encodeToString(salt);
        String hashText = Base64.getEncoder().encodeToString(hash);

        System.out.println("ADMIN PASSWORD HASH:");
        System.out.println(saltText + ":" + hashText);
    }
}