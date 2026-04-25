import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/models/user_model.dart';
import 'package:project_mobile_application/features/register_view/cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      var box = Hive.box<UserModel>('userBox');
      UserModel user = UserModel(
        fullName: fullName,
        email: email,
        password: password,
      );
      await box.add(user);
      var sessionBox = Hive.box('sessionBox');
      await sessionBox.put('userName', fullName);
      await sessionBox.put('userEmail', email);
      await sessionBox.put('userKey', email);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(errMessage: e.toString()));
    }
  }
}
