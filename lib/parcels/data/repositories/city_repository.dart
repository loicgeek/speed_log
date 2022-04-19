import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';

class CityRepository {
  ApiClient apiClient;
  CityRepository({
    required this.apiClient,
  });

  Future<List<City>> find(String q) async {
    List queries = [];
    if (q.isNotEmpty) {
      queries.add(Query.search('name', q));
    }
    DocumentList docs = await apiClient.database.listDocuments(
      collectionId: CollectionIds.cities,
      queries: queries,
    );

    var data = docs.documents
        .map(
          (e) => City.fromJson({
            ...e.data,
            "id": e.$id,
          }),
        )
        .toList();

    return data;
  }

  Future<List<Quarter>> findQuarterByCityId(String cityId, String q) async {
    List queries = [
      Query.equal("city_id", cityId),
    ];

    if (q.isNotEmpty) {
      queries.add(Query.search('name', q));
    }

    DocumentList docs = await apiClient.database.listDocuments(
      collectionId: CollectionIds.quarters,
      queries: queries,
      orderAttributes: ["name"],
    );

    var data = docs.documents
        .map(
          (e) => Quarter.fromJson({
            ...e.data,
            "id": e.$id,
          }),
        )
        .toList();

    return data;
  }
}
