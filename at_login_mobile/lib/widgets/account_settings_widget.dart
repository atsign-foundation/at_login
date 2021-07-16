// import 'invitation_history_widget.dart';
// import 'send_invitation_widget.dart';
// import 'package:at_login_mobile/services/at_services.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class AccountSettingsWidget extends StatefulWidget {
//   @override
//   _AccountSettingsWidgetState createState() => _AccountSettingsWidgetState();
// }
//
// class _AccountSettingsWidgetState extends State<AccountSettingsWidget> {
//   User user;
//   StateContainerState container;
//   dynamic drawerWidget = SendInvitationWidget();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isVisible = false;
//   bool profileSharing = false;
//   bool profileEmbedding = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70),
//         child: AppBar(
//           centerTitle: true,
//           title: Text(
//             'Account Settings',
//             style: TextStyle(fontFamily: 'Open SansB'),
//           ),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
//           leading: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//       drawer: drawerWidget,
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         children: [
//           Row(
//             children: <Widget>[
//               Icon(Icons.cached),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 'UpComing Renewals',
//                 style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.black,
//                     fontFamily: 'Open SansB'),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Align(
//                   alignment: AlignmentDirectional.centerEnd,
//                   child: IconButton(
//                     iconSize: 25,
//                     icon: _isVisible
//                         ? Icon(
//                             Icons.keyboard_arrow_up,
//                             color: Colors.black,
//                           )
//                         : Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.black,
//                           ),
//                     onPressed: () {
//                       setState(() {
//                         _isVisible = !_isVisible;
//                       });
//                     },
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               )
//             ],
//           ),
//           _isVisible
//               ? Padding(
//                   padding: const EdgeInsets.fromLTRB(40.0, 8.0, 8.0, 0),
//                   child: AnimatedOpacity(
//                     opacity: _isVisible ? 1.0 : 0.0,
//                     duration: Duration(milliseconds: 100),
//                     child: Column(children: getUpComingRenewals()),
//                   ),
//                 )
//               : Center(),
//           Divider(
//             color: Colors.grey[300],
//             thickness: 1,
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: <Widget>[
//               Icon(Icons.history),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 'Invitation History',
//                 style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.black,
//                     fontFamily: 'Open SansB'),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Align(
//                   alignment: AlignmentDirectional.centerEnd,
//                   child: IconButton(
//                     iconSize: 25,
//                     icon: Icon(
//                       Icons.keyboard_arrow_right,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         drawerWidget = InvitationHistoryWidget();
//                       });
//                       _scaffoldKey.currentState.openDrawer();
//                     },
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             children: <Widget>[
//               Icon(
//                 FontAwesomeIcons.solidPaperPlane,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 'Send Invitation',
//                 style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.black,
//                     fontFamily: 'Open SansB'),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Align(
//                   alignment: AlignmentDirectional.centerEnd,
//                   child: IconButton(
//                     iconSize: 25,
//                     icon: Icon(
//                       Icons.keyboard_arrow_right,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         drawerWidget = SendInvitationWidget();
//                       });
//                       _scaffoldKey.currentState.openDrawer();
//                     },
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Divider(
//             color: Colors.grey[300],
//             thickness: 1,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 40),
//             child: Text(
//               'Sharing',
//               style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.black,
//                   fontFamily: 'Open SansB'),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Allow Profile Sharing',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Switch(
//                   value: profileSharing,
//                   onChanged: (value) {
//                     setState(() {
//                       profileSharing = value;
//                     });
//                   },
//                   inactiveThumbColor: AtTheme.inactiveThumbColor,
//                   inactiveTrackColor: AtTheme.inactiveTrackColor,
//                   activeTrackColor: AtTheme.activeTrackColor,
//                   activeColor: AtTheme.activeColor,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Allow Profile Embedding',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Switch(
//                   value: profileEmbedding,
//                   onChanged: (value) {
//                     setState(() {
//                       profileEmbedding = value;
//                     });
//                   },
//                   inactiveThumbColor: AtTheme.inactiveThumbColor,
//                   inactiveTrackColor: AtTheme.inactiveTrackColor,
//                   activeTrackColor: AtTheme.activeTrackColor,
//                   activeColor: AtTheme.activeColor,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   getUpComingRenewals() {
//     List<Widget> widget = [];
//     Map<String, dynamic> renewalData = {
//       '@sign45': '1/21/21',
//       '@craytabletennis': '1/21/21'
//     };
//     int index = 0;
//     List<String> renewalDataKeys = renewalData.keys.toList();
//     List<dynamic> renewalDataValues = renewalData.values.toList();
//
//     while (index < renewalData.length) {
//       widget.addAll([
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               flex: 6,
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     renewalDataKeys[index],
//                     style: TextStyle(fontFamily: 'Open SansB', fontSize: 16),
//                   ),
//                   Text(
//                     'Renewal date: ${renewalDataValues[index]}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               flex: 3,
//               child: RaisedButton(
//                   padding: EdgeInsets.all(7.0),
//                   onPressed: () {},
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                   ),
//                   child: Text(
//                     'Renew',
//                     style:
//                         TextStyle(fontSize: 16, color: AtTheme.buttonTextColor),
//                   )),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 20,
//         )
//       ]);
//       index++;
//     }
//     return widget;
//   }
// }
