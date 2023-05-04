# JSON And C# Code Generation

In this example we will generate JSON serialization method, and C# types for our Dart classes.

To start generating code, run the following command:

```console
PS c:\FlutterCsharpRpc\example\code_generation\flutter_app> flutter pub run build_runner watch --delete-conflicting-outputs
```

After running this command, you will see that new files are added to the project file, a `*.g.dart` files for JSON serialization and a `CsharpModels/Models.cs` for C# types.

This example uses the [json_serializable](https://pub.dev/packages/json_serializable) package for JSON serialization, and [csharp_generator](https://pub.dev/packages/csharp_generator) package for C# types generation.

Note: You can set the output path of the C# file-types by create and edit the [build.yaml](https://github.com/YehudaKremer/FlutterCsharpRpc/tree/main/example/code_generation/flutter_app/build.yaml) file.
