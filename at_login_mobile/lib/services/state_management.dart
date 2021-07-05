import 'package:at_login_mobile/services/at_common_service.dart';
import 'package:at_login_mobile/services/at_enum.dart';
import 'package:at_login_mobile/services/user.dart';
import 'package:flutter/material.dart';
import 'package:at_login_mobile/services/at_me_utils.dart';

import 'at_enum.dart';

class _InheritedStateContainer extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final StateContainerState data;

  // You must pass through a child and your state.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  // You must pass through a child.
  final Widget child;
  final User user;

  StateContainer({
    @required this.child,
    this.user,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  // Whichever properties you wanna pass around your app as state
  User user;
  var atCommonService = AtCommonService.getInstance();
  bool _isValid = true;

  StateContainerState();

  // You can (and probably will) have methods on your StateContainer
  // These methods are then used through our your app to
  // change state.
  // Using setState() here tells Flutter to repaint all the
  // Widgets in the app that rely on the state you've changed.

  save(user) {
    user.allPrivate = false;
    this.user = user;
  }

  set setIsValid(bool value) => this._isValid = value;
  get isValid => _isValid;

  setAllPrivate(private) {
    setState(() {
      user.allPrivate = private;
      for (var field in FieldsEnum.values) {
        if (field == FieldsEnum.ATSIGN) {
          continue;
        }
        setPrivacy(field.name, private);
      }
      var customFields =
          user.customFields.values.expand((element) => element).toList();
      for (var field in customFields) {
        field.isPrivate = private;
      }
    });
  }

  Map<dynamic, dynamic> _toMap() {
    return {
      FieldsEnum.ATSIGN.name: user?.atsign,
      FieldsEnum.IMAGE.name: user?.image,
      FieldsEnum.FIRSTNAME.name: user?.firstname,
      FieldsEnum.LASTNAME.name: user?.lastname,
      FieldsEnum.PHONE.name: user?.phone,
      FieldsEnum.EMAIL.name: user?.email,
      FieldsEnum.ABOUT.name: user?.about,
      FieldsEnum.LOCATION.name: user?.location,
      FieldsEnum.LOCATIONNICKNAME.name: user?.locationNickName,
      FieldsEnum.PRONOUN.name: user?.pronoun,
      FieldsEnum.TWITTER.name: user?.twitter,
      FieldsEnum.FACEBOOK.name: user?.facebook,
      FieldsEnum.LINKEDIN.name: user?.linkedin,
      FieldsEnum.INSTAGRAM.name: user?.instagram,
      FieldsEnum.YOUTUBE.name: user?.youtube,
      FieldsEnum.TUMBLR.name: user?.tumbler,
      FieldsEnum.MEDIUM.name: user?.medium,
      FieldsEnum.PS4.name: user?.ps4,
      FieldsEnum.XBOX.name: user?.xbox,
      FieldsEnum.STEAM.name: user?.steam,
      FieldsEnum.DISCORD.name: user?.discord,
    };
  }

  /// Returns `true` if custom content can be created otherwise returns `false`.
  createCustomField(BasicData basicData, String screenName) {
    var response;
    bool exist = this.checkForProperty(basicData.accountName);
    if (exist) {
      return false;
    }
    var customFields = user.customFields ??= {};
    bool index = customFields.containsKey(screenName);
    switch (index) {
      case true:
        user.customFields[screenName].add(basicData);
        response = true;
        break;
      case false:
        user.customFields.putIfAbsent(screenName, () => [basicData]);
        response = true;
        break;
      default:
        return false;
        break;
    }
    setState(() {});
    return response;
  }

  deleteCustomField(key, index) {
    List<BasicData> values = user.customFields[key];
    values[index] = BasicData(
        accountName: values[index].accountName + AtText.IS_DELETED,
        isPrivate: values[index].isPrivate);
  }

  ///checks the [fieldName] across all customContent and app's fields.
  ///Returns `true` if exists else `false`.
  checkForProperty(fieldName) {
    fieldName = _formatFieldName(fieldName);
    bool response = false;
    var customFields = user.customFields;
    if (customFields != null) {
      var values = customFields.values;
      for (var basicDataList in values) {
        var result = basicDataList.indexWhere((data) {
          return _formatFieldName(data.accountName) == fieldName;
        });
        if (result != -1) {
          return true;
        }
      }
    }
    var _mapRep = _toMap();
    response = _mapRep.containsKey(fieldName);

    return response;
  }

  updateWidgets() {
    setState(() {});
  }


  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  dynamic set(property, value, {isPrivate}) {
    if (user == null) user = User();
    isPrivate = user.allPrivate == true ? true : isPrivate;
    FieldsEnum field = valueOf(property);

    var data = atCommonService.formData(property, value, private: isPrivate);
    switch (field) {
      case FieldsEnum.ATSIGN:
        user.atsign = value;
        break;
      case FieldsEnum.IMAGE:
        user.image = data;
        break;
      case FieldsEnum.FIRSTNAME:
        user.firstname = data;
        break;
      case FieldsEnum.LASTNAME:
        user.lastname = data;
        break;
      case FieldsEnum.PHONE:
        user.phone = data;
        break;
      case FieldsEnum.EMAIL:
        user.email = data;
        break;
      case FieldsEnum.ABOUT:
        user.about = data;
        break;
      case FieldsEnum.PRONOUN:
        user.pronoun = data;
        break;
      case FieldsEnum.LOCATION:
        user.location = data;
        break;
      case FieldsEnum.LOCATIONNICKNAME:
        user.locationNickName = data;
        break;
      case FieldsEnum.TWITTER:
        user.twitter = data;
        break;
      case FieldsEnum.FACEBOOK:
        user.facebook = data;
        break;
      case FieldsEnum.LINKEDIN:
        user.linkedin = data;
        break;
      case FieldsEnum.INSTAGRAM:
        user.instagram = data;
        break;
      case FieldsEnum.YOUTUBE:
        user.youtube = data;
        break;
      case FieldsEnum.TUMBLR:
        user.tumbler = data;
        break;
      case FieldsEnum.MEDIUM:
        user.medium = data;
        break;
      case FieldsEnum.PS4:
        user.ps4 = data;
        break;
      case FieldsEnum.XBOX:
        user.xbox = data;
        break;
      case FieldsEnum.STEAM:
        user.steam = data;
        break;
      case FieldsEnum.DISCORD:
        user.discord = data;
        break;
      default:
        break;
    }
  }

  dynamic setPrivacy(property, value) {
    BasicData field = this.get(property);
    if (user.allPrivate != null && user.allPrivate == true)
      field.isPrivate = true;
    else
      field.isPrivate =
          field.value != '' && field.value != null ? value : false;
  }

  ///returns a string with lowercase and removing spaces.
  ///returns null if [fieldname] is null.
  String _formatFieldName(String fieldname) {
    if (fieldname == null) {
      return null;
    }
    return fieldname.trim().toLowerCase().replaceAll(' ', '');
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
