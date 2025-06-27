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
    double numero = random.nextInt(451) - 600;
    canoA = SpriteComponent()
      ..sprite = sprite_
      ..size = Vector2(200, 600)
      ..position = Vector2(800, numero);

    canoB = SpriteComponent()
      ..sprite = sprite_
      ..size = Vector2(200, 600)
      ..position = Vector2(800, 800 + numero); 
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
  final List<Cano> canos = [];
  late Sprite canoSprite;

  double velocityY = 0;
  final double gravity = 1200;
  final double jumpForce = -600;
  final double velocityX = -250;

  double tempoNovoCano = 0;

  @override
  Future<void> onLoad() async {
    canoSprite = await loadSprite('cano.png');
    final birdSprite = await loadSprite('bird.png');
    print("Sprites carregados");

    player = SpriteComponent()
      ..sprite = birdSprite
      ..size = Vector2(100, 100)
      ..position = Vector2(100, 100);
    add(player);

    spawnCano(); 
  }

  void spawnCano() async {
    final novoCano = Cano();
    await novoCano.loadCano(canoSprite);
    novoCano.addToGame(this);
    canos.add(novoCano);
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocityY += gravity * dt;
    player.position.y += velocityY * dt;

    if (player.position.y > 500) {
      player.position.y = 500;
      velocityY = 0;
    } else if (player.position.y < 0) {
      player.position.y = 0;
      velocityY = 0;
    }

    for (final cano in canos) {
      cano.moveCano(velocityX * dt);
    }

    canos.removeWhere((cano) {
      if (cano.canoA.position.x + cano.canoA.size.x < 0) {
        cano.canoA.removeFromParent();
        cano.canoB.removeFromParent();
        return true;
      }
      return false;
    });

    tempoNovoCano -= dt;
    if (tempoNovoCano <= 0) {
      spawnCano();
      tempoNovoCano = 2.0; 
    }
  }

  @override
  void onTap() {
    velocityY = jumpForce;
  }
}
