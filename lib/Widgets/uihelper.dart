import 'package:flutter/material.dart';

class UiHelper {
  /// Custom Text Button with optional custom text style
  static Widget CustomTextButton({
    required String text,
    required VoidCallback callback,
    TextStyle? style,
  }) {
    return TextButton(
      onPressed: callback,
      child: Text(
        text,
        style: style ?? const TextStyle(fontSize: 22, color: Colors.black),
      ),
    );
  }

  /// Custom Text Field
  static Widget CustomTestField({
    required TextEditingController controller,
    required String text,
    required bool tohide,
    required TextInputType textinputtype,
  }) {
    return Container(
      height: 363,
      width: 335,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        obscureText: tohide,
        keyboardType: textinputtype,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF000000),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// Custom Image Loader from assets
  static Widget CustomImage({
    required String imgurl,
    double height = 200,
    double width = 200,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      "assets/images/$imgurl",
      height: height,
      width: width,
      fit: fit,
    );
  }

  /// Bold Text Style
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  /// Header Text Style
  static TextStyle HeaderTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  /// Light Text Style
  static TextStyle LightTextFieldStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle semiBoldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }
}
