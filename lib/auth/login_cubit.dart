// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:daily_planner_test/auth/login_state.dart';
import 'package:daily_planner_test/enviroment/environment.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginCubit extends Cubit<LoginState> {
  final http.Client httpClient;
  final box = GetStorage();

  // Controllers for Streams
  final StreamController<String> _emailController = StreamController<String>();
  final StreamController<String> _passwordController =
      StreamController<String>();

  LoginCubit({required this.httpClient}) : super(LoginInitial());

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  void setEmail(String email) {
    _emailController.add(email);
  }

  void setPassword(String password) {
    _passwordController.add(password);
  }

  void login(String email, String password) async {
    emit(LoginLoading());

    try {
      final response = await httpClient.post(
        Uri.parse('${Environment().appBaseUrl}/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Decode the response body to a Map<String, dynamic>
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Access the userToken directly from the map
        final String userToken = data['userToken'];

        // Store the token in local storage
        box.write("token", json.encode(userToken));
        box.write("userId", data['_id']);

        print('Token: $userToken');
        print('userId: ${data['_id']}');

        // Emit success with the actual token
        emit(LoginSuccess(token: userToken));
      } else {
        emit(LoginFailure(error: 'Đăng nhập thất bại'));
      }
    } catch (e) {
      print("Error: " + e.toString());
      emit(LoginFailure(error: 'Có lỗi xảy ra'));
    }
  }

  void logout() {
    box.erase();
    emit(LoginInitial());
  }

  void register(String email, String password) async {
    emit(LoginLoading());

    try {
      final response = await httpClient.post(
        Uri.parse(
            '${Environment().appBaseUrl}/api/users/register'), // Thay đổi URL này với URL thực tế của bạn
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('appBaseUrl: ${Environment().appBaseUrl}');

      if (response.statusCode == 201) {
        // final jsonResponse = jsonDecode(response.body);

        emit(LoginSuccess(token: "Thành công"));
      } else {
        emit(LoginFailure(error: 'Đăng ky thất bại'));
      }
    } catch (e) {
      print("Error: " + e.toString());
      emit(LoginFailure(error: 'Có lỗi xảy ra ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _emailController.close();
    _passwordController.close();
    return super.close();
  }
}
