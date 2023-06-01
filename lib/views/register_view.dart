import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;
import 'package:noteme/constants/routes.dart';
import 'package:noteme/services/auth/auth_exceptions.dart';
import 'package:noteme/services/auth/auth_service.dart';
import 'package:noteme/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                // devtools.log(userCredential.toString());
                final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                showErrorDialog(
                  context,
                  "Weak password",
                );
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                  context,
                  "Email already in use",
                );
              } on InvalidEmailAuthException {
                showErrorDialog(
                  context,
                  "This is an invalid email",
                );
              } on GenericAuthException {
                showErrorDialog(
                  context,
                  "Failed to register",
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login here!"),
          )
        ],
      ),
    );
  }
}
