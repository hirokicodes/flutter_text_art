import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _imageFile;
  Image _image;
  Image _modifiedImage;
  bool _isLoading;

  // Get image from gallery
  Future<bool> getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
        _image = Image.file(imageFile);
      });
      return true;
    }
    return false;
  }

  // Return Text Art Image as Image Buffer from an image file
  Future<img.Image> createTextArtImage(File imageFile) async {
    String chars =
        "\$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. ";
    List<String> charsList = chars.split('').toList();
    int charLength = charsList.length;
    double interval = charLength / 256;

    double scaleFactor = 0.09;
    int oneCharWidth = 10;
    int oneCharHeight = 18;

    getChar(int inputint) {
      return charsList[(inputint * interval).floor()];
    }

    img.Image imageBuffer = img.decodeImage(imageFile.readAsBytesSync());

    List<int> xywh = img.findTrim(imageBuffer);
    int width = xywh[2];
    int height = xywh[3];
    img.Image resizedImageBuffer = img.copyResize(imageBuffer,
        width: (scaleFactor * width).round(),
        height:
            (scaleFactor * height * (oneCharWidth / oneCharHeight)).round());
    List<int> resizedXywh = img.findTrim(resizedImageBuffer);
    int resizedWidth = resizedXywh[2];
    int resizedHeight = resizedXywh[3];

    img.Image outputImageBuffer =
        img.Image(oneCharWidth * resizedWidth, oneCharHeight * resizedHeight);

    print('resized width: $resizedWidth');
    print('resized height: $resizedHeight');
    img.fill(outputImageBuffer, img.getColor(0, 0, 0));
    for (int i = 0; i < resizedHeight; i++) {
      for (int j = 0; j < resizedWidth; j++) {
        int pixel32 = resizedImageBuffer.getPixelSafe(j, i);
        int col = img.getLuminance(pixel32);
        img.drawString(outputImageBuffer, img.arial_14, j * oneCharWidth,
            i * oneCharHeight, getChar(col),
            color: pixel32);
      }
    }

    return outputImageBuffer;
  }

  // Save image buffer as PNG and return the saved image file
  Future<File> _saveImageBufferToPng(img.Image imageBuffer) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File('${dir.path}/modifiedImg.png')
        .writeAsBytesSync(img.encodePng(imageBuffer));
    File savedFile = File('${dir.path}/modifiedImg.png');
    return savedFile;
  }

  void _handleOnImageSelected() async {
    setState(() {
      _isLoading = true;
    });
    img.Image textArtImageBuffer = await createTextArtImage(_imageFile);
    File textArtImageFile = await _saveImageBufferToPng(textArtImageBuffer);
    Image textArtImage = Image.memory(textArtImageFile.readAsBytesSync());
    setState(() {
      _isLoading = false;
      _modifiedImage = textArtImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _imageFile == null ? Text('No image selected.') : _image,
            _modifiedImage == null ? Text('No modified image') : _modifiedImage,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool imageSelected = await getImage();
          if (imageSelected) {
            _handleOnImageSelected();
          }
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
