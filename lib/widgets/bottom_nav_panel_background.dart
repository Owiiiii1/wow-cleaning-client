import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wow_cleaning/config/bottom_nav_layout.dart';

Future<ui.Image>? _panelImageFuture;

Future<ui.Image> _loadPanelImage() {
  return _panelImageFuture ??= () async {
    final data = await rootBundle.load(BottomNavAssets.panel);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }();
}

/// Фон нижней панели:
/// - по ширине: центр с го́рбом фиксирован, бока тянутся;
/// - сама панель рисуется без вертикальных искажений,
///   вниз на [bottomInset] продолжается только нижняя кромка.
class BottomNavPanelBackground extends StatefulWidget {
  const BottomNavPanelBackground({
    super.key,
    required this.contentHeight,
    this.bottomInset = 0,
  });

  final double contentHeight;
  final double bottomInset;

  @override
  State<BottomNavPanelBackground> createState() =>
      _BottomNavPanelBackgroundState();
}

class _BottomNavPanelBackgroundState extends State<BottomNavPanelBackground> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadPanelImage().then((image) {
      if (!mounted) return;
      setState(() => _image = image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    if (image == null) {
      return ColoredBox(color: BottomNavLayout.panelSafeAreaColor);
    }

    return CustomPaint(
      painter: _PanelNinePatchPainter(
        image: image,
        srcCenterLeft: BottomNavLayout.panelSourceCenterLeft,
        srcCenterRight: BottomNavLayout.panelSourceCenterRight,
        srcEdgePx: BottomNavLayout.panelBottomEdgeSourcePx,
        edgeBlurSigma: BottomNavLayout.panelBottomEdgeBlurSigma,
        edgeOverlap: BottomNavLayout.panelBottomEdgeOverlap,
        contentHeight: widget.contentHeight,
        bottomInset: widget.bottomInset,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _PanelNinePatchPainter extends CustomPainter {
  _PanelNinePatchPainter({
    required this.image,
    required this.srcCenterLeft,
    required this.srcCenterRight,
    required this.srcEdgePx,
    required this.edgeBlurSigma,
    required this.edgeOverlap,
    required this.contentHeight,
    required this.bottomInset,
  });

  final ui.Image image;
  final double srcCenterLeft;
  final double srcCenterRight;
  final double srcEdgePx;
  final double edgeBlurSigma;
  final double edgeOverlap;
  final double contentHeight;
  final double bottomInset;

  @override
  void paint(Canvas canvas, Size size) {
    final srcW = image.width.toDouble();
    final srcH = image.height.toDouble();
    if (srcW <= 0 || srcH <= 0 || size.isEmpty) return;

    final panelH = contentHeight.clamp(0.0, size.height);
    final inset = math.min(bottomInset, math.max(0.0, size.height - panelH));

    // Горизонтальные границы: бока тянутся, центр — нет.
    final left = srcCenterLeft.clamp(0.0, srcW);
    final right = srcCenterRight.clamp(left, srcW);
    final srcCenterW = right - left;

    // Центр всегда в исходных пропорциях: масштаб по полной высоте панели.
    final scale = panelH / srcH;
    var dstCenterW = srcCenterW * scale;
    if (dstCenterW > size.width) {
      dstCenterW = size.width;
    }

    final sideW = math.max(0.0, (size.width - dstCenterW) / 2);
    final paint = Paint()..filterQuality = FilterQuality.high;

    // Кромку отдаём расширению, иначе она нарисуется дважды и даст стык.
    final edge = inset > 0 ? srcEdgePx.clamp(1.0, srcH - 1) : 0.0;
    final bodySrcH = srcH - edge;

    void drawColumn(
      double srcLeft,
      double srcRight,
      double dstX,
      double dstWidth,
    ) {
      if (dstWidth <= 0 || srcRight <= srcLeft) return;

      canvas.drawImageRect(
        image,
        Rect.fromLTRB(srcLeft, 0, srcRight, bodySrcH),
        Rect.fromLTWH(dstX, 0, dstWidth, panelH),
        paint,
      );
    }

    drawColumn(0, left, 0, sideW);
    drawColumn(left, right, sideW, dstCenterW);
    drawColumn(right, srcW, sideW + dstCenterW, sideW);

    // Кромка исходника, растянутая вниз; блюр по X убирает зерно.
    if (inset > 0) {
      final fillPaint = Paint()..filterQuality = FilterQuality.high;
      if (edgeBlurSigma > 0) {
        fillPaint.imageFilter = ui.ImageFilter.blur(
          sigmaX: edgeBlurSigma,
          sigmaY: 0,
          tileMode: TileMode.clamp,
        );
      }

      final overlap = math.min(edgeOverlap, panelH);
      canvas.drawImageRect(
        image,
        Rect.fromLTRB(0, bodySrcH, srcW, srcH),
        Rect.fromLTWH(0, panelH - overlap, size.width, inset + overlap),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PanelNinePatchPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.srcCenterLeft != srcCenterLeft ||
        oldDelegate.srcCenterRight != srcCenterRight ||
        oldDelegate.srcEdgePx != srcEdgePx ||
        oldDelegate.edgeBlurSigma != edgeBlurSigma ||
        oldDelegate.edgeOverlap != edgeOverlap ||
        oldDelegate.contentHeight != contentHeight ||
        oldDelegate.bottomInset != bottomInset;
  }
}
