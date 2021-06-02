import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User {
  bool allPrivate;
  String atsign;
  BasicData image;
  BasicData firstname;
  BasicData lastname;
  BasicData phone;
  BasicData email;
  BasicData about;
  BasicData location;
  BasicData locationNickName;
  BasicData pronoun;
  BasicData twitter;
  BasicData facebook;
  BasicData linkedin;
  BasicData instagram;
  BasicData youtube;
  BasicData tumbler;
  BasicData medium;
  BasicData ps4;
  BasicData xbox;
  BasicData steam;
  BasicData discord;
  Map<String, List<BasicData>> customFields;

  User(
      {allPrivate,
      atsign,
      image,
      firstname,
      lastname,
      location,
      locationNickName,
      pronoun,
      phone,
      email,
      about,
      twitter,
      facebook,
      linkedin,
      instagram,
      youtube,
      tumbler,
      medium,
      ps4,
      xbox,
      steam,
      discord,
      customFields})
      : this.allPrivate = allPrivate,
        this.atsign = atsign,
        this.image = image ?? BasicData(),
        this.firstname = firstname ?? BasicData(),
        this.lastname = lastname ?? BasicData(),
        this.location = location ?? BasicData(),
        this.locationNickName = locationNickName ?? BasicData(),
        this.pronoun = pronoun ?? BasicData(),
        this.phone = phone ?? BasicData(),
        this.email = email ?? BasicData(),
        this.about = about ?? BasicData(),
        this.twitter = twitter ?? BasicData(),
        this.facebook = facebook ?? BasicData(),
        this.linkedin = linkedin ?? BasicData(),
        this.instagram = instagram ?? BasicData(),
        this.youtube = youtube ?? BasicData(),
        this.tumbler = tumbler ?? BasicData(),
        this.medium = medium ?? BasicData(),
        this.ps4 = ps4 ?? BasicData(),
        this.xbox = xbox ?? BasicData(),
        this.steam = steam ?? BasicData(),
        this.discord = discord ?? BasicData(),
        this.customFields = customFields ?? {};
}

class BasicData {
  var value;
  bool isPrivate = false;
  Icon icon;
  String accountName;
  var type;
  BasicData(
      {this.value,
      this.isPrivate = false,
      this.icon,
      this.accountName,
      this.type});
}
