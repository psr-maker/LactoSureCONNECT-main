import 'package:LactosureConnect/Constant/core/helper/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    super.key,
    required Null Function() onTap,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      validator: validator,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: TextHelper.textFieldHintTextStyle,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  const CustomTextField1({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    Future<void> getSavedValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedValue = prefs.getString('enteredValue');
      if (savedValue != null) {
        // Set the saved value to the controller
        controller.text = savedValue;
      }
    }

    getSavedValue();

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      validator: validator,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onEditingComplete: () {},
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: TextHelper.textFieldHintTextStyle,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = true,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    Future<void> getSavedValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedValue = prefs.getString('enteredValue');
      if (savedValue != null) {
        // Set the saved value to the controller
        controller.text = savedValue;
      }
    }

    getSavedValue();

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Theme.of(context).primaryColor,
      validator: validator,
      style: const TextStyle(
          color: Colors.white), // Adjust to your TextHelper.textFieldTextStyle
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        LengthLimitingTextInputFormatter(4),
        ...?inputFormatters, // Limit to 4 characters
      ],
      onEditingComplete: () {
        // Add any logic for completion here
      },
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}

class CustomTextField3 extends StatelessWidget {
  const CustomTextField3({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength = 4,
    this.inputFormatters,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    Future<void> getSavedValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedValue = prefs.getString('enteredValue');
      if (savedValue != null) {
        // Set the saved value to the controller
        controller.text = savedValue;
      }
    }

    getSavedValue();

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      validator: validator,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onEditingComplete: () {},
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: TextHelper.textFieldHintTextStyle,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}

class CustomTextFieldu extends StatelessWidget {
  const CustomTextFieldu({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    super.key,
    required Null Function() onTap,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      validator: validator,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: TextHelper.textFieldHintTextStyle,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}
