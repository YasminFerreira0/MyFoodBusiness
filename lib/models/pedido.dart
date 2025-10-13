class Pedido {
  int? id;
  int? numeroMesa;
  int? clienteId;
  DateTime dataHora;
  String status;
  double valorTotal;
  String metodoPagamento;
  String? observacoes;

  Pedido({
    this.id,
    this.numeroMesa,
    this.clienteId,
    required this.dataHora,
    required this.status,
    required this.valorTotal,
    required this.metodoPagamento,
    this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "numeroMesa": numeroMesa,
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
      numeroMesa: map["numeroMesa"],
      clienteId: map["clienteId"],
      dataHora: DateTime.parse(map["dataHora"]),
      status: map["status"],
      valorTotal: map["valorTotal"],
      metodoPagamento: map["metodoPagamento"],
      observacoes: map["observacoes"]
    );
  }
}