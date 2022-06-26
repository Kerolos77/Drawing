import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Logic/drawn_line.dart';
import 'MainStates.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitialMainStates());

  static MainCubit get(context) => BlocProvider.of(context);

  Color fontColor = Colors.black;
  Color backgroundColor = Colors.yellow.shade100;
  bool isFont = true;
  double fontSize = 2;
  Path path = Path();
  Paint pain = Paint();
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine line = DrawnLine(<Offset>[], Colors.black, 2.0);

  void changeFontColor(Color color) {
    fontColor = color;
    emit(ChangeFontColorStates());
  }

  void changeBackgroundColor(Color color) {
    backgroundColor = color;
    emit(ChangeBackgroundColorStates());
  }

  void changeFont(bool isFont) {
    this.isFont = isFont;
    emit(ChangeFontStates());
  }

  void changeFontSize(double fontSize) {
    this.fontSize = fontSize;
    emit(ChangeFontSizeStates());
  }

  void setPath() {
    lines = [];
    line = DrawnLine(<Offset>[], Colors.black, 2.0);
    emit(SetPathStates());
  }

  void changeLine(DrawnLine line) {
    this.line = line;
    emit(ChangeLineStates());
  }

  void addLine() {
    lines.add(line);
    if (lines.isEmpty) {
      lines.add(line);
    } else {
      lines[lines.length - 1] = line;
    }
    emit(AddLineStates());
  }

  void resetLines(List<DrawnLine> lines) {
    this.lines = lines;
    emit(ResetLinesStates());
  }
}
