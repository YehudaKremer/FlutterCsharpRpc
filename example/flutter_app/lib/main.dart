import 'package:csharp_rpc/csharp_rpc.dart';
import 'package:flutter/material.dart';

import 'types.dart';

late CsharpRpc csharpRpc;

Future<void> main() async {
  runApp(const MyApp());

  csharpRpc =
      await CsharpRpc("../CsharpApp/bin/Debug/net7.0-windows/CsharpApp.exe")
          .start();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    // var dateTimeResult = await csharpRpc.invoke(method: "GetCurrentDateTime");

    // var sumNumbersResult =
    //     await csharpRpc.invoke<int>(method: "SumNumbers", params: [2, 3]);

    var filesResult = FilesInFolderResponse.fromJson(await csharpRpc.invoke(
        method: "getFilesInFolder",
        param: GetFilesInFolderRequest(
            folderPath: '../CsharpApp/bin/Debug/net7.0-windows/')));
    print('filesResult:');
    print(filesResult.files);

    // await csharpRpc.invoke(
    //     method: "ShowMessageBox",
    //     params: ['Hello World!', 'Hello from flutter c# child process.']);

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
