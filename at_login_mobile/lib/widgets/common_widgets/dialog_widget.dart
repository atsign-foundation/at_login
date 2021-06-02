import 'package:at_login_mobile/services/at_error_dialog.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogWidget extends StatefulWidget {
  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AtDialog {
  var _atsignNotFound = 'This device has not been paired with an @sign yet.\n\n' +
      'If you do not have an @sign, or have one that you want to activate now, ' +
      'please visit ';
  var _link = rootEnvironment.website;
  var _atsignNotFound1 = ' and set up an @sign or select one ' +
      'from your dashboard to activate. Once you can see the activation code, ' +
      '"click Activate" to set it up and pair it with this device.\n\n' +
      'If you have already activated your @sign, please locate your backup ' +
      'code, then click "Restore" to pair your @sign with this device.';
  final bool isDismissable;
  final bool showClose;
  final bool showActivate;
  final bool showRestore;
  final Widget title;
  final String highlightText;
  final Function onClickActivate;
  final Function onClickRestore;
  final String message;
  AtDialog(
      {this.isDismissable = false,
      this.showClose = true,
      this.showActivate = false,
      this.showRestore = false,
      this.title,
      this.highlightText = '',
      this.message = '',
      this.onClickActivate,
      this.onClickRestore});
  show(BuildContext context) {
    showDialog(
        barrierDismissible: this.isDismissable,
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            scrollable: true,
            title: this.title,
            content: _getMessage(message, context),
            actions: <Widget>[
              if (message != OnboardStatus.RESTORE.value)
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.onClickActivate();
                  },
                  child: Text(OnboardStatus.ACTIVATE.name),
                ),
              if (message != OnboardStatus.ACTIVATE.value)
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.onClickRestore();
                  },
                  child: Text(OnboardStatus.RESTORE.name),
                ),
              if (showClose)
                FlatButton(
                    child: Text(AppConstants.closeButton),
                    onPressed: () {
                      Navigator.pop(context);
                    })
            ],
          );
        });
  }

  Widget _getMessage(String message, BuildContext context) {
    var text1 = '', text3 = '';

    if (message == OnboardStatus.ACTIVATE.value) {
      text1 =
          'Your atsign got reactivated. Please activate with the new QRCode available on ';
      text3 = ' website.';
    } else if (message == OnboardStatus.ATSIGN_NOT_FOUND.value) {
      text1 = _atsignNotFound;
      text3 = _atsignNotFound1;
    } else if (message == OnboardStatus.RESTORE.value) {
      return Text(
          'Atsign information on device has been erased. Please restore it with backup zip file from stored location');
    } else if (message == 'Reset') {
      return RichText(
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
        TextSpan(
            text:
                'Click on Reset to erase the @sign and the details associated with it from app\n\n'),
        TextSpan(
            text: 'Caution: This action cannot be undone',
            style: TextStyle(fontFamily: AtFont.boldFamily))
      ]));
    } else {
      return Text(message);
    }
    return RichText(
      text: TextSpan(style: TextStyle(), children: [
        TextSpan(text: text1, style: TextStyle(color: Colors.black)),
        TextSpan(
            text: _link,
            style: TextStyle(
                color: AtTheme.themecolor,
                decoration: TextDecoration.underline),
            recognizer: new TapGestureRecognizer()
              ..onTap = () async {
                var url = _link;
                String errorMessage = 'Cannot launch $url';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AtErrorDialog.getAlertDialog(
                            errorMessage, context);
                      });
                  print('Authenticating User throws $errorMessage error');
                }
              }),
        TextSpan(text: text3, style: TextStyle(color: Colors.black)),
      ]),
    );
  }
}
