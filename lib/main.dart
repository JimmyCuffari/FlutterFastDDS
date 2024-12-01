// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:io' show Directory, Platform, exit, sleep;
import 'dart:isolate';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import "package:ffi/ffi.dart";
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

typedef ReceiveDartFunc = ffi.Void Function(Pointer<Utf8>);
typedef ReceiveDart = void Function(Pointer<Utf8>);

typedef SetDartReceiveCallbackFunc = ffi.Void Function(
    Pointer<NativeFunction<Void Function(Pointer<Utf8>)>>);
typedef SetDartReceiveCallback = void Function(
    Pointer<NativeFunction<Void Function(Pointer<Utf8>)>>);

typedef DartRemoveUserFunc = ffi.Void Function(Int32);
typedef DartRemoveUser = void Function(int);

typedef SetUserFunc = ffi.Void Function(Pointer<Utf8>);
typedef SetUser = void Function(Pointer<Utf8>);

typedef GetCurrentUserStatusFunc = ffi.Bool Function(Int32);
typedef GetCurrentUserStatus = bool Function(int);

/*typedef SetDartReceivePortFunc = ffi.Void Function(Pointer<NativeType>);
typedef SetDartReceivePort = void Function(Pointer<NativeType>);*/

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

final SetSendMessage setSendMessage = dylib
    .lookup<ffi.NativeFunction<SetSendMessageFunc>>('setSendMessage')
    .asFunction();

final SetCurrTab setCurrTab =
    dylib.lookup<ffi.NativeFunction<SetCurrTabFunc>>('setCurrTab').asFunction();

final ReceiveDart receiveDart = dylib
    .lookup<ffi.NativeFunction<ReceiveDartFunc>>('receiveDart')
    .asFunction();

final SetDartReceiveCallback setDartReceiveCallback = dylib
    .lookup<ffi.NativeFunction<SetDartReceiveCallbackFunc>>(
        'setDartReceiveCallback')
    .asFunction();

final DartRemoveUser dartRemoveUser = dylib
    .lookup<ffi.NativeFunction<DartRemoveUserFunc>>('dartRemoveUser')
    .asFunction();

final SetUser _setUser =
    dylib.lookup<ffi.NativeFunction<SetUserFunc>>('setUsername').asFunction();
/*final SetDartReceivePort setDartReceivePort =
    dylib.lookup<ffi.NativeFunction<SetDartReceivePortFunc>>('setDartReceivePort').asFunction();*/

//test
typedef CallbackNativeType = Void Function(Pointer<Utf8>);
//typedef CallbackNativeTypeFunc = ffi.Void Function(Pointer<Utf8>);

typedef CallbackNativeTypeFunction = void Function(Pointer<Utf8>);
typedef CallbackNativeTypeNativeFunction = Void Function(Pointer<Utf8>);

final CallbackNativeTypeFunction callbackNativeType = dylib
    .lookup<ffi.NativeFunction<CallbackNativeTypeNativeFunction>>(
        'callbackNativeType')
    .asFunction();

final GetCurrentUserStatus getCurrentUserStatus = dylib
    .lookup<ffi.NativeFunction<GetCurrentUserStatusFunc>>(
        'getCurrentUserStatus')
    .asFunction();

var pubs = {};

void _onMessageReceived(Pointer<Utf8> message) {
  final dartMessage = message.toDartString();
  print("Message received from C++: $dartMessage");
}

List<Color> Theme = [
  Color.fromARGB(255, 59, 59, 59), //primary
  Color.fromARGB(255, 31, 31, 31), //secondary
  Color.fromARGB(255, 117, 117, 117), //buttons
  Color.fromARGB(255, 101, 146, 182), //usermessage
  Color.fromARGB(255, 116, 116, 116) //othermessage
];

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

/*void isolateReceive(SendPort sendPort) {
  final port = ReceivePort();
  sendPort.send(port.sendPort);

  port.listen((message) {
    print("Received message from c++: $message");
  });
}*/

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

 */

  runApp(const MyApp());

  doWhenWindowReady(() {
    var initialSize = ui.Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.minSize = ui.Size(600, 450);
    appWindow.show();
  });
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
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 59, 59, 59)),

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
  State<MyHomePage> createState() => _LogInPageState();
}

class WindowButtons extends StatelessWidget {
  var buttonColors = WindowButtonColors(
    iconNormal: Colors.white,
    iconMouseDown: const Color.fromARGB(46, 255, 255, 255),
    mouseDown: const Color.fromARGB(46, 255, 255, 255),
    mouseOver: const Color.fromARGB(46, 255, 255, 255),
    iconMouseOver: const Color.fromARGB(46, 255, 255, 255),
  );

