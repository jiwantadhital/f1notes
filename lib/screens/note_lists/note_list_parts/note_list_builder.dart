import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:f1notes/screens/extracted_notes_widget/note_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesListBuilder extends StatelessWidget {
  final WidgetRef ref;
  final List<Note> notes;
  final bool isFirebase;

  const NotesListBuilder({
    Key? key,
    required this.ref,
    this.isFirebase = true,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsets listPadding = EdgeInsets.all(0);
    const EdgeInsets itemPadding = EdgeInsets.all(8);
    const EdgeInsets itemMargin = EdgeInsets.only(bottom: 10);

    Color backgroundColor = isFirebase
        ? Theme.of(context).primaryColor.withOpacity(0.2)
        : Theme.of(context).disabledColor.withOpacity(0.1);

    return ListView.builder(
      padding: listPadding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Container(
          margin: itemMargin,
          padding: itemPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: NoteBoxWidget(
            title: notes[index].title,
            desc: notes[index].description,
            addedDate: getDateFormat(notes[index].addedDate, showSeconds: true),
            dueDate: getDateFormat(notes[index].dueDate, showSeconds: true),
          ),
        );
      },
    );
  }
}
