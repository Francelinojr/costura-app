class Orcamento {
  final String id;
  final String clienteId;
  final String descricao;
  final String tipoPeca;
  final double valorMaoDeObra;
  final double valorTecido;
  final double valorAcabamento;
  final double desconto;
  final DateTime dataCriacao;
  final DateTime dataValidade;
  final String observacoes;
  final bool aceito;

  Orcamento({
    required this.id,
    required this.clienteId,
    required this.descricao,
    required this.tipoPeca,
    required this.valorMaoDeObra,
    required this.valorTecido,
    required this.valorAcabamento,
    required this.desconto,
    required this.dataCriacao,
    required this.dataValidade,
    required this.observacoes,
    required this.aceito,
  });

  // Calcular valor total
  double get valorTotal {
    double total = valorMaoDeObra + valorTecido + valorAcabamento;
    return total - desconto;
  }

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'descricao': descricao,
      'tipoPeca': tipoPeca,
      'valorMaoDeObra': valorMaoDeObra,
      'valorTecido': valorTecido,
      'valorAcabamento': valorAcabamento,
      'desconto': desconto,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataValidade': dataValidade.toIso8601String(),
      'observacoes': observacoes,
      'aceito': aceito ? 1 : 0,
    };
  }

  // Criar Orçamento a partir de Map
  factory Orcamento.fromMap(Map<String, dynamic> map) {
    return Orcamento(
      id: map['id'] ?? '',
      clienteId: map['clienteId'] ?? '',
      descricao: map['descricao'] ?? '',
      tipoPeca: map['tipoPeca'] ?? '',
      valorMaoDeObra: (map['valorMaoDeObra'] ?? 0).toDouble(),
      valorTecido: (map['valorTecido'] ?? 0).toDouble(),
      valorAcabamento: (map['valorAcabamento'] ?? 0).toDouble(),
      desconto: (map['desconto'] ?? 0).toDouble(),
      dataCriacao: DateTime.parse(map['dataCriacao'] ?? DateTime.now().toIso8601String()),
      dataValidade: DateTime.parse(map['dataValidade'] ?? DateTime.now().toIso8601String()),
      observacoes: map['observacoes'] ?? '',
      aceito: (map['aceito'] ?? 0) == 1,
    );
  }

  // Copiar com modificações
  Orcamento copyWith({
    String? id,
    String? clienteId,
    String? descricao,
    String? tipoPeca,
    double? valorMaoDeObra,
    double? valorTecido,
    double? valorAcabamento,
    double? desconto,
    DateTime? dataCriacao,
    DateTime? dataValidade,
    String? observacoes,
    bool? aceito,
  }) {
    return Orcamento(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      descricao: descricao ?? this.descricao,
      tipoPeca: tipoPeca ?? this.tipoPeca,
      valorMaoDeObra: valorMaoDeObra ?? this.valorMaoDeObra,
      valorTecido: valorTecido ?? this.valorTecido,
      valorAcabamento: valorAcabamento ?? this.valorAcabamento,
      desconto: desconto ?? this.desconto,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataValidade: dataValidade ?? this.dataValidade,
      observacoes: observacoes ?? this.observacoes,
      aceito: aceito ?? this.aceito,
    );
  }
}
