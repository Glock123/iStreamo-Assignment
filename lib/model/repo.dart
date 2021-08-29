class Repository {
  final String name, description;
  final String language;
  final int bugs, seen;

  Repository(
      {required this.name,
      required this.description,
      required this.language,
      required this.bugs,
      required this.seen});

  static Map<String, dynamic> toJson(Repository repo) {
    return {
      'name': repo.name,
      'description': repo.description,
      'language': repo.language,
      'bugs': repo.bugs,
      'seen': repo.seen,
    };
  }

  static Repository fromJson(Map<String, dynamic> obj) {
    return Repository(
      name: obj['name'] as String,
      description: obj['description'] as String,
      language: obj['language'] as String,
      bugs: obj['bugs'] as int,
      seen: obj['seen'] as int,
    );
  }
}
