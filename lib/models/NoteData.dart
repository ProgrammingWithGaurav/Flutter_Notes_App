import 'package:flutter/material.dart';
import 'package:notes_app_tut/data/hive_db.dart';
import 'package:notes_app_tut/models/Note.dart';

class NoteData extends ChangeNotifier {
  // hive database
  final db = HiveDatabase();

  // initialize list
  void initalizeNotes() {
    allNotes = db.loadNotes();
  }

  // list of notes
  List<Note> allNotes = [];

  // get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  // add a note
  void addNote(Note note) {
    allNotes.add(note);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    db.saveNotes(allNotes);
  }

  // update note
  void updateNote(Note note, String text) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        // replace text
        allNotes[i].text = text;
      }
    }
    notifyListeners();
  }

  // toggle note done
  void toggleDone(Note note) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        // toggle done
        allNotes[i].done = !allNotes[i].done;
      }
    }
    notifyListeners();
  }

  // delete a note
  void deleteNote(Note note) {
    allNotes.remove(note);
    notifyListeners();
  }
}