  void _killThreads() {
    killThreads();
    appWindow.close();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: buttonColors,
          onPressed: _killThreads,
        )
      ],
    );
  }
}

class _LogInPageState extends State<MyHomePage> {
  TextEditingController usernameController = TextEditingController();

  void _loadNext() {
    if (usernameController.text.length > 2)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _ChatPage()),
      );
  }

  void _checks() {
    if (usernameController.text.length > 32) {
      usernameController.text = usernameController.text.substring(0, 32);
    }
    usernameController.text = usernameController.text.trim();
    _setUser(usernameController.text.toNativeUtf8());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.values[0],
          children: [
            Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 31, 31, 31),
                  width: double.infinity,
                  height: 30,
                ),
                WindowTitleBarBox(
                  child: Row(
                    children: [Expanded(child: MoveWindow()), WindowButtons()],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 525,
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 72, 72, 72)),
                        child: TextFormField(
                          textAlign: TextAlign.center,
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
                          onChanged: (text) {
                            _checks();
                          },
                          onEditingComplete: _loadNext,
                          //onEditingComplete: _updateText,
                          controller: usernameController,
                        ),
                      )),
                  Container(
                      // color: Color.fromARGB(255, 72, 72, 72),
                      padding: EdgeInsets.all(10),
                      height: 50,
                      width: 100,
                      child: FloatingActionButton(
                        backgroundColor: Color.fromARGB(255, 117, 117, 117),
                        child: const Text('Log In'),
                        onPressed: () {
                          _loadNext();
                        },
                      ))
                ],
              ),
            )
          ],
        ))
      ])),
    );
  }
}

class _ChatPage extends StatefulWidget {
  @override
  State<_ChatPage> createState() => _MyHomePageState();
}

//colors for backgrounds be different themes
//fonts predetermined, have a drop-down
//font colors be sepera

class _MyHomePageState extends State<_ChatPage> {
  var deleteUserBtn = null;
  var chatText = null;
  final textController = TextEditingController();
  final userController = TextEditingController();
  String message = "";

