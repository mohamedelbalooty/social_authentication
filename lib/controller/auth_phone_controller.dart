import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_auth/helper/social_auth_helper.dart';
import 'package:social_auth/states/auth_controller_states.dart';

class AuthPhoneController extends ChangeNotifier {
  AuthPhoneStates authPhoneStates;
  String errorResult;
  String verificationId;

  Future<void> submitPhoneAuth(String phoneNumber) async {
    authPhoneStates = AuthPhoneStates.AuthPhoneStatesLoading;
    try{
      await SocialAuthHelper.firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+2' + phoneNumber.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await signIn(credential);
          print('verification Completed');
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('${exception.message} verificationFailed');
          print('verificationFailed');
          errorResult = exception.message.toString();
          authPhoneStates = AuthPhoneStates.AuthPhoneStatesError;
          notifyListeners();

        },
        codeSent: (String verificationId, int resendToken) {
          this.verificationId = verificationId;
          authPhoneStates = AuthPhoneStates.AuthPhoneStatesSubmitted;
          notifyListeners();
          print('code Sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAuto Retrieval Timeout');
        },
      );
    }catch(e){
      errorResult = e.message.toString();
      authPhoneStates = AuthPhoneStates.AuthPhoneStatesError;
    }
    notifyListeners();
  }

  Future<void> signIn(PhoneAuthCredential authCredential) async {
    authPhoneStates = AuthPhoneStates.AuthPhoneStatesLoading;
    notifyListeners();
    print('signIn');
    try {
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      authPhoneStates = AuthPhoneStates.AuthPhoneStatesOtpVerified;
    } catch (signingException) {
      errorResult = signingException.toString();
      authPhoneStates = AuthPhoneStates.AuthPhoneStatesError;
    }
    notifyListeners();
  }

  Future<void> submitOtp(String otpCode) async {
    // authPhoneStates = AuthPhoneStates.AuthPhoneStatesLoading;
    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpCode);
    await signIn(authCredential);
    // notifyListeners();
    // authPhoneStates = AuthPhoneStates.AuthPhoneStatesLoading;
    // notifyListeners();
    // try{
    //   PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
    //       verificationId: this.verificationId, smsCode: otpCode);
    //   await signIn(authCredential);
    //   authPhoneStates = AuthPhoneStates.AuthPhoneStateSuccess;
    // }catch(submitOtpException){
    //   errorResult = submitOtpException.toString();
    //   authPhoneStates = AuthPhoneStates.AuthPhoneStatesError;
    // }
    // notifyListeners();
  }

  Future<void> logOut() async {
    await SocialAuthHelper.firebaseAuth.signOut();
  }

  User getLogedInUser() {
    return SocialAuthHelper.firebaseAuth.currentUser;
  }
}
