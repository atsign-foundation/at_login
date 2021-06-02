import 'package:at_login_mobile/services/at_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvitationHistoryWidget extends StatefulWidget {
  @override
  _InvitationHistoryWidgetState createState() =>
      _InvitationHistoryWidgetState();
}

class _InvitationHistoryWidgetState extends State<InvitationHistoryWidget> {
  User user;
  StateContainerState container;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    container = StateContainer.of(context);
    user = container.user;

    return Container(
      width: size.width * 0.88,
      child: Drawer(
        child: Scaffold(
          backgroundColor: AtTheme.lightColor,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.paperPlane,
                      size: 20,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Invitation History',
                      style: TextStyle(fontSize: 20, fontFamily: 'Open SansB'),
                    )
                  ],
                ),
              ),
              Column(
                children: getHistory(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getHistory() {
    List<String> datesData = ['May 2020', 'April 2020'];
    List<Widget> widget = [];
    int index = 0;
    while (index < datesData.length) {
      widget.addAll([
        Container(
          height: 40,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            child: Text(
              datesData[index],
              style: TextStyle(
                  fontFamily: 'Open SansB',
                  fontSize: 20,
                  color: Colors.grey[600]),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ]);
      List<dynamic> historyData = [
        {
          "invitedDate": '4/12/20',
          'mail': 'jimmy@gmail.com',
          'status': 'Pending'
        },
        {
          "invitedDate": '4/09/20',
          'mail': 'sarah12@gmail.com',
          'status': '@goldenticket12'
        },
        {
          "invitedDate": '4/08/20',
          'mail': 'streeter@comcast.com',
          'status': '@samiam'
        },
      ];
      int insideIndex = 0;
      while (insideIndex < historyData.length) {
        var data = historyData[insideIndex];
        widget.addAll([
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['invitedDate'],
                  style: TextStyle(fontSize: 18, fontFamily: 'Open SansB'),
                ),
                Text(
                  data['mail'],
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                Text(
                  data['status'],
                  style: TextStyle(
                      fontSize: 18,
                      color: data['status'].toLowerCase() == 'pending'
                          ? Colors.grey[600]
                          : AtTheme.themecolor),
                ),
                insideIndex != historyData.length - 1
                    ? Divider(
                        color: Colors.grey[400].withOpacity(0.5),
                        thickness: 0.8,
                      )
                    : Center(),
                insideIndex == historyData.length - 1
                    ? SizedBox(
                        height: 30,
                      )
                    : Center()
              ],
            ),
          )
        ]);
        insideIndex++;
      }

      index++;
    }
    return widget;
  }
}
