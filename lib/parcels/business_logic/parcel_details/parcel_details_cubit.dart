import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/utils/helpers.dart';
import 'package:speedest_logistics/parcels/data/models/offer.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';

part 'parcel_details_state.dart';

class ParcelDetailsCubit extends Cubit<ParcelDetailsState> {
  String parcelId;
  DeliveryRepository repository;
  ParcelDetailsCubit({
    required this.parcelId,
    required this.repository,
  }) : super(ParcelDetailsInitial());

  loadDetails() async {
    try {
      emit(LoadParcelDetailsLoading());
      Parcel p = await repository.findOne(parcelId);
      emit(LoadParcelDetailsSucess(parcel: p));
      var offers = await repository.findOffers(parcelId: parcelId);
      emit(LoadParcelDetailsSucess(parcel: state.parcel, offers: offers));
    } catch (e) {
      emit(
        LoadParcelDetailsFailure(
            message: Helpers.extractErrorMessage(e),
            parcel: state.parcel,
            offers: state.offers),
      );
    }
  }

  sendOffer({
    required int amount,
    required String username,
    required String userId,
    required String phone,
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
    } catch (e) {
      // emit(
      //   LoadParcelDetailsFailure(
      //       message: Helpers.extractErrorMessage(e),
      //       parcel: state.parcel,
      //       offers: state.offers),
      // );
    }
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
      emit(
        LoadParcelDetailsSucess(parcel: p, offers: offers),
      );
    } catch (e) {}
  }
}
