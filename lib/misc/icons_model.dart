class AppIcons {
  List<IconData> icons;

  AppIcons({required this.icons});

  factory AppIcons.fromJson(Map<String, dynamic> json) {
    final List<dynamic> iconsJson = json['icons'] as List<dynamic>;
    final List<IconData> icons = iconsJson.map((item) => IconData.fromJson(item)).toList();

    return AppIcons(icons: icons);
  }
}

class IconData {
  String name;
  String backgroundColor;
  String svgPath;

  IconData({
    required this.name,
    required this.backgroundColor,
    required this.svgPath,
  });

  factory IconData.fromJson(Map<String, dynamic> json) {
    return IconData(
      name: json['name'] as String,
      backgroundColor: json['backgroundColor'] as String,
      svgPath: json['svgPath'] as String,
    );
  }
}
