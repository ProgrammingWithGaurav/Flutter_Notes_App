import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_app_tut/models/Note.dart';
import 'package:notes_app_tut/models/NoteData.dart';
import 'package:provider/provider.dart';

class EditingNotePage extends StatefulWidget {
  Note note;
  bool isNewNote;
  EditingNotePage({super.key, required this.note, required this.isNewNote});

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  // add a new note
  void addNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    // get text
    String text = _controller.document.toPlainText();
    Provider.of<NoteData>(context, listen: false)
        .addNote(Note(id: id, text: text));
  }

  // update an existing note
  void updateExistingNote() {
    // get text
    String text = _controller.document.toPlainText();
    // update note
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // if new note,
              if (widget.isNewNote && !_controller.document.isEmpty()) {
                // add new note
                addNewNote();
              } else {
                // update existing note
                updateExistingNote();
              }
              // go back
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        body: Column(children: [
          // tool bar
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              // set all to false except undo redo
              showBoldButton: false,
              showItalicButton: false,
              showUnderLineButton: false,
              showStrikeThrough: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showHeaderStyle: false,
              showListCheck: false,
              showListBullets: false,
              showListNumbers: false,
              showIndent: false,
              showQuote: false,
              showCodeBlock: false,
              showSearchButton: false,
              showFontFamily: false,
              showFontSize: false,
              showLink: false,
              showSubscript: false,
              showSuperscript: false,
              showInlineCode: false,
            ),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(25),
                  child: QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                        controller: _controller, readOnly: false),
                  )))
        ]));
  }
}
