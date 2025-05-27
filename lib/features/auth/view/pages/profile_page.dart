import 'package:chat_app/core/utils/show_snackbar.dart';
import 'package:chat_app/core/widgets/loader.dart';
import 'package:chat_app/features/auth/view/widgets/button.dart';
import 'package:chat_app/features/auth/view/widgets/input_field.dart';
import 'package:chat_app/features/auth/viewmodel/bloc/auth_bloc.dart';
import 'package:chat_app/features/chat/view/pages/chat_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final fistNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  void register() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegister(
          firstName: fistNameController.text.trim(),
          lastName: lastNameController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    fistNameController.dispose();
    lastNameController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          firstNameFocusNode.unfocus();
          lastNameFocusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    MaterialPageRoute(builder: (ctx) => const ChatGroupPage()),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      controller: fistNameController,
                      hintText: 'First name',
                      focusNode: firstNameFocusNode,
                    ),
                    const SizedBox(height: 15),
                    InputField(
                      controller: lastNameController,
                      hintText: 'Last Name',
                      focusNode: lastNameFocusNode,
                    ),
                    const SizedBox(height: 20),
                    Button(
                      onPressed: register,
                      child:
                          state is AuthLoginLoading
                              ? const Loader()
                              : Text('Register'),
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
