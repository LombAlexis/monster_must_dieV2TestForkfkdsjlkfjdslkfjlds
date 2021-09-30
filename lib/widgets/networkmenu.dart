import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:monster_must_die/games/gamesetting.dart';
import 'hud.dart';
import 'package:numberpicker/numberpicker.dart';


class NetworkMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'Net';

  // Reference to parent game.
  final GameSetting gameRef;

  const NetworkMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  _NetworkMenu createState() => _NetworkMenu(this.gameRef);
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _NetworkMenu extends State<NetworkMenu> {

  GameSetting gameRef;
  int _currentValue = 3;

  IPField field1 = IPField(192);
  IPField field2 = IPField(168);
  IPField field3 = IPField(1);
  IPField field4 = IPField(100);

  _NetworkMenu(this.gameRef);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.black.withAlpha(100),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 100),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Where is the server ?',
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                ),
                              ),
                              Row(children: [
                                field1,
                                field2,
                                field3,
                                field4,
                                ElevatedButton(
                                  onPressed: () async {
                                    gameRef.socketFromIP(
                                        field1.val.toString() +
                                            '.' +
                                            field2.val.toString() +
                                            '.' +
                                            field3.val.toString() +
                                            '.' +
                                            field4.val.toString()
                                    );
                                    await Future.delayed(const Duration(seconds: 3), (){});
                                    /*
                                    while(gameRef.socketCreated == false) /////////////////////////////////////////////// if the socket don't connect, let's Alt+F4 !
                                    {
                                      await Future.delayed(const Duration(microseconds: 100), (){});
                                    }*/
                                    gameRef.startGame();
                                    gameRef.setUnitType();

                                    gameRef.overlays.remove(NetworkMenu.id);
                                    gameRef.overlays.add(Hud.id);
                                  },
                                  child: Text(
                                    'Connect',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(height: 32),
                              Row(children: [
                                Text(
                                  'If the server is on local network',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).devicePixelRatio * 8,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 32),
                                ElevatedButton(
                                  onPressed: () async {
                                    gameRef.unknowLocalIP();
                                    await Future.delayed(const Duration(seconds: 4), (){});
                                    /*
                                    while(gameRef.socketCreated == false)
                                    {
                                      await Future.delayed(const Duration(microseconds: 100), (){});
                                    }*/
                                    gameRef.startGame();
                                    gameRef.setUnitType();

                                    gameRef.overlays.remove(NetworkMenu.id);
                                    gameRef.overlays.add(Hud.id);
                                  },
                                  child: Text(
                                    'Auto-connect',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ]),
                            ]))))));
  }
}

///This is the widget where we select one number of the IP adress
class IPField extends StatefulWidget {
  late int val;

  IPField(this.val, {Key? key}) : super(key: key);

  @override
  IPFieldState createState() => IPFieldState();
}

class IPFieldState extends State<IPField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          textStyle: TextStyle(color: Colors.grey),
          selectedTextStyle: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).devicePixelRatio * 9),
          value: widget.val,
          step: 1,
          minValue: 0,
          maxValue: 255,
          onChanged: (value) => setState(() => widget.val = value),
        ),
        Visibility(
          visible:  MediaQuery.of(context).size.width > 500 == true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                color: Colors.white,
                onPressed: () => setState(() {
                  final newValue = widget.val - 1;
                  widget.val = newValue.clamp(0, 255);
                }),
              ),
              Text(widget.val.toString(), style: TextStyle(color: Colors.white)),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () => setState(() {
                  final newValue = widget.val + 1;
                  widget.val = newValue.clamp(0, 255);
                }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
