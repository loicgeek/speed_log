import 'package:appwrite/appwrite.dart';

class ApiClient {
  Client get _client {
    Client client = Client();
    client
        .setEndpoint(
            'http://appwrite.ntech-services.com:8005/v1') // Your Appwrite Endpoint
        .setProject('624005bd3985e60af083') // Your project ID
        .setSelfSigned(status: true);

    return client;
  }

  Account get account => Account(_instance._client);
  Database get database => Database(_instance._client);
  Storage get storage => Storage(_instance._client);
  Realtime get realtime => Realtime(_instance._client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}
