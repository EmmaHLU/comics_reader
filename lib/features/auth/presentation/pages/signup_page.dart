import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/di/injection_container.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_event.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_state.dart';
import 'package:learning_assistant/main.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';
import '../../../../core/localization/l10n/generated/app_localizations.dart';


class SignUpPage extends StatefulWidget {
  // final database;
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _signUp(){
    _authBloc.add(
      AuthSignUpRequested(
        displayName: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
     return BlocProvider.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home page
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyHomePage(title: "Comics Reader",)),
            );
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: GradientScaffold(
          appBar: AppBar(title: Text(tr.signUp), backgroundColor: Colors.transparent,),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: tr.name),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: tr.email),
                  // obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: tr.password),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text(tr.signUp),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}