import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_tut/models/Note.dart';

class HiveDatabase {
  // reference hive box
  final _myBox = Hive.box('notes_db');

  // get notes
  List<Note> loadNotes() {
    List<Note> savedNotesFormatted = [];
    if (_myBox.get("all_notes") != null) {
      List<dynamic> savedNotes = _myBox.get("all_notes");
      for (int i = 0; i < savedNotes.length; i++) {
        Note note = Note(
            id: savedNotes[i][0],
            text: savedNotes[i][1],
            done: savedNotes[i][2]);
        savedNotesFormatted.add(note);
      }
    } else {
      // default first note
      Note note = Note(
        id: 0,
        text: "Welcome to Notes App!",
      );
      savedNotesFormatted.add(note);
    }
    return savedNotesFormatted;
  }

  // save notes
  void saveNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [];

    for (var note in allNotes) {
      int id = note.id;
      String text = note.text;
      bool done = note.done;
      allNotesFormatted.add([id, text, done]);
    }

    // add note
    _myBox.put('all_notes', allNotesFormatted);
  }
}
