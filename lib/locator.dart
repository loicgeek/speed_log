import 'package:get_it/get_it.dart';
import 'package:speedest_logistics/parcels/data/repositories/city_repository.dart';

import 'app/data/api_client.dart';
import 'auth/data/auth_service.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerSingleton<ApiClient>(
    ApiClient(),
  );
  locator.registerSingleton<AuthService>(
    AuthService(apiClient: locator.get<ApiClient>()),
  );

  locator.registerSingleton<CityRepository>(
    CityRepository(apiClient: locator.get<ApiClient>()),
  );
}
