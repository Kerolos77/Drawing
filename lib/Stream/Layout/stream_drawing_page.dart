import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import '../Cubit/MainCubit.dart';
import '../Cubit/MainStates.dart';
import '../Logic/Sketcher.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../Logic/drawn_line.dart';

class stream_drawing_page extends StatefulWidget {
  const stream_drawing_page({Key? key}) : super(key: key);

  @override
  State<stream_drawing_page> createState() => _stream_drawing_pageState();
}

class _stream_drawing_pageState extends State<stream_drawing_page> {
  late MainCubit mainCub;
  final GlobalKey _globalKey = GlobalKey();
  final linesStreamController = StreamController<List<DrawnLine>>.broadcast();
  final currentLineStreamController = StreamController<DrawnLine>.broadcast();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => MainCubit(),
        child: BlocConsumer<MainCubit, MainStates>(
            listener: (BuildContext context, MainStates state) {},
            builder: (BuildContext context, MainStates state) {
              mainCub = MainCubit.get(context);

              // myCustomPainter = Sketcher(mainCub.path,mainCub.pain);
              return Scaffold(
                backgroundColor: mainCub.backgroundColor,
                body: SafeArea(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      buildAllPaths(context),
                      buildCurrentPath(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10,
                            clipBehavior: Clip.hardEdge,
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Stream',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          buildColorButton(mainCub.isFont
                              ? Colors.red
                              : Colors.red.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.orange
                              : Colors.orange.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.green
                              : Colors.green.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.lightGreen
                              : Colors.lightGreen.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.blue
                              : Colors.blue.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.lightBlue
                              : Colors.lightBlue.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.yellow
                              : Colors.yellow.shade100),
                          buildColorButton(mainCub.isFont
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade100),
                          buildColorButton(Colors.black),
                          buildColorButton(Colors.white),
                        ],
                      ),
                      Row(
                        children: [
                          buildToolButton(
                            const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                            () {
                              mainCub.setPath();
                            },
                          ),
                          buildToolButton(
                            const Icon(
                              Icons.restart_alt_outlined,
                              color: Colors.black,
                            ),
                            () {
                              mainCub.changeFontSize(2);
                              mainCub.changeFontColor(Colors.black);
                              mainCub.changeBackgroundColor(
                                  Colors.yellow.shade100);
                            },
                          ),
                          buildToolButton(
                            const Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            () {
                              save();
                            },
                          ),
                          buildStrokeButton(),
                          buildToolButton(
                            Icon(
                              mainCub.isFont
                                  ? Icons.font_download_outlined
                                  : Icons.font_download_off_outlined,
                              color: Colors.black,
                            ),
                            () {
                              mainCub.changeFont(!mainCub.isFont);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  @override
  void dispose() {
    linesStreamController.close();
    currentLineStreamController.close();
    super.dispose();
  }

  GestureDetector buildCurrentPath(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: RepaintBoundary(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<DrawnLine>(
            stream: currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: Sketcher(
                  lines: [mainCub.line],
                ),
              );
            },
          ),
          // CustomPaint widget will go here
        ),
      ),
    );
  }

  Widget buildAllPaths(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<DrawnLine>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: Sketcher(
                lines: mainCub.lines,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildColorButton(Color color) {
    return FloatingActionButton(
        mini: true,
        elevation: 10,
        backgroundColor: color,
        onPressed: () {
          if (mainCub.isFont) {
            mainCub.changeFontColor(color);
          } else {
            mainCub.changeBackgroundColor(color);
          }
        });
  }

  Widget buildToolButton(Icon icon, VoidCallback function) {
    return FloatingActionButton(
      mini: true,
      elevation: 10,
      backgroundColor: Colors.white,
      onPressed: function,
      child: icon,
    );
  }

  Widget buildStrokeButton() {
    return Stack(
      children: [
        buildToolButton(
          const Icon(
            Icons.text_increase,
            color: Colors.black,
          ),
          () {
            if (mainCub.fontSize >= 20) {
              mainCub.changeFontSize(2);
            } else {
              mainCub.changeFontSize(mainCub.fontSize + 2);
            }
          },
        ),
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.white,
          child: Text(
            '${mainCub.fontSize.toInt()}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    mainCub.changeLine(DrawnLine([point], mainCub.fontColor, mainCub.fontSize));
    currentLineStreamController.add(mainCub.line);
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final path = List.from(mainCub.line.path)..add(point);
    mainCub.changeLine(DrawnLine(path, mainCub.fontColor, mainCub.fontSize));
    mainCub.addLine();
    currentLineStreamController.add(mainCub.line);
  }

  void onPanEnd(DragEndDetails details) {
    mainCub.resetLines(List.from(mainCub.lines)..add(mainCub.line));
    linesStreamController.add(mainCub.lines);
  }

  Future<void> save() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final saved = await ImageGallerySaver.saveImage(
        pngBytes!,
        quality: 100,
        name: "${DateTime.now().toIso8601String()}.png",
        isReturnImagePathOfIOS: true,
      );
    } catch (e) {
      print(e);
    }
  }
}
