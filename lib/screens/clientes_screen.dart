import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cliente_provider.dart';
import '../widgets/cliente_card.dart';
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Clientes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar cliente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Lista de clientes
          Expanded(
            child: Consumer<ClienteProvider>(
              builder: (context, clienteProvider, _) {
                final clientes = _searchTerm.isEmpty
                    ? clienteProvider.clientes
                    : clienteProvider.buscarClientes(_searchTerm);

                if (clienteProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (clientes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchTerm.isEmpty
                              ? 'Nenhuma cliente cadastrada'
                              : 'Nenhuma cliente encontrada',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ClienteCard(
                      cliente: cliente,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClienteFormScreen(cliente: cliente),
                          ),
                        ).then((_) {
                          clienteProvider.carregarClientes();
                        });
                      },
                      onDelete: () {
                        _mostrarDialogoConfirmacao(context, cliente.id, clienteProvider);
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
              builder: (context) => const ClienteFormScreen(),
            ),
          ).then((_) {
            context.read<ClienteProvider>().carregarClientes();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoConfirmacao(
    BuildContext context,
    String clienteId,
    ClienteProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar cliente?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deletarCliente(clienteId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cliente deletado com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
