import 'package:flutter/material.dart';
import '../models/route_path.dart';

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location ?? '/');
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return RoutePath.home();
    }

    // Handle '/motor/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'motor') {
      int? id = int.tryParse(uri.pathSegments[1]);
      if (id == null) {
        return RoutePath.unknown();
      }

      return RoutePath.details(id);
    }

    // Handle '/editor'
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'editor') {
      return RoutePath.editor();
    }

    // Handle '/editor/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'editor') {
      int? id = int.tryParse(uri.pathSegments[1]);
      if (id == null) {
        return RoutePath.unknown();
      }
      return RoutePath.editor(id);
    }

    // Handle unknown routes
    return RoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
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
  }
}
