import 'package:chat_app/core/utils/show_snackbar.dart';
import 'package:chat_app/core/widgets/loader.dart';
import 'package:chat_app/features/auth/view/pages/profile_page.dart';
import 'package:chat_app/features/auth/view/widgets/button.dart';
import 'package:chat_app/features/auth/view/widgets/input_field.dart';
import 'package:chat_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  void onLogin() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthLogin(phoneController.text.trim()));
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        phoneFocusNode.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoginFailure) {
                  showSnackbar(
                    context,
                    message: state.message,
                    color: Colors.red,
                  );
                }
                if (state is AuthLoginSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const ProfilePage()),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      controller: phoneController,
                      hintText: 'Mobile Number',
                      focusNode: phoneFocusNode,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    Button(
                      onPressed: onLogin,
                      child:
                          state is AuthLoginLoading
                              ? const Loader()
                              : Text('Login'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
