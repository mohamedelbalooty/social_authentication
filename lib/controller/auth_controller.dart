import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_auth/helper/social_auth_helper.dart';
import 'package:social_auth/states/auth_controller_states.dart';

class AuthController extends ChangeNotifier {
  AuthControllerStates authControllerStates;
  String signInErrorMessage;
  GoogleSignInAccount googleUser;

  Future<void> googleFirebaseSignIn() async {
    authControllerStates = AuthControllerStates.AuthFirebaseSignInLoadingState;
    notifyListeners();
    try {
      googleUser = await SocialAuthHelper.googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication =
          await googleUser.authentication;
      final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );
      await SocialAuthHelper.firebaseAuth
          .signInWithCredential(googleAuthCredential);
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignInSuccessState;
    } on PlatformException catch (platFormException) {
      signInErrorMessage = platFormException.message.toString();
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignInErrorState;
    } on FirebaseAuthException catch (firebaseAuthException) {
      signInErrorMessage = firebaseAuthException.message.toString();
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignInErrorState;
    } catch (googleSignInException) {
      signInErrorMessage = 'Something went wrong when signing !';
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignInErrorState;
    }
    notifyListeners();
  }

  Future<void> googleFirebaseSignOut() async {
    authControllerStates =
        AuthControllerStates.GoogleFirebaseSignOutLoadingState;
    notifyListeners();
    try {
      await SocialAuthHelper.googleSignIn.signOut();
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignOutSuccessState;
    } catch (googleSignOutException) {
      signInErrorMessage = 'Something went wrong when sign out !';
      authControllerStates =
          AuthControllerStates.GoogleFirebaseSignOutErrorState;
    }
    notifyListeners();
  }

  Future<void> facebookFirebaseSignIn() async {
    authControllerStates = AuthControllerStates.AuthFirebaseSignInLoadingState;
    notifyListeners();
    try {
      FacebookLoginResult facebookLoginResult =
          await SocialAuthHelper.facebookLogin.logIn(['public_profile', 'email']);
      final String accessToken = facebookLoginResult.accessToken.token;
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        AuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken);
        await SocialAuthHelper.firebaseAuth
            .signInWithCredential(facebookAuthCredential);
        authControllerStates =
            AuthControllerStates.FacebookFirebaseSignInSuccessState;
      }
    } on PlatformException catch (platFormException) {
      signInErrorMessage = platFormException.message.toString();
      authControllerStates =
          AuthControllerStates.FacebookFirebaseSignInErrorState;
    } on FirebaseAuthException catch (firebaseAuthException) {
      signInErrorMessage = firebaseAuthException.message.toString();
      authControllerStates =
          AuthControllerStates.FacebookFirebaseSignInErrorState;
    } catch (googleSignInException) {
      signInErrorMessage = 'Something went wrong when signing !';
      authControllerStates =
          AuthControllerStates.FacebookFirebaseSignInErrorState;
    }
    notifyListeners();
  }

  Future<void> facebookFirebaseSignOut() async {
    authControllerStates =
        AuthControllerStates.FacebookFirebaseSignOutLoadingState;
    notifyListeners();
    try {
      await SocialAuthHelper.facebookLogin.logOut();
      authControllerStates =
          AuthControllerStates.FacebookFirebaseSignOutSuccessState;
    } catch (googleSignOutException) {
      signInErrorMessage = 'Something went wrong when sign out !';
      authControllerStates =
          AuthControllerStates.FacebookFirebaseSignOutErrorState;
    }
    notifyListeners();
  }

}
