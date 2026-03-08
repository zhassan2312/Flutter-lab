import 'package:flutter/material.dart';
import '../model/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ScrollController _scrollController = ScrollController();  // ScrollController to detect scroll position
  String _scrollStatus = '';  // Displays scroll position feedback

  @override
  void initState() {
    super.initState();
    // Attach scroll listener to detect top / bottom edges
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      setState(() {
        _scrollStatus = isTop ? 'Scrolled to top' : 'Scrolled to bottom';
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Always dispose controllers to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.label),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Task 2: Horizontal row — image + title + prep time ──────────────
          Container(
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Recipe thumbnail image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    recipe.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Title and prep time stacked vertically, expanding to fill remaining width
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.label,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text(
                            recipe.prepTime,
                            style: const TextStyle(fontSize: 14, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scroll position status banner
          if (_scrollStatus.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.deepOrange.shade100,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Text(
                _scrollStatus,
                style: const TextStyle(fontSize: 12, color: Colors.deepOrange),
              ),
            ),

          // ── Task 1: ListView.builder — comments with timestamps ─────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,  // Attach ScrollController
              itemCount: recipe.comments.length,
              padding: const EdgeInsets.only(bottom: 12),
              itemBuilder: (context, index) {
                final comment = recipe.comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Text(
                        comment.author[0].toUpperCase(),  // First letter of author name
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      comment.author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(comment.text),
                    trailing: Text(
                      comment.timestamp,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
