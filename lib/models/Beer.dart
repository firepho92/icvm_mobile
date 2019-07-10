class Beer {
  int id;
  String name;
  int quantity;
  int amount = 0;

  Beer({
    this.id,
    this.name,
    this.quantity
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name : json['name'],
      quantity: json['quantity']
    );
  }

  int getId() {
    return id;
  }

  String getName() {
    return name;
  }
}