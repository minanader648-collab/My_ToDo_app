import 'package:hive/hive.dart';
import 'package:project_mobile_application/core/models/user_model.dart';
import 'package:project_mobile_application/features/login_view/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      var box = Hive.box<UserModel>('userBox');
      
      for (var i = 0; i < box.length; i++) {
        var user = box.getAt(i);
        if (user != null && user.email == email && user.password == password) {
          var sessionBox = Hive.box('sessionBox');
          await sessionBox.put('userName', user.fullName);
          await sessionBox.put('userEmail', user.email);
          await sessionBox.put('userKey', user.email); // Use email as unique key
          emit(LoginSuccess());
          return;
        }
      }

      emit(LoginFailure(errMessage: "الإيميل أو الباسورد غير صحيح"));
    } catch (e) {
      emit(LoginFailure(errMessage: "حدث خطأ أثناء تسجيل الدخول"));
    }
  }
}
