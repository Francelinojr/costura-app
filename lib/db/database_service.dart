import 'dart:convert';
import 'dart:html' as html;
import '../models/cliente.dart';
import '../models/pedido.dart';
import '../models/orcamento.dart';
import '../models/portfolio.dart';

/// Serviço de banco de dados para Web usando localStorage
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Storage keys
  static const String _clientesKey = 'costura_clientes';
  static const String _pedidosKey = 'costura_pedidos';
  static const String _orcamentosKey = 'costura_orcamentos';
  static const String _portfolioKey = 'costura_portfolio';

  final _storage = html.window.localStorage;

  // ===== OPERAÇÕES DE CLIENTES =====
  
  Future<void> inserirCliente(Cliente cliente) async {
    final clientes = await obterTodosClientes();
    clientes.add(cliente);
    _salvarClientes(clientes);
  }

  Future<List<Cliente>> obterTodosClientes() async {
    final json = _storage[_clientesKey];
    if (json == null || json.isEmpty) return [];
    
    try {
      final List<dynamic> lista = jsonDecode(json);
      return lista.map((item) => Cliente.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao carregar clientes: $e');
      return [];
    }
  }

  Future<Cliente?> obterClientePorId(String id) async {
    final clientes = await obterTodosClientes();
    try {
      return clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> atualizarCliente(Cliente cliente) async {
    final clientes = await obterTodosClientes();
    final index = clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      clientes[index] = cliente;
      _salvarClientes(clientes);
    }
  }

  Future<void> deletarCliente(String id) async {
    final clientes = await obterTodosClientes();
    clientes.removeWhere((c) => c.id == id);
    _salvarClientes(clientes);
  }

  void _salvarClientes(List<Cliente> clientes) {
    final json = jsonEncode(clientes.map((c) => c.toMap()).toList());
    _storage[_clientesKey] = json;
  }

  // ===== OPERAÇÕES DE PEDIDOS =====

  Future<void> inserirPedido(Pedido pedido) async {
    final pedidos = await obterTodosPedidos();
    pedidos.add(pedido);
    _salvarPedidos(pedidos);
  }

  Future<List<Pedido>> obterTodosPedidos() async {
    final json = _storage[_pedidosKey];
    if (json == null || json.isEmpty) return [];
    
    try {
      final List<dynamic> lista = jsonDecode(json);
      return lista.map((item) => Pedido.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
      return [];
    }
  }

  Future<List<Pedido>> obterPedidosPorCliente(String clienteId) async {
    final pedidos = await obterTodosPedidos();
    return pedidos.where((p) => p.clienteId == clienteId).toList();
  }

  Future<Pedido?> obterPedidoPorId(String id) async {
    final pedidos = await obterTodosPedidos();
    try {
      return pedidos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> atualizarPedido(Pedido pedido) async {
    final pedidos = await obterTodosPedidos();
    final index = pedidos.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      pedidos[index] = pedido;
      _salvarPedidos(pedidos);
    }
  }

  Future<void> deletarPedido(String id) async {
    final pedidos = await obterTodosPedidos();
    pedidos.removeWhere((p) => p.id == id);
    _salvarPedidos(pedidos);
  }

  void _salvarPedidos(List<Pedido> pedidos) {
    final json = jsonEncode(pedidos.map((p) => p.toMap()).toList());
    _storage[_pedidosKey] = json;
  }

  // ===== OPERAÇÕES DE ORÇAMENTOS =====

  Future<void> inserirOrcamento(Orcamento orcamento) async {
    final orcamentos = await obterTodosOrcamentos();
    orcamentos.add(orcamento);
    _salvarOrcamentos(orcamentos);
  }

  Future<List<Orcamento>> obterTodosOrcamentos() async {
    final json = _storage[_orcamentosKey];
    if (json == null || json.isEmpty) return [];
    
    try {
      final List<dynamic> lista = jsonDecode(json);
      return lista.map((item) => Orcamento.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao carregar orçamentos: $e');
      return [];
    }
  }

  Future<List<Orcamento>> obterOrcamentosPorCliente(String clienteId) async {
    final orcamentos = await obterTodosOrcamentos();
    return orcamentos.where((o) => o.clienteId == clienteId).toList();
  }

  Future<Orcamento?> obterOrcamentoPorId(String id) async {
    final orcamentos = await obterTodosOrcamentos();
    try {
      return orcamentos.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> atualizarOrcamento(Orcamento orcamento) async {
    final orcamentos = await obterTodosOrcamentos();
    final index = orcamentos.indexWhere((o) => o.id == orcamento.id);
    if (index != -1) {
      orcamentos[index] = orcamento;
      _salvarOrcamentos(orcamentos);
    }
  }

  Future<void> deletarOrcamento(String id) async {
    final orcamentos = await obterTodosOrcamentos();
    orcamentos.removeWhere((o) => o.id == id);
    _salvarOrcamentos(orcamentos);
  }

  void _salvarOrcamentos(List<Orcamento> orcamentos) {
    final json = jsonEncode(orcamentos.map((o) => o.toMap()).toList());
    _storage[_orcamentosKey] = json;
  }

  // ===== OPERAÇÕES DE PORTFÓLIO =====

  Future<void> inserirPortfolio(Portfolio portfolio) async {
    final items = await obterTodoPortfolio();
    items.add(portfolio);
    _salvarPortfolio(items);
  }

  Future<List<Portfolio>> obterTodoPortfolio() async {
    final json = _storage[_portfolioKey];
    if (json == null || json.isEmpty) return [];
    
    try {
      final List<dynamic> lista = jsonDecode(json);
      return lista.map((item) => Portfolio.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Erro ao carregar portfólio: $e');
      return [];
    }
  }

  Future<List<Portfolio>> obterPortfolioPorCliente(String clienteId) async {
    final items = await obterTodoPortfolio();
    return items.where((p) => p.clienteId == clienteId).toList();
  }

  Future<Portfolio?> obterPortfolioPorId(String id) async {
    final items = await obterTodoPortfolio();
    try {
      return items.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> atualizarPortfolio(Portfolio portfolio) async {
    final items = await obterTodoPortfolio();
    final index = items.indexWhere((p) => p.id == portfolio.id);
    if (index != -1) {
      items[index] = portfolio;
      _salvarPortfolio(items);
    }
  }

  Future<void> deletarPortfolio(String id) async {
    final items = await obterTodoPortfolio();
    items.removeWhere((p) => p.id == id);
    _salvarPortfolio(items);
  }

  void _salvarPortfolio(List<Portfolio> items) {
    final json = jsonEncode(items.map((p) => p.toMap()).toList());
    _storage[_portfolioKey] = json;
  }
}