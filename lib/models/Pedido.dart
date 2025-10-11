class Pedido {
  int? id;
  int clienteId;
  DateTime dataHora;
  String status;
  double valorTotal;
  String metodoPagamento;
  String? observacoes;

  Pedido({
    this.id,
    required this.clienteId,
    required this.dataHora,
    required this.status,
    required this.valorTotal,
    required this.metodoPagamento,
    this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "clienteId": clienteId,
      "dataHora": dataHora.toIso8601String(),
      "status": status,
      "valorTotal": valorTotal,
      "metodoPagamento": metodoPagamento,
      "observacoes": observacoes
    };
  }

  static Pedido fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map["id"],
      clienteId: map["clienteId"],
      dataHora: DateTime.parse(map["dataHora"]),
      status: map["status"],
      valorTotal: map["valorTotal"],
      metodoPagamento: map["metodoPagamento"],
      observacoes: map["observacoes"]
    );
  }
}