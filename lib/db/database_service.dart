import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';
import '../models/orcamento.dart';
import '../models/portfolio.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'costura_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabela de Clientes
    await db.execute('''
      CREATE TABLE clientes (
        id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        telefone TEXT,
        email TEXT,
        escola TEXT,
        observacoes TEXT,
        dataCadastro TEXT NOT NULL,
        busto REAL,
        cintura REAL,
        quadril REAL,
        comprimentoBlusa REAL,
        comprimentoCalca REAL,
        manga REAL,
        ombro REAL,
        pescoco REAL
      )
    ''');

    // Tabela de Pedidos
    await db.execute('''
      CREATE TABLE pedidos (
        id TEXT PRIMARY KEY,
        clienteId TEXT NOT NULL,
        descricao TEXT NOT NULL,
        tipoPeca TEXT,
        valor REAL,
        dataPedido TEXT NOT NULL,
        dataPrazo TEXT NOT NULL,
        dataEntrega TEXT,
        status TEXT,
        observacoes TEXT,
        fotosPedido TEXT,
        FOREIGN KEY (clienteId) REFERENCES clientes(id)
      )
    ''');

    // Tabela de Orçamentos
    await db.execute('''
      CREATE TABLE orcamentos (
        id TEXT PRIMARY KEY,
        clienteId TEXT NOT NULL,
        descricao TEXT NOT NULL,
        tipoPeca TEXT,
        valorMaoDeObra REAL,
        valorTecido REAL,
        valorAcabamento REAL,
        desconto REAL,
        dataCriacao TEXT NOT NULL,
        dataValidade TEXT NOT NULL,
        observacoes TEXT,
        aceito INTEGER,
        FOREIGN KEY (clienteId) REFERENCES clientes(id)
      )
    ''');

    // Tabela de Portfólio
    await db.execute('''
      CREATE TABLE portfolio (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descricao TEXT,
        tipoPeca TEXT,
        caminhoFoto TEXT NOT NULL,
        dataCriacao TEXT NOT NULL,
        clienteId TEXT,
        avaliacao REAL,
        FOREIGN KEY (clienteId) REFERENCES clientes(id)
      )
    ''');
  }

  // ===== OPERAÇÕES DE CLIENTES =====
  Future<void> inserirCliente(Cliente cliente) async {
    final db = await database;
    await db.insert('clientes', cliente.toMap());
  }

  Future<List<Cliente>> obterTodosClientes() async {
    final db = await database;
    final maps = await db.query('clientes', orderBy: 'dataCadastro DESC');
    return List.generate(maps.length, (i) => Cliente.fromMap(maps[i]));
  }

  Future<Cliente?> obterClientePorId(String id) async {
    final db = await database;
    final maps = await db.query('clientes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Cliente.fromMap(maps.first);
    }
    return null;
  }

  Future<void> atualizarCliente(Cliente cliente) async {
    final db = await database;
    await db.update('clientes', cliente.toMap(), where: 'id = ?', whereArgs: [cliente.id]);
  }

  Future<void> deletarCliente(String id) async {
    final db = await database;
    await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }

  // ===== OPERAÇÕES DE PEDIDOS =====
  Future<void> inserirPedido(Pedido pedido) async {
    final db = await database;
    await db.insert('pedidos', pedido.toMap());
  }

  Future<List<Pedido>> obterTodosPedidos() async {
    final db = await database;
    final maps = await db.query('pedidos', orderBy: 'dataPedido DESC');
    return List.generate(maps.length, (i) => Pedido.fromMap(maps[i]));
  }

  Future<List<Pedido>> obterPedidosPorCliente(String clienteId) async {
    final db = await database;
    final maps = await db.query('pedidos', where: 'clienteId = ?', whereArgs: [clienteId], orderBy: 'dataPedido DESC');
    return List.generate(maps.length, (i) => Pedido.fromMap(maps[i]));
  }

  Future<Pedido?> obterPedidoPorId(String id) async {
    final db = await database;
    final maps = await db.query('pedidos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Pedido.fromMap(maps.first);
    }
    return null;
  }

  Future<void> atualizarPedido(Pedido pedido) async {
    final db = await database;
    await db.update('pedidos', pedido.toMap(), where: 'id = ?', whereArgs: [pedido.id]);
  }

  Future<void> deletarPedido(String id) async {
    final db = await database;
    await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  // ===== OPERAÇÕES DE ORÇAMENTOS =====
  Future<void> inserirOrcamento(Orcamento orcamento) async {
    final db = await database;
    await db.insert('orcamentos', orcamento.toMap());
  }

  Future<List<Orcamento>> obterTodosOrcamentos() async {
    final db = await database;
    final maps = await db.query('orcamentos', orderBy: 'dataCriacao DESC');
    return List.generate(maps.length, (i) => Orcamento.fromMap(maps[i]));
  }

  Future<List<Orcamento>> obterOrcamentosPorCliente(String clienteId) async {
    final db = await database;
    final maps = await db.query('orcamentos', where: 'clienteId = ?', whereArgs: [clienteId], orderBy: 'dataCriacao DESC');
    return List.generate(maps.length, (i) => Orcamento.fromMap(maps[i]));
  }

  Future<Orcamento?> obterOrcamentoPorId(String id) async {
    final db = await database;
    final maps = await db.query('orcamentos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Orcamento.fromMap(maps.first);
    }
    return null;
  }

  Future<void> atualizarOrcamento(Orcamento orcamento) async {
    final db = await database;
    await db.update('orcamentos', orcamento.toMap(), where: 'id = ?', whereArgs: [orcamento.id]);
  }

  Future<void> deletarOrcamento(String id) async {
    final db = await database;
    await db.delete('orcamentos', where: 'id = ?', whereArgs: [id]);
  }

  // ===== OPERAÇÕES DE PORTFÓLIO =====
  Future<void> inserirPortfolio(Portfolio portfolio) async {
    final db = await database;
    await db.insert('portfolio', portfolio.toMap());
  }

  Future<List<Portfolio>> obterTodoPortfolio() async {
    final db = await database;
    final maps = await db.query('portfolio', orderBy: 'dataCriacao DESC');
    return List.generate(maps.length, (i) => Portfolio.fromMap(maps[i]));
  }

  Future<List<Portfolio>> obterPortfolioPorCliente(String clienteId) async {
    final db = await database;
    final maps = await db.query('portfolio', where: 'clienteId = ?', whereArgs: [clienteId], orderBy: 'dataCriacao DESC');
    return List.generate(maps.length, (i) => Portfolio.fromMap(maps[i]));
  }

  Future<Portfolio?> obterPortfolioPorId(String id) async {
    final db = await database;
    final maps = await db.query('portfolio', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Portfolio.fromMap(maps.first);
    }
    return null;
  }

  Future<void> atualizarPortfolio(Portfolio portfolio) async {
    final db = await database;
    await db.update('portfolio', portfolio.toMap(), where: 'id = ?', whereArgs: [portfolio.id]);
  }

  Future<void> deletarPortfolio(String id) async {
    final db = await database;
    await db.delete('portfolio', where: 'id = ?', whereArgs: [id]);
  }
}
