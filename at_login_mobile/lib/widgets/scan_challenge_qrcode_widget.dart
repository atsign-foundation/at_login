import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_login_mobile/services/at_login_service.dart';
import 'package:at_login_mobile/services/at_services.dart';
// import 'package:at_login_mobile/services/size_config.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
// import 'package:at_login_mobile/utils/color_constants.dart';
// import 'package:at_login_mobile/utils/custom_textstyles.dart';
// import 'package:at_login_mobile/utils/response_status.dart';
import 'package:at_login_mobile/utils/strings.dart';
// import 'package:at_login_mobile/utils/response_status.dart';
// import 'package:at_login_mobile/widgets/custom_appbar.dart';
// import 'package:at_login_mobile/widgets/custom_button.dart';
// import 'package:at_login_mobile/widgets/custom_dialog.dart';
// import 'package:at_login_mobile/widgets/custom_strings.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:at_utils/at_logger.dart';

class ScanQrCodeWidget extends StatefulWidget {
  final OnboardingStatus onboardStatus;
  final bool getAtSign;
  ScanQrCodeWidget({Key key, this.onboardStatus, this.getAtSign = false})
      : super(key: key);
  @override
  _ScanQrCodeWidgetState createState() => _ScanQrCodeWidgetState();
}

class _ScanQrCodeWidgetState extends State<ScanQrCodeWidget> {
  var _loginService = AtLoginService.getInstance();
  AtSignLogger _logger = AtSignLogger('QR Scan');

