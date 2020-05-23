import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_text_art_filter/model/app_state_model.dart';
import 'package:flutter_text_art_filter/app.dart';

void main() {
  return runApp(
    ChangeNotifierProvider<AppStateModel>(
      create: (context) => AppStateModel()..loadApp(),
      child: TextArtFilterApp(),
    ),
  );
}
