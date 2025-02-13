import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/common/widgets/loader.dart';
import '../../constants/utils/show_snackbar.dart';

class TextFormContainer extends StatefulWidget {
  const TextFormContainer({
    super.key,
  });

  @override
  State<TextFormContainer> createState() => _TextFormContainerState();
}

class _TextFormContainerState extends State<TextFormContainer> {
  bool _isSecuredPassword = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message);
        } else if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            BlogPage.route(),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const ZLoader();
        }
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your valid email address';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.black,
                    ),
                    labelText: ('Email'),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    suffixIcon: zohPassword(),
                    labelText: ('Password'),
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    )),
                obscureText: _isSecuredPassword,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Login TextButton
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF558B2F), Color(0xFFE64A19)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 55),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              /// SignUp container
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget zohPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isSecuredPassword = !_isSecuredPassword;
          });
        },
        icon: _isSecuredPassword
            ? const Icon(
                Iconsax.eye,
                color: Colors.black,
              )
            : const Icon(
                Iconsax.eye_slash,
                color: Colors.black,
              ));
  }
}
