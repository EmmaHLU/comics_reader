import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/di/injection_container.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/core/localization/language_provider.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_event.dart';
import 'package:learning_assistant/features/auth/presentation/bloc/auth_state.dart';
import 'package:learning_assistant/features/auth/presentation/pages/signin_page.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_favoriates_page.dart';
import 'package:learning_assistant/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:learning_assistant/features/profile/presentation/bloc/profile_event.dart';
import 'package:learning_assistant/features/profile/presentation/bloc/profile_state.dart';
import 'package:learning_assistant/features/profile/presentation/widgets/language_selector.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {


  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late AuthBloc _authBloc;
  late ProfileBloc _profileBloc;
  late String username = '';
  late String email = '';
  late String userId = '';
 @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _profileBloc = sl<ProfileBloc>();
    _loaduserinfo();
  }

  Future<void> _loaduserinfo() async {
    _profileBloc.add(
      ProfileLoadRequested(
      )
    );
  }

  Future<void> _signOut() async {
    _authBloc.add(
      AuthSignOutRequested(
      ),
    );
  }

  @override
  @override
Widget build(BuildContext context) {
  final tr = AppLocalizations.of(context)!;

  return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _profileBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const SignInPage(autolog: false)),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              debugPrint("getting state from the loadprofile event");
              if (state is ProfileLoaded) {
                setState(() {
                  username = state.profile.displayName!;
                  email = state.profile.email;
                  userId = state.profile.userId;
                });
                
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.failure.message)));
              }
            },
          ),
        ],
        child: _buildProfilePage(context,  tr),
      ),
    );
}
Widget _buildProfilePage(BuildContext context, AppLocalizations tr) {

  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column (
        children: [ 
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width, // Full screen width
            ),
            child: Stack(
              fit: StackFit.passthrough,
              // alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('assets//avatar-default.png'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  child: LanguageSelector(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Go to Favorites button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                onPressed: () {
                  // Navigate to favorites page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoriatePage()),
                  );
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: Text(
                  tr.favorites,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Logout button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                onPressed: _signOut,
                icon: const Icon(Icons.logout, color: Colors.black),
                label: Text(
                  tr.logOut,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),

          ],
        ),
      ),
    ),
  );
}

}
