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

class WebHomeScreen extends StatefulWidget {
  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    final isTablet = MediaQuery.of(context).size.width > 600 && !isDesktop;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.cut, color: AppTheme.primaryColor),
            SizedBox(width: 12),
            Text('Costura Fácil'),
          ],
        ),
        elevation: 2,
        backgroundColor: AppTheme.surfaceColor,
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          // Sidebar para desktop
          if (isDesktop)
            Container(
              width: 280,
              color: AppTheme.surfaceColor,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  ..._buildNavItems(),
                ],
              ),
            ),
          // Conteúdo principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
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

  List<Widget> _buildNavItems() {
    final items = [
      ('Início', Icons.home, 0),
      ('Clientes', Icons.people, 1),
      ('Pedidos', Icons.assignment, 2),
      ('Orçamentos', Icons.receipt, 3),
      ('Portfólio', Icons.image, 4),
    ];

    return items.map((item) {
      final isSelected = _selectedIndex == item.$3;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Icon(
            item.$2,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          ),
          title: Text(
            item.$1,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onTap: () {
            setState(() {
              _selectedIndex = item.$3;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
        ),
      );
    }).toList();
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return ClientesScreen();
      case 2:
        return PedidosScreen();
      case 3:
        return OrcamentosScreen();
      case 4:
        return PortfolioScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Bem-vindo ao Costura Fácil',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Gerencie seu negócio de costura de forma simples e eficiente',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
            SizedBox(height: 32),

            // Cards de resumo
            _buildResumoCards(),

            SizedBox(height: 32),

            // Pedidos em atraso
            _buildPedidosEmAtraso(),

            SizedBox(height: 32),

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
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
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
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icone, color: cor, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: cor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodyMedium,
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
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedidos em Atraso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: pedidosAtrasados.take(3).length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final pedido = pedidosAtrasados[index];
                return Card(
                  color: Colors.red.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pedido.descricao,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Prazo: ${pedido.dataPrazo.day}/${pedido.dataPrazo.month}/${pedido.dataPrazo.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Próximos Pedidos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: proximosPedidos.take(3).length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final pedido = proximosPedidos[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pedido.descricao,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Prazo: ${pedido.dataPrazo.day}/${pedido.dataPrazo.month}/${pedido.dataPrazo.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.cut, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  'Costura Fácil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ..._buildNavItems(),
        ],
      ),
    );
  }
}
