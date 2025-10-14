enum CategoriaProduto {
  bebida,
  lanche,
  refeicao,
  acompanhamento,
  sobremesa,
  entrada,
  combo,
  outro;

  String get label {
    switch (this) {
      case CategoriaProduto.bebida:
        return 'Bebida';
      case CategoriaProduto.lanche:
        return 'Lanche';
      case CategoriaProduto.refeicao:
        return 'Refeição';
      case CategoriaProduto.acompanhamento:
        return 'Acompanhamento';
      case CategoriaProduto.sobremesa:
        return 'Sobremesa';
      case CategoriaProduto.entrada:
        return 'Entrada';
      case CategoriaProduto.combo:
        return 'Combo';
      case CategoriaProduto.outro:
        return 'Outro';
    }
  }
}