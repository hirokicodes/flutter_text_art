import 'dart:io';

class SavedImage {
  final DateTime dateAdded;
  final File originalImage;
  final List<File> textArtImagesList = [];
  SavedImage({
    this.dateAdded,
    this.originalImage,
  });

  DateTime get mostRecentTextArtDateTime {
    if (textArtImagesList.length != 0) {
      String fileName =
          textArtImagesList.first.path.split('/').last.split('.').first;
      return DateTime.parse(fileName);
    } else {
      return dateAdded;
    }
  }
}
