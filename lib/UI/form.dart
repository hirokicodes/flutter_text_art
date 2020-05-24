import 'package:flutter/material.dart';
import 'package:flutter_text_art_filter/model/saved_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_text_art_filter/constants.dart';
import 'package:flutter_text_art_filter/model/app_state_model.dart';

class CreateTextArtForm extends StatefulWidget {
  CreateTextArtForm({@required this.savedImage});
  final SavedImage savedImage;

  @override
  _CreateTextArtFormState createState() => _CreateTextArtFormState();
}

class _CreateTextArtFormState extends State<CreateTextArtForm> {
  List<double> scaleFactorOptions = Constants.scaleFactorOptions;
  double chosenScaleFactor = 0.1;
  List<int> backgroundShadeOptions = List<int>.generate(256, (i) => i);
  int chosenRgbVal = 0;
  Map<CharsSet, String> charsSetOptions = {
    CharsSet.defaultSet: "Default",
    CharsSet.smallSet: "Few Characters",
  };
  CharsSet chosenCharsSet = CharsSet.defaultSet;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Scale Factor'),
            DropdownButton(
              items: scaleFactorOptions
                  .map((double scaleFactor) => DropdownMenuItem(
                      value: scaleFactor, child: Text('$scaleFactor')))
                  .toList(),
              value: chosenScaleFactor,
              onChanged: (double newValue) {
                setState(() {
                  chosenScaleFactor = newValue;
                });
              },
            ),
            Text('Background Shade'),
            DropdownButton(
              items: backgroundShadeOptions
                  .map((int rgbVal) =>
                      DropdownMenuItem(value: rgbVal, child: Text('$rgbVal')))
                  .toList(),
              value: chosenRgbVal,
              onChanged: (int newValue) {
                setState(() {
                  chosenRgbVal = newValue;
                });
              },
            ),
            Text('Characters Set'),
            DropdownButton(
              items: CharsSet.values
                  .map((CharsSet charsSet) => DropdownMenuItem(
                      value: charsSet,
                      child: Text('${charsSetOptions[charsSet]}')))
                  .toList(),
              value: chosenCharsSet,
              onChanged: (CharsSet newValue) {
                setState(() {
                  chosenCharsSet = newValue;
                });
              },
            ),
            MaterialButton(
              child: Text('Create'),
              onPressed: () {
                final appStateModel =
                    Provider.of<AppStateModel>(context, listen: false);
                appStateModel.createAndSaveTextArt(widget.savedImage,
                    chosenScaleFactor, chosenRgbVal, chosenCharsSet);
                print('nav pop');
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ],
    );
  }
}
