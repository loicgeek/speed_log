part of 'send_parcel_cubit.dart';

@immutable
abstract class SendParcelState {
  final City? city;
  final Quarter? from;
  final Quarter? to;
  final String? description;
  const SendParcelState({
    this.city,
    this.from,
    this.to,
    this.description,
  });
}

class SendParcelInitial extends SendParcelState {
  const SendParcelInitial()
      : super(city: null, from: null, to: null, description: null);
}

class SendParcelStarted extends SendParcelState {
  const SendParcelStarted({
    required City city,
    required Quarter from,
    required Quarter to,
  }) : super(
          city: city,
          from: from,
          to: to,
        );
}

class SendParcelLoading extends SendParcelState {
  const SendParcelLoading({
    required City city,
    required Quarter from,
    required Quarter to,
  }) : super(
          city: city,
          from: from,
          to: to,
        );
}

class SendParcelFailure extends SendParcelState {
  final String message;
  const SendParcelFailure({
    required City city,
    required Quarter from,
    required Quarter to,
    required this.message,
  }) : super(
          city: city,
          from: from,
          to: to,
        );
}

class SendParcelSucess extends SendParcelState {}
