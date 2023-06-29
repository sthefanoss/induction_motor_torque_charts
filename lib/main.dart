import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:induction_motor_torque_charts/models/motor.dart';
import 'package:induction_motor_torque_charts/screens/motor_details_screen.dart';
import 'package:induction_motor_torque_charts/screens/motor_editor_screen.dart';
import 'package:induction_motor_torque_charts/screens/motors_list_screen.dart';
import 'package:provider/provider.dart';

class MotorsController extends ChangeNotifier {
  List<Motor> motors = [...Motor.list];

  void add(Motor newMotor) {
    motors.add(newMotor);
    notifyListeners();
  }
}

void main() => runApp(ChangeNotifierProvider(
      create: (_) => MotorsController(),
      child: BooksApp(),
    ));

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

/*
http://localhost:51845/#/share?name=Motor+de+50hp+&pn=37285&p=4&f=60&vl=460&r1=0.087&x1=0.302&xm=13.08&r2=0.228&x2=0.302
*/
class _BooksAppState extends State<BooksApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MotorsListScreen(), routes: [
        GoRoute(path: 'new', builder: (context, state) => const MotorEditorScreen()),
        GoRoute(
            path: 'share',
            redirect: (context, state) {
              try {
                print(state.pathParameters);
                final newMotor = Motor.fromMap(state.queryParameters);
                final motorController = context.read<MotorsController>();
                motorController.add(newMotor);
                return '/${motorController.motors.length - 1}';
              } catch (e) {
                print(e);
                return '/';
              }
            }),
        GoRoute(
            path: ':index',
            builder: (context, state) => const MotorDetailsScreen(),
            redirect: (context, state) {
              final index = int.tryParse(state.pathParameters['index']!);
              if (index == null || index < 0 || index >= context.read<MotorsController>().motors.length) {
                return '/';
              }
            }),
      ]),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Motor App',
      routerConfig: _router,
    );
  }
}
