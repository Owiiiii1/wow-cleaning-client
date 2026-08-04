/// In-memory auth session for the current app run.
/// Not persisted (no secure storage yet).
class SessionStore {
  SessionStore._();

  static final SessionStore instance = SessionStore._();

  String? token;
  Map<String, dynamic>? authData;

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  void save({required String? token, required Map<String, dynamic> authData}) {
    this.token = token;
    this.authData = authData;
  }

  void clear() {
    token = null;
    authData = null;
  }
}
