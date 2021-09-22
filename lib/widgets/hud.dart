import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../games/gameloader.dart';
import '../models/player_data.dart';


class Hud extends StatelessWidget {

  // An unique identified for this overlay.
  static const id = 'Hud';

  // Reference to parent game.
  final GameLoader gameRef;

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  ///Build l'hud du jeu
  ///Il est build avec ChangeNotifierProvider qui permet à certaines valeur de changer automatiquement si elles sont changer ailleurs et notifier
  ///le build ici consiste a une colonne avec une ligne situé tout en bas avec des textes
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0,left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.waves,
                  builder: (_, waves, __) {
                    return Expanded (
                      child:Text(
                        'Waves: $waves',
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      )
                    );
                  },
                ),
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.lives,
                  builder: (_, lives, __) {
                    return Expanded (
                        child:Text(
                          'Lives: $lives',
                          style: TextStyle(color: Colors.white,fontSize: 20),
                        )
                    );
                  },
                ),
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.pointsPerso,
                  builder: (_, pointsPerso, __) {
                    return Expanded(
                      child: Text(
                        'pointsPerso: $pointsPerso',
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      ),
                    );
                  },
                ),
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.pointsCoop,
                  builder: (_, pointsCoop, __) {
                    return Expanded(
                      child: Text(
                        'pointsCoop: $pointsCoop',
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
