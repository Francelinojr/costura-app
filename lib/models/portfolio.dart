class Portfolio {
  final String id;
  final String titulo;
  final String descricao;
  final String tipoPeca;
  final String caminhoFoto;
  final DateTime dataCriacao;
  final String clienteId;
  final double avaliacao;

  Portfolio({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.tipoPeca,
    required this.caminhoFoto,
    required this.dataCriacao,
    required this.clienteId,
    required this.avaliacao,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'tipoPeca': tipoPeca,
      'caminhoFoto': caminhoFoto,
      'dataCriacao': dataCriacao.toIso8601String(),
      'clienteId': clienteId,
      'avaliacao': avaliacao,
    };
  }

  // Criar Portfolio a partir de Map
  factory Portfolio.fromMap(Map<String, dynamic> map) {
    return Portfolio(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      tipoPeca: map['tipoPeca'] ?? '',
      caminhoFoto: map['caminhoFoto'] ?? '',
      dataCriacao: DateTime.parse(map['dataCriacao'] ?? DateTime.now().toIso8601String()),
      clienteId: map['clienteId'] ?? '',
      avaliacao: (map['avaliacao'] ?? 0).toDouble(),
    );
  }

  // Copiar com modificações
  Portfolio copyWith({
    String? id,
    String? titulo,
    String? descricao,
    String? tipoPeca,
    String? caminhoFoto,
    DateTime? dataCriacao,
    String? clienteId,
    double? avaliacao,
  }) {
    return Portfolio(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      tipoPeca: tipoPeca ?? this.tipoPeca,
      caminhoFoto: caminhoFoto ?? this.caminhoFoto,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      clienteId: clienteId ?? this.clienteId,
      avaliacao: avaliacao ?? this.avaliacao,
    );
  }
}
