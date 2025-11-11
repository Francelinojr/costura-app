import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orcamento.dart';
import '../services/orcamento_provider.dart';
import '../services/cliente_provider.dart';
import '../utils/constants.dart';
import 'orcamento_form_screen.dart';

class OrcamentosScreen extends StatefulWidget {
  const OrcamentosScreen({super.key});

  @override
  State<OrcamentosScreen> createState() => _OrcamentosScreenState();
}

class _OrcamentosScreenState extends State<OrcamentosScreen> {
  int _filtroSelecionado = 0; // 0: Todos, 1: Pendentes, 2: Aceitos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtro
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('Todos', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Pendentes', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Aceitos', 2),
              ],
            ),
          ),
          // Lista de orçamentos
          Expanded(
            child: Consumer2<OrcamentoProvider, ClienteProvider>(
              builder: (context, orcamentoProvider, clienteProvider, _) {
                List<Orcamento> orcamentos = orcamentoProvider.orcamentos;

                if (_filtroSelecionado == 1) {
                  orcamentos = orcamentoProvider.obterOrcamentosPendentes();
                } else if (_filtroSelecionado == 2) {
                  orcamentos = orcamentoProvider.obterOrcamentosAceitos();
                }

                if (orcamentoProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orcamentos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum orçamento encontrado',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orcamentos.length,
                  itemBuilder: (context, index) {
                    final orcamento = orcamentos[index];
                    final cliente = clienteProvider.obterClientePorId(orcamento.clienteId);

                    return _buildOrcamentoCard(
                      context,
                      orcamento,
                      cliente?.nome ?? 'Cliente desconhecido',
                      orcamentoProvider,
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
              builder: (context) => const OrcamentoFormScreen(),
            ),
          ).then((_) {
            context.read<OrcamentoProvider>().carregarOrcamentos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _filtroSelecionado == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroSelecionado = index;
        });
      },
    );
  }

  Widget _buildOrcamentoCard(
    BuildContext context,
    Orcamento orcamento,
    String clienteNome,
    OrcamentoProvider provider,
  ) {
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
                        orcamento.descricao,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        clienteNome,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: orcamento.aceito ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orcamento.aceito ? 'Aceito' : 'Pendente',
                    style: TextStyle(
                      color: orcamento.aceito ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mão de obra:', style: Theme.of(context).textTheme.bodySmall),
                      Text(AppConstants.formatarMoeda(orcamento.valorMaoDeObra), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tecido:', style: Theme.of(context).textTheme.bodySmall),
                      Text(AppConstants.formatarMoeda(orcamento.valorTecido), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Acabamento:', style: Theme.of(context).textTheme.bodySmall),
                      Text(AppConstants.formatarMoeda(orcamento.valorAcabamento), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(AppConstants.formatarMoeda(orcamento.valorTotal), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Válido até: ${AppConstants.formatarData(orcamento.dataValidade)}', style: Theme.of(context).textTheme.bodySmall),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrcamentoFormScreen(orcamento: orcamento),
                          ),
                        ).then((_) {
                          provider.carregarOrcamentos();
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _mostrarDialogoConfirmacao(context, orcamento.id, provider);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Deletar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoConfirmacao(
    BuildContext context,
    String orcamentoId,
    OrcamentoProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar orçamento?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deletarOrcamento(orcamentoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orçamento deletado com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
