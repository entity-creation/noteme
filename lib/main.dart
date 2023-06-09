import 'package:flutter/material.dart';
import 'package:noteme/constants/routes.dart';
import 'package:noteme/services/auth/auth_service.dart';
import 'package:noteme/views/login_view.dart';
import 'package:noteme/views/notes/create_update_note_view.dart';
import 'package:noteme/views/notes/notes_view.dart';
import 'package:noteme/views/register_view.dart';
import 'package:noteme/views/verify_email_view.dart';
// import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log("Email is verified");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const NotesView();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
