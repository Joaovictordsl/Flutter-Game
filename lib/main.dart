import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

void main() {
  //Flame.device.fullScreen();

  runApp(MaterialApp(
    home: GameWidget(
    game: MyFarmGame(),
    ),
  ));
}

class MyFarmGame extends FlameGame with TapDetector {
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation idleAnimation;

  late SpriteAnimationComponent george;
  late SpriteComponent background;

  //0 = idle, 1 = down, 2 = left, 3 = up, 4 = right;
  int direction = 0;

  final double animationSpeed = 0.15;
  final double characterSize = 50;
  final double characterSpeed = 40;

  Future<void> onLoad() async{
    await super.onLoad();

    Sprite backgroundSprite = await loadSprite('farm-background.jpg');
    background = SpriteComponent()..sprite = backgroundSprite..size = backgroundSprite.originalSize;
    add(background);

    final spriteSheet = SpriteSheet(image: await images.load('cow2.png'), srcSize: Vector2.all(628));

    downAnimation =
    spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 2);
    leftAnimation = 
    spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 2);
    rightAnimation = 
    spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 2);
    upAnimation = 
    spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 2);
    idleAnimation = 
    spriteSheet.createAnimation(row: 1, stepTime: animationSpeed);


    george = SpriteAnimationComponent()
    ..animation = idleAnimation 
    ..position = Vector2(100, 200)
    ..size = Vector2.all(characterSize);


    add(george);

    camera.followComponent(george, worldBounds: Rect.fromLTRB(0, 0, background.size.x, background.size.y));
  }

  @override
    void update(double dt){
      super.update(dt);
      switch (direction) {
        case 0:
          george.animation = idleAnimation;
          break;
        case 1:
          george.animation = downAnimation;
          if (george.y < background.size.y - george.height){
            george.y += dt * characterSpeed;
          }
          
          break;
        case 2:
          george.animation = leftAnimation;
          if (george.x > 0) {
            george.x -= dt * characterSpeed;
          }
          break;
        case 3:
          george.animation = upAnimation;
          if (george.y > 0){
            george.y -= dt * characterSpeed;
          }
        break;
        case 4:
          george.animation = rightAnimation;
          if (george.x < background.size.x - george.width){
            george.x += dt * characterSpeed;
          }
        break;
      }
    }

    @override
    void onTapUp(TapUpInfo info){
      direction += 1;
        if(direction > 4) {
          direction = 0;
        }
      print('change animation');
    }
}