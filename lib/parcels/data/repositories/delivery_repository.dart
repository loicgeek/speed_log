import 'package:appwrite/appwrite.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/utils/collection_ids.dart';
import 'package:speedest_logistics/parcels/data/models/offer.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';

class DeliveryRepository {
  ApiClient apiClient;
  DeliveryRepository({required this.apiClient});

  Future<Parcel> sendParcel({
    required String title,
    required String description,
    required String cityId,
    required String cityName,
    required String fromId,
    required String fromName,
    required String fromDescription,
    required String toId,
    required String toName,
    required String toDescription,
    required String senderId,
    required String senderName,
    required String receiverName,
    required String receiverPhone,
    required num weight,
  }) async {
    Map<String, dynamic> data = {};
    data["title"] = title;
    data["description"] = description;
    data["city_id"] = cityId;
    data["city_name"] = cityName;
    data["sender_id"] = senderId;
    data["sender_name"] = senderName;
    data["receiver_name"] = receiverName;
    data["receiver_phone"] = receiverPhone;
    data["weight"] = weight;
    data["status"] = 'waiting';

    data["from_id"] = fromId;
    data["from_name"] = fromName;
    data["from_description"] = fromDescription;

    data["to_id"] = toId;
    data["to_name"] = toName;
    data["to_description"] = toDescription;
    data["created_at"] = DateTime.now().toIso8601String();

    var doc = await apiClient.database.createDocument(
      collectionId: CollectionIds.deliveries,
      documentId: "unique()",
      data: data,
      read: ["role:all"],
      write: ["role:all"],
    );

    return Parcel.fromJson(doc.data);
  }

  Future<Parcel> findOne(String parcelId) async {
    var doc = await apiClient.database.getDocument(
        collectionId: CollectionIds.deliveries, documentId: parcelId);
    var data = Parcel.fromJson({
      ...doc.data,
      "id": doc.$id,
    });
    return data;
  }

  Future<Parcel> update({
    required String parcelId,
    String? deliveryManId,
    String? deliveryManName,
    String? deliveryManPhone,
    int? amount,
    String? status,
  }) async {
    Map<String, dynamic> data = {};
    data["delivery_man_id"] = deliveryManId;
    data["delivery_man_name"] = deliveryManName;
    data["delivery_man_phone"] = deliveryManPhone;
    data["amount"] = amount;
    data["status"] = status;
    var doc = await apiClient.database.updateDocument(
      collectionId: CollectionIds.deliveries,
      documentId: parcelId,
      data: data,
    );
    return Parcel.fromJson(doc.data);
  }

  Future<List<Parcel>> find({
    String? senderId,
    String? deliveryManId,
    String? status,
    String? notSenderId,
  }) async {
    List queries = [];
    if (senderId != null) {
      queries.add(Query.equal('sender_id', senderId));
    }
    if (notSenderId != null) {
      queries.add(Query.notEqual('sender_id', notSenderId));
    }
    if (status != null) {
      queries.add(Query.equal('status', status));
    }
    if (deliveryManId != null) {
      queries.add(Query.equal('delivery_man_id', deliveryManId));
    }

    var docs = await apiClient.database.listDocuments(
      collectionId: CollectionIds.deliveries,
      queries: queries,
    );
    var data = docs.documents
        .map(
          (e) => Parcel.fromJson({...e.data}),
        )
        .toList();

    return data;
  }

  Future<List<Offer>> findOffers({
    String? parcelId,
  }) async {
    List queries = [];
    if (parcelId != null) {
      queries.add(Query.equal('parcel_id', parcelId));
    }

    var docs = await apiClient.database.listDocuments(
      collectionId: CollectionIds.offers,
      queries: queries,
    );
    var data = docs.documents
        .map(
          (e) => Offer.fromJson({...e.data}),
        )
        .toList();

    return data;
  }

  Future<Offer> sendOffer({
    required int amount,
    required String parcelId,
    required String parcelTitle,
    required String username,
    required String phone,
    required String userId,
  }) async {
    Map<String, dynamic> data = {};
    data["amount"] = amount;
    data["parcel_id"] = parcelId;
    data["parcel_title"] = parcelTitle;
    data["username"] = username;
    data["user_id"] = userId;
    data["phone"] = phone;
    data["created_at"] = DateTime.now().toIso8601String();

    var doc = await apiClient.database.createDocument(
      collectionId: CollectionIds.offers,
      documentId: "unique()",
      data: data,
      read: ["role:all"],
      write: ["role:all"],
    );

    return Offer.fromJson(doc.data);
  }

  Future<Offer> updateOffer({
    required String offerId,
    String? status,
  }) async {
    Map<String, dynamic> data = {};
    data["status"] = status;
    var doc = await apiClient.database.updateDocument(
      collectionId: CollectionIds.offers,
      documentId: offerId,
      data: data,
    );
    return Offer.fromJson(doc.data);
  }
}
