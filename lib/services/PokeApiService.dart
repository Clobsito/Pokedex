import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapi/models/Pokemon.dart';

class Pokeapiservice {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<Pokemon> fetchPokemon(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el Pokemon');
    }
  }

  Future<List<Pokemon>> getPokemonRange(int start, int end) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/pokemon?limit=${end - start + 1}&offset=${start - 1}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data["results"] as List;

      final List<Pokemon> pokemons = [];
      for (var resultado in results) {
        debugPrint('Consultando datos para Pokemon: ${resultado['name']}...');
        final pokemonResponse = await http.get(Uri.parse(resultado['url']));

        if (pokemonResponse.statusCode == 200) {
          final pokemonData = json.decode(pokemonResponse.body);
          pokemons.add(Pokemon.fromJson(pokemonData));
        }
      }
      return pokemons;
    } else {
      throw Exception('Error al cargar los Pokemons');
    }
  }
}
