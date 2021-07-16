import 'package:flutter/material.dart';

class BasicProvider extends ChangeNotifier {
  PageState pageState;

  setPageState(PageState state) {
    this.pageState = state;
    notifyListeners();
  }
}

enum PageState { loading, error, done }
