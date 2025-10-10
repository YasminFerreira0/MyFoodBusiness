class Cliente {
  int? id;
  String nome;
  String telefone;
  String email;
  String cpf;
  
  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf
  });

  
  Map<String, dynamic> toMap() {
    return {
      "id": id, 
      "nome": nome, 
      "telefone": telefone,
      "email": email,
      "cpf": cpf
    };
  }

  static Cliente fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map["id"],
      nome: map["nome"],
      telefone: map["telefone"],
      email: map["email"],
      cpf: map["cpf"]
    );
  }
}