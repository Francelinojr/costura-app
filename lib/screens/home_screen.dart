import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cliente_provider.dart';
import '../services/pedido_provider.dart';
import '../services/orcamento_provider.dart';
import '../services/portfolio_provider.dart';
import 'clientes_screen.dart';
import 'pedidos_pendentes_screen.dart';
import 'pedidos_screen.dart';
import 'dashboard_screen.dart';
import 'orcamentos_screen.dart';
import 'portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    Future.microtask(() {
      context.read<ClienteProvider>().carregarClientes();
      context.read<PedidoProvider>().carregarPedidos();
      context.read<OrcamentoProvider>().carregarOrcamentos();
      context.read<PortfolioProvider>().carregarPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'A Fazer'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orçamentos'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Portfólio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Relatório'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const PedidosPendentesScreen();
      case 1:
        return const ClientesScreen();
      case 2:
        return const PedidosScreen();
      case 3:
        return const OrcamentosScreen();
      case 4:
        return const PortfolioScreen();
      case 5:
        return const DashboardScreen();
      default:
        return const PedidosPendentesScreen();
    }
  }
}