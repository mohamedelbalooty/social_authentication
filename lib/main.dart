import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'controller/auth_controller.dart';
import 'controller/auth_phone_controller.dart';
import 'view/pagination_view.dart';
import 'view/phone_auth_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SocialAuthApp());
}

class SocialAuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<AuthPhoneController>(
          create: (_) => AuthPhoneController(),
        ),
      ],
      child: RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(),
          footerBuilder:  () => ClassicFooter(),
          headerTriggerDistance: 30.0,
          maxOverScrollExtent :100,
          maxUnderScrollExtent:0,
          enableScrollWhenRefreshCompleted: true,
          enableLoadingWhenFailed : true,
          hideFooterWhenNotFull: false,
          enableBallisticLoad: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social Authentication',
          home: PaginationView(),
        ),
      ),
    );
  }
}
