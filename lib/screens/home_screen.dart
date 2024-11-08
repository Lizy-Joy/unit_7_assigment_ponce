import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String url = 'https://hp-api.onrender.com/api/characters/staff';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder(
        future: http.get(Uri.parse(url)),
        builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Oh no! Error! ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nothing to show'));
          }

          // Decode JSON and extract information
          final List<dynamic> responseBody = json.decode(snapshot.data.body) as List<dynamic>;
          final int statusCode = snapshot.data.statusCode;
          if (statusCode > 299) {
            return Center(child: Text('Server error: $statusCode'));
          }

          // Use ListView.builder to display the list of characters
          return ListView.builder(
            itemCount: responseBody.length,
            itemBuilder: (BuildContext context, int index) {
              var character = responseBody[index] as Map<String, dynamic>;

              // Extract details with null handling
              String name = character['name'] ?? 'Unknown Name';
              String alternateNames = character['alternate_names']?.join(', ') ?? 'No alternate names available';
              String imageUrl = character['image'] ?? '';

              // Create an ExpandedTileController for each tile
              final ExpandedTileController controller = ExpandedTileController();

              // Return the ExpandedTile for each character
              return ExpandedTile(
                controller: controller,
                title: Text(name),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(imageUrl, height: 200, width: 200, fit: BoxFit.cover),
                    Text(alternateNames),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
