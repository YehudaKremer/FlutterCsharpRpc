![FlutterCsharpRPC](https://raw.githubusercontent.com/YehudaKremer/FlutterCsharpRpc/main/docs/assets/csharp_rpc_logo.png)

[![pub package](https://img.shields.io/pub/v/csharp_rpc.svg?color=blue)](https://pub.dev/packages/csharp_rpc) [![issues-closed](https://img.shields.io/github/issues-closed/YehudaKremer/FlutterCsharpRpc?color=green)](https://github.com/YehudaKremer/FlutterCsharpRpc/issues?q=is%3Aissue+is%3Aclosed) [![issues-open](https://img.shields.io/github/issues-raw/YehudaKremer/FlutterCsharpRpc)](https://github.com/YehudaKremer/FlutterCsharpRpc/issues)

# Flutter Csharp RPC

With this package we can execute C# code from Dart (Flutter) application via JSON-RPC protocol.

In run-time, we will create a C# child process and communicate with it via JSON-RPC protocol on the standard in/out (stdin/stdout) stream.

The JSON-RPC protocol let us invoke C# methods on the child process.

For example, we have the C# method:

```csharp
public DateTime GetCurrentDateTime()
{
    return DateTime.Now;
}
```

And we call it from Dart code with the `invoke` method:

```Dart
String currentDateTime = await csharpRpc.invoke(method: "GetCurrentDateTime");
```

We can also invoke method with array of parameters:

```Dart
var sum = await csharpRpc.invoke<int>(method: "SumNumbers", params: [2, 3]);
```

And even send a **typed** request parameter:

```Dart
var filesResult = await csharpRpc.invoke(
   method: "GetFilesInFolder",
   param: GetFilesInFolderRequest(folderPath: Directory.current.path)
);
var files = FilesInFolderResponse.fromJson(filesResult);
```

here we sending instance of request type `GetFilesInFolderRequest`,
then we convert the result to a response type `FilesInFolderResponse` with the `fromJson` method, so we can have fully typed communication experience 🎉

## 📋 Dart/Flutter Setup

In your `pubspec.yaml`, add the `csharp_rpc` package as a new dependency with
the following command:

```console
PS c:\src\flutter_project> flutter pub add csharp_rpc
```

In your program code, create and use the `CsharpRpc` class to invoke methods:

```Dart
import 'package:csharp_rpc/csharp_rpc.dart';

// create instance of CsharpRpc
var pathToCsharpExecutableFile = "<path_to_your_csharp_app>/CsharpApp.exe";

CsharpRpc csharpRpc = await CsharpRpc(pathToCsharpExecutableFile).start();

// invoke the C# method 'GetCurrentDateTime'
var currentDateTime = await csharpRpc.invoke(method: "GetCurrentDateTime");
```

## 📋 C# Setup

In your C# project, add the `FlutterCsharpRpc` Nuget package as a new dependency with
the following command:

```console
PS c:\src\csharp_project> dotnet add package FlutterCsharpRpc
```

In your program code, start the JSON-RPC server by calling the `StartAsync` method:

```csharp
using FlutterCsharpRpc;

static async Task Main(string[] args)
{
    // your program setup (DI, service, etc) here...

    // start the JSON-RPC server
    await CsharpRpcServer.StartAsync(new Server());
}

public class Server
{
    public DateTime GetCurrentDateTime()
    {
        return DateTime.Now;
    }
}
```

## ⚡ Demo

See the full [demo](https://github.com/YehudaKremer/FlutterCsharpRpc/tree/main/example/basic) of Flutter and C# app that communicate between them.

## 🤖 Code Generation

`Note: this feature is optional and not needed for small applications`

When using JSON-RPC we need our Dart classes to be serialize to JSON.

Also, it will be helpful if our csharp program have the same classes as our Flutter program so we can easily communicate between them.

To solve those problems and to speed up and enhance our development experience, we can use code generation to do the work for us.

Take a look on a [example](https://github.com/YehudaKremer/FlutterCsharpRpc/tree/main/example/code_generation) Flutter app that use code generation solution.

## 📦 Publish (Release Mode)

While in development (Debug Mode) our C# program can located anywhere ([see in basic example](https://github.com/YehudaKremer/FlutterCsharpRpc/blob/5c57deb2026b15d58bfc9a6d34fcda6a43556ac5/example/basic/flutter_app/lib/main.dart#L17)),
but when we build our Flutter app in Release mode, its time to move and publish the C# program into the Flutter build folder ([see in basic example](https://github.com/YehudaKremer/FlutterCsharpRpc/blob/5c57deb2026b15d58bfc9a6d34fcda6a43556ac5/example/basic/flutter_app/lib/main.dart#LL18C13-L18C13)).

- you can publish the C# into the Flutter Release-build folder: [example](https://github.com/YehudaKremer/FlutterCsharpRpc/blob/5c57deb2026b15d58bfc9a6d34fcda6a43556ac5/example/basic/CsharpApp/Properties/PublishProfiles/FolderProfile.pubxml#LL5C19-L5C19)
- when publishing the C# program, set it as [SelfContained](https://github.com/YehudaKremer/FlutterCsharpRpc/blob/5c57deb2026b15d58bfc9a6d34fcda6a43556ac5/example/basic/CsharpApp/Properties/PublishProfiles/FolderProfile.pubxml#LL9C1-L9C1), so it will work on every device even if Dotnet is not installed

Note: Those publish instructions are also suitable publish/deploy with [MSIX](https://pub.dev/packages/msix).

## 🙏 Credit

This package based on Michael K Snead's article on medium: [Flutter, C# and JSON RPC](https://medium.com/@aikeru/flutter-c-and-json-rpc-f325be6764bd)

---

Tags: `Csharp` `C#` `RPC` `flutter csharp` `flutter c#` `csharp ffi` `csharp json-rpc` `FlutterCsharpRpc` `StreamJsonRpc`
