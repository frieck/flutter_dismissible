// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget likedBuilder(BuildContext context) {
    final Iterable<Widget> tiles = _saved.map(
      (WordPair pair) {
        return _buildRow(pair, true);
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: ListView(children: divided.toList()),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: likedBuilder,
      ),
    );
  }

  Widget _buildSuggestions({bool asDimissible = false}) {
    return ListView.builder(
        //padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
      if (i.isOdd) return Divider(); /*2*/

      final index = i ~/ 2; /*3*/
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10)); /*4*/
      }
      return _buildRow(_suggestions[index], asDimissible);
    });
  }

  Widget _buildRow(WordPair pair, bool asDimissible) {
    final bool alreadySaved = _saved.contains(pair);
    if (asDimissible) {
      return Dismissible(
        key: Key(pair.asLowerCase),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(0.9, 0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        child: ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _saved.remove(pair);
          });
        },
      );
    } else {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
