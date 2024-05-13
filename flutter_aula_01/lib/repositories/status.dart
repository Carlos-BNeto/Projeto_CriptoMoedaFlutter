import 'package:flutter/material.dart';
enum Status{
  initial, loading, error, sucess,
}
abstract class BaseStatus with ChangeNotifier {
  Status _status = Status.initial;
void setStatus(Status status){
  _status = status;
  notifyListeners();
}

bool get isInitial => _status == Status.initial;
bool get isLoanding => _status == Status.loading;
bool get isError => _status == Status.error;
bool get isSucess => _status == Status.sucess;
Status get nowStatus => _status;
}
