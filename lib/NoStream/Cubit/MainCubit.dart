import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    path.reset();
    emit(SetPathStates());
  }

  void addPath(double x, double y) {
    path.lineTo(x, y);
    emit(AddPathStates());
  }

  void movePath(double x, double y) {
    path.moveTo(x, y);
    emit(MovePathStates());
  }
}
