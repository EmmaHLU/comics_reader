import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/di/injection_container.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_event.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_state.dart';
import 'package:learning_assistant/main.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';
import 'signup_page.dart';
import '../../../../core/localization/l10n/generated/app_localizations.dart';

class SignInPage extends StatefulWidget {
  final bool autolog;
  const SignInPage({super.key, required this.autolog});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    if (widget.autolog){
      _autoLogin();
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
   void _signIn() {
    _authBloc.add(
      AuthSignInRequested(
        email: _emailController.text,
        password: _passwordController.text,
        // saveCredentials: true,
      ),
    );
  }

  void _autoLogin(){
    _authBloc.add(
      const AuthAutoLoginRequested(),
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
          appBar: AppBar(
            title: Text(tr.signIn),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: tr.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: tr.password),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _signIn,
                      child: Text(tr.signIn),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(tr.noAccountSignUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
