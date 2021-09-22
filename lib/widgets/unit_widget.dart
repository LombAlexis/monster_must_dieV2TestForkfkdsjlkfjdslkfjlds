import 'dart:math';
import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:monster_must_die/models/unit.dart';
import 'package:monster_must_die/widgets/enemywidget.dart';



class UnitWidget extends Unit  {

  //Lier a l'animation
  late SpriteAnimation unitAnimation;
  bool etatChanger=false;
  bool isStopped=false;
  late Sprite lifebar;

  late Images images;


  ///Constructors : prend position [x] [y] et un [type]
  ///de plus [images] pour pouvoir prendre les images depuis le cache directement
  UnitWidget(double x, double y, int type,this.images) : super(x, y, type,images) {
    //Reduit le type de -1 s'il est impair pour start forcement sur une animation de mouvement
    if(type.isOdd){
      type-=1;
    }
    switch(type) {
    //0-1 : archer
      case 0:
      case 1: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/archer/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 30),
            stepTime: 0.1,
          ));
      break;
    //2-3 : balista
      case 2:
      case 3: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/balista/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 30),
            stepTime: 0.1,
          ));
      break;
    //4-5 : berserker
      case 4:
      case 5: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/berserker/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 32),
            stepTime: 0.1,
          ));
      break;
    //6-7 : cavalier
      case 6:
      case 7: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/cavalrer/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 32),
            stepTime: 0.1,
          ));
      break;
    //8-9 : dragon
      case 8:
      case 9: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/dragon/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 32),
            stepTime: 0.1,
          ));
      break;
    //10-11 : marshall
      case 10:
      case 11: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/marshall/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 30),
            stepTime: 0.1,
          ));
      break;
    //12-13 : spear
      case 12:
      case 13: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/spear/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 30),
            stepTime: 0.1,
          ));
      break;
      //14-15 : wizard
      case 14:
      case 15: unitAnimation = SpriteAnimation.fromFrameData(
          images.fromCache('Unit/wizard/moving.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            amountPerRow: 1,
            textureSize: Vector2(32, 30),
            stepTime: 0.1,
          ));
      break;

      default: {
        unitAnimation=SpriteAnimation.fromFrameData(
            images.fromCache('heheboy.png'),
            SpriteAnimationData.sequenced(
              amount: 19,
              textureSize: Vector2(700, 660),
              stepTime: 0.1,
            ));
      }
      break;
    }

    lifebar=Sprite(images.fromCache('lifebar.png'));
  }


  ///Avec le [dt] : deltaTime, on update l'animation sur la next frame
  ///puis on fait un calculer vectorielle pour pouvoir se diriger vers une [target] avec une certaine [speed]
  void updateMovUnit(double dt,double speed,EnemyWidget target) {
    unitAnimation.update(dt);
    playing=true;
    super.update(dt);

    double vectorX=target.getPosition().x-getPosition().x;
    double vectorY=target.getPosition().y-getPosition().y;

    double length=sqrt(vectorX*vectorX+vectorY*vectorY);
    double newVectorX = 0;
    double newVectorY = 0;
    //Si pas d'ennemie ducoup target = soi meme
    if(length!=0) {
       newVectorX = vectorX / length;
       newVectorY = vectorY / length;
    }
    position=Vector2(getPosition().x+newVectorX*speed,getPosition().y+newVectorY*speed);
    setPosition(Vector2(getPosition().x+newVectorX*speed,getPosition().y+newVectorY*speed));
  }

  ///Avec le [dt] : deltaTime, on update l'animation sur la next frame
  ///On attaque la [target] avec sa stats de degats
  void attaque(double dt,EnemyWidget target) {
    unitAnimation.update(dt);
    target.health-=damage;

  }

  ///Fonction appeller pour pouvoir faire apparaitre l'unit a la bonne position ainsi que sa barre de pv dans le [canvas]
  void renderUnit(Canvas canvas) {
    if(health==maxHealth) {
      flipHorizontally();
    }
    canvas.save();

    super.render(canvas);
    //animation?.getSprite().render(canvas,position: getPosition(),size:unitSize);

    /*unitAnimation
        .getSprite()
        .render(canvas, position: getPosition(), size: unitSize);*/
    canvas.restore();
    lifebar.render(canvas, position: Vector2(getPosition().x,getPosition().y-10), size: Vector2((unitSize.x*health)/maxHealth,10));
  }

  ///Creer une unit avec une position à la pos [x] et [y]
  ///Accessible statiquement
  static UnitWidget unitWidgetSpawn(double x, double y, int type,Images images){
    return UnitWidget(x, y, type,images);
  }

  ///Prends [ens] qui est la liste de tous les ennemies vivantes actuellement
  ///Le but de cette fonction est de regarder chaque unit et prend la plus proche puis
  ///regarder si l'ennemie est dans sa range
  ///Si oui alors renvoie l'ennemie le plus proche pour l'attaque
  ///sinon renvoie soit l'ennemie le plus proche mais pas a portee d'attaque
  EnemyWidget checkInRangeEnnemie(List<EnemyWidget> ens ){
    bool canHit=true;
    double enemyX,enemyY;
    //get sa position au centre du sprite
    double unitX=getPosition().x+unitSize.x/2,unitY=getPosition().y+unitSize.y/2;

    EnemyWidget plusProche=EnemyWidget(getPosition().x, getPosition().y, 0,images);
    double proximite=9999999;
    double tempProxi=9999999;

    for(int ii=0;ii<ens.length;ii++) {
      //Check si ennemie=arien et qu'on peut taper
      if((ens[ii].type == 8 || ens[ii].type == 9) && type > 3) {
        canHit=false;
      }
      //mage peut taper ghost
      else if((ens[ii].type == 10 || ens[ii].type == 11) && (type != 14 || type != 15)){
        canHit=false;
      }
      else {
        canHit=true;
      }
      if (canHit) {
        //get la position au centre du sprit de l'ennemie
        enemyX = ens[ii].getPosition().x + ens[ii].enemySize.x / 2;
        enemyY = ens[ii].getPosition().y + ens[ii].enemySize.y / 2;

        tempProxi = sqrt(pow(enemyX - unitX, 2) + pow(enemyY - unitY, 2));

        if (tempProxi < proximite) {
          plusProche = ens[ii];
          proximite = tempProxi;
        }
      }
    }
    if (proximite <= range) {
      isStopped = true;
      return plusProche;
    }
    isStopped=false;
    return plusProche;
  }

  ///Dit si les PV sont > 0
  bool isAlive(){
    return health>0?true:false;
  }

  ///Permet d'actualiser l'animation en changeant son type grace a [modificateurType] qui est  1 ou -1
  ///Passe entre moving<->attacking
  void actualisationAnim(int modificateurType){
    if(etatChanger) {
      type += modificateurType;

      switch (type) {
      //0-1 : archer
        case 0:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/archer/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 30),
                stepTime: 0.1,
              ));
          break;
        case 1: unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/archer/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 25,
              textureSize: Vector2(50, 50),
              stepTime: 0.1,
            ));
        break;
      //2-3 : balista
        case 2:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/balista/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 30),
                stepTime: 0.1,
              ));
          break;
        case 3: unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/balista/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 10,
              textureSize: Vector2(80, 80),
              stepTime: 0.1,
            ));
        break;
      //4-5 : berserker
        case 4:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/berserker/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 32),
                stepTime: 0.1,
              ));
          break;
        case 5:
          unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/berserker/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 12,
              textureSize: Vector2(100, 80),
              stepTime: 0.1,
            ));
        break;
      //6-7 : cavalier
        case 6:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/cavalrer/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 32),
                stepTime: 0.1,
              ));
          break;
        case 7:
          unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/cavalrer/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 21,
              textureSize: Vector2(140, 80),
              stepTime: 0.1,
            ));
        break;
      //8-9 : dragon
        case 8:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/dragon/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 32),
                stepTime: 0.1,
              ));
          break;
        case 9:
          unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/dragon/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 20,
              textureSize: Vector2(140, 110),
              stepTime: 0.1,
            ));
        break;
      //10-11 : marshall
        case 10:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/marshall/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 30),
                stepTime: 0.1,
              ));
          break;
        case 11: unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/marshall/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 31,
              textureSize: Vector2(140, 95),
              stepTime: 0.1,
            ));
        break;
      //12-13 : spear
        case 12:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/spear/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 30),
                stepTime: 0.1,
              ));
          break;
        case 13:
          unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/spear/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 26,
              textureSize: Vector2(90, 60),
              stepTime: 0.1,
            ));
        break;
      //14-15 : wizard
        case 14:
          unitAnimation=SpriteAnimation.fromFrameData(
              images.fromCache('Unit/wizard/moving.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                amountPerRow: 1,
                textureSize: Vector2(32, 30),
                stepTime: 0.1,
              ));
          break;
        case 15:
          unitAnimation = SpriteAnimation.fromFrameData(
            images.fromCache('Unit/wizard/attack.png'),
            SpriteAnimationData.sequenced(
              amount: 19,
              textureSize: Vector2(90, 100),
              stepTime: 0.1,
            ));
        break;
        default:
          break;
      }
    }
  }
}