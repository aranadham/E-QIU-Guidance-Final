class Speaker {
  String id = "";
  List eventRef = [];
  String name = "";
  String description = "";

  Speaker({
    required this.id,
    required this.eventRef,
    required this.name,
    required this.description,
  });

  Speaker.empty();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventRef': eventRef,
      'Speaker': name,
      'Description': description,
    };
  }
  factory Speaker.fromMap(String id, Map<String, dynamic> map) {
    return Speaker(
      id: id,
      eventRef: map['eventRefs'],
      name: map["Speaker Name"],
      description: map["Speaker Description"],
    );
  }
}
