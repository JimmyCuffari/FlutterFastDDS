// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;

import "package:ffi/ffi.dart";

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_application_1/main.dart';
import 'package:path/path.dart' as path;

// FFI signature of the hello_world C function
typedef AddUserFunc = ffi.Void Function();
// Dart type definition for calling the C foreign function
typedef CppAddUser = void Function();

// FFI signature of the hello_world C function
typedef CreatePubFunc = ffi.Void Function(Pointer<Utf8>);
// Dart type definition for calling the C foreign function
typedef CreatePub = void Function(Pointer<Utf8>);

typedef KillThreadsFunc = ffi.Void Function();
typedef KillThreads = void Function();

typedef SetSendMessageFunc = ffi.Void Function(Pointer<Utf8>, Pointer<Utf8>);
typedef SetSendMessage = void Function(Pointer<Utf8>, Pointer<Utf8>);

typedef SetCurrTabFunc = ffi.Void Function(Pointer<Utf8>);
typedef SetCurrTab = void Function(Pointer<Utf8>);

var libraryPath = path.join(
    Directory.current.path, 'lib', 'build', 'Debug', 'FastDDSUser.dll');

//path.join(
//  Directory.current.path, 'lib', 'hello_library', 'libhello_library.dll');

final dylib = ffi.DynamicLibrary.open(libraryPath);

final CppAddUser addUser =
    dylib.lookup<ffi.NativeFunction<AddUserFunc>>('addUser').asFunction();

final CreatePub createPub = dylib
    .lookup<ffi.NativeFunction<CreatePubFunc>>('createPublisher')
    .asFunction();

final KillThreads killThreads =
    dylib.lookup<ffi.NativeFunction<AddUserFunc>>('killThreads').asFunction();

final SetSendMessage setSendMessage =
    dylib.lookup<ffi.NativeFunction<SetSendMessageFunc>>('setSendMessage').asFunction();

final SetCurrTab setCurrTab =
    dylib.lookup<ffi.NativeFunction<SetCurrTabFunc>>('setCurrTab').asFunction();

var pubs = {};

/*
// Look up the C function 'hello_world'
final HelloWorld hello = dylib
    .lookup<ffi.NativeFunction<HelloWorldFunc>>('hello_world')
    .asFunction();

/*/////////////////////////////////////////
  final returnHello hi = dylib
      .lookup<ffi.NativeFunction<returnHelloFunc>>('returnHello')
      .asFunction();
  // Call the function
  */

final Pointer<Utf8> Function() hi = dylib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>('returnHello')
    .asFunction();
String getString() => hi().toDartString();

final int Function() num =
    dylib.lookup<NativeFunction<Int64 Function()>>('returnX').asFunction();
int retnum() => num().toInt();
*/ /////////////////////////

void main() {
  // Open the dynamic library
/*  var libraryPath =
      path.join(Directory.current.path, 'hello_library', 'libhello.so');

  if (Platform.isMacOS) {
    libraryPath =
        path.join(Directory.current.path, 'hello_library', 'libhello.dylib');
  }

  if (Platform.isWindows) {
    libraryPath = path.join(
        Directory.current.path, 'lib', 'hello_library', 'libhello.dll');
  }

  final dylib = ffi.DynamicLibrary.open(libraryPath);


  // Look up the C function 'hello_world'
  final HelloWorld hello = dylib
      .lookup<ffi.NativeFunction<HelloWorldFunc>>('hello_world')
      .asFunction();

    final returnHello hi = dylib
      .lookup<ffi.NativeFunction<returnHelloFunc>>('returnHello')
      .asFunction();
  // Call the function
*/

  //hello();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 59, 59, 59),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 101, 146, 182)),

        ///const Color.fromARGB(255, 101, 146, 182)
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  final userController = TextEditingController();
  String message = "";

  List<Widget> users = <Widget>[
    Row(children: [
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Image(
              image: AssetImage('assets/ASRCTransparent.png'),
              width: 30,
              height: 30)),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(
              textAlign: TextAlign.center,
              "General",
              style: TextStyle(color: Color.fromARGB(255, 229, 229, 229))))
    ])
  ];

  List<bool> _selectedUsers = [true]; //for toggle button

  List usernameList = ["General"]; //for the user being selected

  var userMessages = Map<String, List<Widget>>();

  int selectedUser = 0;

  @override
  initState() {
    userMessages["General"] = <Widget>[];

    var tempStr = "General";
    setCurrTab(tempStr.toNativeUtf8()); // Sets initial tab to General
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    userController.dispose();

    super.dispose();
  }

/*

  var other_message = Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 116, 116, 116)),
        padding: EdgeInsets.all(10),
        child: Text("Nice"),
      ));
*/

  List<Widget> message_list = <Widget>[
    //self_message
  ];

  List<Widget> tempList = <Widget>[
    //self_message
  ];

  void _blank() {}

