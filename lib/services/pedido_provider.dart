import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../db/database_service.dart';

class PedidoProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Pedido> _pedidos = [];
  bool _isLoading = false;

  List<Pedido> get pedidos => _pedidos;
  bool get isLoading => _isLoading;

  // Carregar todos os pedidos
  Future<void> carregarPedidos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _pedidos = await _databaseService.obterTodosPedidos();
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Carregar pedidos de um cliente específico
  Future<List<Pedido>> carregarPedidosPorCliente(String clienteId) async {
    try {
      return await _databaseService.obterPedidosPorCliente(clienteId);
    } catch (e) {
      print('Erro ao carregar pedidos do cliente: $e');
      return [];
    }
  }

  // Adicionar novo pedido
  Future<void> adicionarPedido(Pedido pedido) async {
    try {
      await _databaseService.inserirPedido(pedido);
      _pedidos.add(pedido);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar pedido: $e');
    }
  }

  // Atualizar pedido
  Future<void> atualizarPedido(Pedido pedido) async {
    try {
      await _databaseService.atualizarPedido(pedido);
      final index = _pedidos.indexWhere((p) => p.id == pedido.id);
      if (index != -1) {
        _pedidos[index] = pedido;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar pedido: $e');
    }
  }

  // Deletar pedido
  Future<void> deletarPedido(String id) async {
    try {
      await _databaseService.deletarPedido(id);
      _pedidos.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar pedido: $e');
    }
  }

  // Obter pedido por ID
  Pedido? obterPedidoPorId(String id) {
    try {
      return _pedidos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter pedidos por status
  List<Pedido> obterPedidosPorStatus(StatusPedido status) {
    return _pedidos.where((p) => p.status == status).toList();
  }

  // Obter pedidos em atraso
  List<Pedido> obterPedidosEmAtraso() {
    final agora = DateTime.now();
    return _pedidos.where((p) => p.dataPrazo.isBefore(agora) && p.status != StatusPedido.entregue && p.status != StatusPedido.cancelado).toList();
  }

  // Obter próximos pedidos a entregar
  List<Pedido> obterProximosPedidos() {
    final agora = DateTime.now();
    final proximosDias = agora.add(Duration(days: 7));
    return _pedidos
        .where((p) =>
            p.dataPrazo.isAfter(agora) &&
            p.dataPrazo.isBefore(proximosDias) &&
            p.status != StatusPedido.entregue &&
            p.status != StatusPedido.cancelado)
        .toList();
  }
}
