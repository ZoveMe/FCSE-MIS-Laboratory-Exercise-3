import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() =>
      _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<MealSummary> _meals = [];
  List<MealSummary> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMeals() async {
    try {
      final meals =
      await _apiService.fetchMealsByCategory(widget.category);
      setState(() {
        _meals = meals;
        _filtered = meals;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _onSearch() async {
    final q = _searchController.text;
    if (q.isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }

    final results = await _apiService.searchMeals(q);
    setState(() => _filtered = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text('Meals: ${widget.category}'),
        backgroundColor: const Color(0xFF3F5EFB),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, index) {
                final meal = _filtered[index];
                return GestureDetector(
                  onTap: () async {
                    final detail = await _apiService.fetchMealDetail(meal.idMeal);

                    if (!context.mounted) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(meal: detail),
                      ),
                    );
                  },

                  child: MealGridItem(meal: meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
