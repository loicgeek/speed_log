import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/data/notification_client.dart';
import 'package:speedest_logistics/app/utils/database_events.dart';
import 'package:speedest_logistics/app/utils/utils.dart';
import 'package:speedest_logistics/background_location_handler.dart';
import 'package:speedest_logistics/parcels/data/models/offer.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';
import 'package:speedest_logistics/profile/data/profile_repository.dart';

part 'parcel_details_state.dart';

class ParcelDetailsCubit extends Cubit<ParcelDetailsState> {
  String parcelId;
  DeliveryRepository repository;
  NotificationClient notificationClient;
  ProfileRepository profileRepository;
  late RealtimeSubscription offersSuscription;
  ParcelDetailsCubit({
    required this.parcelId,
    required this.repository,
    required this.profileRepository,
    required this.notificationClient,
  }) : super(ParcelDetailsInitial()) {
    offersSuscription = repository.apiClient.realtime
        .subscribe(["collections.${CollectionIds.offers}.documents"]);
    offersSuscription.stream.listen((event) {
      var offer = Offer.fromJson(event.payload);

      if (offer.parcelId == parcelId &&
          (event.event == DatabaseEvents.documentCreated ||
              event.event == DatabaseEvents.documentUpdated)) {
        var offers = [...state.offers!];
        int index = offers.indexWhere((element) => element.id == offer.id);
        if (index >= 0) {
          offers[index] = offer;
        } else {
          offers = [...state.offers!, offer];
        }

        emit(LoadParcelDetailsSucess(parcel: state.parcel, offers: offers));
        loadDetails();
      }
    });
  }

  // @override
  // close() async {
  //   offersSuscription.close();
  //   super.close();
  // }

  loadDetails() async {
    try {
      emit(
        LoadParcelDetailsLoading(
          offers: state.offers,
          parcel: state.parcel,
        ),
      );
      Parcel p = await repository.findOne(parcelId);
      emit(LoadParcelDetailsSucess(parcel: p));
      var offers = await repository.findOffers(parcelId: parcelId);
      emit(
        LoadParcelDetailsSucess(
          parcel: state.parcel,
          offers: offers,
        ),
      );
    } catch (e) {
      emit(
        LoadParcelDetailsFailure(
          message: Helpers.extractErrorMessage(e),
          parcel: state.parcel,
          offers: state.offers,
        ),
      );
    }
  }

  Future<Offer?> sendOffer({
    required int amount,
    required String username,
    required String userId,
    required String phone,
    String? toToken,
  }) async {
    try {
      Offer o = await repository.sendOffer(
        amount: amount,
        username: username,
        userId: userId,
        parcelId: parcelId,
        phone: phone,
        parcelTitle: state.parcel!.title,
      );
      emit(LoadParcelDetailsSucess(
        parcel: state.parcel,
        offers: [
          ...state.offers!,
          o,
        ],
      ));
      return o;
    } catch (e) {
      emit(
        LoadParcelDetailsFailure(
          message: Helpers.extractErrorMessage(e),
          parcel: state.parcel,
          offers: state.offers,
        ),
      );
      return null;
    }
  }

  sendOfferNotification(Offer o) async {
    var notifTitle = "New offer  for ${o.parcelTitle}";
    var notifBody =
        "${o.username} offered ${o.amount}XAF to carry ${o.parcelTitle}";
    var user = await profileRepository.getUser(state.parcel!.senderId);
    notificationClient.send(
      title: notifTitle,
      body: notifBody,
      data: {
        "parcel_id": parcelId,
        "type": "new-offer",
      },
      token: user.token,
    );
  }

  sendAcceptedOfferNotification(Offer o) async {
    var notifTitle = "Accepted offer  for ${o.parcelTitle}";
    var notifBody =
        "${state.parcel!.senderName} accepted your offer ${o.amount}XAF to carry ${o.parcelTitle}";
    var user = await profileRepository.getUser(o.userId);
    notificationClient.send(
      title: notifTitle,
      body: notifBody,
      data: {
        "parcel_id": parcelId,
        "type": "accepted-offer",
      },
      token: user.token,
    );
  }

  acceptOffer(Offer offer) async {
    try {
      Parcel p = await repository.update(
        parcelId: parcelId,
        amount: offer.amount,
        deliveryManId: offer.userId,
        deliveryManName: offer.username,
        deliveryManPhone: offer.phone,
        status: "ongoing",
      );
      Offer o = await repository.updateOffer(
        offerId: offer.id,
        status: "accepted",
      );

      int index = state.offers!.indexWhere((o) => o.id == offer.id);
      var offers = [...state.offers!];
      if (index >= 0) {
        offers[index] = o;
      }
      sendAcceptedOfferNotification(o);
      emit(
        LoadParcelDetailsSucess(parcel: p, offers: offers),
      );
    } catch (e) {}
  }

  startDelivery(String parcelId) async {
    try {
      await BackgroundLocationHandler.startLocationService();
      Parcel p = await repository.update(
        parcelId: parcelId,
        status: "started",
      );
      var offers = [...state.offers!];
      emit(
        LoadParcelDetailsSucess(parcel: p, offers: offers),
      );
    } catch (e) {
      print(e);
    }
  }
}
