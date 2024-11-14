import 'package:f1notes/data/provider/firebase_search_note_provider.dart';
import 'package:f1notes/resources/extracted_functions/extracted_functions.dart';
import 'package:f1notes/resources/extracted_widgets/custom_button.dart';
import 'package:f1notes/resources/extracted_widgets/custom_text.dart';
import 'package:f1notes/resources/extracted_widgets/custom_textfield.dart';
import 'package:f1notes/resources/extracted_widgets/empty_retry/empty.dart';
import 'package:f1notes/screens/note_lists/note_list_parts/note_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenSearchPage extends ConsumerStatefulWidget {
  const OpenSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OpenSearchPage> createState() => _OpenSearchPageState();
}

class _OpenSearchPageState extends ConsumerState<OpenSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  void _openDatepicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime.now().add(const Duration(days: 4)),
    ).then((selectedRange) {
      if (selectedRange != null) {
        setState(() {
          _startDate = selectedRange.start;
          _endDate = selectedRange.end;
          _dateController.text =
              "${getDateFormat(selectedRange.start)} - ${getDateFormat(selectedRange.end)}";
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(firebaseSearchNoteProvider.notifier).clearNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notes = ref.watch(firebaseSearchNoteProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        title: CustomText(
          text: "Search Synced Notes",
          fontSize: 18,
          weight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search section
              Column(
                children: [
                  CustomTextField(
                    hintText: "Search Notes...",
                    controller: _searchController,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _openDatepicker,
                        child: SizedBox(
                          width: size.width * 0.6,
                          child: CustomTextField(
                            hintText: "From Date - To Date",
                            controller: _dateController,
                            suffixIcon: const Icon(Icons.date_range),
                            enabled: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.3,
                        child: CustomButton(
                          text: "Search",
                          padBot: 0.0,
                          onPress: () {
                           if(_searchController.text.isEmpty && _dateController.text.isEmpty){
                            getToast(text: "Apply any one filter");
                           }
                           else{
                             ref.read(firebaseSearchNoteProvider.notifier).loadFilteredNotes(
                              searchText: _searchController.text,
                              startDate: _startDate,
                              endDate: _endDate,
                              context: context,
                            );
                           }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes list section
              notes.when(
                data: (noteList) {
                  if ((_searchController.text.isNotEmpty || _dateController.text.isNotEmpty) &&
                      noteList.isEmpty) {
                    return  Center(child: EmptyData(text: "No Notes Found"));
                  }
                  if ((_searchController.text.isEmpty && _dateController.text.isEmpty) &&
                      noteList.isEmpty) {
                    return  Center(child: EmptyData(text: "Search Notes"));
                  }
                  return Expanded(child: SingleChildScrollView(child: NotesListBuilder(ref: ref, notes: noteList)));
                },
                error: (error, _) {
                  return Center(
                    child: EmptyData(text: error.toString(),hasRetry: true,
                    onTap: (){
                      ref.read(firebaseSearchNoteProvider.notifier).loadFilteredNotes(
                              searchText: _searchController.text,
                              startDate: _startDate,
                              endDate: _endDate,
                              context: context,
                            );
                    },
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator.adaptive());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
