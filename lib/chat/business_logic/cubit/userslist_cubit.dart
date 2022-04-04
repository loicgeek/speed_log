import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'userslist_state.dart';

class UserslistCubit extends Cubit<UserslistState> {
  UserslistCubit() : super(UserslistInitial());
}
