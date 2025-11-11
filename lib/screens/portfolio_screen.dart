import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/portfolio.dart';
import '../services/portfolio_provider.dart';
import '../utils/constants.dart';
import 'portfolio_form_screen.dart';

class PortfolioScreen extends StatefulWidget {
  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String? _filtroTipo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Portfólio'),
        elevation: 0,
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, portfolioProvider, _) {
          List<Portfolio> trabalhos = portfolioProvider.portfolio;

          if (_filtroTipo != null) {
            trabalhos = trabalhos.where((t) => t.tipoPeca == _filtroTipo).toList();
          }

          if (portfolioProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Filtro por tipo
              if (portfolioProvider.portfolio.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', null),
                      ...AppConstants.tiposPeca.map((tipo) {
                        return Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: _buildFilterChip(tipo, tipo),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              // Grid de trabalhos
              Expanded(
                child: trabalhos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum trabalho no portfólio',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: trabalhos.length,
                        itemBuilder: (context, index) {
                          final trabalho = trabalhos[index];
                          return _buildTrabalhoCard(context, trabalho, portfolioProvider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PortfolioFormScreen(),
            ),
          ).then((_) {
            context.read<PortfolioProvider>().carregarPortfolio();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? tipo) {
    final isSelected = _filtroTipo == tipo;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroTipo = selected ? tipo : null;
        });
      },
    );
  }

  Widget _buildTrabalhoCard(
    BuildContext context,
    Portfolio trabalho,
    PortfolioProvider provider,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: trabalho.caminhoFoto.isNotEmpty
                  ? Image.asset(
                      trabalho.caminhoFoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.image_outlined, color: Colors.grey, size: 40),
                    ),
            ),
          ),
          // Informações
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trabalho.titulo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      trabalho.avaliacao.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PortfolioFormScreen(portfolio: trabalho),
                            ),
                          ).then((_) {
                            provider.carregarPortfolio();
                          });
                        },
                        icon: Icon(Icons.edit, size: 16),
                        label: Text('Editar', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          _mostrarDialogoConfirmacao(context, trabalho.id, provider);
                        },
                        icon: Icon(Icons.delete, size: 16, color: Colors.red),
                        label: Text('Deletar', style: TextStyle(fontSize: 12, color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoConfirmacao(
    BuildContext context,
    String trabalhoId,
    PortfolioProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deletar trabalho?'),
        content: Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deletarTrabalho(trabalhoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trabalho deletado com sucesso')),
              );
            },
            child: Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
