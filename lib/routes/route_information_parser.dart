import 'package:flutter/material.dart';
import '../models/motor.dart';
import '../models/route_path.dart';

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    try {
      final uri = Uri.parse(routeInformation.location ?? '/');
      // Handle '/'
      if (uri.pathSegments.length == 0) {
        return RoutePath.home();
      }

      // Handle '/motor/:id'
      if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'motor') {
        int id = int.parse(uri.pathSegments[1]);
        return RoutePath.details(id);
      }

      // Handle '/editor'
      if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'editor') {
        return RoutePath.editor();
      }

      // Handle '/editor/:id'
      if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'editor') {
        int id = int.parse(uri.pathSegments[1]);
        return RoutePath.editor(id);
      }

      // Handle '/share/:motor'
      if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'share') {
        return RoutePath.share(Motor.fromMap(uri.queryParameters));
      }

      // Handle unknown routes
      return RoutePath.unknown();
    } catch (e) {
      return RoutePath.unknown();
    }
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    try {
      if (path.motor != null) {
        final uri = Uri(path: '/share', queryParameters: path.motor!.toMap());
        return RouteInformation(location: uri.toString());
      }

      if (path.isEditorPage && path.id == null) {
        return RouteInformation(location: '/editor');
      }

      if (path.isEditorPage) {
        return RouteInformation(location: '/editor/${path.id}');
      }

      if (path.isHomePage) {
        return RouteInformation(location: '/');
      }
      if (path.isDetailsPage) {
        return RouteInformation(location: '/motor/${path.id}');
      }

      return RouteInformation(location: '/404');
    } catch (e) {
      return RouteInformation(location: '/404');
    }
  }
}
