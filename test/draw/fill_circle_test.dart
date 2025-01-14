import 'package:image/image.dart';
import 'package:test/test.dart';

import '../_test_util.dart';

void main() {
  group('Draw', () {
    test('fillCircle', () async {
      await (Command()
        ..createImage(width: 256, height: 256, numChannels: 4)
        ..fillCircle(x: 128, y: 128, radius: 100,
            color: ColorRgba8(255, 255, 0, 128))
        ..writeToFile('$testOutputPath/draw/fillCircle.png')
      ).execute();
    });
  });
}
