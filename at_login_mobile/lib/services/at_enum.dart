import 'package:flutter/material.dart';

enum FieldsEnum {
  ATSIGN,
  IMAGE,
  FIRSTNAME,
  LASTNAME,
  EMAIL,
  PHONE,
  ABOUT,
  PRONOUN,
  LOCATION,
  LOCATIONNICKNAME,
  TWITTER,
  FACEBOOK,
  LINKEDIN,
  INSTAGRAM,
  YOUTUBE,
  MEDIUM,
  TUMBLR,
  PS4,
  XBOX,
  STEAM,
  DISCORD
}

extension FieldsEnumValues on FieldsEnum {
  String get label {
    switch (this) {
      case FieldsEnum.FIRSTNAME:
        return 'FIRSTNAME';
        break;
      case FieldsEnum.LASTNAME:
        return 'LASTNAME';
        break;
      case FieldsEnum.PHONE:
        return 'PHONE';
        break;
      case FieldsEnum.EMAIL:
        return 'EMAIL';
        break;
      case FieldsEnum.ABOUT:
        return 'ABOUT ME';
        break;
      case FieldsEnum.LOCATION:
        return 'SHOW ON MAP';
        break;
      case FieldsEnum.LOCATIONNICKNAME:
        return 'LOCATION NICKNAME';
        break;
      case FieldsEnum.TWITTER:
        return 'TWITTER';
        break;
      case FieldsEnum.INSTAGRAM:
        return 'INSTAGRAM';
        break;
      case FieldsEnum.FACEBOOK:
        return 'FACEBOOK';
        break;
      case FieldsEnum.LINKEDIN:
        return 'LINKEDIN';
        break;
      case FieldsEnum.TUMBLR:
        return 'TUMBLR';
        break;
      case FieldsEnum.MEDIUM:
        return 'MEDIUM';
        break;
      case FieldsEnum.YOUTUBE:
        return 'YOUTUBE';
        break;
      case FieldsEnum.PRONOUN:
        return 'PRONOUN';
        break;
      case FieldsEnum.PS4:
        return 'PS4';
        break;
      case FieldsEnum.XBOX:
        return 'XBOX';
        break;
      case FieldsEnum.STEAM:
        return 'STEAM (PC)';
        break;
      case FieldsEnum.DISCORD:
        return 'DISCORD';
        break;
      default:
        return '';
        break;
    }
  }

  String get name {
    return this.toString().split('.').last.toLowerCase();
  }

  String get title {
    return this == FieldsEnum.ABOUT
        ? 'about me'
        : this.toString().split('.').last.toLowerCase();
  }

  String get hintText {
    switch (this) {
      case FieldsEnum.FIRSTNAME:
        return 'First name';
        break;
      case FieldsEnum.LASTNAME:
        return 'Last name';
        break;
      case FieldsEnum.PHONE:
        return 'Phone';
        break;
      case FieldsEnum.EMAIL:
        return 'Email';
        break;
      case FieldsEnum.ABOUT:
        return 'Write a short bio or quote';
        break;
      case FieldsEnum.PRONOUN:
        return 'Preferred pronoun';
        break;
      case FieldsEnum.LOCATIONNICKNAME:
        return 'Home, Office, School, etc...';
        break;
      case FieldsEnum.LOCATION:
        return 'Type postal code, city, country, or street';
        break;
      case FieldsEnum.TWITTER:
      case FieldsEnum.INSTAGRAM:
      case FieldsEnum.FACEBOOK:
      case FieldsEnum.LINKEDIN:
      case FieldsEnum.TUMBLR:
      case FieldsEnum.MEDIUM:
      case FieldsEnum.YOUTUBE:
        return 'USERNAME';
        break;
      case FieldsEnum.PS4:
        return 'PS4';
        break;
      case FieldsEnum.XBOX:
        return 'XBOX';
        break;
      case FieldsEnum.STEAM:
        return 'Steam (PC)';
        break;
      case FieldsEnum.DISCORD:
        return 'Discord';
        break;
      default:
        return '';
        break;
    }
  }
}

