import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:induction_motor_torque_charts/screens/motor_editor_screen.dart';
import 'package:induction_motor_torque_charts/screens/unknown_screen.dart';
import '../helpers.dart';
import '../routes/router_delegate.dart';
import '../widgets/motor_tile.dart';
import 'motor_details_screen.dart';

class MotorsListPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => MotorsListScreen(),
    );
  }
}

class MotorsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = AppRouterDelegate.of(context);

    final mainContent = ListView.builder(
      itemCount: router.motors.length,
      itemBuilder: (context, index) {
        final motor = router.motors[index];
        return MotorTile(
          motor: motor,
          onTap: () => router.selectMotor(index),
          selected: index == router.indexOfMotor,
        );
      },
    );

    if (showTableView(context)) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 1400),
          child: Row(
            children: [
              Container(
                width: 425,
                child: Scaffold(
                  primary: true,
                  appBar: AppBar(title: Text('Motores')),
                  body: mainContent,
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => router.editMotor(),
                  ),
                ),
              ),
              VerticalDivider(width: 1, color: Colors.grey),
              Expanded(child: _buildWebSelectedPage(router))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: mainContent,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => router.editMotor(),
      ),
    );
  }

  Widget _buildWebSelectedPage(AppRouterDelegate router) {
    if (router.show404) return UnknownScreen();
    if (router.isEditorPage)
      return MotorEditorScreen(motor: router.selectedMotor);
    if (router.selectedMotor != null)
      return MotorDetailsScreen(motor: router.selectedMotor!);
    return Scaffold(appBar: AppBar());
  }
}
