// import 'package:at_follows_flutter/screens/connections.dart';
import 'package:at_login_mobile/services/at_common_service.dart';
import 'package:at_login_mobile/services/at_fields.dart';
import 'package:at_login_mobile/services/at_login_service.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/services/navigator_service.dart';
import 'package:at_login_mobile/services/onboarding_widget_service.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:at_login_mobile/widgets/common_widgets/web_view_screen.dart';
import 'package:at_login_mobile/widgets/home_widget.dart';
import 'package:at_login_mobile/widgets/third_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_login_mobile/services/at_error_dialog.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';

class DashboardWidget extends StatefulWidget {
  final isLoadAtsign;
  DashboardWidget({
    Key key,
    this.isLoadAtsign,
  }) : super(key: key);

  @override
  State createState() => _DashBoardState(this.isLoadAtsign);
}

class _DashBoardState extends State<DashboardWidget> {
  var _logger = AtSignLogger('DashboardWidget');
  bool isLoadAtsign;
  _DashBoardState(loadAtsign) {
    this.isLoadAtsign = loadAtsign;
  }
  var atLoginServiceInstance = AtLoginService.getInstance();
  final _sdkService = SDKService();
  User user;
  var container;
  bool loading = false;
  List<AtSign> atsignsList = [];
  int lastAccessedAtsignIndex;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    container = StateContainer.of(context);
    user = container.user;
    if ((atsignsList.isEmpty && isLoadAtsign == true) || user.atsign == null) {
      _loadAtSigns();
    }
    return _getDashBoard();
  }

  _getDashBoard() {
    return Stack(
      children: [
        Opacity(
          opacity: loading ? 0.2 : 1,
          child: AbsorbPointer(
            absorbing: loading,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: AppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                      child: (user.image?.value == null ||
                                          user.image.value == '')
                                          ? Icon(
                                        Icons.person,
                                        size: 28,
                                        color: Colors.black87,
                                      )
                                          : Image.memory(user.image?.value,
                                          fit: BoxFit.fill,
                                          gaplessPlayback: true)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 0,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: AtTheme.themecolor,
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                children: [
                                  TextSpan(text: 'Hello, '),
                                  TextSpan(
                                      text: ' ${user.atsign}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ),
                      ),
                      // IconButton(
                      //     icon: Icon(Icons.group_add, color: Colors.white),
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Connections(
                      //                     appColor: AtTheme.themecolor,
                      //                     atClientserviceInstance: SDKService()
                      //                         .atClientServiceMap[user.atsign],
                      //                   )));
                      //     }),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
                ),
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                  child: Container(
                      margin: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 16.0),
                                child: ListView(
                                  children: viewAtSigns(),
                                ),
                              )),
                          IconButton(
                            color: AtTheme.themecolor,
                            icon: Icon(Icons.add_circle_outline),
                            iconSize: 45,
                            onPressed: () {
                              OnboardingWidgetService().onboarding(
                                  fistTimeAuthNextScreen: ThirdWidget(),
                                  nextScreen: null,
                                  atsign: '',
                                  onboard: (value, atsign) async {
                                    _sdkService.atClientServiceMap = value;
                                    _sdkService.lastOnboardedAtsign = atsign;
                                    await _loadAtSigns();
                                    setState(() {});
                                  },
                                  onError: (error) {});
                            },
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                          title: AtText.PRIVACY_POLICY,
                                          url: AtText.PRIVACY_POLICY_URL,
                                          showAppBarColor: false,
                                        )));
                              },
                              child: Text(AtText.PRIVACY_POLICY,
                                  style: TextStyle(color: AtTheme.themecolor)))
                        ],
                      ))),
            ),
          ),
        ),
        Opacity(
          opacity: loading ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AtTheme.themecolor),
            ),
          ),
        )
      ],
    );
  }

  viewAtSigns() {
    List<Widget> widget = [];
    for (int index = 0; index < atsignsList.length; index++) {
      widget.addAll(buildAtSigns(atsignsList[index], index));
    }
    return widget;
  }

  buildAtSigns(AtSign atsign, int currentIndex) {
    return <Widget>[
      FlatButton(
        onPressed: () async {
          if (!atsign.isOnboarded && !atsign.isOpen) {
            var isOnboarded = SDKService().isOnboarded(atsign.name);
            if (!isOnboarded) {
              OnboardingWidgetService().onboarding(
                  nextScreen: null,
                  onboard: (value, atsignName) {
                    SDKService().atClientServiceMap = value;
                    atsign.isOnboarded = true;
                    setState(() {});
                  },
                  onError: (error) {
                    showDialog(
                        barrierDismissible: false,
                        context: NavigatorService.navigatorKey.currentContext,
                        builder: (BuildContext context) {
                          return AtErrorDialog.getAlertDialog(error, context);
                        });
                    _logger.severe('onboarding this atsign throws $error');
                  },
                  atsign: atsign.name);
            } else {
              atsign.isOnboarded = true;
            }
          }
          if (currentIndex != lastAccessedAtsignIndex &&
              lastAccessedAtsignIndex != null) {
            atsignsList[lastAccessedAtsignIndex].isOpen = false;
          }
          atsign.isOpen = !atsign.isOpen;
          lastAccessedAtsignIndex = currentIndex;
          setState(() {});
        },
        child: Container(
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Text(
                  '${atsign.name}',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: atsign.isLastAccessed
                          ? AtTheme.themecolor
                          : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(
                    atsign.isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      atsign.isOpen
          ? Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: AnimatedOpacity(
          opacity: atsign.isOpen ? 1.0 : 0.0,
          duration: Duration(milliseconds: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: IconButton(
                        icon: Icon(FontAwesomeIcons.signInAlt,
                            color: Colors.white, size: 22),
                        onPressed: () {
                          _loginWithAtSign(context, atsign);
                        })),
              ),
              Flexible(
                flex: 2,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.history,
                        color: Colors.white, size: 25),
                    onPressed: () {
                      _showHistory(context, atsign);
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: IconButton(
                        icon: Icon(FontAwesomeIcons.trashAlt,
                            color: Colors.white, size: 22),
                        onPressed: () {
                          _deleteAtSign(atsign);
                        })),
              ),
              Flexible(
                flex: 2,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: BackupKeyWidget(
                      atClientService: _sdkService.atClientServiceMap[atsign.name],
                      atsign: atsign.name,
                      iconColor: Colors.white,
                      iconSize: 22,
                      isIcon: true),
                ),
              ),
            ],
          ),
        ),
      )
          : Center(),
      Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    ];
  }

  _loadFirstAtSign(context, atsign) async {
    await atLoginServiceInstance.getHistory(context, atsign: atsign,
        successCallBack: (response) {
          if (isLoadAtsign) {
            AtCommonService.getInstance()
                .openSpecificPage(context, atsign: user.atsign);
          }
          isLoadAtsign = false;
          _logger.info('loaded successfully');
        }, errorCallBack: (errorValue) {
          _logger.info('loading first atsign throws $errorValue');
        });
  }

  _loadAtSigns() async {
    atsignsList.clear();
    atsignsList = await _sdkService.getAtsignsWithStatus();
    if (user.atsign == null || this.isLoadAtsign == true) {
      await _loadFirstAtSign(context, atsignsList[0].name);
      user = container.user;
    } else if (user.atsign != atsignsList[0].name) {
      user.atsign = atsignsList[0].name;
    }
  }

  _loginWithAtSign(context, AtSign atsign) async {
    loading = true;
    setState(() {});
    if (!atsign.isLastAccessed && atsign.isOnboarded) {
      var isPrimary = await _sdkService.makeAtSignPrimary(atsign.name);
      _logger.info(isPrimary
          ? 'Made ${atsign.name} @sign as primary'
          : 'Failed in making ${atsign.name} as primary @sign');
      await _loadAtSigns();
    }
    await atLoginServiceInstance.getHistory(context, atsign: atsign.name,
        successCallBack: (response) {
          if (response) {
            loading = false;
            setState(() {});
            // Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => EditProfileWidget()))
            //     .then((value) => setState(() {}));
          } else {
            setState(() {
              loading = false;
            });
            _logger.info('no scan from server response');
          }
        }, errorCallBack: (error) {
          setState(() {
            loading = false;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AtErrorDialog.getAlertDialog(error, context);
              });
          _logger.severe('Throws $error');
        }).catchError((error) {
      setState(() {
        loading = false;
      });
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AtErrorDialog.getAlertDialog(error, context);
          });
      _logger.severe('Throws $error');
    });
  }

  _showHistory(context, AtSign atsign) async {
    // String atSign = atsign.replaceFirst('@', '');
    // String url = "${rootEnvironment.previewLink}$atSign";
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => WebViewScreen(
    //           title: 'Public Content',
    //           url: url,
    //           showAppBarColor: false,
    //         )));
  }

  _deleteAtSign(AtSign atsign) async {
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Remove @sign',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            content: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'This will remove the selected @sign and its details from this app only',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 20),
                  Text('${atsign.name}',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Type the above @sign to proceed',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 5),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value.contains('@') ? value : '@' + value;
                        if (value.toLowerCase() != atsign.name) {
                          return "The @sign doesn't match. Please retype.";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        // prefix: Text('@'),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: AtTheme.themecolor)),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Warning: This action cannot be undone",
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                          child: Text('Remove',
                              style: TextStyle(color: AtTheme.themecolor)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await _sdkService.deleteAtSign(atsign.name);
                              var index = atsignsList.indexOf(atsign);
                              atsignsList.remove(atsign);
                              lastAccessedAtsignIndex = null;
                              if (atsignsList.isNotEmpty) {
                                Navigator.pop(context);
                                isLoadAtsign = true;
                                if (!atsignsList[0].isOnboarded && index == 0) {
                                  OnboardingWidgetService().onboarding(
                                      nextScreen: null,
                                      onboard: (value, atsignName) async {
                                        _sdkService.atClientServiceMap = value;
                                        _sdkService.lastOnboardedAtsign =
                                            atsignName;
                                        await _loadAtSigns();
                                      },
                                      onError: (error) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: NavigatorService
                                                .navigatorKey.currentContext,
                                            builder: (BuildContext context) {
                                              return AtErrorDialog
                                                  .getAlertDialog(
                                                  error, context);
                                            });
                                        _logger.severe(
                                            'onboarding this atsign throws $error');
                                      },
                                      atsign: atsignsList[0].name);
                                } else {
                                  await _loadAtSigns();
                                }
                              } else {
                                container.save(User());
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeWidget()),
                                        (Route<dynamic> route) => false);
                              }
                            }
                          }),
                      // Spacer(),
                      FlatButton(
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
