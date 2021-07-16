// import 'package:app/services/at_me_utils.dart';
import 'package:app/services/at_services.dart';
import 'package:flutter/material.dart';
import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_server_status/at_server_status.dart';

class AtErrorDialog {
  static getAlertDialog(var error, BuildContext context) {
    String errorMessage = _getErrorMessage(error);
    var title = AtText.TITLE_ERROR_DIALOG;
    return AlertDialog(
      title: Row(
        children: [
          Text(
            title,
            style:
                TextStyle(fontFamily: AtFont.boldFamily, fontSize: AtFont.size),
          ),
          Icon(Icons.sentiment_dissatisfied)
        ],
      ),
      content: Text('$errorMessage'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        )
      ],
    );
  }

  ///Returns corresponding errorMessage for [error].
  static String _getErrorMessage(var error) {
    switch (error.runtimeType) {
      case AtClientException:
        return 'Unable to perform this action. Please try again.';
        break;
      case UnAuthenticatedException:
        return 'Unable to authenticate. Please try again.';
        break;
      case NoSuchMethodError:
        return 'Failed in processing. Please try again.';
        break;
      case AtConnectException:
        return 'Unable to connect server. Please try again later.';
        break;
      case AtIOException:
        return 'Unable to perform read/write operation. Please try again.';
        break;
      case AtServerException:
        return 'Unable to activate server. Please contact admin.';
        break;
      case SecondaryNotFoundException:
        return 'Server is unavailable. Please try again later.';
        break;
      case SecondaryConnectException:
        return 'Unable to connect. Please check with network connection and try again.';
        break;
      case InvalidAtSignException:
        return 'Invalid atsign is provided. Please contact admin.';
        break;
      case ServerStatus:
        return _getServerStatusMessage(error);
        break;
      case OnboardingStatus:
        return _message(error);
        break;
      case String:
        if (error == OnboardStatus.ACTIVATE.value) {
          return 'Your atsign got reactivated. Please activate with the new QRCode available on ${AtText.rootDomain} website.';
        }
        return error;
        break;
      default:
        return 'Unknown error.';
        break;
    }
  }

  static String _getServerStatusMessage(ServerStatus message) {
    switch (message) {
      case ServerStatus.unavailable:
      case ServerStatus.stopped:
        return 'Server is unavailable. Please try again later.';
        break;
      case ServerStatus.error:
        return 'Unable to connect. Please check with network connection and try again.';
        break;
      default:
        return '';
        break;
    }
  }

  static String _message(OnboardingStatus status) {
    switch (status) {
      case (OnboardingStatus.ACTIVATE):
        return 'Your atsign got reactivated. Please activate with the new QRCode available on ${AtText.rootDomain} website.';
        break;
      case (OnboardingStatus.ENCRYPTION_PRIVATE_KEY_NOT_FOUND):
      case (OnboardingStatus.ENCRYPTION_PUBLIC_KEY_NOT_FOUND):
      case (OnboardingStatus.PKAM_PRIVATE_KEY_NOT_FOUND):
      case (OnboardingStatus.PKAM_PUBLIC_KEY_NOT_FOUND):
        return 'Fatal error occurred. Please contact support@atsign.com';
        break;
      case (OnboardingStatus.RESTORE):
        return 'Please restore it with the available backup zip file as the local keys were missing.';
        break;
      default:
        return '';
        break;
    }
  }
}

extension customMessages on OnboardingStatus {}
