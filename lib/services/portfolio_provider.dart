import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import '../db/database_service.dart';

class PortfolioProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Portfolio> _portfolio = [];
  bool _isLoading = false;

  List<Portfolio> get portfolio => _portfolio;
  bool get isLoading => _isLoading;

  // Carregar todo portfólio
  Future<void> carregarPortfolio() async {
    _isLoading = true;
    notifyListeners();
    try {
      _portfolio = await _databaseService.obterTodoPortfolio();
    } catch (e) {
      print('Erro ao carregar portfólio: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Carregar portfólio de um cliente específico
  Future<List<Portfolio>> carregarPortfolioPorCliente(String clienteId) async {
    try {
      return await _databaseService.obterPortfolioPorCliente(clienteId);
    } catch (e) {
      print('Erro ao carregar portfólio do cliente: $e');
      return [];
    }
  }

  // Adicionar novo trabalho ao portfólio
  Future<void> adicionarTrabalho(Portfolio trabalho) async {
    try {
      await _databaseService.inserirPortfolio(trabalho);
      _portfolio.add(trabalho);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar trabalho: $e');
    }
  }

  // Atualizar trabalho
  Future<void> atualizarTrabalho(Portfolio trabalho) async {
    try {
      await _databaseService.atualizarPortfolio(trabalho);
      final index = _portfolio.indexWhere((p) => p.id == trabalho.id);
      if (index != -1) {
        _portfolio[index] = trabalho;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar trabalho: $e');
    }
  }

  // Deletar trabalho
  Future<void> deletarTrabalho(String id) async {
    try {
      await _databaseService.deletarPortfolio(id);
      _portfolio.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar trabalho: $e');
    }
  }

  // Obter trabalho por ID
  Portfolio? obterTrabalhoPorId(String id) {
    try {
      return _portfolio.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obter trabalhos por tipo de peça
  List<Portfolio> obterTrabalhosPorTipo(String tipo) {
    return _portfolio.where((p) => p.tipoPeca == tipo).toList();
  }

  // Obter trabalhos melhor avaliados
  List<Portfolio> obterTrabalhosMelhorAvaliados({int limite = 5}) {
    final sorted = List<Portfolio>.from(_portfolio);
    sorted.sort((a, b) => b.avaliacao.compareTo(a.avaliacao));
    return sorted.take(limite).toList();
  }

  // Calcular avaliação média
  double calcularAvaliacaoMedia() {
    if (_portfolio.isEmpty) return 0;
    final soma = _portfolio.fold(0.0, (sum, p) => sum + p.avaliacao);
    return soma / _portfolio.length;
  }
}
