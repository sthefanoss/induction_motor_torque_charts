import 'package:flutter/material.dart';
import '../models/motor.dart';

class MotorTile extends StatelessWidget {
  final Motor motor;
  final VoidCallback onTap;
  final bool selected;

  const MotorTile({
    required this.motor,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: onTap,
      title: Text(motor.name),
      subtitle: Text(
        'R1 = ${motor.R1}Ω |'
        ' X1 = ${motor.X1}Ω |'
        ' Xm = ${motor.Xm}Ω |'
        ' R2 = ${motor.R2}Ω |'
        ' X2 = ${motor.X2}Ω',
      ),
      selected: selected,
    );
  }
}
