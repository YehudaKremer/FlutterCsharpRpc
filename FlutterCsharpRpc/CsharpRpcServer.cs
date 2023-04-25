using Nerdbank.Streams;
using Newtonsoft.Json.Serialization;
using StreamJsonRpc;
using System;
using System.Threading.Tasks;

namespace FlutterCsharpRpc
{
    /// <summary>
    /// Manage csharp-json-rpc server
    /// </summary>
    public static class CsharpRpcServer
    {
        /// <summary>
        /// Start a csharp-json-rpc server and starts listening to incoming messages.
        /// </summary>
        /// <typeparam name="TServer">Type of class that contains the PRC methods</typeparam>
        /// <param name="server">Instance of class that contains the PRC methods</param>
        /// <returns>Task that resolve when the process stops</returns>
        public static async Task StartAsync<TServer>(TServer server)
        {
            // Log to STDERR so we wont corrupt the STDOUT pipe that we using for JSON-RPC.
            await Console.Error.WriteLineAsync($"csharp-json-rpc server starting...");
            var streamStdIo = FullDuplexStream.Splice(Console.OpenStandardInput(), Console.OpenStandardOutput());

            var formatter = new JsonMessageFormatter();
            formatter.JsonSerializer.ContractResolver = new CamelCasePropertyNamesContractResolver();

            JsonRpc jsonRpc = new JsonRpc(new HeaderDelimitedMessageHandler(streamStdIo, streamStdIo, formatter));

            jsonRpc.AddLocalRpcTarget(
                server,
                new JsonRpcTargetOptions
                {
                    DisposeOnDisconnect = true,
                    EventNameTransform = CommonMethodNameTransforms.CamelCase,
                    MethodNameTransform = CommonMethodNameTransforms.CamelCase,
                });

            jsonRpc.StartListening();
            await Console.Error.WriteLineAsync($"csharp-json-rpc server started. Waiting for requests...");
            await jsonRpc.Completion;
            await Console.Error.WriteLineAsync($"csharp-json-rpc server terminated.");
        }
    }
}
