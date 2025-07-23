import 'package:flutter/material.dart';
import 'package:pokeapi/helpers/get_pokemon.dart';
import 'package:pokeapi/models/Pokemon.dart';
import 'package:pokeapi/services/PokeApiService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 233, 227, 242),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 78, 37),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'cambria', color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Pokemon>> futurePokemons;
  final Pokeapiservice _pokeapiservice = Pokeapiservice();

  @override
  void initState() {
    super.initState();
    futurePokemons = _pokeapiservice.getPokemonRange(810, 898);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        title: const Text(
          'OCTAVA GENERACION POKEMON',
          style: TextStyle(color: Colors.black, fontFamily: 'cambria'),
        ),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontFamily: 'cambria'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No se encontro Pokemon',
                style: TextStyle(fontFamily: 'cambria'),
              ),
            );
          }
          return _buildPokemonList(snapshot.data!, context);
        },
      ),
    );
  }
}

Widget _buildPokemonList(List<Pokemon> pokemons, BuildContext context) {
  return GridView.builder(
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.4,
    ),
    itemCount: pokemons.length,
    itemBuilder: (context, index) {
      final pokemon = pokemons[index];

      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 241, 78, 37),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(pokemon.imageUrl, height: 100),
                    const SizedBox(height: 10),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'cambria',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tipo: ${pokemon.type}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'cambria',
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Card(
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 251, 41, 5),
                  const Color.fromARGB(255, 12, 12, 12),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(pokemon.imageUrl, height: 65),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'cambria',
                        ),
                      ),
                      Text(
                        pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'cambria',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
