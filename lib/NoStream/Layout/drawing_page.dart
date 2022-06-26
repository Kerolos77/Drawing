import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import '../Cubit/MainCubit.dart';
import '../Cubit/MainStates.dart';
import '../Logic/Sketcher.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class drawing_page extends StatefulWidget {
  const drawing_page({Key? key}) : super(key: key);

  @override
  State<drawing_page> createState() => _drawing_pageState();
}

class _drawing_pageState extends State<drawing_page> {
  late MainCubit mainCub;
  late Sketcher myCustomPainter;
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => MainCubit(),
        child: BlocConsumer<MainCubit, MainStates>(
            listener: (BuildContext context, MainStates state) {},
            builder: (BuildContext context, MainStates state) {
              mainCub = MainCubit.get(context);
              mainCub.pain
                ..color = mainCub.fontColor
                ..strokeWidth = mainCub.fontSize
                ..style = PaintingStyle.stroke;
              myCustomPainter = Sketcher(mainCub.path, mainCub.pain);
              return Scaffold(
                // backgroundColor: mainCub.backgroundColor,
                body: SafeArea(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
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
                                'NoStream',
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
                          Stack(
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
                                    mainCub
                                        .changeFontSize(mainCub.fontSize + 2);
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
                          ),
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

  GestureDetector buildCurrentPath(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: mainCub.backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: myCustomPainter,
          ),
        ),
      ),
      // CustomPaint widget will go her
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
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: mainCub.fontColor,
        radius: 10,
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    mainCub.movePath(point.dx, point.dy);
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    mainCub.addPath(point.dx, point.dy);
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {});
  }

  Future<void> save() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
          as FutureOr<ByteData?>);
      final pngBytes = byteData?.buffer.asUint8List();

      final saved = await ImageGallerySaver.saveImage(
        pngBytes!,
        quality: 100,
        name: "${DateTime.now().toIso8601String()}.png",
        isReturnImagePathOfIOS: true,
      );
      _toastInfo("Image saved Successfully in gallery");
    } catch (e) {
      print("Error: $e");
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
