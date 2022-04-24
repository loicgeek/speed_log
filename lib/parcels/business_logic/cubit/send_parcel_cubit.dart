import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/app/utils/helpers.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/parcel.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';
import 'package:speedest_logistics/parcels/data/repositories/delivery_repository.dart';

part 'send_parcel_state.dart';

class SendParcelCubit extends Cubit<SendParcelState> {
  final DeliveryRepository deliveryRepository;
  SendParcelCubit(this.deliveryRepository) : super(SendParcelInitial());

  startParcel({
    required City city,
    required Quarter from,
    required Quarter to,
  }) {
    emit(SendParcelStarted(city: city, from: from, to: to));
  }

  sendParcel({
    required String fromDetails,
    required String toDetails,
    required String title,
    required String description,
    required num weight,
    required String senderId,
    required String senderName,
    required String receiverName,
    required String receiverPhone,
  }) async {
    try {
      emit(
        SendParcelLoading(
          city: state.city!,
          from: state.from!,
          to: state.to!,
        ),
      );
      Parcel parcel = await deliveryRepository.sendParcel(
        title: title,
        description: description,
        senderId: senderId,
        senderName: senderName,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        cityId: state.city!.id,
        cityName: state.city!.name,
        weight: weight,
        fromId: state.from!.id,
        fromName: state.from!.name,
        fromDescription: fromDetails,
        toId: state.to!.id,
        toName: state.to!.name,
        toDescription: toDetails,
      );
      emit(SendParcelSucess());
    } catch (e) {
      print(e);
      emit(
        SendParcelFailure(
          city: state.city!,
          from: state.from!,
          to: state.to!,
          message: Helpers.extractErrorMessage(e),
        ),
      );
    }
  }
}
