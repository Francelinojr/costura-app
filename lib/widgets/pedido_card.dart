import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../utils/constants.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final String? clienteNome;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PedidoCard({
    Key? key,
    required this.pedido,
    this.clienteNome,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diasRestantes = pedido.dataPrazo.difference(DateTime.now()).inDays;
    final isAtrasado = diasRestantes < 0 && pedido.status != StatusPedido.entregue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pedido.descricao,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (clienteNome != null)
                        Text(
                          clienteNome!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pedido.statusLabel,
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo: ${pedido.tipoPeca}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Valor: ${AppConstants.formatarMoeda(pedido.valor)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Prazo: ${AppConstants.formatarData(pedido.dataPrazo)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      isAtrasado ? 'ATRASADO!' : 'Faltam $diasRestantes dias',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isAtrasado ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Deletar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (pedido.status) {
      case StatusPedido.orcamento:
        return Colors.orange;
      case StatusPedido.confirmado:
        return Colors.blue;
      case StatusPedido.emProgresso:
        return Colors.amber;
      case StatusPedido.pronto:
        return Colors.lightGreen;
      case StatusPedido.entregue:
        return Colors.green;
      case StatusPedido.cancelado:
        return Colors.red;
    }
  }
}
