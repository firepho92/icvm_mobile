class Sale {
  int id;
  String date;
  int beer;
  int quantity;

  Sale({
    this.id,
    this.date,
    this.beer,
    this.quantity
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      date : json['date'],
      beer: json['beer'],
      quantity: json['quantity']

    );
  }
}