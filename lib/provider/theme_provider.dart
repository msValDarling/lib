import 'package:flutter/material.dart';
import 'package:pmsna/settings/styles_settings.dart';

class Theme_provider with ChangeNotifier {
  //BuildContext context;
  ThemeData? _themeData;
  Theme_provider(BuildContext context) {
    _themeData = StyleSettings.lightTheme(context);
  }
  getthemeData() => this._themeData;
  setthemeData(ThemeData theme) {
    this._themeData = theme;
    notifyListeners();
  }
}
