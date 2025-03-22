import 'dart:math';
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Ball extends BodyComponent {
  final Vector2 initialPosition;
  final double _radius;
  bool isSelected = false;
  late final Color _color;

  Ball({required this.initialPosition, required double radius})
    : _radius = radius,
      super(renderBody: false) {
    // 랜덤한 밝은 색상 생성
    final random = Random();
    final colors = [
      Colors.red[400],
      Colors.green[400],
      Colors.blue[400],
      Colors.yellow[400],
      Colors.orange[400],
      Colors.purple[400],
      Colors.pink[400],
      Colors.teal[400],
      Colors.indigo[400],
      Colors.amber[400],
    ];
    _color = colors[random.nextInt(colors.length)]!;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint = Paint()..color = _color;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = _radius;
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      userData: this,
    );

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      density: 1.0,
      friction: 0.4,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 외부 그림자 효과
    canvas.drawCircle(
      Offset.zero,
      _radius + 1,
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // 공 메인 색상
    canvas.drawCircle(Offset.zero, _radius, paint);

    // 반사 효과 (하이라이트)
    canvas.drawCircle(
      Offset(-_radius * 0.3, -_radius * 0.3),
      _radius * 0.3,
      Paint()..color = Colors.white.withOpacity(0.6),
    );

    if (isSelected) {
      // 선택된 공 효과
      canvas.drawCircle(
        Offset.zero,
        _radius * 0.7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }
}
