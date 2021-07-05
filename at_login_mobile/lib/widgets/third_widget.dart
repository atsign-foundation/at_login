import 'dart:async';
import 'package:at_login_mobile/routes/routes.dart';
import 'package:at_login_mobile/services/at_login_service.dart';

import 'dashboard_widget.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:flutter/material.dart';

class ThirdWidget extends StatefulWidget {
  ThirdWidget();
  @override
  _ThirdWidgetState createState() => _ThirdWidgetState();
}

class _ThirdWidgetState extends State<ThirdWidget> {
  var atLoginServiceInstance = AtLoginService.getInstance();
  bool loading = false;
  String atsign;
  StreamSubscription accel;
  TextEditingController atsignController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var container = StateContainer.of(context);
    if (atsign == null) {
      container.save(
          User(atsign: SDKService().lastOnboardedAtsign, allPrivate: false));
    }
    atsign = container.user.atsign;
    return Stack(
      children: [
        Opacity(
          opacity: loading ? 0.2 : 1,
          child: AbsorbPointer(
              absorbing: loading,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: AppBar(
                      leading: Container(),
                      centerTitle: true,
                      title: Text(
                        'Success!',
                        style: TextStyle(fontFamily: 'Open SansB'),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30))),
                    ),
                  ),
                  body: GestureDetector(
                    onLongPress: () {
                      accel.isPaused ? accel.resume() : accel.pause();
                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    children: [
                                      SizedBox(height: 200),
                                      Text(
                                        "Your @sign",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Text(atsign,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.0,
                                              fontFamily: 'Open SansB')),
                                      Text(
                                        "is now ready to configure!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 19.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            // height: 60.0,
                                            width: 280.0,
                                            child: RaisedButton(
                                                padding: EdgeInsets.all(7),
                                                onPressed: () {
                                                  accel.pause();
                                                  container.user = User(
                                                      allPrivate: false,
                                                      atsign: atsign);
                                                  Navigator.pushNamed(context,
                                                          Routes.PROFILE_IMAGE)
                                                      .then((value) {
                                                    setState(() {
                                                      accel.resume();
                                                    });
                                                  });
                                                },
                                                // color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(50.0)),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Customize your profile",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                                    SizedBox(
                                                      width: 18,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ))),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      accel.cancel();
                                      container.save(User(
                                          allPrivate: false, atsign: atsign));
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardWidget(
                                                  isLoadAtsign: true,
                                                )),
                                        (route) => route.isFirst,
                                      );
                                    },
                                    child: Text(
                                      "Skip to Dashboard",
                                      style: TextStyle(
                                        color: AtTheme.themecolor,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))),
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
}
