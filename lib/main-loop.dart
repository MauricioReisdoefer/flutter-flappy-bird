import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'dart:math';

class Cano {
  final random = Random();
  late SpriteComponent canoA;
  late SpriteComponent canoB;

  Future<void> loadCano(final Sprite sprite_) async {
    double numero = random.nextInt(301) - 600;
    canoA = SpriteComponent()
      ..sprite = sprite_
      ..size = Vector2(200, 400)
      ..position = Vector2(800, numero);

    canoB = SpriteComponent()
      ..sprite = sprite_
      ..size = Vector2(200, 400)
      ..position = Vector2(800, 600 + numero); 
  }
  void addToGame(FlameGame game) {
    game.add(canoA);
    game.add(canoB);
  }

  void moveCano(dist)
  {
    canoA.position.x += dist;
    canoB.position.x += dist;
  }
}

class FlappyBird extends FlameGame with HasKeyboardHandlerComponents, TapDetector {
  late SpriteComponent player;
  late Cano cano;
  double velocityY = 0;
  final double gravity = 1200;   
  final double jumpForce = -600;

  double velocityX = -250;

  @override
  Future<void> onLoad() async {
    final cano_sprite = await loadSprite('cano.png');
    final sprite = await loadSprite('bird.png');
    print("Sprites carregado com sucesso");

    player = SpriteComponent()
      ..sprite = sprite
      ..size = Vector2(100, 100)
      ..position = Vector2(100, 100);

    add(player);

    cano = Cano();
    await cano.loadCano(cano_sprite);
    cano.addToGame(this);
  }

  @override
  void update(double dt) {
    cano.moveCano(velocityX * dt);

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