import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:monster_must_die/controller/wavecontroller.dart';
import 'package:monster_must_die/widgets/enemywidget.dart';
import 'package:monster_must_die/widgets/unit_widget.dart';

import '../models/player_data.dart';

class GameLoader extends FlameGame {
  //Permet de mettre en cache les images plus tard
  static const _imageAssets = [
    'heheboy.png',
    'lifebar.png',
    'lifebarRouge.png',
    'fe.png',
    'Enemy/zombie/attack.png',
    'Enemy/ghost/moving.png',
    'Enemy/gargoyle/attack.png',
    'Enemy/eye/moving.png',
    'Enemy/dog/attack.png',
    'Enemy/cyclop/attack.png',
    'Enemy/archer/attack.png',
    'Unit/archer/attack.png',
    'Unit/balista/attack.png',
    'Unit/berserker/attack.png',
    'Unit/cavalrer/attack.png',
    'Unit/dragon/attack.png',
    'Unit/marshall/attack.png',
    'Unit/spear/attack.png',
    'Unit/wizard/attack.png',
    'Enemy/zombie/moving.png',
    'Enemy/gargoyle/moving.png',
    'Enemy/dog/moving.png',
    'Enemy/cyclop/moving.png',
    'Enemy/archer/moving.png',
    'Unit/archer/moving.png',
    'Unit/balista/moving.png',
    'Unit/berserker/moving.png',
    'Unit/cavalrer/moving.png',
    'Unit/dragon/moving.png',
    'Unit/marshall/moving.png',
    'Unit/spear/moving.png',
    'Unit/wizard/moving.png',
    'Background/field.png',
    'Background/fog.png',
    'Background/forest.png',
    'Background/rain.png',
    'Background/swamp.png',
    'Background/volcano.png',
  ];

  late SpriteComponent background;
  late int typeBg = 5;

  late PlayerData playerData;

  //Listes des unit/ennemie qui vont apparaitre
  late List<EnemyWidget> listEnemy;
  late List<UnitWidget> listUnit;

  //boolean temp pour voir si unit/ennemy ne bouge plus
  late bool tempAStopper;

  ///Charger plusieurs element au debut du jeu
  @override
  Future<void> onLoad() async {
    await images.loadAll(_imageAssets);
    playerData = PlayerData();
    listUnit = List.empty(growable: true);
    listEnemy = List.empty(growable: true);
    changeBackground(typeBg);
  }

  ///Lance le jeu en creant pour l'instant des ennemies random
  void startGame() {
    /*for(int i = 0; i < 5 ; i++){
      listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 0,images));
    }
    //TODO y supprimer plus tard
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 2,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 4,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 6,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 8,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 10,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 12,images));*/
    WaveController.newWave(7, listEnemy, 0.toDouble(), size.x, 0, size.y / 3, images, playerData);

  }

  void changeBackground(int typeBg) {
    switch (typeBg) {
      case 0:
        background = SpriteComponent.fromImage(images.fromCache("Background/field.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(256,160 ),
            position: Vector2(0, 0));
        break;
      case 1:
        background = SpriteComponent.fromImage(images.fromCache("Background/fog.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(240,160 ),
            position: Vector2(0, 0));
        break;
      case 2:
        background = SpriteComponent.fromImage(images.fromCache("Background/forest.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(240, 160),
            position: Vector2(0, 0));
        break;
      case 3:
        background = SpriteComponent.fromImage(images.fromCache("Background/rain.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(240,160 ),
            position: Vector2(0, 0));
        break;
      case 4:
        background = SpriteComponent.fromImage(images.fromCache("Background/swamp.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(1280,960 ),
            position: Vector2(0, 0));
        break;
      case 5:
        background = SpriteComponent.fromImage(images.fromCache("Background/volcano.png"),
            size: Vector2(size.x, size.y),
            srcSize: Vector2(256,160 ),
            position: Vector2(0, 0));
        break;
      default:
        break;
    }
  }

  ///Execute chaque frame pour render les differents choses sur le [canvas]
  @override
  void render(Canvas canvas) {
    canvas.save();
    background.render(canvas);
    canvas.restore();
    for (int i = 0; i < listUnit.length; i++) {
      listUnit[i].renderUnit(canvas);
    }

    for (int i = 0; i < listEnemy.length; i++) {
      listEnemy[i].renderEnemy(canvas);
    }
  }

  ///Executer chaque frame pour update certaines action dont les mouvements avec un [dt]
  @override
  void update(double dt) {
    //LOGIQUE POUR UNIT ALLIER
    for (int i = 0; i < listUnit.length; i++) {
      EffectOfBg(listUnit[i]);
      EnemyWidget target = EnemyWidget(0, 0, 0, images);
      if (listUnit[i].isAlive()) {
        if (listEnemy.isNotEmpty) {
          tempAStopper = listUnit[i].isStopped;

          target = listUnit[i].checkInRangeEnnemie(listEnemy);

          if (tempAStopper == listUnit[i].isStopped) {
            listUnit[i].etatChanger = false;
          } else {
            listUnit[i].etatChanger = true;
          }

          if (!listUnit[i].isStopped) {
            //Move TOWARDS nearest ennemy
            listUnit[i].updateMovUnit(dt, listUnit[i].speed, target);
            listUnit[i].actualisationAnim(-1);
          } else {
            listUnit[i].attaque(dt, target);
            listUnit[i].actualisationAnim(1);
          }
        }
      } else {
        listUnit.removeAt(i);
      }
    }
    //LOGIQUE POUR ENEMIES
    for (int i = 0; i < listEnemy.length; i++) {
      EffectOfBg(listEnemy[i]);
      UnitWidget target = UnitWidget(0, 0, 0, images, null, 0);
      if (listEnemy[i].isAlive()) {
        tempAStopper = listEnemy[i].isStopped;
        target = listEnemy[i].checkInRangeUnit(listUnit, size);
        if (tempAStopper == listEnemy[i].isStopped) {
          listEnemy[i].etatChanger = false;
        } else {
          listEnemy[i].etatChanger = true;
        }

        if (!listEnemy[i].isStopped) {
          //Move TOWARDS nearest ennemy
          listEnemy[i].updateMovEnemie(dt, listEnemy[i].speed, target);
          listEnemy[i].actualisationAnim(-1);
        } else {
          listEnemy[i].attaque(dt, target);
          listEnemy[i].actualisationAnim(1);
        }

        if (listEnemy[i].position.y > size.y) {
          playerData.lives -= 1;
          listEnemy.removeAt(i);
        }
      } else {
        listEnemy.removeAt(i);
      }
    }
  }

  void EffectOfBg(var unit) {
    switch (typeBg) {
      //FOG
      case 1:
        if(unit.isRanged && unit.effetUnique){
          unit.range/=2;
          unit.effetUnique=false;
        }
        break;
        //FOREST
      case 2:
        if(unit.isFlying){
          unit.health-=0.1;
        }
        break;
        //RAIN
      case 3:
        if(unit.isFlying&& unit.effetUnique){
          if(unit.speed>0.4) {
            unit.speed-=0.4;
          } else {
            unit.speed=0.2;
          }
          unit.effetUnique=false;
        }
        break;
        //SWAMP
      case 4:
        if(!unit.isFlying && unit.effetUnique){
          if(unit.speed>0.4) {
            unit.speed-=0.4;
          } else {
            unit.speed=0.2;
          }
          unit.effetUnique=false;
        }
        break;
        //VOLCANO
      case 5:
        if(!unit.isFlying){
          unit.health-=0.1;
        }
        break;
      default:
        break;
    }
  }
}
