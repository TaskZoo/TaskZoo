class Biomes {
  List<Biome> biomes;

  Biomes({required this.biomes});

  factory Biomes.fromJson(Map<String, dynamic> json) {
    final List<dynamic> biomesJson = json['biomes'] as List<dynamic>;
    final List<Biome> biomes = biomesJson.map((item) => Biome.fromJson(item)).toList();

    return Biomes(biomes: biomes);
  }
}

class Biome {
  String name;
  String primaryColor;
  String secondaryColor;
  String backgroundPath;
  BiomeIcon icon;
  List<Animal> animals;

  Biome({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundPath,
    required this.icon,
    required this.animals,
  });

  factory Biome.fromJson(Map<String, dynamic> json) {
    final List<dynamic> animalsJson = json['animals'] as List<dynamic>;
    final List<Animal> animals = animalsJson.map((item) => Animal.fromJson(item)).toList();

    return Biome(
      name: json['name'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
      backgroundPath: json['backgroundPath'] as String,
      icon: BiomeIcon.fromJson(json['icon']),
      animals: animals,
    );
  }
}

class BiomeIcon {
  String name;
  String svgPath;

  BiomeIcon({
    required this.name,
    required this.svgPath,
  });

  factory BiomeIcon.fromJson(Map<String, dynamic> json) {
    return BiomeIcon(
      name: json['name'] as String,
      svgPath: json['svgPath'] as String,
    );
  }
}

class Animal {
  String name;
  String svgPath;

  Animal({
    required this.name,
    required this.svgPath,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      name: json['name'] as String,
      svgPath: json['svgPath'] as String,
    );
  }
}
