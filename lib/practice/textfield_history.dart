import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldHistory extends StatefulWidget {
  TextFieldHistory({super.key});

  @override
  State<TextFieldHistory> createState() => _TextFieldHistoryState();
}

class _TextFieldHistoryState extends State<TextFieldHistory> {
  List<String> searchHistory = [];
  bool showHistory = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Load search history from persistent storage (if implemented)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('TextField history'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextField(
              controller: searchController,
              onTap: () {
                setState(() {
                  showHistory = true;
                });
              },
              onSubmitted: (value) {
                // Add new search term to history
                if (value.isNotEmpty) {
                  searchHistory.add(value);
                }
                // Save search history to persistent storage (if implemented)
                setState(() {
                  showHistory = false;
                  searchController.text = '';
                });
              },
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white70),
                labelText: 'Search For a Movie',
                suffixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white70,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
              ),
            ),
          ),

          ///
          /// show history
          //
          (showHistory == true)
              ? Container(
                  width: 320,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchHistory.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'No searches Made',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: searchHistory.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        searchHistory[index],
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          searchHistory
                                              .remove(searchHistory[index]);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ]),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
