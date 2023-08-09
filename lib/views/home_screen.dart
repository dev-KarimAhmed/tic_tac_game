import 'package:flutter/material.dart';

import '../logic/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  int turns = 0;
  bool gameOver = false;
  String result = '';
  Game game = Game();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait ?  Column(
        children: [
          ...firstBlock(),
          _expanded(context),
          ...lastBlock(),
        ],
      ): Row(
       children: [
         Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ...firstBlock(),
          const SizedBox(height: 20,),
          ...lastBlock(),        
         ],
          ),
        ),
          _expanded(context),
       ],
      ),
      ) ,
    );
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
        child: GridView.count(
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      crossAxisCount: 3,
      children: List.generate(
          9,
          (index) => GestureDetector(
                onTap: gameOver ? null : () => onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                        Player.playerX.contains(index)
                            ? 'X'
                            : Player.playerO.contains(index)
                                ? 'O'
                                : '',
                        style: TextStyle(
                            color: Player.playerX.contains(index)
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 58)),
                  ),
                ),
              )),
    ));
  }

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turns != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turns++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = 'Winner player is $winnerPlayer';
      } else if (!gameOver && turns == 9) {
        result = 'It\'s Draw';
      }
    });
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            'Turn on/off two players',
            style: TextStyle(color: Colors.white),
          ),
          value: isSwitched,
          onChanged: (newVal) {
            setState(() {
              isSwitched = newVal;
            });
          }),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 58),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
        Text(
            result.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 58),
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Player.playerX = [];
                Player.playerO = [];
                activePlayer = 'x';
                turns = 0;
                gameOver = false;
                result = '';
              });
            },
            label: const Text('Repeat the game'),
            icon: const Icon(Icons.replay),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).splashColor),
          )
        
    ];
  }
}