  List profilePictures = [AssetImage('assets/ASRCTransparent.png')];

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
              "Notes",
              style: TextStyle(color: Color.fromARGB(255, 229, 229, 229))))
    ])
  ];

  List<bool> _selectedUsers = [true]; //for toggle button

  List usernameList = ["Notes"]; //for the user being selected

  var userMessages = Map<String, List<Widget>>();

  int selectedUser = 0;

  @override
  initState() {
    userMessages["Notes"] = <Widget>[];

    var tempStr = "Notes";
    setCurrTab(tempStr.toNativeUtf8()); // Sets initial tab to General

    final callback =
        NativeCallable<CallbackNativeType>.listener(callbackFunction);
    setDartReceiveCallback(callback.nativeFunction);

    /*final callbackPointer = Pointer.fromFunction<Void Function(Pointer<Utf8>)>(callbackFunction);
    setDartReceiveCallback(callbackPointer);*/

    /*final receivePort = ReceivePort();
    Isolate.spawn(isolateReceive, receivePort.sendPort);

    receivePort.listen((sendPort) {
      final isolatePort = sendPort as SendPort;
      final message = "Hello from C++";

      isolatePort.send(message);
    });

    final receivePortPointer = Pointer.fromAddress(receivePort.hashCode);
    setDartReceivePort(receivePortPointer);*/
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    userController.dispose();

    super.dispose();
  }

  List<Widget> message_list = <Widget>[
    //self_message
  ];

  List<Widget> tempList = <Widget>[
    //self_message
  ];

  void _blank() {}

  void _loadNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _SettingsPage()),
    ).then((_) => setState(() {}));
  }

  void _checks() {
    if (userController.text.length > 32) {
      userController.text = userController.text.substring(0, 32);
    }
    userController.text = userController.text.trim();
    //_setUser(userController.text.toNativeUtf8());
  }

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
        profilePictures.add(AssetImage('assets/pic1.png'));

        users.add(
          Row(children: [
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Image(
                    image: profilePictures[usernameList.indexOf(newUser)],
                    width: 30,
                    height: 30)),
            Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    newUser,
                    style:
                        TextStyle(color: Color.fromARGB(255, 229, 229, 229))))
          ]),
        );
      });
    }
  }

  void _removeUser() {
    // Sends index to backend
    dartRemoveUser(selectedUser);

    _selectedUsers[selectedUser] = false;

    _selectedUsers[0] = true;

    setState(() {
      users.remove(users[selectedUser]);
      _selectedUsers.remove(_selectedUsers[selectedUser]);
      usernameList.remove(usernameList[selectedUser]);
      profilePictures.remove(usernameList[selectedUser]);
      selectedUser = 0;
      if (selectedUser == 0) {
        deleteUserBtn = null;
      } else {
        deleteUserBtn = IconButton(
            alignment: Alignment.centerRight,
            color: Colors.grey,
            onPressed: _removeUser,
            icon: Icon(Icons.person_remove));
      }
      message_list = userMessages[usernameList[selectedUser]]!;
    });
  }

  void _updateText() {
    //user sending text
    //  killThreads();
    if (textController.text != "") {
      message = textController.text;
      textController.text = "";

////////////////////////////////////////////////////////////////////////////////
      //     bool status = getCurrentUserStatus(selectedUser);
      //     print("Current Status of user selected: $status");
////////////////////////////////////////////////////////////////////////////////

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
                    borderRadius: BorderRadius.circular(10), color: Theme[3]),
                padding: EdgeInsets.all(10),
                child: Container(
                    child: Text(
                  message,
                  style: TextStyle(
                      color: Theme[4].computeLuminance() < 0.5
                          ? Colors.white.withAlpha(200)
                          : Colors.black.withAlpha(200)),
                )),
              )),
          ...message_list,
        ];
      });
    }
  }

  void callbackFunction(Pointer<Utf8> message) {
    String msg = message.toDartString();
    print(msg);

    _updateTextReceive(msg);
  }

  void _saveChat() {}

  // for updating messages when received
  void _updateTextReceive(String message) {
    setState(() {
      message_list = [
        Container(
            key: UniqueKey(),
            padding: EdgeInsets.fromLTRB(10, 0, 60, 5),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Theme[4]),
              padding: EdgeInsets.all(10),
              child: Container(child: Text(message)),
            )),
        ...message_list,
      ];
    });
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
                color: Theme[1], //
                width: 260,
                child: Column(children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 31, 31, 31),
                              width: double.infinity,
                              height: 30,
                            ),
                            WindowTitleBarBox(
                              child: Row(
                                children: [
                                  Expanded(child: MoveWindow()),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            color: Theme[1],
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
                                            color: Theme[2]),
                                        child: TextFormField(
                                          cursorColor:
                                              Theme[3].computeLuminance() < 0.5
                                                  ? Colors.white.withAlpha(200)
                                                  : Colors.black.withAlpha(200),
                                          style: TextStyle(
                                              color: Theme[3]
                                                          .computeLuminance() <
                                                      0.5
                                                  ? Colors.white.withAlpha(200)
                                                  : Colors.black
                                                      .withAlpha(200)),
                                          decoration: InputDecoration(
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
                                                  color:
                                                      Theme[3].computeLuminance() <
                                                              0.5
                                                          ? Colors.white
                                                              .withAlpha(200)
                                                          : Colors.black
                                                              .withAlpha(200))),
                                          onEditingComplete: _addUser,
                                          onChanged: (text) {
                                            _checks();
                                          },
                                          controller: userController,
                                        ),
                                      )),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: FloatingActionButton(
                                        foregroundColor:
                                            Color.fromARGB(255, 36, 36, 36),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        backgroundColor: Theme[2],
                                        onPressed: _loadNext,
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
                                disabledColor: Theme[1],
                                disabledBorderColor: Theme[1],
                                fillColor: Theme[0].withAlpha(
                                    200), //Color.fromARGB(255, 50, 50, 50),
                                //selectedBorderColor: Theme[0].withAlpha(200),
                                direction: Axis.vertical,
                                isSelected: _selectedUsers,
                                children: users,
                                onPressed: (int index) {
                                  setState(() {
                                    userMessages[usernameList[selectedUser]] =
                                        message_list;
                                    selectedUser = index;
                                    var strUser =
                                        usernameList[index].toString();
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
                                    if (selectedUser == 0) {
                                      deleteUserBtn = null;
                                    } else {
                                      deleteUserBtn = IconButton(
                                          alignment: Alignment.centerRight,
                                          color: Theme[2],
                                          onPressed: _removeUser,
                                          icon: Icon(Icons.person_remove));
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
                child: Container(
                    color: Theme[0],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 31, 31, 31),
                              width: double.infinity,
                              height: 30,
                            ),
                            WindowTitleBarBox(
                              child: Row(
                                children: [
                                  Expanded(child: MoveWindow()),
                                  WindowButtons()
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            height: 50,
                            width: double.infinity,
                            color: Theme[1].withAlpha(50),
                            child: Row(
                                //mainAxisAlignment: MainAxisAlignment.values[3],
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width - 480,
                                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      usernameList[selectedUser],
                                      style: TextStyle(
                                          color:
                                              Theme[0].computeLuminance() < 0.5
                                                  ? Colors.white.withAlpha(200)
                                                  : Colors.black.withAlpha(200),
                                          fontSize: 25),
                                    ),
                                  ),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.values[1],
                                    children: [
                                      Container(
                                          // color: Color.fromARGB(255, 72, 72, 72),
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 10),
                                          height: 50,
                                          width: 140,
                                          child: FloatingActionButton(
                                            backgroundColor: Theme[2],
                                            foregroundColor: Theme[3]
                                                        .computeLuminance() <
                                                    0.5
                                                ? Colors.white.withAlpha(200)
                                                : Colors.black.withAlpha(200),
                                            child: const Text("Save User Chat"),
                                            onPressed: () {
                                              _saveChat();
                                            },
                                          )),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 30, 0),
                                        alignment: Alignment.centerRight,
                                        child: deleteUserBtn,
                                      ),
                                    ],
                                  ))
                                ])),
                        Expanded(
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                children: message_list)),
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme[2].withAlpha(
                                      200)), //const Color.fromARGB(255, 72, 72, 72)),
                              child: TextFormField(
                                cursorColor: Theme[2].computeLuminance() < 0.5
                                    ? Colors.white
                                    : Colors.black,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Start Typing...",
                                  hintStyle: TextStyle(
                                      color: Theme[2].computeLuminance() < 0.5
                                          ? Colors.white.withAlpha(200)
                                          : Colors.black.withAlpha(200)),
                                ),
                                // Color.fromARGB(70, 255, 255, 255))),
                                //onEditingComplete: _updateText,
                                onEditingComplete: _updateText,
                                controller: textController,
                              ),
                            ))
                      ],
                    )))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _SettingsPage extends StatefulWidget {
  @override
  State<_SettingsPage> createState() => SettingsPage();
}

