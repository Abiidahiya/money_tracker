import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String name;
  final Color containerColor;
  final TextStyle textStyle;
  final double fontSize;
  final Color fontColor;
  final double height;
  final double width;
  final double borderRadius;
  final VoidCallback? onTap; // ✅ Add onTap callback

  const CustomContainer({
    Key? key,
    required this.name,
    required this.containerColor,
    required this.textStyle,
    required this.fontSize,
    required this.fontColor,
    this.height = 80.0,
    this.width = double.infinity,
    this.borderRadius = 20.0,
    this.onTap, // ✅ Make it optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped: $name"); // ✅ Log when tapped
        if (onTap != null) {
          onTap!(); // ✅ Call the callback function
        } else {
          print("No onTap function provided for $name"); // ✅ Debugging log
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            name,
            style: textStyle.copyWith(fontSize: fontSize, color: fontColor),
          ),
        ),
      ),
    );
  }
}