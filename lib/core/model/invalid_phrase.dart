class InvalidPhrase {
  String? invalid;
  String? correct;

  InvalidPhrase({required this.invalid, required this.correct});

  InvalidPhrase.fromJson(Map<String, dynamic> json) {
    invalid = json['invalid'];
    correct = json['correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invalid'] = invalid;
    data['correct'] = correct;
    return data;
  }
}
