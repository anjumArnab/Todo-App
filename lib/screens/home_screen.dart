import 'package:dbapp/database/database.dart';
import 'package:dbapp/models/note_model.dart';
import 'package:dbapp/screens/add_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;
  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  _updateNoteList() {
    setState(() {
      _noteList = DatabaseHelper.instance.getNoteList();
    });
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              "${_dateFormatter.format(note.date!)} - ${note.priority}",
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddNoteScreen(
                  updateNoteList: _updateNoteList,
                  note: note,
                ),
              ),
            ),
          ),
          const Divider(
            height: 5.0,
            color: Colors.white,
            thickness: 1.5,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: const Text("T O D O  L I S T"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Note>>(
        future: _noteList,
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Empty Todo List!",
                style: TextStyle(fontSize: 20.0),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No notes available. Add a note to get started.",
                  style: TextStyle(fontSize: 20.0)),
            );
          }
          final int completeNoteCount = snapshot.data!
              .where((Note note) => note.status == 1)
              .toList()
              .length;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Notes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        '$completeNoteCount of ${snapshot.data!.length}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
              return _buildNote(snapshot.data![index - 1]);
            },
          );
        },
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: Colors.purple.shade300,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNoteScreen(updateNoteList: _updateNoteList),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
