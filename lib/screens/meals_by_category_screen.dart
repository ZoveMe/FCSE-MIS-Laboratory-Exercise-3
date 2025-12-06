import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';
import '../widgets/gradient_background.dart';


class MealsByCategoryScreen extends StatefulWidget {
  final String category;

  const MealsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _MealsByCategoryScreenState createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService _apiService = ApiService();
  List<MealSummary> _meals = [];
  List<MealSummary> _filtered = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMeals() async {
    try {
      final meals = await _apiService.fetchMealsByCategory(widget.category);

      setState(() {
        _meals = meals;
        _filtered = meals;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged() async {
    final query = _searchController.text;

    if (query.isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }

    try {
      final results = await _apiService.searchMeals(query);
      setState(() => _filtered = results);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F5EFB), // Blue header ONLY
        foregroundColor: Colors.white,
        title: Text("Meals: ${widget.category}"),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // SEARCH BAR
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
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),

          // GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, index) {
                final meal = _filtered[index];

                return GestureDetector(
                  onTap: () async {
                    final detail = await _apiService.fetchMealDetail(meal.idMeal);
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
