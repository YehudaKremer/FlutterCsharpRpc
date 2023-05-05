import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:csharp_rpc/csharp_rpc.dart';
import 'types.dart';

late CsharpRpc csharpRpc;

Future<void> main() async {
  runApp(const MyApp());

  /// The path to our C# program.
  /// In release-mode we will publish the C# app to the flutter build path:
  /// "..\flutter_app\build\windows\runner\Release\csharp"
  /// so, we can use the path: "csharp/CsharpApp.exe"
  var pathToCsharpExecutableFile = kReleaseMode
      ? 'csharp/CsharpApp.exe'
      : "../CsharpApp/bin/Debug/net7.0-windows/CsharpApp.exe";

  /// Create and start CsharpRpc instance.
  /// you can create this instance anywhere in your program, but remember to
  /// dispose is by calling 'csharpRpc.dispose()'
  csharpRpc = await CsharpRpc(pathToCsharpExecutableFile).start();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _textFieldController = TextEditingController();

  MyHomePage({super.key});

  void _updateTextField(String text) {
    _textFieldController.value = TextEditingValue(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Csharp RPC Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('GET CURRENT DATE TIME'),
                  onPressed: () async {
                    /// invoke C# method 'GetCurrentDateTime'
                    /// to get the current date time
                    var currentDateTime =
                        await csharpRpc.invoke(method: "GetCurrentDateTime");

                    _updateTextField(currentDateTime);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: const Text('SUM NUMBERS 2 + 3'),
                    onPressed: () async {
                      /// invoke C# method 'SumNumbers' with the params '[2, 3]'
                      /// to get the summary of 2 + 5
                      var sumNumbersResult = await csharpRpc
                          .invoke<int>(method: "SumNumbers", params: [2, 3]);

                      _updateTextField(sumNumbersResult.toString());
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text('GET FILES IN CURRENT FOLDER'),
                  onPressed: () async {
                    /// invoke C# method 'GetFilesInFolder' with param of
                    /// 'GetFilesInFolderRequest' instance to get a list of
                    /// files in the current folder
                    var filesResult = await csharpRpc.invoke(
                      method: "GetFilesInFolder",
                      param: GetFilesInFolderRequest(
                          folderPath: Directory.current.path),
                    );
                    var filesInFolder =
                        FilesInFolderResponse.fromJson(filesResult);

                    _updateTextField(filesInFolder.files.toString());
                  },
                ),
              ],
            ),
            SizedBox(
              width: 618,
              child: TextField(
                controller: _textFieldController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'C# Response',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
