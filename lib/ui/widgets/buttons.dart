import 'package:bank_sha/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const CustomFilledButton(
      {super.key,
      required this.title,
      this.width = double.infinity,
      this.height = 50,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor: purpleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(56),
              )),
          child: Text(
            title,
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          )),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const CustomTextButton(
      {super.key,
      required this.title,
      this.width = double.infinity,
      this.height = 50,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
            title,
            style: greyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: regular,
            ),
          )),
    );
  }
}

class CustomNumberButton extends StatefulWidget {
  final String number;
  final VoidCallback? onTap;

  const CustomNumberButton({super.key, required this.number, this.onTap});

  @override
  State<CustomNumberButton> createState() => _CustomNumberButtonState();
}

class _CustomNumberButtonState extends State<CustomNumberButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPressed ? whiteColor : numberBackgroundColor,
        ),
        child: Center(
          child: Text(
            widget.number,
            style: isPressed
                ? GoogleFonts.poppins(
                    color: numberBackgroundColor,
                    fontSize: 22,
                    fontWeight: semiBold,
                  )
                : whiteTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: semiBold,
                  ),
          ),
        ),
      ),
    );
  }
}
