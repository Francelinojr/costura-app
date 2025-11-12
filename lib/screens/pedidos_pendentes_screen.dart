import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/pedido.dart';
import '../services/pedido_provider.dart';
import '../services/cliente_provider.dart';
import '../widgets/pedido_card.dart';
import 'pedido_form_screen.dart';
import 'novo_pedido_integrado_screen.dart';

class PedidosPendentesScreen extends StatelessWidget {
  const PedidosPendentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Pendentes'),
        elevation: 0,
      ),
      body: Consumer2<PedidoProvider, ClienteProvider>(
        builder: (context, pedidoProvider, clienteProvider, _) {
          if (pedidoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filtra os pedidos que NÃO estão como 'concluido' ou 'cancelado'
          final List<Pedido> pedidosPendentes = pedidoProvider.pedidos.where((p) {
            return p.status != StatusPedido.concluido && p.status != StatusPedido.cancelado;
          }).toList();

          if (pedidosPendentes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum pedido pendente encontrado',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: pedidosPendentes.length,
            itemBuilder: (context, index) {
              final pedido = pedidosPendentes[index];
              final cliente = clienteProvider.obterClientePorId(pedido.clienteId);

              return Slidable(
                key: ValueKey('pedido_${pedido.id}'),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.35,
                  children: [
                    SlidableAction(
                      onPressed: (actionContext) async {
                        final originalPedido = pedido;
                        final concluido = Pedido(
                          id: originalPedido.id,
                          clienteId: originalPedido.clienteId,
                          descricao: originalPedido.descricao,
                          tipoPeca: originalPedido.tipoPeca,
                          valor: originalPedido.valor,
                          dataPedido: originalPedido.dataPedido,
                          dataPrazo: originalPedido.dataPrazo,
                          dataEntrega: DateTime.now(),
                          status: StatusPedido.concluido,
                          observacoes: originalPedido.observacoes,
                          fotosPedido: originalPedido.fotosPedido,
                        );

                        await pedidoProvider.atualizarPedido(concluido);

                        ScaffoldMessenger.of(actionContext).showSnackBar(
                          SnackBar(
                            content: const Text('Pedido marcado como Concluído'),
                            action: SnackBarAction(
                              label: 'Desfazer',
                              onPressed: () async {
                                await pedidoProvider.atualizarPedido(originalPedido);
                                ScaffoldMessenger.of(actionContext).showSnackBar(
                                  const SnackBar(content: Text('Conclusão desfeita')),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.check,
                      label: 'Confirmar',
                    ),
                  ],
                ),
                child: PedidoCard(
                  pedido: pedido,
                  clienteNome: cliente?.nome,
                  clienteEscola: cliente?.escola,
                  mostrarPrazo: false,
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NovoPedidoIntegradoScreen(),
            ),
          ).then((_) {
            context.read<PedidoProvider>().carregarPedidos();
          });
        },
        label: const Text('+ Novo Pedido'),
        icon: const Icon(Icons.add),
      ),
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
