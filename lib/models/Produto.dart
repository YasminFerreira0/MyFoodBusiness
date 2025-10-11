class Produto {
  int? id;
  String nome;
  double preco;
  String categoria;
  String? descricao;
  
  Produto({
    this.id,
    required this.nome,
    required this.preco,
    required this.categoria,
    this.descricao
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "preco": preco,
      "categoria": categoria,
      "descricao": descricao
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map["id"],
      nome: map["nome"],
      preco: map["preco"],
      categoria: map["categoria"],
      descricao: map["descricao"]
    );
  }
}