import 'motor.dart';

class RoutePath {
  final int? id;
  final Motor? motor;
  final bool isUnknown;
  final bool isEditorPage;

  RoutePath.home()
      : id = null,
        isUnknown = false,
        isEditorPage = false,
        motor = null;

  RoutePath.details(this.id)
      : isUnknown = false,
        isEditorPage = false,
        motor = null;

  RoutePath.editor([this.id])
      : isUnknown = false,
        isEditorPage = true,
        motor = null;

  RoutePath.unknown()
      : id = null,
        isUnknown = true,
        isEditorPage = false,
        motor = null;

  RoutePath.share(this.motor)
      : id = null,
        isUnknown = false,
        isEditorPage = false;

  bool get isHomePage => id == null && isEditorPage == false && motor == null;
  bool get isDetailsPage =>
      id != null && isEditorPage == false && motor == null;
}
