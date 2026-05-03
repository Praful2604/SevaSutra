import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:sevasutra_flutter/models/user.dart';
import 'package:sevasutra_flutter/screens/display_surveys_screen/user_details_screen.dart';
import 'package:sevasutra_flutter/screens/display_surveys_screen/user_list_screen.dart';

import 'package:sevasutra_flutter/screens/display_user_data.dart';
import 'package:sevasutra_flutter/screens/surveys_functions_screen/screen_one.dart';

import '../drawer_button/common_drawer.dart';
import '../../main.dart';

class SurveysScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const SurveysScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  int selectedIndex = 0;
  final List<String> filters = ["All", "Draft", "Completed", "Synced"];

  // Search state
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Search Isar for beneficiaries whose name contains the query (case-insensitive)
  Future<void> _onSearchChanged(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final results = await isar.users
        .filter()
        .nameContains(trimmed, caseSensitive: false)
        .findAll();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Surveys"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey),
        ),
      ),
      drawer: CommonDrawer(
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // 🔍 Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search beneficiary by name...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: hasQuery
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.green.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),



                // View Data button (hidden while searching)
                if (!hasQuery)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.greenAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.visibility, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "View Data",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 🔎 Search Results
          if (hasQuery)
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 60, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(
                                'No results for "${_searchController.text}"',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.green,
                                  backgroundImage: (user.photo != null &&
                                          user.photo!.isNotEmpty)
                                      ? MemoryImage(
                                          Uint8List.fromList(user.photo!))
                                      : null,
                                  child: (user.photo == null ||
                                          user.photo!.isEmpty)
                                      ? Text(
                                          (user.name?.isNotEmpty == true)
                                              ? user.name![0].toUpperCase()
                                              : 'U',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  user.name ?? 'Unknown',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Age: ${user.age ?? 'N/A'}  •  ${user.address ?? ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Icon(
                                  user.isSynced
                                      ? Icons.cloud_done
                                      : Icons.cloud_upload_outlined,
                                  color: user.isSynced
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UserDetailScreen(user: user),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenOne(userEmail: widget.userEmail),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