  QrReaderViewController _controller;
  bool loading = false;
  bool _isQR = false;
  bool permissionGrated = false;
  bool scanCompleted = false;
  String _incorrectKeyFile =
      'Unable to fetch the keys from chosen file. Please choose correct file';
  @override
  void initState() {
    checkPermissions();
    if (widget.getAtSign == true) {
      _getAtsignForm();
    }
    if (widget.onboardStatus != null) {
      if (widget.onboardStatus == OnboardingStatus.ACTIVATE) {
        _isQR = true;
      }
    }
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isCram(String data) {
    if (data == null || data == '' || !data.contains('@')) {
      return false;
    }
    return true;
  }

  _processSharedSecret(String atsign, String secret) async {
    var authResponse;
    try {
      setState(() {
        loading = true;
      });
      var isExist = await _loginService.isExistingAtsign(atsign);
      if (isExist) {
        setState(() {
          loading = false;
        });
        // _showAlertDialog(CustomStrings().pairedAtsign(atsign));
        return;
      }
      authResponse = await _loginService.authenticate(atsign,
          cramSecret: secret, status: widget.onboardStatus);
      if (authResponse == ResponseStatus.AUTH_SUCCESS) {
        if (widget.onboardStatus == OnboardingStatus.ACTIVATE ||
            widget.onboardStatus == OnboardingStatus.RESTORE) {
          // _loginService.onboardFunc(_loginService.atClientServiceMap,
          //     _loginService.currentAtsign);
          if (_loginService.nextScreen == null) {
            Navigator.pop(context);
            return;
          }
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => _loginService.nextScreen));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PrivateKeyQRCodeGenScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (e == ResponseStatus.AUTH_FAILED) {
        _logger.severe('Error in authenticateWith cram secret');
        _showAlertDialog(e, title: 'Auth Failed');
      } else if (e == ResponseStatus.SERVER_NOT_REACHED && _isContinue) {
        _isServerCheck = _isContinue;
        await _processSharedSecret(atsign, secret);
      } else if (e == ResponseStatus.TIME_OUT) {
        _showAlertDialog(e, title: 'Response Time out');
      }
    }
    return authResponse;
  }

  void onScan(String data, List<Offset> offsets, context) async {
    // _isServerCheck = false;
    // _isContinue = true;
    _controller.stopCamera();
    var message;
    if (_isCram(data)) {
      List params = data.split(':');
      if (params[1].length < 128) {
        _showAlertDialog(CustomStrings().invalidCram(params[0]));
      } else if (LoginService.getInstance().formatAtSign(params[0]) !=
          _pairingAtsign &&
          _pairingAtsign != null) {
        _showAlertDialog(CustomStrings().atsignMismatch(_pairingAtsign));
      } else if (params[1].length == 128) {
        message = await this._processSharedSecret(params[0], params[1]);
      } else {
        _showAlertDialog(CustomStrings().invalidData);
      }
    } else {
      _showAlertDialog(CustomStrings().invalidData);
    }
    this.setState(() {
      loading = false;
    });
    if (message != ResponseStatus.AUTH_SUCCESS) {
      scanCompleted = false;
      await _controller.startCamera((data, offsets) {
        if (!scanCompleted) {
          onScan(data, offsets, context);
          scanCompleted = true;
        }
      });
    }
  }

  checkPermissions() async {
    var cameraStatus = await Permission.camera.status;
    // var storageStatus = await Permission.storage.status;
    _logger.info("camera status => $cameraStatus");
    // _logger.info('storage status is $storageStatus');
    if (cameraStatus.isRestricted || cameraStatus.isDenied) {
      await askPermissions(Permission.camera);
    } else if (cameraStatus.isGranted) {
      setState(() {
        permissionGrated = true;
      });
    }
  }

  askPermissions(Permission type) async {
    if (type == Permission.camera) {
      await Permission.camera.request();
    } 
    setState(() {
      permissionGrated = true;
    });
  }
  
  _processAESKey(String atsign, String aesKey, String contents) async {
    assert(aesKey != null || aesKey != '');
    assert(atsign != null || atsign != '');
    assert(contents != null || contents != '');
    setState(() {
      loading = true;
    });
    try {
      var isExist = await _loginService.isExistingAtsign(atsign);
      if (isExist) {
        setState(() {
          loading = false;
        });
        _showAlertDialog(CustomStrings().pairedAtsign(atsign));
        return;
      }
      var authResponse = await _loginService.authenticate(atsign,
          jsonData: contents, decryptKey: aesKey);
      if (authResponse == ResponseStatus.AUTH_SUCCESS) {
        if (_loginService.nextScreen == null) {
          Navigator.pop(context);
          _loginService.onboardFunc(_loginService.atClientServiceMap,
              _loginService.currentAtsign);
        } else {
          _loginService.onboardFunc(_loginService.atClientServiceMap,
              _loginService.currentAtsign);
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => _loginService.nextScreen));
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (e == ResponseStatus.SERVER_NOT_REACHED && _isContinue) {
        _isServerCheck = _isContinue;
        await _processAESKey(atsign, aesKey, contents);
      } else if (e == ResponseStatus.AUTH_FAILED) {
        _logger.severe('Error in authenticateWithAESKey');
        _showAlertDialog(e, isPkam: true, title: 'Auth Failed');
      } else if (e == ResponseStatus.TIME_OUT) {
        _showAlertDialog(e, title: 'Response Time out');
      }
    }
  }

  _showAlertDialog(var errorMessage,
      {bool isPkam, String title, bool getClose, Function onClose}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isErrorDialog: true,
              showClose: true,
              context: context,
              message: errorMessage,
              title: title,
              onClose: getClose == true ? onClose : () {});
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double deviceTextFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: ColorConstants.light,
        appBar: CustomAppBar(
          showBackButton: true,
          title: Strings.pairAtsignTitle,
          actionItems: [
            IconButton(
                icon: Icon(Icons.help, size: 16.toFont),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            title: Strings.faqTitle,
                            url: Strings.faqUrl,
                          )));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 25.toHeight, horizontal: 24.toHeight),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isQR) ..._getQRWidget(deviceTextFactor),
                    if (_isBackup) ...[
                      SizedBox(
                        height: SizeConfig().screenHeight * 0.25,
                      ),
                      Text(Strings.backupKeyDescription,
                          style: CustomTextStyles.fontR16primary,
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 25.toHeight,
                      ),
                      Center(
                        child: CustomButton(
                          width: 230.toWidth,
                          buttonText: Strings.uploadZipTitle,
                          onPressed: _uploadKeyFile,
                        ),
                      ),
                      SizedBox(
                        height: 25.toHeight,
                      ),
                    ]
                  ],
                ),
                loading
                    ? _isServerCheck
                    ? Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig().screenHeight * 0.30),
                  child: Center(
                    child: Container(
                      color: ColorConstants.light,
                      child: Padding(
                        padding: EdgeInsets.all(8.0.toFont),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<
                                          Color>(
                                          ColorConstants
                                              .appColor)),
                                ),
                                SizedBox(width: 6.toWidth),
                                Flexible(
                                  flex: 7,
                                  child: Text(
                                      Strings.recurr_server_check,
                                      textAlign: TextAlign.start,
                                      style: CustomTextStyles
                                          .fontR16primary),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                isInverted: true,
                                height: 35.0.toHeight,
                                width: 65.toWidth,
                                buttonText: Strings.stopButtonTitle,
                                onPressed: () {
                                  _isContinue = false;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  height: SizeConfig().screenHeight * 0.6,
                  width: SizeConfig().screenWidth,
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.appColor)),
                  ),
                )
                    : SizedBox()
              ],
            ),
          ),
        ));
  }

  _getQRWidget(deviceTextFactor) {
    return <Widget>[
      SizedBox(height: 70.toHeight),
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: TextStyle(
                  fontSize: 16, color: ColorConstants.lightBackgroundColor),
              children: [
                TextSpan(text: Strings.scanQrMessage),
                TextSpan(text: AppConstants.website)
              ])),
      SizedBox(
        height: 25.toHeight,
      ),
      Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          width: 300.toWidth,
          height: 350.toHeight,
          color: Colors.black,
          child: !permissionGrated
              ? SizedBox()
              : Stack(
            children: [
              QrReaderView(
                width: 300.toWidth,
                height: 350.toHeight,
                callback: (container) {
                  this._controller = container;
                  _controller.startCamera((data, offsets) {
                    if (!scanCompleted) {
                      onScan(data, offsets, context);
                      scanCompleted = true;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 25.toHeight,
      ),
      Center(child: Text('OR')),
      SizedBox(
        height: 25.toHeight,
      ),
      CustomButton(
        width: 230.toWidth,
        height: 50.toHeight * deviceTextFactor,
        buttonText: Strings.uploadQRTitle,
        onPressed: _uploadCramKeyFile,
      ),
    ];
  }

  bool _validatePickedFileContents(String fileContents) {
    var result = fileContents
        .contains(BackupKeyConstants.PKAM_PRIVATE_KEY_FROM_KEY_FILE) &&
        fileContents
            .contains(BackupKeyConstants.PKAM_PUBLIC_KEY_FROM_KEY_FILE) &&
        fileContents
            .contains(BackupKeyConstants.ENCRYPTION_PRIVATE_KEY_FROM_FILE) &&
        fileContents
            .contains(BackupKeyConstants.ENCRYPTION_PUBLIC_KEY_FROM_FILE) &&
        fileContents.contains(BackupKeyConstants.SELF_ENCRYPTION_KEY_FROM_FILE);
    return result;
  }

  _getAtsignForm() {
    loading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => WillPopScope(
          onWillPop: () async {
            int ct = 0;
            Navigator.of(context).popUntil((_) => ct++ >= 2);
            return true;
          },
          child: CustomDialog(
            isAtsignForm: true,
            onSubmit: (atsign) async {
              var isExist = await LoginService.getInstance()
                  .isExistingAtsign(atsign)
                  .catchError((error) {
                _showAlertDialog(error);
              });
              var atsignStatus = await LoginService.getInstance()
                  .checkAtsignStatus(atsign: atsign);
              _pairingAtsign =
                  LoginService.getInstance().formatAtSign(atsign);
              _atsignStatus = atsignStatus ?? AtSignStatus.error;
              switch (_atsignStatus) {
                case AtSignStatus.teapot:
                  if (isExist) {
                    _showAlertDialog(CustomStrings().pairedAtsign(atsign),
                        getClose: true, onClose: _getAtsignForm);
                    break;
                  }
                  _isQR = true;
                  break;
                case AtSignStatus.activated:
                  if (isExist) {
                    _showAlertDialog(CustomStrings().pairedAtsign(atsign),
                        getClose: true, onClose: _getAtsignForm);
                    break;
                  }
                  _isBackup = true;
                  break;
                case AtSignStatus.unavailable:
                case AtSignStatus.notFound:
                  _showAlertDialog(Strings.atsignNotFound,
                      getClose: true, onClose: _getAtsignForm);
                  break;
                case AtSignStatus.error:
                  _showAlertDialog(Strings.atsignNull,
                      getClose: true, onClose: _getAtsignForm);
                  break;
                default:
                  break;
              }
              setState(() {
                loading = false;
              });
            },
          ),
        ),
      );
    });
  }
}