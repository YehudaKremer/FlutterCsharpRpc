/// <summary>
/// Class that contains the JSON-RPC methods
/// </summary>
public class Server
{
    public DateTime GetCurrentDateTime()
    {
        // Log to STDERR so we wont corrupt the STDOUT pipe that we using for JSON-RPC.
        Console.Error.WriteLine($"Received 'GetCurrentDateTime' request");

        return DateTime.Now;
    }

    public int SumNumbers(int a, int b)
    {
        Console.Error.WriteLine($"Received 'SumNumbers' request");

        return a + b;
    }

    public FilesInFolderResponse GetFilesInFolder(GetFilesInFolderRequest request)
    {
        Console.Error.WriteLine($"Received 'GetFilesInFolder' request");

        return new FilesInFolderResponse
        {
            Files = Directory.GetFiles(request.FolderPath!).Take(10).ToArray()
        };
    }
}
