import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../utils/dialog_utils.dart';

//Check Connectivity With Network
final Connectivity _connectivity = Connectivity();
String? _connectionStatus;
Future<bool> checkNetworkConnection(context) async {
  String connectionStatus;

  try {
    connectionStatus = (await _connectivity.checkConnectivity()).toString();
  } on PlatformException catch (_) {
    connectionStatus = "Internet Connection Failed";
  }

  _connectionStatus = connectionStatus;
  if (_connectionStatus == "ConnectivityResult.mobile" ||
      _connectionStatus == "ConnectivityResult.wifi") {
    return true;
  } else {
    DialogUtils.showAlertDialog(context, "Internet Connection Failed");
    return false;
  }
}
