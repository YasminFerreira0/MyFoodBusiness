class ItemPedido {
  int? id;
  int pedidoId;
  int produtoId;
  int quantidade;
  double precoUnitario;

  ItemPedido({
    this.id,
    required this.pedidoId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "pedidoId": pedidoId,
      "produtoId": produtoId,
      "quantidade": quantidade,
      "precoUnitario": precoUnitario
    };
  }

  static ItemPedido fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      id: map["id"],
      pedidoId: map["pedidoId"],
      produtoId: map["produtoId"],
      quantidade: map["quantidade"],
      precoUnitario: map["precoUnitario"]
    );
  }
}