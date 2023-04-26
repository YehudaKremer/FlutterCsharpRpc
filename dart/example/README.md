```Dart
import 'package:csharp_rpc/csharp_rpc.dart';

// create instance of CsharpRpc
var pathToCsharpExecutableFile = "<path_to_your_csharp_app>/CsharpApp.exe";

CsharpRpc csharpRpc = await CsharpRpc(pathToCsharpExecutableFile).start();

// invoke the C# method 'GetCurrentDateTime'
var currentDateTime = await csharpRpc.invoke(method: "GetCurrentDateTime");

// invoke the C# method 'SumNumbers' with array of parameters
var sum = await csharpRpc.invoke<int>(method: "SumNumbers", params: [2, 3]);

// invoke the C# method 'GetFilesInFolder' with typed request parameter
var filesResult = await csharpRpc.invoke(
   method: "GetFilesInFolder",
   param: GetFilesInFolderRequest(folderPath: Directory.current.path)
);
var files = FilesInFolderResponse.fromJson(filesResult);
```
