class Cliente {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String escola;
  final String observacoes;
  final DateTime dataCadastro;
  
  // Medidas
  final double busto;
  final double cintura;
  final double quadril;
  final double comprimentoBlusa;
  final double comprimentoCalca;
  final double manga;
  final double ombro;
  final double pescoco;
  final String tamanho;
  
  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.escola,
    required this.observacoes,
    required this.dataCadastro,
    required this.busto,
    required this.cintura,
    required this.quadril,
    required this.comprimentoBlusa,
    required this.comprimentoCalca,
    required this.manga,
    required this.ombro,
    required this.pescoco,
    required this.tamanho,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'escola': escola,
      'observacoes': observacoes,
      'dataCadastro': dataCadastro.toIso8601String(),
      'busto': busto,
      'cintura': cintura,
      'quadril': quadril,
      'comprimentoBlusa': comprimentoBlusa,
      'comprimentoCalca': comprimentoCalca,
      'manga': manga,
      'ombro': ombro,
      'pescoco': pescoco,
      'tamanho': tamanho,
    };
  }

  // Criar Cliente a partir de Map
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
      escola: map['escola'] ?? '',
      observacoes: map['observacoes'] ?? '',
      dataCadastro: DateTime.parse(map['dataCadastro'] ?? DateTime.now().toIso8601String()),
      busto: (map['busto'] ?? 0).toDouble(),
      cintura: (map['cintura'] ?? 0).toDouble(),
      quadril: (map['quadril'] ?? 0).toDouble(),
      comprimentoBlusa: (map['comprimentoBlusa'] ?? 0).toDouble(),
      comprimentoCalca: (map['comprimentoCalca'] ?? 0).toDouble(),
      manga: (map['manga'] ?? 0).toDouble(),
      ombro: (map['ombro'] ?? 0).toDouble(),
      pescoco: (map['pescoco'] ?? 0).toDouble(),
      tamanho: map['tamanho'] ?? '',
    );
  }

  // Copiar com modificações
  Cliente copyWith({
    String? id,
    String? nome,
    String? telefone,
    String? email,
    String? escola,
    String? observacoes,
    DateTime? dataCadastro,
    double? busto,
    double? cintura,
    double? quadril,
    double? comprimentoBlusa,
    double? comprimentoCalca,
    double? manga,
    double? ombro,
    double? pescoco,
    String? tamanho,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      escola: escola ?? this.escola,
      observacoes: observacoes ?? this.observacoes,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      busto: busto ?? this.busto,
      cintura: cintura ?? this.cintura,
      quadril: quadril ?? this.quadril,
      comprimentoBlusa: comprimentoBlusa ?? this.comprimentoBlusa,
      comprimentoCalca: comprimentoCalca ?? this.comprimentoCalca,
      manga: manga ?? this.manga,
      ombro: ombro ?? this.ombro,
      pescoco: pescoco ?? this.pescoco,
      tamanho: tamanho ?? this.tamanho,
    );
  }
}
