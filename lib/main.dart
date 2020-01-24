import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  reset() {
    player1score = 0;
    player2score = 0;
    timer1 = 10;
    timer2 = 10;
  }

  static AudioCache player = AudioCache();
  Future popup(int player1, int player2, String win) async {
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Color(0xFF4BCFFA),
          title: Text(
            '    SCORE CARD',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          content: Container(
            height: 250,
            width: 100,
            child: Center(
                child: Column(
              children: <Widget>[
                Text(
                  '🏆',
                  style: TextStyle(fontSize: 80),
                ),
                Text("WINNER : $win",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                Text(
                  "PLAYER 1 SCORE : $player1score",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text("PLAYER 2 SCORE : $player2score",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
               
                //winnersound()
              ],
            )),
          ),
        );
      },
    );
  }

  time() {
    player.play("timer.wav");
  }

  dicesound() {
    player.play("dice.wav");
  }

  winnersound() {
    player.play("winner.wav");
  }

  bool disble = true;
  bool diceroll = true;
  var img = "dice1.png";
  var img2 = "dice1.png";
  int round = 5;
  int player1score = 0, player2score = 0;
  int timer1 = 10, timer2 = 10;
  Timer t1, t2;

  //For First Dice
  pressed1() {
    dicesound();
    if (round >= 1) {
      setState(() {
        var a = Random().nextInt(6) + 1;
        img = "dice$a.png";
        player1score = player1score + a;
        disble = false;
        diceroll = false;
        timer2 = 10;
      });
      starttimer2();
    } else {
      return null;
    }
  }

  pressed2() {
    dicesound();
    if (round >= 1) {
      setState(() {
        var a = Random().nextInt(6) + 1;
        img2 = "dice$a.png";
        player2score = player2score + a;
        disble = true;
        diceroll = true;
        timer1 = 10;

        round--;
      });
      starttimer1();
    } else {
      return null;
    }
  }

  void starttimer1() async {
    if (round >= 1) {
      Timer.periodic(Duration(seconds: 1), (t1) {
        setState(() {
          if (!diceroll) {
            t1.cancel();
          } else {
            if (timer1 < 1) {
              t1.cancel();
              timer2 = 10;
              diceroll = false;
              starttimer2();
              disble = false;
            } else {
              timer1 = timer1 - 1;
              time();
            }
          }
        });
      });
    } else {
      winnersound();
      if (player1score > player2score) {
        popup(player1score, player2score, "PLAYER 1");
      } else {
        popup(player1score, player2score, "PLAYER 2");
      }
    }
  }

  void starttimer2() async {
    if (round >= 1) {
      Timer.periodic(Duration(seconds: 1), (t2) {
        setState(() {
          if (diceroll) {
            t2.cancel();
          } else {
            if (timer2 < 1) {
              t2.cancel();
              timer1 = 10;
              diceroll = true;
              starttimer1();
              disble = true;
            } else {
              timer2 = timer2 - 1;
              time();
            }
          }
        });
      });
    } else {
      winnersound();
      if (player1score > player2score) {
        popup(player1score, player2score, "PLAYER 1");
      } else {
        popup(player1score, player2score, "PLAYER 2");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Color(0xFF4BCFFA)),
        home: Scaffold(
          backgroundColor: Color(0xFFEAF0F1),
          appBar: AppBar(
            title: Text(
              "Roll the Dice",
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            backgroundColor: Color(0xFF4BCFFA),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "SCORE -> $player1score ",
                          style:
                              TextStyle(fontSize: 24, color: Color(0xFF487EB0)),
                        )),
                    Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(left: 80),
                        child: Text(
                          "⏰ $timer1",
                          style: TextStyle(fontSize: 38),
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                GestureDetector(
                    onTap: () {
                      if (disble) {
                        pressed1();
                      } else {
                        return null;
                      }
                    },
                    child:
                        Image(height: 150, image: AssetImage("images/" + img))),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                GestureDetector(
                    onTap: () {
                      if (!disble) {
                        pressed2();
                      } else {
                        return null;
                      }
                    },
                    child: Image(
                        height: 150, image: AssetImage("images/" + img2))),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 20, bottom: 30, top: 20),
                        child: Text(
                          "SCORE -> $player2score",
                          style:
                              TextStyle(fontSize: 24, color: Color(0XFF487EB0)),
                        )),
                    Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 80, bottom: 10, top: 20),
                        child: Text(
                          "⏰ $timer2",
                          style: TextStyle(fontSize: 38),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
