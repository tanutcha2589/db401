import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/tile.dart';

class Game extends StatefulWidget {
   final String id;
  const Game({required this.id, super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
   bool _done = false;
 String _symbol = '_';
 String _status = 'C'; // C: challenge, P: playing, D: draw, O: O win, X: X win
 bool _isTurn = false;
 List<List<String>> _filled = [
   ['_', '_', '_'],
   ['_', '_', '_'],
   ['_', '_', '_'],
 ];
 late DocumentReference _game;
  String _gameTitle() {
   if(_done) {
     if(_status == 'D') {
       return 'Draw';
     } else if(_status == _symbol) {
       return 'You win';
     } else {
       return 'You lost';
     }
   } else {
     return 'You are $_symbol';
   }
 }

 Color _gameBackground() {
   if(_status == 'D') {
     return Colors.yellow;
   } else if(_status == 'P' || _status == 'C') {
     return Colors.blueGrey;
   } else if(_status == _symbol) {
     return Colors.green;
   }
   return Colors.red;
 }
 bool _winByRow() {
   for (var row in _filled) {
     var players = <String>{...row};
     if (players.length == 1 && players.first == _symbol) {
       return true;
     }
   }
   return false;
 }

  bool _winByColumn() {
   for (var col = 0; col < 3; col++) {
     var players = <String>{for (var row in [0,1,2]) _filled[row][col]};
     if (players.length == 1 && players.first == _symbol) {
       return true;
     }
   }
   return false;
 }
 
  bool _winByDiagonal() {
   var listOfPlayers = <Set<String>>[];
   listOfPlayers.add({_filled[0][0],_filled[1][1],_filled[2][2]});
   listOfPlayers.add({_filled[0][2],_filled[1][1],_filled[2][0]});
   for (var players in listOfPlayers) {
     if (players.length == 1 && players.first == _symbol) {
       return true;
     }
   }
   return false;
 }

  void _checkResult(int row, int col) {
   if(!_done && _isTurn) {
     setState(() {
       _isTurn = false;
       _filled[row][col] = _symbol;
       String filledString = _filled[0].join('') + _filled[1].join('') + _filled[2].join('');
       if(_winByRow() || _winByColumn() || _winByDiagonal()) {
         _game.update({'filled': filledString, 'status': _symbol});
       } else {
         if(filledString.contains('_')) {
           _game.update({'filled': filledString, 'turn': _symbol == 'O' ? 'X' : 'O'});
         } else {
           _game.update({'filled': filledString, 'status': 'D'});
         }
       }
     });
   }
 }

  @override
 void initState() {
   String playerName = FirebaseAuth.instance.currentUser!.email!;
   playerName = playerName.substring(0, playerName.length - 14);
   _game = FirebaseFirestore.instance.collection('games').doc(widget.id);
   _game.get().then((value) {
     setState(() {
       _symbol = playerName == value['player_o'] ? 'O' : 'X';
     });
   });
   super.initState();
 }
  @override
  Widget build(BuildContext context) {
    void gotoChallenge() {
  Navigator.pushReplacementNamed(context, 'challenge');
}
    return StreamBuilder<DocumentSnapshot>(
  stream: _game.snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    DocumentSnapshot data = snapshot.requireData;
    _isTurn = data['turn'] == _symbol;
    String filledString = data['filled'];
    _filled = [
      filledString.substring(0, 3).split(''),
      filledString.substring(3, 6).split(''),
      filledString.substring(6).split(''),
    ];
    _status = data['status'];
    _done = 'DOX'.contains(_status);
    return Scaffold(
      backgroundColor: _gameBackground(),
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        actions: [
          IconButton(
            icon: Icon(_done ? Icons.table_rows : Icons.flag), 
            onPressed: () async {
              if(!_done) {
                await _game.update({
                  'status': _symbol == 'O' ? 'X' : 'O',
                });
              }
              gotoChallenge();
            }
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _gameTitle(),
            style: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ), 
          ),
          const SizedBox(height: 24,),
          Text(
            _isTurn ? 'Your turn' : 'Opponent',
            style: TextStyle(
              fontSize: 32,
              color: Colors.red.shade900,
            ),
          ),
          const SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tile(row: 0, col: 0, value: _filled[0][0], onTap: _checkResult),
              Tile(row: 0, col: 1, value: _filled[0][1], onTap: _checkResult),
              Tile(row: 0, col: 2, value: _filled[0][2], onTap: _checkResult),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tile(row: 1, col: 0, value: _filled[1][0], onTap: _checkResult),
              Tile(row: 1, col: 1, value: _filled[1][1], onTap: _checkResult),
              Tile(row: 1, col: 2, value: _filled[1][2], onTap: _checkResult),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tile(row: 2, col: 0, value: _filled[2][0], onTap: _checkResult),
              Tile(row: 2, col: 1, value: _filled[2][1], onTap: _checkResult),
              Tile(row: 2, col: 2, value: _filled[2][2], onTap: _checkResult),
            ],
          ),
        ],
      ),
    );
  }
);
  }
}