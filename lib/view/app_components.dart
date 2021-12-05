import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class BuildDefaultButton extends StatelessWidget {
  final Function onClicked;
  final Color buttonColor;
  final String buttonTitle;

  const BuildDefaultButton(
      {@required this.onClicked,
      @required this.buttonColor,
      @required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        height: 40.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: buttonColor,
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}


void showToast(BuildContext context, String message) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}