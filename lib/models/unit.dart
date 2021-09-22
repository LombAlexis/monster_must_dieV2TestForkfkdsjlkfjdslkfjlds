import 'dart:math';
import 'package:flame/assets.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';

class Unit  extends SpriteAnimationComponent{

  //Position
  late double _x;
  late double _y;

  //Stats
  late double damage;
  late double health;
  late double maxHealth;
  late double speed;
  late double range;

  //Taille
  late Vector2 unitSize;

  //Autres
  late int type;

  //Vu que je sais pas faire les enum et que sa a l'air chiant a faire
  //TYPE
  //0-1 : archer
  //2-3 : balista
  //4-5 : berserker
  //6-7 : cavalier
  //8-9 : dragon
  //10-11 : marshall
  //12-13 : spear
  //14-15 : wizard


  ///get la position en tant que vecteur2
  Vector2 getPosition() {
    return Vector2(_x, _y);
  }

  ///set la position avec un [vector2]
  void setPosition(Vector2 vector2) {
    _x = vector2.x;
    _y = vector2.y;
  }
  ///Constructors : prend position [x] [y] et un [type]
  Unit(double x, double y, int pType,Images images):super.fromFrameData(images.fromCache('Unit/archer/moving.png'), SpriteAnimationData.sequenced(
    amount: 4,
    amountPerRow: 1,
    textureSize: Vector2(32, 30),
    stepTime: 0.1,
  ),position: Vector2(x,y),playing: true,size: Vector2(60,60)){
    _x = x;
    _y = y;
    type = pType;
    switch(type) {
    //0-1 : archer
      case 0:
      case 1: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //2-3 : balista
      case 2:
      case 3: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //4-5 : berserker
      case 4:
      case 5: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //6-7 : cavalier
      case 6:
      case 7: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //8-9 : dragon
      case 8:
      case 9: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //10-11 : marshall
      case 10:
      case 11: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //12-13 : spear
      case 12:
      case 13: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;
    //14-15 : wizard
      case 14:
      case 15: {
        damage = 1;
        health = 1000;
        maxHealth = 1000;
        speed = 0.4;
        unitSize = Vector2(60, 60);
        range=50;
      }
      break;

      default: {
        damage = 1;
        health = 100;
        maxHealth=100;
        speed = 0.5;
        range=50;
        unitSize = Vector2(40, 40);
      }
      break;
    }
  }

}
