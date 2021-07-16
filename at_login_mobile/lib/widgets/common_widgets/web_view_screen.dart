import 'dart:io';

// import 'package:at_onboarding_flutter/widgets/custom_appbar.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:at_login_mobile/widgets/common_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:at_utils/at_logger.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final bool showAppBarColor;

  WebViewScreen({this.url, this.title, this.showAppBarColor = true});
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading;
  var _logger = AtSignLogger('WebView Widget');

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        title: widget.title,
        isCenterTitle: true,
        showBackgroundcolor: widget.showAppBarColor,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest navReq) async {
              if (navReq.url.startsWith(AppConstants.appUrl)) {
                _logger.info('Navigation decision is taken by urlLauncher');
                await _launchURL(navReq.url);
                return NavigationDecision.prevent;
              }
              _logger.info('Navigation decision is taken by webView');
              return NavigationDecision.navigate;
            },
            onPageFinished: (value) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                    AtTheme.themecolor,
                  )),
                )
              : SizedBox()
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      Navigator.pop(context);
      await launch(url);
    } else {
      _logger.severe('unable to launch $url');
    }
  }
}
