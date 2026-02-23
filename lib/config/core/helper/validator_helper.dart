import 'package:flutter/material.dart';

/// A class containing various validators for text fields.
class AppValidator {
  AppValidator._();

  /// Validates an email address.
  ///
  /// Returns null if the email address is valid, otherwise returns an error
  /// message.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Адрес электронной почты не может быть пустым';
    }
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Неверный формат адреса электронной почты';
    }
    return null; // Valid email address
  }

  /// Validates a password.
  ///
  /// Returns null if the password is valid, otherwise returns an error message.
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Пароль не может быть пустым';
    }
    if (password.length < 6) {
      return 'Пароль должен содержать не менее 6 символов';
    }
    return null; // Valid password
  }

  /// Validates a required field using its name.
  ///
  /// Returns null if the field is valid, otherwise returns an error message.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName не может быть пустым'; // Using the field name in the error message
    }
    return null; // Valid input
  }

  /// Validates a confirm password field.
  ///
  /// Returns null if the confirm password is valid, otherwise returns an error
  /// message.
  static String? validateConfirmPassword(String? confirmPassword, TextEditingController passwordController) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Поле подтверждения пароля не может быть пустым'; // Error message for empty field
    }
    if (confirmPassword != passwordController.text) {
      return 'Пароли не совпадают'; // Error message for non-matching passwords
    }
    return null; // Valid confirm password
  }

  /// Validates a username.
  ///
  /// Returns null if the username is valid, otherwise returns an error message.
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Имя пользователя не может быть пустым';
    }
    if (username.length < 3) {
      return 'Имя пользователя должно содержать не менее 3 символов';
    }
    return null;
  }

  /// Validates a name.
  ///
  /// Returns null if the name is valid, otherwise returns an error message.
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Имя не может быть пустым';
    }
    if (name.length < 3) {
      return 'Имя должно содержать не менее 3 символов';
    }
    return null;
  }
}
