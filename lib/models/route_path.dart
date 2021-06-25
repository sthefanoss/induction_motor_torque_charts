class RoutePath {
  final int? id;
  final bool isUnknown;
  final bool isEditorPage;

  RoutePath.home()
      : id = null,
        isUnknown = false,
        isEditorPage = false;

  RoutePath.details(this.id)
      : isUnknown = false,
        isEditorPage = false;

  RoutePath.editor([this.id])
      : isUnknown = false,
        isEditorPage = true;

  RoutePath.unknown()
      : id = null,
        isUnknown = true,
        isEditorPage = false;

  bool get isHomePage => id == null && isEditorPage == false;
  bool get isDetailsPage => id != null && isEditorPage == false;
}
