import 'dart:math';

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.child,
    this.nip,
    this.background,
    this.shadow,
    this.elevation,
  }) : super(key: key);

  final Widget? child;

  final MessageBubbleNip? nip;
  final Color? background;
  final Color? shadow;
  final double? elevation;

  MessageBubblePainter get painter => MessageBubblePainter(
        nip: this.nip,
        background: this.background,
        shadow: this.shadow,
        elevation: this.elevation,
      );

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        padding: EdgeInsets.all(8),
        child: child,
      ),
      painter: painter,
    );
  }
}

@immutable
class MessageBubblePainter extends CustomPainter {
  MessageBubblePainter({
    Listenable? repaint,
    MessageBubbleNip? nip,
    Color? background,
    Color? shadow,
    double? elevation,
  })  : nip = nip ?? MessageBubbleNip.bottomLeft,
        background = background ?? Colors.blue.shade300,
        shadow = shadow ?? Colors.grey,
        elevation = elevation ?? 4,
        super(repaint: repaint);

  final MessageBubbleNip nip;
  final Color background;
  final Color shadow;
  final double elevation;

  Paint get rectPainter {
    return Paint()..color = background;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path outline = this.outline(size);
    canvas.drawShadow(outline, shadow, elevation, true);
    canvas.drawPath(outline, rectPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this == oldDelegate;
  }

  Path outline(Size size) {
    final double width = size.width;
    final double height = size.height;

    final Path rect = Path();
    rect.addRect(Rect.fromLTWH(0, 0, width, height));

    Path nip = Path();
    nip.addPolygon(
      [Offset(-5, -5), Offset(0, 5), Offset(5, 0)],
      true,
    );
    nip = nip.transform(this.nip.matrix4(size).storage);

    final outline = Path.combine(PathOperation.union, rect, nip);

    return outline;
  }
}

enum MessageBubbleNip {
  bottomLeft,
  bottomRight,
  topLeft,
  topRight,
}

extension MessageBubbleNipTransform on MessageBubbleNip {
  Matrix4 matrix4(Size size) {
    final matrix4 = Matrix4.identity();

    switch (this) {
      case MessageBubbleNip.bottomLeft:
        matrix4.rotateX(pi);
        matrix4.translate(0.0, -size.height);
        break;
      case MessageBubbleNip.bottomRight:
        matrix4.rotateX(pi);
        matrix4.rotateY(pi);
        matrix4.translate(-size.width, -size.height);
        break;
      case MessageBubbleNip.topLeft:
        break;
      case MessageBubbleNip.topRight:
        matrix4.rotateY(pi);
        matrix4.translate(-size.width);
        break;
      default:
    }

    return matrix4;
  }
}
