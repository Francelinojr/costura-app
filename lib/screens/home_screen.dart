import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cliente_provider.dart';
import '../services/pedido_provider.dart';
import '../services/orcamento_provider.dart';
import '../services/portfolio_provider.dart';
import '../utils/theme.dart';
import 'clientes_screen.dart';
import 'pedidos_screen.dart';
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orçamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Portfólio',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const ClientesScreen();
      case 2:
        return const PedidosScreen();
      case 3:
        return const OrcamentosScreen();
      case 4:
        return const PortfolioScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Costura Fácil',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bem-vindo ao seu gerenciador de costura',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            const SizedBox(height: 24),

            // Cards de resumo
            _buildResumoCards(),

            const SizedBox(height: 24),

            // Pedidos em atraso
            _buildPedidosEmAtraso(),

            const SizedBox(height: 24),

            // Próximos pedidos
            _buildProximosPedidos(),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoCards() {
    return Consumer4<ClienteProvider, PedidoProvider, OrcamentoProvider, PortfolioProvider>(
      builder: (context, clienteProvider, pedidoProvider, orcamentoProvider, portfolioProvider, _) {
        final totalClientes = clienteProvider.clientes.length;
        final totalPedidos = pedidoProvider.pedidos.length;
        final totalOrcamentos = orcamentoProvider.orcamentos.length;
        final totalPortfolio = portfolioProvider.portfolio.length;

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildResumoCard(
              titulo: 'Clientes',
              valor: totalClientes.toString(),
              icone: Icons.people,
              cor: Colors.blue,
            ),
            _buildResumoCard(
              titulo: 'Pedidos',
              valor: totalPedidos.toString(),
              icone: Icons.assignment,
              cor: Colors.purple,
            ),
            _buildResumoCard(
              titulo: 'Orçamentos',
              valor: totalOrcamentos.toString(),
              icone: Icons.receipt,
              cor: Colors.orange,
            ),
            _buildResumoCard(
              titulo: 'Portfólio',
              valor: totalPortfolio.toString(),
              icone: Icons.image,
              cor: Colors.green,
            ),
          ],
        );
      },
    );
  }

  Widget _buildResumoCard({
    required String titulo,
    required String valor,
    required IconData icone,
    required Color cor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icone, color: cor, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: cor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidosEmAtraso() {
    return Consumer<PedidoProvider>(
      builder: (context, pedidoProvider, _) {
        final pedidosAtrasados = pedidoProvider.obterPedidosEmAtraso();

        if (pedidosAtrasados.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedidos em Atraso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                  ),
            ),
            const SizedBox(height: 12),
            ...pedidosAtrasados.take(3).map((pedido) {
              return Card(
                color: Colors.red.withOpacity(0.1),
                child: ListTile(
                  title: Text(pedido.descricao),
                  subtitle: Text('Prazo: ${pedido.dataPrazo.day}/${pedido.dataPrazo.month}'),
                  trailing: const Icon(Icons.warning, color: Colors.red),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildProximosPedidos() {
    return Consumer<PedidoProvider>(
      builder: (context, pedidoProvider, _) {
        final proximosPedidos = pedidoProvider.obterProximosPedidos();

        if (proximosPedidos.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximos Pedidos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...proximosPedidos.take(3).map((pedido) {
              return Card(
                child: ListTile(
                  title: Text(pedido.descricao),
                  subtitle: Text('Prazo: ${pedido.dataPrazo.day}/${pedido.dataPrazo.month}'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
