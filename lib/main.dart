import 'package:flutter/material.dart';

import 'NoStream/Layout/drawing_page.dart';
import 'Stream/Layout/stream_drawing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isStream = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: drawing_page()
        // Scaffold(
        //   floatingActionButton: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     mini: true,
        //     onPressed: () {
        //       setState(() {
        //         isStream = !isStream;
        //       });
        //     },
        //     child: Icon(
        //       isStream ? Icons.view_stream : Icons.view_stream_outlined,
        //       color: Colors.black,
        //     ),
        //   ),
        //   body: isStream ? const stream_drawing_page() : const drawing_page(),
        // ),
        );
  }
}
