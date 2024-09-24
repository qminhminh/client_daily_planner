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
            image: AssetImage('assets/logo.jpg'),
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
                        TextFormField(
                          cursorColor: const Color.fromARGB(255, 159, 207, 219),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 159, 207, 219)),
                            fillColor: const Color.fromARGB(255, 159, 207, 219),
                            iconColor: const Color.fromARGB(255, 159, 207, 219),
                            prefixIcon: const Icon(Icons.email,
                                color: Color.fromARGB(255, 159, 207, 219)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219),
                                  width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219),
                                  width: 2.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                          ),
                          onChanged: (email) {
                            cubit.setEmail(email);
                          },
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
                                color: Color.fromARGB(255, 159, 207, 219)),
                            fillColor: const Color.fromARGB(255, 159, 207, 219),
                            iconColor: const Color.fromARGB(255, 159, 207, 219),
                            prefixIcon: const Icon(Icons.password,
                                color: Color.fromARGB(255, 159, 207, 219)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219),
                                  width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 159, 207, 219),
                                  width: 2.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                          ),
                          onChanged: (password) {
                            cubit.setPassword(password);
                          },
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 159, 207, 219),
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
                                  child: const Text(
                                    'Đã có tài khoản? Đăng nhập ngay',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 159, 207, 219)),
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
