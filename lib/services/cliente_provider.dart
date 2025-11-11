import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../db/database_service.dart';

class ClienteProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Cliente> _clientes = [];
  bool _isLoading = false;

  List<Cliente> get clientes => _clientes;
  bool get isLoading => _isLoading;

  // Carregar todos os clientes
  Future<void> carregarClientes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _clientes = await _databaseService.obterTodosClientes();
    } catch (e) {
      print('Erro ao carregar clientes: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Adicionar novo cliente
  Future<void> adicionarCliente(Cliente cliente) async {
    try {
      await _databaseService.inserirCliente(cliente);
      _clientes.add(cliente);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar cliente: $e');
    }
  }

  // Atualizar cliente
  Future<void> atualizarCliente(Cliente cliente) async {
    try {
      await _databaseService.atualizarCliente(cliente);
      final index = _clientes.indexWhere((c) => c.id == cliente.id);
      if (index != -1) {
        _clientes[index] = cliente;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar cliente: $e');
    }
  }

  // Deletar cliente
  Future<void> deletarCliente(String id) async {
    try {
      await _databaseService.deletarCliente(id);
      _clientes.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar cliente: $e');
    }
  }

  // Obter cliente por ID
  Cliente? obterClientePorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Buscar clientes por nome
  List<Cliente> buscarClientes(String termo) {
    if (termo.isEmpty) return _clientes;
    return _clientes
        .where((cliente) =>
            cliente.nome.toLowerCase().contains(termo.toLowerCase()) ||
            cliente.telefone.contains(termo) ||
            cliente.escola.toLowerCase().contains(termo.toLowerCase()))
        .toList();
  }
}
