// ignore_for_file: unused_import

import 'package:LactosureConnect/Constant/core/helper/text_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onTap,
    this.child,
    this.text,
    this.borderRadius = 16,
    this.maxHeight = 146,
    this.maxWidth = double.infinity,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double borderRadius;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Get.theme.primaryColor,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Get.theme.primaryColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor.withOpacity(0.26),
                Get.theme.primaryColor.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onTap,
    this.child,
    this.text,
    this.borderRadius = 16,
    this.maxHeight = 46,
    this.maxWidth = double.infinity,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double borderRadius;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Get.theme.primaryColor,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withOpacity(0.07),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}

class ElevatedGradButton extends StatelessWidget {
  const ElevatedGradButton({
    required this.onTap,
    this.child,
    this.text,
    this.maxHeight = 46,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(0, 214, 187, 187),
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 190, 149),
                Color.fromARGB(255, 19, 18, 18)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}

class CaptionButton extends StatelessWidget {
  const CaptionButton({
    required this.onTap,
    this.child,
    this.text,
    this.maxHeight = 32,
    this.maxWidth = double.maxFinite,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white10,
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            alignment: Alignment.center,
            child: child ??
                (text != null
                    ? Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: TextHelper.captionButtonTextStyle,
                      )
                    : null),
          ),
        ),
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    required this.onTap,
    required this.icon,
    this.radius = 16,
    super.key,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        splashColor: Colors.green.shade300,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.teal.shade200.withOpacity(0.4),
            ),
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.teal.shade200.withOpacity(0.26),
                Colors.teal.shade200.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: radius * 2,
          height: radius * 2,
          alignment: Alignment.center,
          child: Icon(icon, size: radius, color: Colors.teal.shade200),
        ),
      ),
    );
  }
}

class PrimaryButton1 extends StatelessWidget {
  const PrimaryButton1({
    required this.onTap,
    this.child,
    this.text,
    this.borderRadius = 16,
    this.maxHeight = 146,
    this.maxWidth = double.infinity,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double borderRadius;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Get.theme.primaryColor,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Get.theme.primaryColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor.withOpacity(0.26),
                Get.theme.primaryColor.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : null),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class select extends StatefulWidget {
  const select({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _selectState createState() => _selectState();
}

// ignore: camel_case_types
class _selectState extends State<select> {
  List<bool> isSelected = [true, false]; // Track the selected state of buttons

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(230, 840, 0, 0),
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            // Toggle the state of the buttons
            isSelected[index] = !isSelected[index];

            // Handle the selected option
            if (isSelected[0]) {
              // Option 1 selected
            } else if (isSelected[1]) {
              // Option 2 selected
            }
          });
        },
        color: Colors.blue, // Background color of the buttons
        selectedColor: Colors.white, // Text color when button is selected
        fillColor: Colors.blue, // Background color when button is selected
        borderRadius: BorderRadius.circular(10.0),
        children: [
          // Option 1
          Icon(Icons.bluetooth,
              color: isSelected[0] ? Colors.white : Colors.black),
          // Option 2
          Icon(Icons.wifi, color: isSelected[1] ? Colors.white : Colors.black),
        ], // Adjust the radius as needed
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  final String buttonName;

  const MyButton({Key? key, required this.buttonName}) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: 120.0.r, // Adjust the width for size
          height: 50.0.r, // Adjust the height for size
          padding: EdgeInsets.all(1.0.r),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 6, 20, 31),
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 255, 235, 246),
                const Color.fromARGB(255, 12, 14, 16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 16, 29),
                  const Color.fromARGB(255, 8, 31, 49),
                  const Color.fromARGB(255, 2, 18, 37),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                widget.buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.r,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final VoidCallback onPressed;
  final double imageSize;

  ImageButton({
    required this.image,
    required this.title,
    required this.onPressed,
    this.imageSize = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(10, 10),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: image,
            width: 25.r,
            height: 25.r,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 18),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 2,
            ),
          ),
        ],
      ),
    );
  }
}

late bool PSelected;

class TickBoxButton1 extends StatefulWidget {
  final bool x; // Change the type to String

  final ValueChanged<bool>? onChanged;

  const TickBoxButton1({
    Key? key,
    required this.x,
    this.onChanged,
  }) : super(key: key);

  @override
  _TickBoxButton1State createState() => _TickBoxButton1State();
}

class _TickBoxButton1State extends State<TickBoxButton1> {
  bool _isSelected = false; // Track selection state internally

  @override
  void initState() {
    super.initState();
    // Set the initial selection based on the value of 'x'
    _isSelected = widget.x == true; // Check if x equals '1'
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected; // Toggle selection state
          widget.onChanged?.call(_isSelected); // Notify parent about change
        });
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: const Color.fromARGB(255, 192, 183, 183)),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: _isSelected
            ? const Icon(Icons.check,
                size: 20.0, color: Colors.green) // Tick icon when selected
            : null, // No icon when not selected
      ),
    );
  }
}
