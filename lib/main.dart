import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'List of CountDown Timer'),
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
  List<Widget> timerList = <Widget>[];
  late List<TextEditingController> _controllers;
  List<String> _textList = List.generate(100, (index) => 'HH:mm:ss');
  List<String> _btnstate = List.generate(100, (index) => 'Start');

  void addWidgetToList() {
    setState(() {
      timerList.insert(timerList.length, coundownWidget());
      // _btnstate.insert(timerList.length, "Start");
      _controllers = List.generate(
          timerList.length, (index) => TextEditingController(),
          growable: true);
    });
  }

  Widget coundownWidget() {
    return Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: timerList.length,
            itemBuilder: (BuildContext context, int index) {
              return Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _controllers[index],
                          onChanged: (String newText) {
                            setState(() {
                              int seconds = int.parse(newText);
                              Duration duration = Duration(seconds: seconds);
                              String formattedTime =
                                  '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
                              _textList[index] = formattedTime;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Time in seconds',
                          ),
                        )),
                        Expanded(child: Text(_textList[index])),
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blueAccent)),
                          onPressed: () {
                            int seconds =
                                int.parse(_controllers[index].text.toString());

                            Duration duration = Duration(seconds: seconds);
                            String formattedTime =
                                '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
                            Timer.periodic(const Duration(seconds: 1), (timer) {
                              setState(() {
                                _textList[index] = timer.tick.toString();
                                _btnstate[index] = 'Stop';
                              });
                              print(timer.tick);
                              seconds--;
                              if (seconds == 0) {
                                setState(() {
                                  _textList[index] = formattedTime;
                                  _btnstate[index] = 'Start';
                                });
                                timer.cancel();
                                print("timer cancel");
                              }
                            });
                          },
                          child: Text(_btnstate[index],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ))
                      ],
                    ),
                  ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: <Widget>[
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
            onPressed: () {
              addWidgetToList();
            },
            child: const Text('Add New Timer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ),
          timerList.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Please add countdown timer'),
                  ),
                )
              : coundownWidget()
        ]));
  }
}
