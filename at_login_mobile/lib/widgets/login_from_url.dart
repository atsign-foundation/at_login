// import 'package:at_follows_flutter/screens/connections.dart';
import 'package:at_login_mobile/domain/shared_data.dart';
import 'package:at_login_mobile/providers/basic_provider.dart';
import 'package:at_login_mobile/providers/login_from_web_provider.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/services/onboarding_widget_service.dart';
import 'package:at_login_mobile/utils/strings.dart';
import 'package:at_login_mobile/widgets/common_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:at_utils/at_logger.dart';

class LoginFromUrl extends StatefulWidget {
  @override
  _LoginFromUrlState createState() => _LoginFromUrlState();
}

class _LoginFromUrlState extends State<LoginFromUrl> {
  @override
  void initState() {
    super.initState();
  }

  var lastSelectedIndex;
  var _logger = AtSignLogger('Follow From Web Widget');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          showBackButton: true,
        ),
        body: Consumer<LoginFromWebProvider>(
          builder: (context, provider, _) {
            if (provider.pageState == PageState.loading) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (provider.pageState == PageState.done) {
              if (provider.deviceAtsigns.isEmpty) {
                return Text(
                    'The device is not paired with any atsign. Please pair an atsign ');
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          children: [
                            TextSpan(text: 'Please select an @sign to add '),
                            TextSpan(
                              text: '${SharedData.getInstance().followAtsign}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' into the following list')
                          ]),
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 0.8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.deviceAtsigns.length,
                        itemBuilder: (ctxt, index) {
                          return RadioListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            groupValue: lastSelectedIndex,
                            onChanged: (value) {
                              if (value == index) {
                                _showDialog(provider.deviceAtsigns[index]);
                              }
                              setState(() {
                                lastSelectedIndex = value;
                              });
                            },
                            value: index,
                            activeColor: AtTheme.themecolor,
                            title: Text('${provider.deviceAtsigns[index]}',
                                style: TextStyle(
                                    fontWeight: index == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (provider.pageState == PageState.error) {
              _logger.severe('Throws an error');
              return SizedBox();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await provider.getDeviceAtsigns();
              });
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }

  _showDialog(String toAtsign) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(Strings.addFollowConfirmation(
                SharedData.getInstance().followAtsign, toAtsign)),
            actions: [
              TextButton(
                  child: Text(Strings.noButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text(Strings.yesButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addToFollowingList(
                        SharedData.getInstance().followAtsign, toAtsign);
                  }),
            ],
          );
        });
  }

  _addToFollowingList(String from, String to) {
    var _sdkService = SDKService();
    bool isOnboarded = _sdkService.atClientServiceMap.containsKey(to);

    if (!isOnboarded) {
      OnboardingWidgetService().onboarding(
          atsign: to,
          onError: (error) {
            _logger.severe('Onboarding throws $error');
          },
          onboard: (value, atsign) {
            _sdkService.atClientServiceMap = value;
            _sdkService.lastOnboardedAtsign = atsign;
            Navigator.pop(context);
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (_) => Connections(
            //     atClientserviceInstance: _sdkService.atClientServiceMap[to],
            //     followAtsignTitle: from,
            //     appColor: AtTheme.themecolor,
            //   ),
            // ));
          });
    } else {
      Navigator.of(context).pop();
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (_) => Connections(
      //     atClientserviceInstance: _sdkService.atClientServiceMap[to],
      //     followAtsignTitle: from,
      //     appColor: AtTheme.themecolor,
      //   ),
      // ));
    }
  }
}
