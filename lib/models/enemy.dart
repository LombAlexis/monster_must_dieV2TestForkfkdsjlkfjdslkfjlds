import 'dart:math';
import 'package:flame/assets.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteAnimationComponent {

  //late modifier can be used while declaring a non-nullable variable that’s initialized after its declaration.
  //Position
  /*
  late double _x;
  late double _y;*/

  //Stats
  late double damage;
  late double health;
  late double maxHealth;
  late double speed;
  late double range;

  //Taille
  //late Vector2 size;

  //Autres
  late int type;

  //Vu que je sais pas faire les enum et que sa a l'air chiant a faire
  //TYPE
  //0-1 : archer
  //2-3 : cyclop
  //4-5 : dog
  //6-7 : eye
  //8-9 : gargoyle
  //10-11 : ghost
  //12-13 : zombie


  /*///get la position en tant que vecteur2
  Vector2 getPosition() {
    return Vector2(_x, _y);
  }
  ///set la position avec un [vector2]
  void setPosition(Vector2 vector2) {
    _x = vector2.x;
    _y = vector2.y;
  }*/

  ///Constructors : prend position [x] [y] et un [type]
  Enemy(double x, double y, int pType):super(position: Vector2(x,y)){
    /*_x = x;
    _y = y;*/
    type = pType;
    //switch sur le type pour ses stats
    switch(type) {
      //0-1 : archer
      case 0:
      case 1: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.3;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //2-3 : cyclop
      case 2:
      case 3: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.1;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //4-5 : dog
      case 4:
      case 5: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.1;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //6-7 : eye
      case 6:
      case 7: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.3;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //8-9 : gargoyle
      case 8:
      case 9: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.1;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //10-11 : ghost
      case 10:
      case 11: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.3;
        size = Vector2(60, 60);
        range=50;
      }
      break;
      //12-13 : zombie
      case 12:
      case 13: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.1;
        size = Vector2(60, 60);
        range=50;
      }
      break;

      default: {
        damage = 1;
        health = 100;
        maxHealth = 100;
        speed = 0.1;
        range=50;
        size = Vector2(40, 40);
      }
      break;
    }
  }
}