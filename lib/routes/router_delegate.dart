import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helpers.dart';
import '../models/route_path.dart';
import '../models/motor.dart';
import '../screens/motor_details_screen.dart';
import '../screens/motors_list_screen.dart';
import '../screens/unknown_screen.dart';
import '../screens/motor_editor_screen.dart';
import 'no_animation_transition_delegate.dart';

class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final transitionDelegate = NoAnimationTransitionDelegate();
  List<Motor> motors = [...Motor.list];
  bool show404 = false;
  bool isEditorPage = false;
  Motor? _selectedMotor;
  Motor? get selectedMotor => _selectedMotor;
  int? get indexOfMotor =>
      _selectedMotor != null ? motors.indexOf(_selectedMotor!) : null;

  RoutePath get currentConfiguration {
    if (show404) {
      return RoutePath.unknown();
    }
    if (isEditorPage) {
      return RoutePath.editor(indexOfMotor);
    }
    if (_selectedMotor != null) {
      return RoutePath.details(indexOfMotor);
    }

    return RoutePath.home();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      pages: [
        MaterialPage(
          key: showTableView(context)
              ? ValueKey('MotorsListScreen/$indexOfMotor')
              : ValueKey('MotorsListScreen'),
          child: MotorsListScreen(),
        ),
        if (show404 && !showTableView(context))
          MaterialPage(
            key: ValueKey('UnknownScreen'),
            child: UnknownScreen(),
          )
        else if (_selectedMotor != null && !showTableView(context))
          MaterialPage(
            key: ValueKey('MotorDetailsScreen/$indexOfMotor'),
            child: MotorDetailsScreen(motor: _selectedMotor!),
          )
        else if (isEditorPage && !showTableView(context))
          MaterialPage(
            key: ValueKey('MotorEditorScreen/$indexOfMotor'),
            child: MotorEditorScreen(motor: _selectedMotor),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedMotor to null
        _selectedMotor = null;
        isEditorPage = false;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    if (path.isEditorPage) {
      if (path.id != null)
        _selectedMotor = motors[path.id!];
      else
        _selectedMotor = null;
      isEditorPage = true;
      show404 = false;
      notifyListeners();
      return;
    }
    isEditorPage = false;
    if (path.isUnknown) {
      _selectedMotor = null;
      isEditorPage = false;
      show404 = true;
      notifyListeners();
      return;
    }

    if (path.isDetailsPage && path.id != null) {
      isEditorPage = false;
      if (path.id! < 0 || path.id! > motors.length - 1) {
        show404 = true;
        notifyListeners();
        return;
      }

      _selectedMotor = motors[path.id!];
    } else {
      _selectedMotor = null;
    }

    show404 = false;
    notifyListeners();
  }

  Future<void> selectMotor(int id) async {
    await setNewRoutePath(RoutePath.details(id));
  }

  Future<void> editMotor([int? id]) async {
    await setNewRoutePath(RoutePath.editor(id));
  }

  int saveMotor(Motor motor) {
    motors.add(motor);
    notifyListeners();
    return motors.indexOf(motor);
  }

  static AppRouterDelegate of(BuildContext context) {
    return Router.of(context).routerDelegate as AppRouterDelegate;
  }
}
