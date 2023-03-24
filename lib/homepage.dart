// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman_game/path.dart';
import 'package:pacman_game/pixel.dart';
import 'package:pacman_game/player.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;

  int player = numberInRow * 15 + 1;

  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    26,
    38,
    28,
    37,
    39,
    33,
    44,
    55,
    66,
    77,
    78,
    79,
    80,
    81,
    83,
    84,
    85,
    86,
    59,
    70,
    61,
    72,
    99,
    100,
    101,
    102,
    103,
    105,
    106,
    107,
    108,
    110,
    114,
    125,
    116,
    127,
    121,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    132,
    143,
    147,
    148,
    149,
    158,
    160,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    88,
    98,
  ];

  List<int> foodList = [];

  String direction = "right";

  bool mouthClosed = false;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   MyPath(
    //     innerColor: Colors.yellow,
    //     outerColor: Colors.black,
    //   );
    // });
  }

  void startGame() {
    print("Started");
    getFood();
    Timer.periodic(
      const Duration(milliseconds: 250),
      (timer) {
        // setState(() {
        // mouthClosed = !mouthClosed;
        // });

        if (foodList.contains(player)) {
          foodList.remove(player);
        }

        switch (direction) {
          case "left":
            moveLeft();
            break;
          case "right":
            moveRight();
            break;
          case "up":
            moveUp();
            break;
          case "down":
            moveDown();
            break;
        }
      },
    );
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        foodList.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
        print("going " + direction);
      });
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
        print("going " + direction);
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
        print("going " + direction);
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
        print("going " + direction);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    direction = "down";
                  } else if (details.delta.dy < 0) {
                    direction = "up";
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    direction = "right";
                  } else if (details.delta.dx < 0) {
                    direction = "left";
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                  ),
                  itemBuilder: (BuildContext, int index) {
                    if (mouthClosed) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                              // color: Colors.yellow,
                              // shape: BoxShape.circle,
                              ),
                        ),
                      );
                    } else if (player == index) {
                      switch (direction) {
                        case "left":
                          return Transform.rotate(
                            angle: pi,
                            child: const MyPlayer(),
                          );
                        case "right":
                          const MyPlayer();
                          break;
                        case "up":
                          return Transform.rotate(
                            angle: 3 * pi / 2,
                            child: const MyPlayer(),
                          );
                        case "down":
                          return Transform.rotate(
                            angle: pi / 2,
                            child: const MyPlayer(),
                          );
                      }
                      return const MyPlayer();
                    } else if (barriers.contains(index)) {
                      return MyPixel(
                        innerColor: Colors.blue[800],
                        outerColor: Colors.blue[900],
                        // child: Text(index.toString()),
                      );
                    } else if (foodList.contains(index)) {
                      return MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                        // child: Text(index.toString()),
                      );
                    } else {
                      return MyPath(
                        innerColor: Colors.black,
                        outerColor: Colors.black,
                        // child: Text(index.toString()),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // const Text(
                  //   "Score: ",
                  //   style: TextStyle(color: Colors.white, fontSize: 40),
                  // ),
                  GestureDetector(
                    onTap: startGame,
                    child: const Text(
                      "P L A Y ",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
