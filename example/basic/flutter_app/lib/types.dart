class GetFilesInFolderRequest {
  String folderPath;

  GetFilesInFolderRequest({required this.folderPath});

  Map<String, dynamic> toJson() => {'folderPath': folderPath};
}

class FilesInFolderResponse {
  List<String> files;

  FilesInFolderResponse({required this.files});

  FilesInFolderResponse.fromJson(Map<String, dynamic> json)
      : files = List<String>.from(json['files']);
}
