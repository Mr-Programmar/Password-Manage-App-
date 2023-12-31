import 'package:flutter/material.dart';

class ThreeWidgetButton extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;
  final void Function()? onPressed;

  const ThreeWidgetButton({
    Key? key,
    this.left,
    required this.center,
    this.right,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 255, 255, 255),
        shadowColor: const Color.fromARGB(255, 165, 156, 154),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            if (left != null) left!,
            Flexible(
              fit: FlexFit.tight,
              child: center,
            ),
            if (right != null) right!,
          ],
        ),
      ),
    );
  }
}
