import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
                MapEntry<String, String> note = notes.get()[position];

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
  final String id;

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
  final String id;

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
  Map<String, String> _notes = new HashMap();


  NotesModel() {
    _loadFromPrefs();
  }

  List<MapEntry<String, String>> get() {
    return _notes.entries.toList();
  }

  String add() {
    return new Uuid().v1();
  }

  void set(String id, String note) {
    this._notes[id] = note;
    _saveNotes();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList("notes_index");

    ids.forEach((id) {
      _notes[id] = prefs.getString("notes:$id");
    });

    notifyListeners();
  }

  void _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notes_index", _notes.keys.map((id) => id.toString()).toList());
    _notes.forEach((key, value) => prefs.setString("notes:$key", value));
  }
}
