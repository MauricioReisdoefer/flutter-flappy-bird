import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';

class FlappyBird extends FlameGame with HasKeyboardHandlerComponents, TapDetector {
  late SpriteComponent player;

  double velocityY = 0;
  final double gravity = 1200;   
  final double jumpForce = -600;

  @override
  Future<void> onLoad() async {
    final sprite = await loadSprite('bird.png');
    print("Sprite carregado com sucesso");
    player = SpriteComponent()
      ..sprite = sprite
      ..size = Vector2(100, 100)
      ..position = Vector2(100, 100);

    add(player);
  }

  @override
  void update(double dt) {
    velocityY += gravity * dt;           
    player.position.y += velocityY * dt;

    if (player.position.y > 500) {
      player.position.y = 500;
      velocityY = 0;
    }
    else if (player.position.y < 0)
    {
      player.position.y = 0;
      velocityY = 0;
    }
    super.update(dt);
  }

  @override
  void onTap() {
    super.onTap();
    velocityY = jumpForce;
  }
}