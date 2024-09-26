import 'package:daily_planner_test/color/color_background.dart';
import 'package:daily_planner_test/component/custom_snack_bar.dart';
import 'package:daily_planner_test/component/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:daily_planner_test/auth/login_cubit.dart';
import 'package:daily_planner_test/auth/login_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.jpg'),
            fit: BoxFit.cover,
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
                      message: 'Proceed to register',
                      backgroundColor: ColorBackground.primaryColor, // Màu nền
                      icon: Icons.add_alert, // Icon thông báo
                      iconColor: Colors.white, // Màu icon
                      textColor: Colors.black, // Màu chữ
                    ),
                  );
                  Navigator.pushNamed(context, '/login');
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
                    key: _formKey,
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
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      cubit.register(email, password);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        ColorBackground.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 24.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: const Text('Đăng ký'),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Đã có tài khoản? Đăng nhập ngay',
                                    style: TextStyle(
                                        color: ColorBackground.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
