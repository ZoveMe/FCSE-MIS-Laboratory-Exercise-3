import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../models/favorite_manager.dart';

class MealGridItem extends StatelessWidget {
  final MealSummary meal;

  const MealGridItem({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoriteManager.isFavorite(meal);

    return Hero(
      tag: meal.idMeal,
      child: Stack(
        children: [

          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      meal.strMealThumb,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    meal.strMeal,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () {
                FavoriteManager.toggleFavorite(meal);

                (context as Element).markNeedsBuild();
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
