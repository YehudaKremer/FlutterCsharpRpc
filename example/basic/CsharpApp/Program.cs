using FlutterCsharpRpc;

internal class Program
{
    static async Task Main(string[] args)
    {
        // your program setup (DI, service, etc) here...

        // start the JSON-RPC server
        // and start listening for requests coming from Dart (Flutter).
        await CsharpRpcServer.StartAsync(new Server());
    }
}
