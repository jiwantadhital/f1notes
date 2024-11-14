import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1notes/data/model/note.dart';

class FirebaseNoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<List<Note>> getNotes(String deviceId) async {
  try {
    DocumentSnapshot document = await _firestore.collection('notes').doc(deviceId).get();

    if (!document.exists) return [];

    List<dynamic> notesData = document['notes'];
    List<Note> notes = notesData.map((noteData) {
      return Note.fromMap(Map<String, dynamic>.from(noteData));
    }).toList();

    return notes;
  } catch (e) {
    return [];
  }
}


Future<List<Note>> getFilteredNotes(String deviceId, {String? searchText, DateTime? startDate, DateTime? endDate}) async {
  try {
    if ((searchText == null || searchText.isEmpty) && startDate == null && endDate == null) {
      return [];
    }
    else{

    DocumentSnapshot document = await _firestore.collection('notes').doc(deviceId).get();

    if (!document.exists) return [];

    List<dynamic> notesData = document['notes'];
    List<Note> notes = notesData.map((noteData) {
      return Note.fromMap(Map<String, dynamic>.from(noteData));
    }).toList();

    if (searchText != null && searchText.isNotEmpty) {
      notes = notes.where((note) {
        return note.title.contains(searchText) ||
               note.description.contains(searchText) ||
               note.addedDate.toString().contains(searchText) ||
               note.dueDate.toString().contains(searchText);
      }).toList();
    }

    if (startDate != null && endDate != null) {
      notes = notes.where((note) {
        bool isAddedDateInRange = (note.addedDate.isAfter(startDate) || note.addedDate.isAtSameMomentAs(startDate)) &&
                                  (note.addedDate.isBefore(endDate) || note.addedDate.isAtSameMomentAs(endDate));
        bool isDueDateInRange = (note.dueDate.isAfter(startDate) || note.dueDate.isAtSameMomentAs(startDate)) &&
                                (note.dueDate.isBefore(endDate) || note.dueDate.isAtSameMomentAs(endDate));
        return isAddedDateInRange || isDueDateInRange;
      }).toList();
    }

    return notes;
    }
  } catch (e) {
    return [];
  }
}



}