valueOf(String property) {
  for (var field in FieldsEnum.values) {
    if (property == field.name) {
      return field;
    }
  }
  return '';
}

enum AtCategory { IMAGE, DETAILS, LOCATION, SOCIAL, GAMER }

extension AtCategoryValues on AtCategory {
  String get name {
    return this.toString().split('.').last;
  }

  String get label {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Image';
        break;
      case AtCategory.DETAILS:
        return 'Details';
        break;
      case AtCategory.SOCIAL:
        return 'Social';
        break;
      case AtCategory.GAMER:
        return 'Gaming';
        break;
      default:
        return '';
        break;
    }
  }
}

enum Operation { EDIT, DELETE, PRINT, SAVE }

extension OperationValues on Operation {
  String get name {
    switch (this) {
      case Operation.DELETE:
        return 'Delete';
        break;
      case Operation.EDIT:
        return 'Edit';
        break;
      case Operation.PRINT:
        return 'Print';
        break;
      case Operation.SAVE:
        return 'Save';
        break;
      default:
        return '';
        break;
    }
  }
}

enum LocationJson { RADIUS, LOCATION }

extension LocationJsonValues on LocationJson {
  String get name {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum OnboardStatus {
  ATSIGN_NOT_FOUND,
  PRIVATE_KEY_NOT_FOUND,
  ACTIVATE,
  RESTORE
}

// extension on OnboardStatus {
//   bool isEqual => this.toString().split
// }

extension status on OnboardStatus {
  String get value => this.toString().split('.').last.toUpperCase();
  String get name {
    switch (this) {
      case OnboardStatus.ACTIVATE:
        return 'Activate';
        break;
      case OnboardStatus.RESTORE:
        return 'Restore';
        break;
      default:
        return '';
        break;
    }
  }
}

enum RootEnvironment { Staging, Production, Testing }

extension value on RootEnvironment {
  String get domain {
    switch (this) {
      case RootEnvironment.Staging:
        return 'root.atsign.wtf';
        break;
      case RootEnvironment.Production:
        return 'root.atsign.org';
        break;
      case RootEnvironment.Testing:
        return 'vip.ve.atsign.zone';
        break;
      default:
        return '';
        break;
    }
  }

  String get website {
    switch (this) {
      case RootEnvironment.Staging:
        return 'https://atsign.wtf';
        break;
      case RootEnvironment.Production:
        return 'https://atsign.com';
        break;
      case RootEnvironment.Testing:
        return 'https://atsign.wtf';
        break;
      default:
        return '';
        break;
    }
  }

  String get previewLink {
    switch (this) {
      case RootEnvironment.Staging:
        return 'https://directory.atsign.wtf/';
        break;
      case RootEnvironment.Production:
        return 'https://login.ng/';
        break;
      case RootEnvironment.Staging:
        return 'https://directory.atsign.wtf/';
        break;
      default:
        return '';
        break;
    }
  }
}

enum CustomContentStatus { Exists, Success, Fails }
enum CustomContentType { Text, Link, Number, Image, Youtube }

extension values on CustomContentType {
  String get name {
    switch (this) {
      case CustomContentType.Text:
        return 'Text';
        break;
      case CustomContentType.Link:
        return 'Link';
        break;
      case CustomContentType.Number:
        return 'Number';
        break;
      case CustomContentType.Image:
        return 'Image';
        break;
      case CustomContentType.Youtube:
        return 'Youtube';
        break;
      default:
        return '';
        break;
    }
  }

  String get label {
    if (this == CustomContentType.Youtube) {
      return 'YouTube';
    } else {
      return this.name;
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case CustomContentType.Link:
        return TextInputType.url;
        break;
      case CustomContentType.Youtube:
        return TextInputType.url;
        break;
      case CustomContentType.Number:
        return TextInputType.number;
        break;
      default:
        return TextInputType.text;
        break;
    }
  }
}

enum FollowType { notification, website }
