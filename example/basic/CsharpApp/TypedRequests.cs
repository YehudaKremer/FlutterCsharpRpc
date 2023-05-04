public class GetFilesInFolderRequest
{
    public string FolderPath { get; set; }
}

public class FilesInFolderResponse
{
    public string[] Files { get; set; }
}
