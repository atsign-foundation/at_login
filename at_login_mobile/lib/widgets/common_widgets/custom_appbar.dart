import 'package:at_login_mobile/services/at_services.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  ///appbar title
  final String title;

  ///displayes backarrow if sets to `true`. Defaults to `false`.
  final bool showBackButton;

  ///appbar will have curvedShape if sets to `true`. Defaults to `true`.
  final bool isRoundShape;

  ///List of actionitems in appbar.
  final List<Widget> actionItems;

  ///specifies customized leading widget of appbar. This takes priority over showBackButton if it is not null.
  final Widget leadingWidget;

  ///shows apptheme backgroundColor if sets to `true`. Defaults to `true`.
  final bool showBackgroundcolor;

  ///Displays title to the center of the appbar. Defaults to `false`.
  final bool isCenterTitle;
  CustomAppBar(
      {this.title,
      this.isRoundShape = true,
      this.isCenterTitle = false,
      this.showBackgroundcolor = true,
      this.showBackButton = false,
      this.actionItems,
      this.leadingWidget});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: showBackgroundcolor ? Brightness.dark : Brightness.light,
      backgroundColor: showBackgroundcolor ? AtTheme.themecolor : Colors.white,
      elevation: showBackgroundcolor ? 1.0 : 0.0,
      title: title != null
          ? Text('$title',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: showBackgroundcolor ? Colors.white : Colors.black))
          : null,
      centerTitle: isCenterTitle,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back,
                  color: showBackgroundcolor ? Colors.white : Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              })
          : leadingWidget,
      automaticallyImplyLeading: false,
      actions: actionItems,
      shape: isRoundShape
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)))
          : false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
