using System.IO;
using System.Windows;

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

    /// <summary>
    /// Windows UI example for fun :)
    /// Of course we will use Flutter for the UI.
    /// </summary>
    public void ShowMessageBox(string title, string message)
    {
        Console.Error.WriteLine($"Received 'ShowMessageBox' request");

        MessageBox.Show(message, title, MessageBoxButton.OK, MessageBoxImage.Asterisk, MessageBoxResult.OK, MessageBoxOptions.DefaultDesktopOnly);
    }

    public FilesInFolderResponse GetFilesInFolder(GetFilesInFolderRequest request)
    {
        Console.Error.WriteLine($"Received 'GetFilesInFolder' request");

        return new FilesInFolderResponse
        {
            Files = Directory.GetFiles(request.FolderPath!)
        };
    }
}
