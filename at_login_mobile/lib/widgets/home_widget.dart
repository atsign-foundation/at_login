import 'dart:async';
import 'package:at_login_mobile/domain/shared_data.dart';
import 'package:at_login_mobile/services/at_common_service.dart';
import 'package:at_login_mobile/services/at_error_dialog.dart';
import 'package:at_login_mobile/services/at_login_service.dart';
import 'package:at_login_mobile/services/navigator_service.dart';
import 'package:at_login_mobile/services/notification_service.dart';
import 'package:at_login_mobile/services/onboarding_widget_service.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:at_login_mobile/utils/strings.dart';
import 'package:at_login_mobile/widgets/dashboard_widget.dart';
import 'package:at_login_mobile/widgets/third_widget.dart';
import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:at_login_mobile/services/globals.dart' as globals;
import 'package:uni_links/uni_links.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  StreamSubscription _intentDataStreamSubscription;
  StreamSubscription _deepLinkStreamSubscription;
  NotificationService _notificationService;
  var loginTextwidth;
  var screenHeight;

  @override
  void initState() {
    super.initState();
    _checkToOnboard();
    _notificationService = NotificationService();
    _notificationService.setOnNotificationClick(onNotificationClick);
    _receiveIntent();
    _initialLink();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _deepLinkStreamSubscription.cancel();
    super.dispose();
  }

  _initialLink() async {
    try {
      //when app is in background.
      getLinksStream().listen((String link) {
        SharedData.getInstance().followData = link;
        AtCommonService.getInstance().openSpecificPage(context);
      });

      //when app is opened with deep link.
      String initialLink = await getInitialLink();
      if (initialLink != null && SDKService().lastOnboardedAtsign != null) {
        SharedData.getInstance().sharedText = initialLink;
        globals.loadProfileIndex = true;
      }
    } catch (e) {
      _logger.severe('Following link throws $e error');
    }
  }

  onNotificationClick(String payload) {
    _logger.info('clicked on notification and received atsign is $payload');
    SharedData.getInstance().notificationData = payload;
    globals.loadFollowers = true;
    globals.followType = FollowType.notification;
    if (SDKService().lastOnboardedAtsign != null) {
      accel.cancel();
      NavigatorService.navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => DashboardWidget(
                    isLoadAtsign: true,
                  )),
          (route) => route.isFirst);
    }
  }

  /// listens to accelerometer events for moving bubbles as per user's movement.
  StreamSubscription accel;
  var _logger = AtSignLogger('AtHome');
  var _atsign;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    loginTextwidth = MediaQuery.of(context).size.width * 0.55;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onLongPress: () {
          accel.isPaused ? accel.resume() : accel.pause();
          setState(() {});
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark),
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 100,
                                  width: screenHeight < 1200
                                      ? loginTextwidth
                                      : loginTextwidth / 2,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        right: screenHeight < 1200
                                            ? loginTextwidth * 0.58
                                            : loginTextwidth * 0.3,
                                        child: Image.asset(
                                          AppConstants.appIconImage,
                                          height: 100,
                                          // width: loginTextwidth / 2,
                                          fit: BoxFit.fill,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Positioned(
                                        right: loginTextwidth * 0.13,
                                        bottom: loginTextwidth * 0.02,
                                        child: Text(Strings.appTitle,
                                            style: TextStyle(
                                                color: AtTheme.darkColor,
                                                fontFamily: AtFont.comfortaa,
                                                fontSize: 50)),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 60.0,
                            ),
                            if (_loading)
                              Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AtTheme.themecolor),
                                ),
                              ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 160.0,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(7.0),
                                  onPressed: () {
                                    OnboardingWidgetService().onboarding(
                                      onboard: _onboard,
                                      onError: (error) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AtErrorDialog
                                                  .getAlertDialog(
                                                      error, context);
                                            });
                                        _logger.severe(
                                            'Authenticating User throws $error error');
                                      },
                                      fistTimeAuthNextScreen: ThirdWidget(),
                                      nextScreen: DashboardWidget(
                                        isLoadAtsign: true,
                                      ),
                                    );
                                  },
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(50.0),
                                  ),
                                  child: Text(
                                    Strings.letsGo,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontFamily: AtFont.boldFamily),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                            color: Colors.grey[200],
                            onPressed: () {
                              _showResetDialog();
                            },
                            child: Text(
                              Strings.resetButton,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copyright,
                                color: Colors.grey[600],
                                size: 15,
                              ),
                              Text(
                                AppConstants.copyRight,
                                style: TextStyle(color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _resetDevice(List checkedAtsigns) async {
    Navigator.of(context).pop();
    setState(() {
      _loading = true;
    });
    await SDKService().resetAtsigns(checkedAtsigns).then((value) async {
      setState(() {
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AtErrorDialog.getAlertDialog(error, context);
          });
      _logger.severe('Authenticating User throws $error error');
    });
  }

  _receiveIntent() async {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      _logger.info("atsign is $_atsign and Incoming Shared file:" +
          (value?.map((f) => f.path)?.join(",") ?? ""));

      if (value != null) {
        SharedData.getInstance().sharedFile = value;
        globals.loadProfileIndex = true;
        accel.cancel();
        NavigatorService.navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => DashboardWidget(
                      isLoadAtsign: true,
                    )),
            (route) => route.isFirst);
      }
    }, onError: (err) {
      _logger.severe("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      _logger.info('Incoming images Value is $value');
      if (value != null) {
        SharedData.getInstance().sharedFile = value;
      }
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _logger.info('Incoming text Value is $value');
      if (value != null) {
        if (!value.startsWith(AppConstants.appUrl)) {
          SharedData.getInstance().sharedText = value;
          globals.loadProfileIndex = true;
        }
        accel.cancel();
        AtCommonService.getInstance().openSpecificPage(context);
      }
    }, onError: (err) {
      _logger.severe("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        if (!value.startsWith(AppConstants.appUrl)) {
          SharedData.getInstance().sharedText = value;
        }
      }
      _logger.info('Incoming text when app is closed $value');
    });
  }

  _checkToOnboard() async {
    OnboardingWidgetService().onboarding(
      onboard: _onboard,
      onError: (error) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AtErrorDialog.getAlertDialog(error, context);
            });
        _logger.severe('Authenticating User throws $error error');
      },
      fistTimeAuthNextScreen: ThirdWidget(),
      nextScreen: DashboardWidget(
        isLoadAtsign: true,
      ),
    );
  }

  _onboard(clientServiceMap, atsign) async {
    SDKService().atClientServiceMap = clientServiceMap;
    SDKService().lastOnboardedAtsign = atsign;
    var container = StateContainer.of(context);
    container.save(User(atsign: atsign, allPrivate: false));

    await AtLoginService.getInstance().startMonitor();
    accel.cancel();
    if (SharedData.getInstance().data != null) {
      globals.loadProfileIndex = true;
    }
  }

  _showResetDialog() async {
    bool isSelectAtsign = false;
    var atsignsList = await SDKService().getAtsignList();
    var atsignMap = {};
    for (String atsign in atsignsList) {
      atsignMap[atsign] = false;
    }
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, stateSet) {
            return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Strings.resetDescription,
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 0.8,
                    )
                  ],
                ),
                content: atsignsList.isEmpty
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(Strings.noAtsignToReset,
                            style: TextStyle(fontSize: 15)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppConstants.closeButton,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AtTheme.themecolor))),
                        )
                      ])
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var atsign in atsignsList)
                            CheckboxListTile(
                              onChanged: (value) {
                                atsignMap[atsign] = value;
                                stateSet(() {});
                              },
                              value: atsignMap[atsign],
                              checkColor: Colors.white,
                              activeColor: AtTheme.themecolor,
                              title: Text('$atsign'),
                              // trailing: Checkbox,
                            ),
                          Divider(thickness: 0.8),
                          if (isSelectAtsign)
                            Text(Strings.resetErrorText,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(Strings.resetWarningText,
                              style: TextStyle(
                                  fontFamily: AtFont.boldFamily, fontSize: 14)),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            FlatButton(
                              onPressed: () {
                                var tempAtsignMap = {};
                                tempAtsignMap.addAll(atsignMap);
                                tempAtsignMap.removeWhere(
                                    (key, value) => value == false);
                                if (tempAtsignMap.keys.toList().isEmpty) {
                                  isSelectAtsign = true;
                                  stateSet(() {});
                                } else {
                                  isSelectAtsign = false;
                                  _resetDevice(tempAtsignMap.keys.toList());
                                }
                              },
                              child: Text(AppConstants.removeButton,
                                  style: TextStyle(
                                      fontSize: 15, color: AtTheme.themecolor)),
                            ),
                            Spacer(),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppConstants.cancelButton,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)))
                          ])
                        ],
                      ));
          });
          // );
        });
  }
}
