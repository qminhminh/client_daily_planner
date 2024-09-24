// ignore_for_file: use_key_in_widget_constructors

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
                        // Center(
                        //   child: ClipOval(
                        //     ch ild: Image.asset(
                        //       'assets/logo.jpg', // Đường dẫn đến logo của bạn
                        //       height: 150, // Chiều cao của logo
                        //       width: 150, // Chiều rộng của logo
                        //       fit:
                        //           BoxFit.cover, // Đảm bảo hình ảnh không bị méo
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: const Color.fromARGB(255, 159, 207, 219),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 159, 207,
                                  219), // Màu của labelText khi không focus
                            ),
                            fillColor: const Color.fromARGB(255, 159, 207, 219),
                            iconColor: const Color.fromARGB(255, 159, 207, 219),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 159, 207, 219),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 207, 219),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 207,
                                    219), // Màu viền khi chưa focus
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(
                                    255, 159, 207, 219), // Màu viền khi focus
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.red, // Màu viền khi có lỗi
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color:
                                    Colors.red, // Màu viền khi focus mà có lỗi
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (email) {
                            cubit.setEmail(email);
                          },
                          // Thêm validator để kiểm tra tính hợp lệ
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email không được để trống';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: const Color.fromARGB(255, 159, 207, 219),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 159, 207,
                                  219), // Màu của labelText khi không focus
                            ),
                            fillColor: const Color.fromARGB(255, 159, 207, 219),
                            iconColor: const Color.fromARGB(255, 159, 207, 219),
                            prefixIcon: const Icon(
                              Icons.password,
                              color: Color.fromARGB(255, 159, 207, 219),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 207, 219),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 207,
                                    219), // Màu viền khi chưa focus
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(
                                    255, 159, 207, 219), // Màu viền khi focus
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.red, // Màu viền khi có lỗi
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color:
                                    Colors.red, // Màu viền khi focus mà có lỗi
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (password) {
                            cubit.setPassword(password);
                          },
                          // Thêm validator để kiểm tra tính hợp lệ
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password không được để trống';
                            }
                            return null;
                          },
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 159, 207, 219),
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
                                  child: const Text(
                                    'Chưa có tài khoản? Đăng ký ngay',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 159, 207, 219)),
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
