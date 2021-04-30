import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class ControllerState {}

class CtrlFirstState extends ControllerState {}

class CtrlIndexState extends ControllerState {
  int sectionIndex;
  CtrlIndexState({required this.sectionIndex}) : assert(sectionIndex != null);
}
