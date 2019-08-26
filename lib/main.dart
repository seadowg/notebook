import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      builder: (context) => NotesModel(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notebook',
      home: NotesWidget(),
    );
  }
}

class NotesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesModel>(
      builder: (context, notes, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Notebook'),
          ),
          body: ListView.builder(
              itemCount: notes.get().length,
              itemBuilder: (context, position) {
                MapEntry<int, String> note = notes.get()[position];

                return ListTile(
                  title: Text(note.value),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditNoteWidget(id: note.key)),
                    );
                  },
                );
              }),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add Note',
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewNoteWidget(id: notes.add())),
              );
            },
          ),
        );
      },
    );
  }
}

class NewNoteWidget extends StatelessWidget {
  final int id;

  const NewNoteWidget({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Column(children: [
        TextField(
          autofocus: true,
          onChanged: (text) {
            Provider.of<NotesModel>(context, listen: false).set(id, text);
          },
        ),
      ]),
    );
  }
}

class EditNoteWidget extends StatelessWidget {
  final int id;

  const EditNoteWidget({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Column(children: [
        TextField(
          autofocus: true,
          onChanged: (text) {
            Provider.of<NotesModel>(context, listen: false).set(id, text);
          },
        ),
      ]),
    );
  }
}

class NotesModel extends ChangeNotifier {
  Map<int, String> _notes = new HashMap();
  int _nextID = 0;

  List<MapEntry<int, String>> get() {
    return _notes.entries.toList();
  }

  int add() {
    return _nextID++;
  }

  void set(int id, String note) {
    this._notes[id] = note;
    notifyListeners();
  }
}
