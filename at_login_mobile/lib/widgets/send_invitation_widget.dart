import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:at_login_mobile/services/at_services.dart';

class SendInvitationWidget extends StatefulWidget {
  @override
  _SendInvitationWidgetState createState() => _SendInvitationWidgetState();
}

class _SendInvitationWidgetState extends State<SendInvitationWidget> {
  bool isChecked = false;
  TextEditingController _fromController = TextEditingController();
  TextEditingController _friendMailController = TextEditingController();
  TextEditingController _personalNoteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> contentDropDown = ['samplemail@gmail.com', 'xyz@corporate.com'];

  _validateForm() {
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    _friendMailController.text = contentDropDown[0];
    Size size = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: AtTheme.themecolor,
          buttonColor: AtTheme.themecolor,
          textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 20,
                fontFamily: AtFont.boldFamily,
                color: Colors.white),
          )),
      child: Container(
        width: size.width * 0.88,
        child: Drawer(
          child: Scaffold(
            backgroundColor: AtTheme.darkColor,
            body: Column(
              children: [
                Expanded(
                    child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(FontAwesomeIcons.solidPaperPlane,
                          color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Send Invitation', style: TextStyle(fontSize: 18))
                    ]),
                    SizedBox(
                      height: size.height / 12,
                    ),
                    Text(
                      'Invite friends and family to get their @sign!',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: size.height / 14,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Your First Name',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: AtFont.family)),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _fromController,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please provide your name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (_fromController.text != value) {
                                setState(() {
                                  //  showText = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                // hintText: '',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  // borderRadius: BorderRadius.circular(10.0),
                                )),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 20.0),
                          Text("Recipient's Email",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: AtFont.family)),
                          SizedBox(height: 8.0),
                          DropdownButtonFormField<String>(
                              hint: Text('-Select-'),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    //  borderRadius: BorderRadius.circular(12.0)
                                    ),
                              ),
                              value: _friendMailController.text,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              elevation: 16,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select mail';
                                }
                                return null;
                              },
                              onChanged: (String newValue) {
                                setState(() {
                                  //  _setType(newValue);
                                });
                              },
                              items: contentDropDown
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                          SizedBox(height: 20.0),
                          Text("Personal Note",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: AtFont.family)),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            //  autovalidate: true,
                            controller: _personalNoteController,
                            //  validator: (value) {
                            //    if (value == null) {
                            //      return 'Please provide field content';
                            //    }
                            //    return null;
                            //  },
                            maxLines: 5,

                            decoration: InputDecoration(
                                //  hintText: 'FieldContent',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    //  borderRadius: BorderRadius.circular(10.0),
                                    ),
                                focusedBorder: OutlineInputBorder(
                                    //  borderSide: BorderSide(color: Colors.Wh),
                                    //  borderRadius: BorderRadius.circular(10.0),
                                    )),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Send me a copy',
                                  style: TextStyle(
                                      fontFamily: AtFont.family, fontSize: 18)),
                              Switch(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.white38,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          MaterialButton(
                            //  color: Colors.transparent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                          MaterialButton(
                            minWidth: 120,
                            height: 40,
                            color: AtTheme.themecolor,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            onPressed: () {
                              _validateForm();
                              Navigator.pop(context);
                            },
                            child: Text('Send',
                                style: TextStyle(
                                    color: AtTheme.buttonTextColor,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
