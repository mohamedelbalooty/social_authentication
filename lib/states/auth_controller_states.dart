enum AuthControllerStates{
  AuthFirebaseSignInLoadingState,
  GoogleFirebaseSignInSuccessState,
  GoogleFirebaseSignInErrorState,
  GoogleFirebaseSignOutLoadingState,
  GoogleFirebaseSignOutSuccessState,
  GoogleFirebaseSignOutErrorState,
  FacebookFirebaseSignInSuccessState,
  FacebookFirebaseSignInErrorState,
  FacebookFirebaseSignOutLoadingState,
  FacebookFirebaseSignOutSuccessState,
  FacebookFirebaseSignOutErrorState
}
enum AuthPhoneStates{
  AuthPhoneStatesLoading,
  AuthPhoneStatesSubmitted,
  AuthPhoneStatesOtpVerified,
  AuthPhoneStateSuccess,
  AuthPhoneStatesError,
}