class SettingsPage extends State<_SettingsPage> {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  var _isSelected;

  List<Widget> options = [
    Container(
        width: 260,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            "Primary Color",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229)))),
    Container(
        width: 260,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            "Secondary Color",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229)))),
    Container(
        width: 260,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            "Button Color",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229)))),
    Container(
        width: 260,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            "Self Message Color",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229)))),
    Container(
        width: 260,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            "Other Message Color",
            style: TextStyle(color: Color.fromARGB(255, 229, 229, 229))))
  ];

  List<bool> optionsButtons = [true, false, false, false, false];

  List<Widget> ColorWheels = [];

  late var pickerColor = Theme[0];

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    setState(() {
      if (optionsButtons[0] == true)
        Theme[0] = color;
      else if (optionsButtons[1] == true)
        Theme[1] = color;
      else if (optionsButtons[2] == true)
        Theme[2] = color;
      else if (optionsButtons[3] == true)
        Theme[3] = color;
      else if (optionsButtons[4] == true) Theme[4] = color;
    });
  }

  void _goBack() {
    Navigator.pop(context);
  }

  // Theme.of(context).colorScheme.primary,

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                color: Theme[1], //
                width: 260,
                child: Expanded(
                    child: Column(children: [
                  Stack(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 31, 31, 31),
                        width: double.infinity,
                        height: 30,
                      ),
                      WindowTitleBarBox(
                        child: Row(
                          children: [
                            Expanded(child: MoveWindow()),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 20),
                      child: FloatingActionButton(
                        foregroundColor: Color.fromARGB(255, 36, 36, 36),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Theme[2],
                        onPressed: _goBack,
                        child: const Icon(Icons.arrow_back_rounded),
                      )),
                  Container(
                    child: ToggleButtons(
                      disabledColor: Theme[1],
                      disabledBorderColor: Theme[1],
                      fillColor: Theme[0].withAlpha(200),
                      direction: Axis.vertical,
                      isSelected: optionsButtons,
                      children: options,
                      onPressed: (int index) {
                        setState(() {
                          _isSelected = index;
                          // var strUser = usernameList[index].toString();
                          //  setCurrTab(strUser.toNativeUtf8());
                          //setCurrTab(usernameList[index].toNativeUtf8());
                          //print(index);
                          for (int buttonIndex = 0;
                              buttonIndex < optionsButtons.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              optionsButtons[buttonIndex] = true;
                            } else {
                              optionsButtons[buttonIndex] = false;
                            }
                            pickerColor = Theme[_isSelected];
                          }
                        });
                      },
                    ),
                  ),
                ]))),
            Expanded(
              child: Container(
                  color: Theme[0],
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 31, 31, 31),
                            width: double.infinity,
                            height: 30,
                          ),
                          WindowTitleBarBox(
                            child: Row(
                              children: [
                                Expanded(child: MoveWindow()),
                                WindowButtons()
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(

                              //height: 70,
                              padding: EdgeInsets.all(20),
                              child: SlidePicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ))
                        ],
                      ))
                    ],
                  )),
            ),
          ],
        ))
      ])),
    );
  }
}
