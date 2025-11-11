enum StatusPedido {
  orcamento,
  confirmado,
  emProgresso,
  pronto,
  concluido,
  cancelado,
  // Mantido por compatibilidade; evitar usar em novos fluxos
  entregue,
}

class Pedido {
  final String id;
  final String clienteId;
  final String descricao;
  final String tipoPeca;
  final double valor;
  final DateTime dataPedido;
  final DateTime dataPrazo;
  final DateTime? dataEntrega;
  final StatusPedido status;
  final String observacoes;
  final List<String> fotosPedido;

  Pedido({
    required this.id,
    required this.clienteId,
    required this.descricao,
    required this.tipoPeca,
    required this.valor,
    required this.dataPedido,
    required this.dataPrazo,
    this.dataEntrega,
    required this.status,
    required this.observacoes,
    required this.fotosPedido,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'descricao': descricao,
      'tipoPeca': tipoPeca,
      'valor': valor,
      'dataPedido': dataPedido.toIso8601String(),
      'dataPrazo': dataPrazo.toIso8601String(),
      'dataEntrega': dataEntrega?.toIso8601String(),
      'status': status.toString().split('.').last,
      'observacoes': observacoes,
      'fotosPedido': fotosPedido.join('|'),
    };
  }

  // Criar Pedido a partir de Map
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'] ?? '',
      clienteId: map['clienteId'] ?? '',
      descricao: map['descricao'] ?? '',
      tipoPeca: map['tipoPeca'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      dataPedido: DateTime.parse(map['dataPedido'] ?? DateTime.now().toIso8601String()),
      dataPrazo: DateTime.parse(map['dataPrazo'] ?? DateTime.now().toIso8601String()),
      dataEntrega: map['dataEntrega'] != null ? DateTime.parse(map['dataEntrega']) : null,
      status: _parseStatus(map['status'] ?? 'orcamento'),
      observacoes: map['observacoes'] ?? '',
      fotosPedido: (map['fotosPedido'] ?? '').toString().split('|').where((e) => e.isNotEmpty).toList(),
    );
  }

  static StatusPedido _parseStatus(String status) {
    switch (status) {
      case 'orcamento':
        return StatusPedido.orcamento;
      case 'confirmado':
        return StatusPedido.confirmado;
      case 'emProgresso':
        return StatusPedido.emProgresso;
      case 'pronto':
        return StatusPedido.pronto;
      case 'concluido':
        return StatusPedido.concluido;
      case 'entregue':
        // Mapear registros antigos para o novo status explícito
        return StatusPedido.concluido;
      case 'cancelado':
        return StatusPedido.cancelado;
      default:
        return StatusPedido.orcamento;
    }
  }

  // Copiar com modificações
  Pedido copyWith({
    String? id,
    String? clienteId,
    String? descricao,
    String? tipoPeca,
    double? valor,
    DateTime? dataPedido,
    DateTime? dataPrazo,
    DateTime? dataEntrega,
    StatusPedido? status,
    String? observacoes,
    List<String>? fotosPedido,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      descricao: descricao ?? this.descricao,
      tipoPeca: tipoPeca ?? this.tipoPeca,
      valor: valor ?? this.valor,
      dataPedido: dataPedido ?? this.dataPedido,
      dataPrazo: dataPrazo ?? this.dataPrazo,
      dataEntrega: dataEntrega ?? this.dataEntrega,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      fotosPedido: fotosPedido ?? this.fotosPedido,
    );
  }

  // Obter label do status
  String get statusLabel {
    switch (status) {
      case StatusPedido.orcamento:
        return 'Orçamento';
      case StatusPedido.confirmado:
        return 'Confirmado';
      case StatusPedido.emProgresso:
        return 'Em Progresso';
      case StatusPedido.pronto:
        return 'Pronto';
      case StatusPedido.concluido:
        return 'Concluído';
      case StatusPedido.entregue:
        // Uniformizar exibição
        return 'Concluído';
      case StatusPedido.cancelado:
        return 'Cancelado';
    }
  }

  // Obter cor do status
  String get statusColor {
    switch (status) {
      case StatusPedido.orcamento:
        return '#FFA500'; // Laranja
      case StatusPedido.confirmado:
        return '#4169E1'; // Azul
      case StatusPedido.emProgresso:
        return '#FFD700'; // Amarelo
      case StatusPedido.pronto:
        return '#90EE90'; // Verde claro
      case StatusPedido.concluido:
        return '#228B22'; // Verde escuro
      case StatusPedido.entregue:
        return '#228B22'; // Verde escuro
      case StatusPedido.cancelado:
        return '#FF6347'; // Vermelho
    }
  }
}
