class OpenAiResponse {
  String? id;
  List<Choices>? choices;

  OpenAiResponse({this.id, this.choices});

  OpenAiResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['choices'] != null) {
      choices = <Choices>[];
      json['choices'].forEach((v) {
        choices!.add(new Choices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.choices != null) {
      data['choices'] = this.choices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Choices {
  String? text;
  int? index;
  Null? logprobs;
  String? finishReason;
  bool messageByUser = true;

  Choices({this.text, this.index, this.logprobs, this.finishReason,required messageByUser});

  Choices.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    index = json['index'];
    logprobs = json['logprobs'];
    finishReason = json['finish_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['index'] = this.index;
    data['logprobs'] = this.logprobs;
    data['finish_reason'] = this.finishReason;
    return data;
  }
}
