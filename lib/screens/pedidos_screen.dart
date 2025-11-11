import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pedido.dart';
import '../services/pedido_provider.dart';
import '../services/cliente_provider.dart';
import '../widgets/pedido_card.dart';
import 'pedido_form_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  StatusPedido? _filtroStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtro de status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip(null, 'Todos'),
                const SizedBox(width: 8),
                _buildFilterChip(StatusPedido.orcamento, 'Orçamento'),
                const SizedBox(width: 8),
                _buildFilterChip(StatusPedido.confirmado, 'Confirmado'),
                const SizedBox(width: 8),
                _buildFilterChip(StatusPedido.emProgresso, 'Em Progresso'),
                const SizedBox(width: 8),
                _buildFilterChip(StatusPedido.pronto, 'Pronto'),
                const SizedBox(width: 8),
                _buildFilterChip(StatusPedido.entregue, 'Entregue'),
              ],
            ),
          ),
          // Lista de pedidos
          Expanded(
            child: Consumer2<PedidoProvider, ClienteProvider>(
              builder: (context, pedidoProvider, clienteProvider, _) {
                List<Pedido> pedidos = pedidoProvider.pedidos;

                if (_filtroStatus != null) {
                  pedidos = pedidos.where((p) => p.status == _filtroStatus).toList();
                }

                if (pedidoProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pedidos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum pedido encontrado',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    final cliente = clienteProvider.obterClientePorId(pedido.clienteId);

                    return PedidoCard(
                      pedido: pedido,
                      clienteNome: cliente?.nome,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PedidoFormScreen(pedido: pedido),
                          ),
                        ).then((_) {
                          pedidoProvider.carregarPedidos();
                        });
                      },
                      onDelete: () {
                        _mostrarDialogoConfirmacao(context, pedido.id, pedidoProvider);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PedidoFormScreen(),
            ),
          ).then((_) {
            context.read<PedidoProvider>().carregarPedidos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(StatusPedido? status, String label) {
    final isSelected = _filtroStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroStatus = selected ? status : null;
        });
      },
    );
  }

  void _mostrarDialogoConfirmacao(
    BuildContext context,
    String pedidoId,
    PedidoProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar pedido?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deletarPedido(pedidoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido deletado com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
