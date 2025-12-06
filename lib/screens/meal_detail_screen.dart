import 'package:flutter/material.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111), // 🔥 Dark grey (border visible)

      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          meal.strMeal,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),

          // 🔥 THE BORDER NOW SHOWS!
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white24,
              width: 1.2,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  meal.strMealThumb,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                meal.strMeal,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Category: ${meal.strCategory}",
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Instructions:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                meal.strInstructions,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              if (meal.ingredients.isNotEmpty) ...[
                const Text(
                  "Ingredients:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                ...meal.ingredients.entries.map(
                      (e) => Text(
                    "• ${e.key}: ${e.value}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
