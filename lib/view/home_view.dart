import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_auth/controller/auth_controller.dart';
import 'package:social_auth/states/auth_controller_states.dart';
import 'package:social_auth/view/auth_view.dart';
import 'app_components.dart';

enum AuthType { GoogleAuth, FacebookAuth }

class HomeView extends StatelessWidget {
  final AuthType authType;

  HomeView({@required this.authType});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authController.googleUser.displayName,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(authController.googleUser.photoUrl),
              radius: 15.0,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: authType == AuthType.GoogleAuth ? () async {
              await authController.googleFirebaseSignOut();
              if (authController.authControllerStates ==
                  AuthControllerStates.GoogleFirebaseSignOutSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthView(),
                  ),
                );
              }
              if (authController.authControllerStates ==
                  AuthControllerStates.GoogleFirebaseSignOutErrorState) {
                showToast(context, authController.signInErrorMessage);
              }
            } : () async{
              await authController.facebookFirebaseSignOut();
              if (authController.authControllerStates ==
                  AuthControllerStates.FacebookFirebaseSignOutSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthView(),
                  ),
                );
              }
              if (authController.authControllerStates ==
                  AuthControllerStates.FacebookFirebaseSignOutErrorState) {
                showToast(context, authController.signInErrorMessage);
              }
            }
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: authController.authControllerStates ==
            AuthControllerStates.GoogleFirebaseSignOutLoadingState,
        child: Center(
          child: Text('Home view'),
        ),
      ),
    );
  }
}
