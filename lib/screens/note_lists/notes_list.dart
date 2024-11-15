import 'package:animations/animations.dart';
import 'package:f1notes/data/model/note.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/active.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/expired.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/search_box.dart';
import 'package:f1notes/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f1notes/data/provider/firebase_note_provider.dart';
import 'package:f1notes/data/provider/note_provider.dart';
import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:f1notes/screens/extracted_notes_widget/add_notes_bottomsheet.dart';

class NotesList extends ConsumerWidget {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final localNoteData = ref.watch(noteProvider);
    final firebaseNotesData = ref.watch(firebaseNoteProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, ref, localNoteData, firebaseNotesData, size),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  //AppBar for the NotesList screen.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title:  CustomText(
        text: "Notes",
        color: Colors.white,
        fontSize: 18,
        weight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: _buildSearchBox(),
      ),
    );
  }

  //SearchBox inside the AppBar.
  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: _transitionType,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return const Stack(
            alignment: Alignment.centerRight,
            children: [
              SearchBox(),
            ],
          );
        },
        openBuilder: (BuildContext _, VoidCallback __) {
          return const OpenSearchPage();
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Note>> localNoteData,
    AsyncValue<List<Note>> firebaseNotesData,
    Size size,
  ) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: _buildTabBarView(ref, localNoteData, firebaseNotesData),
            ),
          ],
        ),
      ),
    );
  }

  //TabBar for the NotesList screen.
   _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabBar(
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0.0,
        splashBorderRadius: BorderRadius.circular(10),
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        tabs: const [
          Tab(text: "Active"),
          Tab(text: "Expired"),
        ],
      ),
    );
  }

  //TabBarView for displaying the Active and Expired notes.
  Widget _buildTabBarView(
    WidgetRef ref,
    AsyncValue<List<Note>> localNoteData,
    AsyncValue<List<Note>> firebaseNotesData,
  ) {
    return TabBarView(
      children: [
        // Active notes
        SingleChildScrollView(
          child: ActiveTabData(
            ref: ref,
            localNoteData: localNoteData,
            firebaseNoteData: firebaseNotesData,
          ),
        ),
        // Expired notes
        SingleChildScrollView(
          child: ExpiredTabData(
            ref: ref,
            localNoteData: localNoteData,
            firebaseNoteData: firebaseNotesData,
          ),
        ),
      ],
    );
  }

  //FloatingActionButton for adding new notes.
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddNotesBottomSheet(),
            );
          },
        );
      },
      label: const Text("Add Notes"),
    );
  }
}
