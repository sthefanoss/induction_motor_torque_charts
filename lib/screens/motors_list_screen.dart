import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:induction_motor_torque_charts/main.dart';
import 'package:provider/provider.dart';
import '../widgets/motor_tile.dart';

class MotorsListScreen extends StatelessWidget {
  const MotorsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MotorsController>(
        builder: (context, controller, _) => ListView.builder(
          itemCount: controller.motors.length,
          itemBuilder: (context, index) {
            final motor = controller.motors[index];
            return MotorTile(
              motor: motor,
              onTap: () => context.go('/$index'),
              selected: false,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => context.go('/new'),
      ),
    );
  }
}
