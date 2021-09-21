import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:monster_must_die/widgets/enemywidget.dart';
import 'package:monster_must_die/widgets/unit_widget.dart';

import '../models/player_data.dart';


class GameLoader extends BaseGame {
  static const _imageAssets = [
    'heheboy.png',
    'Archer.png',
    'Axe.png',
    'Bishop.png',
    'CavArcher.png',
    'Lance.png',
    'Mage.png',
    'lifebar.png',
    'lifebarRouge.png',
    'fe.png',
    'Lance_attaque_anim.png',
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
  ];
  // A constant speed, represented in logical pixels per second
  static const int squareSpeed = 400;

  late PlayerData playerData;

  // BasicPalette is a help class from Flame, which provides default, pre-built instances
  // of Paint that can be used by your game
  static final squarePaint = BasicPalette.white.paint;

  late List<EnemyWidget> listEnemy;

  late List<UnitWidget> listUnit;
  late bool tempAStopper;

  @override
  Future<void> onLoad() async {
    await images.loadAll(_imageAssets);
    playerData=PlayerData();

    listUnit = List.empty(growable: true);
    listEnemy = List.empty(growable: true);
  }
  void startGame(){
    for(int i = 0; i < 20 ; i++){
      listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 0,images));
    }
    //TODO y supprimer plus tard
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 2,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 4,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 6,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 8,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 10,images));
    listEnemy.add(EnemyWidget.enemyWidgetRandom(20, size.x - 20, 20, size.y - 20, 12,images));

    listUnit.add(UnitWidget.unitWidgetSpawn(size.x/2 , size.y - 40, 12, images));

  }

  @override
  void render(Canvas canvas) {

    for(int i = 0; i < listUnit.length; i++)
    {
      listUnit[i].renderUnit(canvas);
    }

    for(int i = 0; i < listEnemy.length; i++)
    {
      listEnemy[i].renderEnemy(canvas);
    }
  }

  @override
  void update(double dt) {

    //LOGIQUE POUR UNIT ALLIER
    for(int i = 0; i < listUnit.length; i++)
    {
      EnemyWidget target=EnemyWidget(0,0,0,images);
      if(listUnit[i].isAlive()) {
        if (listEnemy.isNotEmpty) {
          tempAStopper = listUnit[i].isStopped;

          target = listUnit[i].checkInRangeEnnemie(listEnemy);

          if (tempAStopper == listUnit[i].isStopped) {
            listUnit[i].etatChanger = false;
          }
          else {
            listUnit[i].etatChanger = true;
          }

          if (!listUnit[i].isStopped) {
            //Move TOWARDS nearest ennemy
            listUnit[i].updateMovUnit(dt, listUnit[i].speed, target);
            listUnit[i].actualisationAnim(-1);
          }
          else {
            listUnit[i].attaque(dt, target);
            listUnit[i].actualisationAnim(1);
          }
        }
      }
      else {
        listUnit.removeAt(i);
      }
    }
    //LOGIQUE POUR ENEMIES
    for(int i = 0; i < listEnemy.length; i++)
    {
      UnitWidget target=UnitWidget(0,0,0,images);
      if(listEnemy[i].isAlive()) {
        tempAStopper=listEnemy[i].isStopped;
        target = listEnemy[i].checkInRangeUnit(listUnit,size);

        if(tempAStopper==listEnemy[i].isStopped){
          listEnemy[i].etatChanger=false;
        }
        else{
          listEnemy[i].etatChanger=true;
        }

        if(!listEnemy[i].isStopped) {
          //Move TOWARDS nearest ennemy
          listEnemy[i].updateMovEnemie(dt, listEnemy[i].speed,target);
          listEnemy[i].actualisationAnim(-1);
        }
        else{
          listEnemy[i].attaque(dt,target);
          listEnemy[i].actualisationAnim(1);
        }

        if (listEnemy[i].getPosition().y > size.y) {
          playerData.lives -= 1;
          listEnemy.removeAt(i);
        }
      }
      else {
        listEnemy.removeAt(i);
      }
    }


    //HIERARCHIE EN COMMENTAIRES DES FUTURS FONCTIONS COTE ENNEMIES
    //check si en vie

    //check si un unit from unitList a porte
      //ATTENTION METTRE UN BOOLEAN SI PAS BESOIN DE RECHANGER ANIMATION
      //Si non alors change animation to avance
      //Si oui alors change animation puis attaque

    //HIERARCHIE EN COMMENTAIRES DES FUTURS FONCTIONS COTE Unit
    //check si en vie

    //check si un unit from unitList a porte
      //ATTENTION METTRE UN BOOLEAN SI PAS BESOIN DE RECHANGER ANIMATION
      //Si non alors change animation to avance VERS ennemie plus proche
      //Si oui alors change animation puis attaque

    //HIERARCHIE EN COMMENTAIRES DES FUTURS FONCTIONS de la suite
    //Check nb ennemie si 0 faire l'etape de pause
    //si >0 rien faire
  }


}

