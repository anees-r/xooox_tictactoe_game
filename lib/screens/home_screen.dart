import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tictactoe_game/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int xWins = 0;
  int oWins = 0;
  int filledTiles = 0;
  bool oTurn = false;
  List<String> displayIcon = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  @override
  Widget build(BuildContext context) {
    // match notification bar color to scaffold color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: mainAccent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: mainAccent,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    xoooxLogo,
                    scale: 3,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  oTurn ? "O's Turn" : "X's Turn",
                  style: headerText,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(50),
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: displayIcon[index] == ""
                                ? mainAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1)),
                        child: Center(
                          child: displayIcon[index].isEmpty
                              ? Container()
                              : SvgPicture.asset(
                                  displayIcon[index],
                                  color: mainAccent,
                                  width: 50,
                                  height: 50,
                                ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "S C O R E B O A R D",
                    style: headerText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Player X:",
                              style: playerText,
                            ),
                            Text(
                              xWins.toString(),
                              style: playerText,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Player O:",
                              style: playerText,
                            ),
                            Text(
                              oWins.toString(),
                              style: playerText,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (displayIcon[index].isEmpty) {
        oTurn ? displayIcon[index] = oIcon : displayIcon[index] = xIcon;
        oTurn = !oTurn;
        filledTiles += 1;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    // check horizontal
    for (int i = 0; i < 7; i += 3) {
      if (displayIcon[i] == displayIcon[i + 1] &&
          displayIcon[i] == displayIcon[i + 2] &&
          displayIcon[i] != "") {
        _showWinnerDialogue(i);
      }
    }

    // check vertical
    for (int i = 0; i < 3; i++) {
      if (displayIcon[i] == displayIcon[i + 3] &&
          displayIcon[i] == displayIcon[i + 6] &&
          displayIcon[i] != "") {
        _showWinnerDialogue(i);
      }
    }

    // check diagonals
    if (displayIcon[0] == displayIcon[4] &&
        displayIcon[0] == displayIcon[8] &&
        displayIcon[0] != "") {
      _showWinnerDialogue(0);
    }
    if (displayIcon[2] == displayIcon[4] &&
        displayIcon[2] == displayIcon[6] &&
        displayIcon[2] != "") {
      _showWinnerDialogue(2);
    } else if (filledTiles == 9) {
      _showDrawDialogue();
    }
  }

  void _showWinnerDialogue(int index) {
    String winner = displayIcon[index] == xIcon ? "Player X" : "Player O";
    displayIcon[index] == xIcon ? xWins++ : oWins++;
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              shadowColor: Colors.black,
              backgroundColor: mainAccent,
              title: Text(
                "V I C T O R Y !",
                style: headerText,
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Winner: $winner",
                style: playerText,
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetGrid();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Change button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(100), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "P L A Y   A G A I N",
                      style: buttonText,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showDrawDialogue() {
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: mainAccent,
              shadowColor: Colors.black,
              title: Text(
                "D R A W !",
                style: headerText,
                textAlign: TextAlign.center,
              ),
              content: Text(
                "It's a draw!",
                style: playerText,
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetGrid();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Change button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(100), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "P L A Y   A G A I N",
                      style: buttonText,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _resetGrid() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayIcon[i] = "";
      }
      filledTiles = 0;
    });
  }
}
