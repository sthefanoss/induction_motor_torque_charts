import 'implementation/base_uri_stub.dart'
    if (dart.library.js) 'implementation/base_uri_web.dart';

String? getBaseUri() {
  return getBaseUriCall();
}
