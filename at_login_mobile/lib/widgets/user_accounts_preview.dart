// import 'package:at_login_mobile/services/at_enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:at_login_mobile/services/at_services.dart';
//
// import '../services/at_fields.dart';
//
// class UserAccountsPreview extends StatefulWidget {
//   final pageCategory;
//
//   UserAccountsPreview({this.pageCategory});
//   @override
//   _UserAccountsState createState() => _UserAccountsState(pageCategory);
// }
//
// class _UserAccountsState extends State<UserAccountsPreview> {
//   final AtCategory pageCategory;
//   _UserAccountsState(this.pageCategory);
//
//   StateContainerState container;
//   User user;
//   List<BasicData> otherContent = [];
//   String category;
//
//   String pageTitle = '';
//   @override
//   void initState() {
//     pageTitle = pageCategory.label.toLowerCase();
//     category = pageCategory.name;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     container = StateContainer.of(context);
//     user = container.user;
//     // otherContent = container.getLocalCustomFields(category);
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           brightness: Brightness.light,
//           backgroundColor: Colors.white,
//           automaticallyImplyLeading: true,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Back',
//                 style: TextStyle(fontSize: 18.0, color: Colors.black),
//               ),
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             "Preview $pageTitle",
//             style: TextStyle(
//                 fontSize: 22.0,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Comic Sans MS'),
//           ),
//         ),
//         body: Column(children: <Widget>[
//           Container(
//             height: 52,
//             width: double.infinity,
//             color: AtTheme.themecolor,
//             child: Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   '${user.atsign}',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontFamily: 'Open SansB'),
//                 )),
//           ),
//           Container(
//             height: 85,
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: AtTheme.darkColor,
//             ),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipOval(
//                     child: Material(
//                       color: pageTitle != AtCategory.SOCIAL.label.toLowerCase()
//                           ? AtTheme.darkColor
//                           : AtTheme.themecolor,
//                       child: InkWell(
//                         child: SizedBox(
//                             width: 56,
//                             height: 56,
//                             child: Icon(
//                               FontAwesomeIcons.users,
//                               color: Colors.white,
//                               size: 30,
//                             )),
//                         // splashColor: Colors.white,
//                         onTap: () {
//                           setState(() {
//                             pageTitle = AtCategory.SOCIAL.label.toLowerCase();
//                             category = AtCategory.SOCIAL.name;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 17.0),
//                     child: VerticalDivider(
//                       color: Colors.white,
//                       thickness: 1,
//                     ),
//                   ),
//                   ClipOval(
//                     child: Material(
//                       color: pageTitle != AtCategory.GAMER.label.toLowerCase()
//                           ? AtTheme.darkColor
//                           : AtTheme.themecolor,
//                       child: InkWell(
//                         child: SizedBox(
//                             width: 56,
//                             height: 56,
//                             child: Icon(
//                               FontAwesomeIcons.gamepad,
//                               color: Colors.white,
//                               size: 30,
//                             )),
//                         // splashColor: Colors.white,
//                         onTap: () {
//                           setState(() {
//                             pageTitle = AtCategory.GAMER.label.toLowerCase();
//                             category = AtCategory.GAMER.name;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ]),
//           )
//         ]));
//   }
// }
