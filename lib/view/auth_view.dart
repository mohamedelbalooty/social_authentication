import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_auth/controller/auth_controller.dart';
import 'package:social_auth/states/auth_controller_states.dart';
import 'package:social_auth/view/home_view.dart';
import 'app_components.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Authentication'),
        centerTitle: true,
      ),
      body: Consumer<AuthController>(
        builder: (context, provider, child) {
          return ModalProgressHUD(
            inAsyncCall: provider.authControllerStates ==
                AuthControllerStates.AuthFirebaseSignInLoadingState,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BuildDefaultButton(
                        buttonColor: Colors.red,
                        buttonTitle: 'Sign in with google in firebase',
                        onClicked: () async {
                          await provider.googleFirebaseSignIn();
                          if (provider.authControllerStates ==
                              AuthControllerStates
                                  .GoogleFirebaseSignInSuccessState) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeView(authType: AuthType.GoogleAuth,),
                              ),
                            );
                          }
                          if (provider.authControllerStates ==
                              AuthControllerStates
                                  .GoogleFirebaseSignInErrorState) {
                            showToast(context, provider.signInErrorMessage);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      BuildDefaultButton(
                        buttonColor: Colors.blueAccent,
                        buttonTitle: 'Sign in with facebook in firebase',
                        onClicked: () async {
                          await provider.facebookFirebaseSignIn();
                          if (provider.authControllerStates ==
                              AuthControllerStates
                                  .FacebookFirebaseSignInSuccessState) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeView(authType: AuthType.FacebookAuth,),
                              ),
                            );
                          }
                          if (provider.authControllerStates ==
                              AuthControllerStates
                                  .FacebookFirebaseSignInErrorState) {
                            showToast(context, provider.signInErrorMessage);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      BuildDefaultButton(
                        buttonColor: Colors.red,
                        buttonTitle: 'Sign in with google in API',
                        onClicked: () {},
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      BuildDefaultButton(
                        buttonColor: Colors.blueAccent,
                        buttonTitle: 'Sign in with facebook in Graph API',
                        onClicked: () {},
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
