import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:social_auth/controller/auth_phone_controller.dart';
import 'package:social_auth/states/auth_controller_states.dart';

import 'app_components.dart';
import 'auth_view.dart';

class PhoneAuthView extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> _globalKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _globalKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
        centerTitle: true,
      ),
      body: Consumer<AuthPhoneController>(
        builder: (context, provider, child) {
          return ModalProgressHUD(
            inAsyncCall: provider.authPhoneStates ==
                AuthPhoneStates.AuthPhoneStatesLoading,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _globalKey1,
                    child: Row(
                      children: [
                        Expanded(child: BuildTextFormField(phoneController)),
                        SizedBox(
                          width: 10,
                        ),
                        BuildButton(
                          () async{
                            if (_globalKey1.currentState.validate()) {
                              await provider
                                  .submitPhoneAuth(phoneController.text);
                              if (provider.authPhoneStates ==
                                  AuthPhoneStates.AuthPhoneStatesError) {
                                print('ERROR ERROR');
                                showToast(context, provider.errorResult);
                              }
                            }
                            print('states => ${provider.authPhoneStates}');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Form(
                    key: _globalKey2,
                    child: Row(
                      children: [
                        Expanded(child: BuildTextFormField(otpController)),
                        SizedBox(
                          width: 10,
                        ),
                        BuildButton(() async {
                          if (_globalKey2.currentState.validate()) {
                            await provider.submitOtp(otpController.text);
                            if (provider.authPhoneStates ==
                                AuthPhoneStates.AuthPhoneStatesError) {
                              print('erroer');
                              showToast(context, provider.errorResult);
                            }
                            if(provider.authPhoneStates == AuthPhoneStates.AuthPhoneStatesOtpVerified){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AuthView(),
                                ),
                              );
                            }
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildTextFormField extends StatelessWidget {
  TextEditingController controller;

  BuildTextFormField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Entered your value';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  Function onClick;

  BuildButton(this.onClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 50,
        width: 100,
        color: Colors.blue,
        child: Center(child: Text('submit')),
      ),
    );
  }
}
