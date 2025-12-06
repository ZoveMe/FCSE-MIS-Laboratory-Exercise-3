import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/gradient_background.dart';
import 'meal_detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ApiService _apiService = ApiService();
  List<Category> _categories = [];
  List<Category> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cats = await _apiService.fetchCategories();
      setState(() {
        _categories = cats;
        _filtered = cats;
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onSearch(String text) {
    final q = text.toLowerCase();
    setState(() {
      _filtered = _categories
          .where((c) => c.strCategory.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar is SOLID BLUE like GitHub version
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: const Color(0xFF3F5EFB),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () async {
              final randomMeal = await _apiService.fetchRandomMeal();
              final detail =
              await _apiService.fetchMealDetail(randomMeal.idMeal);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(meal: detail),
                ),
              );
            },
          )
        ],
      ),

      /// BODY gets the gradient – NOT the AppBar and NOT the whole Scaffold
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: _onSearch,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search categories...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, i) => CategoryCard(category: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
