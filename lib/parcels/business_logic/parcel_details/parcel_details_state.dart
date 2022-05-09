part of 'parcel_details_cubit.dart';

@immutable
abstract class ParcelDetailsState {
  final Parcel? parcel;
  final List<Offer>? offers;

  const ParcelDetailsState({this.parcel, this.offers});
}

class ParcelDetailsInitial extends ParcelDetailsState {}

class LoadParcelDetailsLoading extends ParcelDetailsState {
  const LoadParcelDetailsLoading({Parcel? parcel, List<Offer>? offers})
      : super(parcel: parcel, offers: offers);
}

class LoadParcelDetailsSucess extends ParcelDetailsState {
  const LoadParcelDetailsSucess({Parcel? parcel, List<Offer>? offers})
      : super(parcel: parcel, offers: offers);
}

class LoadParcelDetailsFailure extends ParcelDetailsState {
  final String message;
  const LoadParcelDetailsFailure({
    required this.message,
    Parcel? parcel,
    List<Offer>? offers,
  }) : super(
          parcel: parcel,
          offers: offers,
        );
}
