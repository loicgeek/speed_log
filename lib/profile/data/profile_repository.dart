import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/auth/data/models/user_model.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository(this.apiClient);

  Future<UserModel> updateProfile({
    required String userId,
    bool? availability,
    bool? isDriver,
    String? name,
    double? lat,
    double? long,
    bool? online,
    String? phone,
    String? token,
  }) async {
    Map<String, dynamic> data = {};
    if (isDriver != null) {
      data["is_driver"] = isDriver;
    }
    if (availability != null) {
      data["is_available"] = availability;
    }
    if (token != null) {
      data["token"] = token;
    }
    if (lat != null) {
      data["latitude"] = lat;
    }
    if (long != null) {
      data["longitude"] = long;
    }
    if (online != null) {
      data["online"] = online;
    }
    if (phone != null) {
      data["phone"] = phone;
    }
    if (name != null) {
      data["name"] = name;
    }

    var doc = await apiClient.database.updateDocument(
      collectionId: CollectionIds.users,
      documentId: userId,
      data: data,
    );
    return UserModel.fromJson(doc.data);
  }

  Future<UserModel> getUser(String userId) async {
    var d = await apiClient.database.getDocument(
      collectionId: CollectionIds.users,
      documentId: userId,
    );

    return UserModel.fromJson(d.data);
  }
}
