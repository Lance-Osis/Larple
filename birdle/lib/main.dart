import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType){
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
        child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: GamePage()),
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Larple'),
          ),
        ), 
        
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (final guess in _game.guesses)
            Row(
              spacing:5.0,
              children:[
                for (var letter in guess)
                  Tile(letter.char, letter.type)
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
              });
            }
          )
        ]
      ),
    );
  }
}

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  State<GuessInput> createState() => _guessInputState();
}

class _guessInputState extends State<GuessInput> {
  final TextEditingController _textEdit = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    widget.onSubmitGuess(_textEdit.text.trim());
    _textEdit.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textEdit.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //building the UI next
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                )
              ),
              controller: _textEdit,
              focusNode: _focusNode,
              autofocus: true,
              onSubmitted: (input) {
                _onSubmit();
              },
            )
          )
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit
        )
      ]
    );
  }

}