import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/home/logic/cubits/notes_cubit/notes_state.dart';
import 'package:note_app/features/home/widget/custom_home_container.dart';

import '../../home/logic/cubits/notes_cubit/notes_cubit.dart';
import '../../home/logic/model/home_model.dart';
import '../widget/custom_search_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              CustomSearchField(
                controller: searchController,
                onChanged: (query) {
                  context.read<NotesCubit>().searchNotes(query);
                },
              ),
              GestureDetector(
                  onTap: () {
                    BlocProvider.of<NotesCubit>(context).fetchNotes();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ))
            ],
          ),
          BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<NotesCubit>(context);
              List<HomeModel>? notes = bloc.notes ?? [];
              return searchController.text.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Text(
                            "Notes",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "Try typing to search",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : (notes.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                return CustomHomeContainer(
                                  note: notes[index],
                                  index: index + 11,
                                );
                              }))
                      : Container(
                          color: Colors.red,
                          width: 300,
                          height: 300,
                          alignment: Alignment.center,
                          child: Text("Aeshaa")));
            },
          ),
        ],
      )),
    );
  }
}
