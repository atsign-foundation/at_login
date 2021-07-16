import 'package:at_login_mobile/services/at_enum.dart';
import 'package:at_login_mobile/services/at_services.dart';

final String keyExtension = '.me';

final String image = FieldsEnum.IMAGE.name + keyExtension;
final String firstname = FieldsEnum.FIRSTNAME.name + keyExtension;
final String lastname = FieldsEnum.LASTNAME.name + keyExtension;
final String email = FieldsEnum.EMAIL.name + keyExtension;
final String phone = FieldsEnum.PHONE.name + keyExtension;
final String about = FieldsEnum.ABOUT.name + keyExtension;
final String location = FieldsEnum.LOCATION.name + keyExtension;
final String locationNickName = FieldsEnum.LOCATIONNICKNAME.name + keyExtension;
final String pronoun = FieldsEnum.PRONOUN.name + keyExtension;
final String twitter = FieldsEnum.TWITTER.name + keyExtension;
final String instagram = FieldsEnum.INSTAGRAM.name + keyExtension;
final String youtube = FieldsEnum.YOUTUBE.name + keyExtension;
final String tumbler = FieldsEnum.TUMBLR.name + keyExtension;
final String medium = FieldsEnum.MEDIUM.name + keyExtension;
final String facebook = FieldsEnum.FACEBOOK.name + keyExtension;
final String linkedIn = FieldsEnum.LINKEDIN.name + keyExtension;
final String ps4 = FieldsEnum.PS4.name + keyExtension;
final String xbox = FieldsEnum.XBOX.name + keyExtension;
final String steam = FieldsEnum.STEAM.name + keyExtension;
final String discord = FieldsEnum.DISCORD.name + keyExtension;

Map<String, dynamic> _toMap() {
  return {
    FieldsEnum.IMAGE.name: image,
    FieldsEnum.FIRSTNAME.name: firstname,
    FieldsEnum.LASTNAME.name: lastname,
    FieldsEnum.EMAIL.name: email,
    FieldsEnum.PHONE.name: phone,
    FieldsEnum.ABOUT.name: about,
    FieldsEnum.PRONOUN.name: pronoun,
    FieldsEnum.LOCATION.name: location,
    FieldsEnum.LOCATIONNICKNAME.name: locationNickName,
    FieldsEnum.TWITTER.name: twitter,
    FieldsEnum.INSTAGRAM.name: instagram,
    FieldsEnum.YOUTUBE.name: youtube,
    FieldsEnum.TUMBLR.name: tumbler,
    FieldsEnum.MEDIUM.name: medium,
    FieldsEnum.FACEBOOK.name: facebook,
    FieldsEnum.LINKEDIN.name: linkedIn,
    FieldsEnum.PS4.name: ps4,
    FieldsEnum.XBOX.name: xbox,
    FieldsEnum.STEAM.name: steam,
    FieldsEnum.DISCORD.name: discord
  };
}

dynamic get(String propertyName) {
  String property = propertyName.toLowerCase();

  var _mapRep = _toMap();
  if (_mapRep.containsKey(property)) {
    return _mapRep[property];
  }
  throw ArgumentError('propery not found');
}
