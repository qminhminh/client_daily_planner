// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:daily_planner_test/auth/login_cubit.dart';
import 'package:daily_planner_test/auth/login_state.dart';
import 'package:daily_planner_test/color/color_background.dart';
import 'package:daily_planner_test/component/custom_snack_bar.dart';
import 'package:daily_planner_test/component/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flare_flutter/flare_actor.dart'; // Import FlareActor

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Animation Controllers
  late AnimationController _teddyController;
  late Animation<double> _teddyAnimation;

  @override
  void initState() {
    super.initState();

    // Teddy Animation: Move down from top of the screen
    _teddyController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _teddyAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _teddyController, curve: Curves.bounceOut),
    );

    _teddyController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _teddyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBackground.primaryColor,
      body: BlocProvider(
        create: (context) =>
            LoginCubit(httpClient: http.Client()), // Use your RegisterCubit
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar.show(
                  message: 'Đăng ký thành công!Vui lòng đăng nhập.',
                  backgroundColor: ColorBackground.primaryColor,
                  icon: Icons.add_alert,
                  iconColor: Colors.white,
                  textColor: Colors.black,
                ),
              );
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final cubit = BlocProvider.of<LoginCubit>(context);

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Animated Teddy using FlareActor
                  AnimatedBuilder(
                    animation: _teddyAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _teddyAnimation.value),
                        child: child,
                      );
                    },
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 300,
                        child: FlareActor(
                          'assets/Teddy.flr', // Path to your Flare file
                          animation: 'idle', // Animation name in Flare file
                        ),
                      ),
                    ),
                  ),

                  // Register Form with styled container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            icon: Icons.lock,
                          ),
                          const SizedBox(height: 20),
                          if (state is LoginLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Center(
                              child: ElevatedButton(
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
                                  backgroundColor: ColorBackground.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text('Đăng ký'),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                'Đã có một tài khoản?Đăng nhập',
                                style: TextStyle(
                                    color: ColorBackground.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
