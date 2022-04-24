import 'package:appwrite/models.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await apiClient.account.createSession(email: email, password: password);
    return getCurrentUser();
  }

  Future<UserModel> getCurrentUser() async {
    var u = await apiClient.account.get();
    var d = await apiClient.database.getDocument(
      collectionId: CollectionIds.users,
      documentId: u.$id,
    );

    return UserModel.fromJson(d.data);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    var user = await apiClient.account.create(
      email: email,
      password: password,
      userId: "unique()",
      name: name,
    );

    await apiClient.account.createSession(email: email, password: password);

    var d = await apiClient.database.createDocument(
      collectionId: CollectionIds.users,
      documentId: user.$id,
      data: {
        "email": email,
        "name": name,
        "phone": phone,
      },
      read: ["role:all"],
      write: ["user:${user.$id}"],
    );
    return UserModel.fromJson(d.data);
  }

  Future<bool> logout() async {
    SessionList sessions = await apiClient.account.getSessions();
    for (var item in sessions.sessions) {
      if (item.current) {
        apiClient.account.deleteSession(sessionId: item.$id);
        break;
      }
    }
    return true;
  }
}
