import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';

part 'send_parcel_state.dart';

class SendParcelCubit extends Cubit<SendParcelState> {
  SendParcelCubit() : super(SendParcelInitial());

  startParcel({
    required City city,
    required Quarter from,
    required Quarter to,
  }) {
    emit(SendParcelStarted(city: city, from: from, to: to));
  }
}
