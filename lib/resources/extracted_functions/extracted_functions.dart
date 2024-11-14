// Get the device identifier
  import 'package:device_info_plus/device_info_plus.dart';
import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' show Platform;


final LocalAuthentication auth = LocalAuthentication();

Future<bool> authenticate({required String reason}) async {
  try {
    bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    if (!canAuthenticate) {
      return false;
    }

    bool isAuthenticated = await auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );

    return isAuthenticated;
  } catch (e) {
    return false;
  }
}

Future<String?> getDeviceId(BuildContext context) async {
  bool? userWantsToAuthenticate = await _showAuthenticationPrompt(context);

  if (userWantsToAuthenticate == true) {
    bool isAuthenticated = await authenticate(reason: 'Please authenticate to access your notes');
    if (!isAuthenticated) {
      return null;
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; 
      } else {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    }
  } else {
    return null;
  }
}

Future<bool?> _showAuthenticationPrompt(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomText(text: 'Authentication Required'),
        content: CustomText(text: 'Do you want to authenticate to access your notes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: CustomText(text: "Yes",),
          ),
          TextButton(
            onPressed: () {
              getToast(text: "Authentication Denied",color: Colors.red);
              Navigator.pop(context, false);
            },
            child: CustomText(text: "No",),
          ),
        ],
      );
    },
  );
}



  getDateFormat(DateTime date, {bool showSeconds = false}){
    if(showSeconds == false){
      return DateFormat("MMM,dd").format(date);
    }
    else{
      return DateFormat("MMM,dd hh:mm:ss").format(date);
    }
  }


//toast
getToast({required String text,Color? color}){
  Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: color??Colors.green,
        textColor: Colors.white,
      );
}


