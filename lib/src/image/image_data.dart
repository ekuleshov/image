import 'dart:typed_data';

import '../color/color.dart';
import '../color/format.dart';
import 'palette.dart';
import 'pixel.dart';

abstract class ImageData extends Iterable<Pixel> {
  final int width;
  final int height;
  final int numChannels;

  ImageData(this.width, this.height, this.numChannels);

  ImageData clone({bool noPixels = false});

  /// The channel [Format] of the image.
  Format get format;

  /// Whether th image has uint, int, or float data.
  FormatType get formatType;

  /// True if the image format is "high dynamic range." HDR formats include:
  /// float16, float32, float64, int8, int16, and int32.
  bool get isHdrFormat;

  /// True if the image format is "low dynamic range." LDR formats include:
  /// uint1, uint2, uint4, and uint8.
  bool get isLdrFormat => !isHdrFormat;

  /// The number of bits per color channel. Can be 1, 2, 4, 8, 16, 32, or 64.
  int get bitsPerChannel;

  /// The maximum value of a pixel channel, based on the [format] of the image.
  /// If the image has a [palette], this will be the maximum value of a palette
  /// color channel. Float format images will have a maxChannelValue of 1.0,
  /// though they can have values above that.
  num get maxChannelValue;

  /// The maximum value of a palette index, based on the [format] of the image.
  /// This differs from [maxChannelValue] in that it will not be affected by
  /// the format of the [palette].
  num get maxIndexValue;

  /// True if the image has a palette. If the image has a palette, then the
  /// image data has 1 channel for the palette index of the pixel.
  bool get hasPalette => palette != null;

  /// The [Palette] of the image, or null if the image does not have one.
  Palette? get palette => null;

  /// The size of the image data in bytes
  int get lengthInBytes;

  /// The size of the image data in bytes.
  @override
  int get length;

  /// The [ByteBuffer] storage of the image.
  ByteBuffer get buffer;

  /// The storage data of the image.
  Uint8List toUint8List() => Uint8List.view(buffer);

  /// The size, in bytes, of a row if pixels in the data.
  int get rowStride;

  Iterator<Pixel> getRange(int x, int y, int width, int height);

  Color getColor(num r, num g, num b, [num? a]);

  Pixel getPixel(int x, int y, [Pixel? pixel]);

  void setPixel(int x, int y, Color p) {
    setPixelRgba(x, y, p.r, p.g, p.b, p.a);
  }

  /// Set the red channel of the pixel, or the index value for palette images.
  void setPixelR(int x, int y, num i);

  void setPixelRgb(int x, int y, num r, num g, num b);

  void setPixelRgba(int x, int y, num r, num g, num b, num a);

  void setPixelRgbSafe(int x, int y, num r, num g, num b) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return;
    }
    setPixelRgb(x, y, r, g, b);
  }

  void setPixelRgbaSafe(int x, int y, num r, num g, num b, num a) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return;
    }
    setPixelRgba(x, y, r, g, b, a);
  }

  /// Set all of the pixels to the Color [c], or all values to 0 if [c] is not
  /// given.
  void clear([Color? c]);
}
