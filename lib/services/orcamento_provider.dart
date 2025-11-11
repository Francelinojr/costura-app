import 'package:flutter/material.dart';
import '../models/orcamento.dart';
import '../db/database_service.dart';

class OrcamentoProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Orcamento> _orcamentos = [];
  bool _isLoading = false;

  List<Orcamento> get orcamentos => _orcamentos;
  bool get isLoading => _isLoading;

  // Carregar todos os orçamentos
  Future<void> carregarOrcamentos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orcamentos = await _databaseService.obterTodosOrcamentos();
    } catch (e) {
      print('Erro ao carregar orçamentos: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Carregar orçamentos de um cliente específico
  Future<List<Orcamento>> carregarOrcamentosPorCliente(String clienteId) async {
    try {
      return await _databaseService.obterOrcamentosPorCliente(clienteId);
    } catch (e) {
      print('Erro ao carregar orçamentos do cliente: $e');
      return [];
    }
  }

  // Adicionar novo orçamento
  Future<void> adicionarOrcamento(Orcamento orcamento) async {
    try {
      await _databaseService.inserirOrcamento(orcamento);
      _orcamentos.add(orcamento);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar orçamento: $e');
    }
  }

  // Atualizar orçamento
  Future<void> atualizarOrcamento(Orcamento orcamento) async {
    try {
      await _databaseService.atualizarOrcamento(orcamento);
      final index = _orcamentos.indexWhere((o) => o.id == orcamento.id);
      if (index != -1) {
        _orcamentos[index] = orcamento;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar orçamento: $e');
    }
  }

  // Deletar orçamento
  Future<void> deletarOrcamento(String id) async {
    try {
      await _databaseService.deletarOrcamento(id);
      _orcamentos.removeWhere((o) => o.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar orçamento: $e');
    }
  }

  // Obter orçamento por ID
  Orcamento? obterOrcamentoPorId(String id) {
    try {
      return _orcamentos.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter orçamentos pendentes
  List<Orcamento> obterOrcamentosPendentes() {
    return _orcamentos.where((o) => !o.aceito).toList();
  }

  // Obter orçamentos aceitos
  List<Orcamento> obterOrcamentosAceitos() {
    return _orcamentos.where((o) => o.aceito).toList();
  }

  // Obter orçamentos vencidos
  List<Orcamento> obterOrcamentosVencidos() {
    final agora = DateTime.now();
    return _orcamentos.where((o) => o.dataValidade.isBefore(agora) && !o.aceito).toList();
  }

  // Calcular receita total de orçamentos aceitos
  double calcularReceitaTotal() {
    return _orcamentos.where((o) => o.aceito).fold(0, (sum, o) => sum + o.valorTotal);
  }
}