/*
  var user = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FloatingActionButton(
        splashColor: Colors.transparent,
        hoverColor: const Color.fromARGB(255, 27, 27, 27),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        onPressed: _blank,
        child: Container(
          alignment: Alignment.centerLeft,
          //color: Color.fromARGB(255, 36, 36, 36),
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
          child: const Text(
            textAlign: TextAlign.left,
            "USER 1",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229)),
          ),
        ),
      ));
*/

  void _addUser() {
    if (userController.text.trim() != "" &&
        !usernameList.contains(userController.text)) {
      String newUser = userController.text;
      userController.text = "";

      createPub(newUser.toNativeUtf8()); // To add user to topics

      userMessages[newUser] = <Widget>[];

      setState(() {
        _selectedUsers.add(false);
        usernameList.add(newUser);
        users.add(Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image(
                  image: AssetImage('assets/pic1.png'), width: 30, height: 30)),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                  textAlign: TextAlign.center,
                  newUser,
                  style: TextStyle(color: Color.fromARGB(255, 229, 229, 229))))
        ]));
      });
    }

    /*else {
      message = textController.text;
      textController.text = "";

      setState(() {
        message_list = [
          Container(
              key: UniqueKey(),
              padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 116, 116, 116)),
                padding: EdgeInsets.all(10),
                child: Container(child: Text(message)),
              )),
          ...message_list,
        ];
      });
    }*/
  }

  void _updateText() {
    //  killThreads();
    if (textController.text != "") {
      message = textController.text;
      textController.text = "";

      // Sends Message to Publisher
      final sendMessage = message.toNativeUtf8();
      final sendUsername = usernameList[selectedUser].toString().toNativeUtf8();
      setSendMessage(sendUsername, sendMessage);

      setState(() {
        message_list = [
          Container(
              key: UniqueKey(),
              padding: EdgeInsets.fromLTRB(60, 0, 10, 5),
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 101, 146, 182)),
                padding: EdgeInsets.all(10),
                child: Container(child: Text(message)),
              )),
          ...message_list,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      /*appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Container(
                color: const Color.fromARGB(255, 31, 31, 31), //
                width: 260,
                child: Column(children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Container(
                            color: const Color.fromARGB(255, 36, 36, 36),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 190,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 10, 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color.fromARGB(
                                                255, 117, 117, 117)),
                                        child: TextFormField(
                                          cursorColor: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 11,
                                                  top: 11,
                                                  right: 15),
                                              hintText: "+ Add User",
                                              hintStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      143, 0, 0, 0))),
                                          onEditingComplete: _addUser,
                                          controller: userController,
                                        ),
                                      )),
                                  /*Container(
                                    padding: EdgeInsets.fromLTRB(0, 15, 60, 15),
                                    child: FloatingActionButton.extended(
                                      label: Text("Add User"),
                                      backgroundColor: const Color.fromARGB(
                                          255, 117, 117, 117),
                                      onPressed: _blank,
                                      icon: const Icon(Icons.add),
                                    )),*/
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: FloatingActionButton(
                                        foregroundColor:
                                            Color.fromARGB(255, 36, 36, 36),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        backgroundColor: const Color.fromARGB(
                                            255, 117, 117, 117),
                                        onPressed: _blank,
                                        child: const Icon(Icons.settings),
                                      )),
                                ])),
                        Expanded(
                            child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: ToggleButtons(
                                disabledColor: Color.fromARGB(255, 36, 36, 36),
                                fillColor: Color.fromARGB(255, 50, 50, 50),
                                selectedBorderColor:
                                    Color.fromARGB(255, 50, 50, 50),
                                direction: Axis.vertical,
                                isSelected: _selectedUsers,
                                children: users,
                                onPressed: (int index) {
                                  setState(() {
                                    userMessages[usernameList[selectedUser]] =
                                        message_list;
                                    selectedUser = index;
                                    var strUser = usernameList[index].toString();
                                    setCurrTab(strUser.toNativeUtf8());
                                    //setCurrTab(usernameList[index].toNativeUtf8());
                                    //print(index);
                                    for (int buttonIndex = 0;
                                        buttonIndex < _selectedUsers.length;
                                        buttonIndex++) {
                                      if (buttonIndex == index) {
                                        _selectedUsers[buttonIndex] = true;
                                      } else {
                                        _selectedUsers[buttonIndex] = false;
                                      }
                                    }

                                    message_list = userMessages[
                                        usernameList[selectedUser]]!;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                      ]))
                ])),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 50, 50, 50),
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    usernameList[selectedUser],
                    style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 25),
                  ),
                ),
                Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        children: message_list

                        /*     
                        [
                      /*   //  Container(
                      //alignment: Alignment.centerRight,
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 101, 146, 182)),
                            constraints: const BoxConstraints(
                                maxWidth: 250, minWidth: 0),
                            padding: EdgeInsets.all(10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("ewewenew")),
                          )),
                 */
                      self_message,
                      other_message,
                      self_message,
                    ]
                  */

                        )),
                /*     Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 101, 146, 182)),
                      padding: EdgeInsets.all(10),
                      child: Text("Nice"),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 116, 116, 116)),
                      padding: EdgeInsets.all(10),
                      child: Text("Nice"),
                    )), */
                Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 72, 72, 72)),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Start Typing...",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(70, 255, 255, 255))),
                        onEditingComplete: _updateText,
                        controller: textController,
                      ),
                    ))
              ],
            ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
