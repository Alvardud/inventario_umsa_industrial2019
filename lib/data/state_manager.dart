import 'package:flutter/foundation.dart';

class StateManager with ChangeNotifier{
  int _pickerMenu = 0;

  int get statePickerMenu => _pickerMenu;

  set statePickerMenu(int value){
    _pickerMenu = value;
    notifyListeners();
  }
}