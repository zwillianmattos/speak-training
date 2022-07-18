class Phrase {
  int? id;
  String? content;
  String? description;
  int? level;
  int? correct;

  Phrase({this.id, required this.content, this.description, this.level, this.correct = 2});

  Phrase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    description = json['description'];
    level = json['level'];
    correct = 2;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['description'] = description;
    data['level'] = level;
    return data;
  }
}