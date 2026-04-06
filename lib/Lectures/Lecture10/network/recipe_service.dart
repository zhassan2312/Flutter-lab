import 'dart:developer';
import 'package:http/http.dart';

const String apiKey = '851f57495abcbf36d267adbd7f599a01';
const String apiId = '51866881';
const String apiUrl = 'https://api.edamam.com/api/recipes/v2';

class RecipeService {
  Future<String> getData(String url) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to load recipes');
    }
  }

  Future<String> getRecipes(String query, int from, int to) async {
    final recipeData = await getData(
        // ignore: lines_longer_than_80_chars
        '$apiUrl?type=any&app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    return recipeData;
  }
}
