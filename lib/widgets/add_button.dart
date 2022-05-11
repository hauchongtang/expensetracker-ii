import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final function;

  AddButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: Color(0xff05386b),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(color: Color(0xffedf5e1), fontSize: 25),
          ),
        ),
      ),
    );
  }
}
