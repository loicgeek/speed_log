import 'package:appwrite/models.dart';
import 'package:test_app_write/app/data/api_client.dart';
import 'package:test_app_write/app/utils/collection_ids.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});
  Future<Session> login({
    required String email,
    required String password,
  }) {
    return apiClient.account.createSession(email: email, password: password);
  }

  Future<User> getCurrentUser() {
    return apiClient.account.get();
  }

  Future<User> register({
    required String email,
    required String password,
    String? name,
  }) async {
    var user = await apiClient.account.create(
      email: email,
      password: password,
      userId: "unique()",
      name: name,
    );
    await apiClient.database.createDocument(
        collectionId: CollectionIds.users,
        documentId: user.$id,
        data: {
          "email": email,
          "name": name,
        });
    return user;
  }

  Future logout() async {
    User user = await apiClient.account.get();
  }
}
