// ignore_for_file: use_key_in_widget_constructors

import 'package:daily_planner_test/color/color_background.dart';
import 'package:daily_planner_test/component/custom_snack_bar.dart';
import 'package:daily_planner_test/component/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_cubit.dart';
import 'login_state.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Đảm bảo Container lấp đầy chiều rộng màn hình
        height: double.infinity, // Đảm bảo Container lấp đầy chiều cao màn hình
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/logo.jpg',
            ), // Đường dẫn đến ảnh nền
            fit: BoxFit.cover, // Đảm bảo ảnh lấp đầy màn hình
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocProvider(
            create: (context) => LoginCubit(httpClient: http.Client()),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar.show(
                      message: 'Proceed to login',
                      backgroundColor: ColorBackground.primaryColor, // Màu nền
                      icon: Icons.add_alert, // Icon thông báo
                      iconColor: Colors.white, // Màu icon
                      textColor: Colors.black, // Màu chữ
                    ),
                  );

                  Navigator.pushReplacementNamed(context, '/home');
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                final cubit = BlocProvider.of<LoginCubit>(context);

                return SingleChildScrollView(
                  child: Form(
                    key: _formKey, // Khai báo Form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 250),
                        const SizedBox(height: 20),
                        TextFieldComponent(
                          controller: _emailController,
                          onChanged: (email) {
                            cubit.setEmail(email);
                          },
                          labeltext: 'Email',
                          notevalidate: 'Email không được để trống',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        TextFieldComponent(
                          controller: _passwordController,
                          onChanged: (password) {
                            cubit.setPassword(password);
                          },
                          labeltext: 'Password',
                          notevalidate: 'Password không được để trống',
                          icon: Icons.password,
                        ),
                        const SizedBox(height: 20),
                        if (state is LoginLoading)
                          const CircularProgressIndicator()
                        else
                          Center(
                            child: Column(
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Kiểm tra form trước khi thực hiện đăng nhập
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        final email = _emailController.text;
                                        final password =
                                            _passwordController.text;
                                        cubit.login(email, password);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          ColorBackground.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 24.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: const Text('Đăng nhập'),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    'Chưa có tài khoản? Đăng ký ngay',
                                    style: TextStyle(
                                        color: ColorBackground.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
