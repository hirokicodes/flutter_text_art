enum CharsSet { defaultSet, smallSet }

Map<CharsSet, String> charsSets = {
  CharsSet.defaultSet:
      "\$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. ",
  CharsSet.smallSet: "@Wat-;^. ",
};

abstract class Constants {
  static List<double> scaleFactorOptions = [
    0.05,
    0.06,
    0.07,
    0.08,
    0.09,
    0.10,
    0.2,
    0.3
  ];
}
