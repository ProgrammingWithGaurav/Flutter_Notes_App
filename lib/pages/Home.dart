import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_tut/models/Note.dart';
import 'package:notes_app_tut/models/NoteData.dart';
import 'package:notes_app_tut/pages/EditingNotePage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initalizeNotes();
  }

  void createNewNote() {
    // create a new note
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    // create a blank note
    Note newNote = Note(
      id: id,
      text: "",
    );

    // go to edit the note
    goToNotePage(newNote, true);
  }

  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditingNotePage(
                  note: note,
                  isNewNote: isNewNote,
                )));
  }

  // delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          floatingActionButton: FloatingActionButton(
            onPressed: createNewNote,
            backgroundColor: Colors.grey[300],
            elevation: 0,
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 75),
                  child: Text(
                    "Notes",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  )),

              // list of notes
              value.getAllNotes().length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                          child: Text(
                        "No notes yet.",
                        style: TextStyle(color: Colors.grey[400]),
                      )),
                    )
                  : CupertinoListSection.insetGrouped(
                      children: List.generate(
                          value.getAllNotes().length,
                          (index) => CupertinoListTile(
                              onTap: () => goToNotePage(
                                  value.getAllNotes()[index], false),
                              trailing: IconButton(
                                  onPressed: () =>
                                      deleteNote(value.getAllNotes()[index]),
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent)),
                              title: Text(value.getAllNotes()[index].text))))
            ],
          )),
    );
  }
}
