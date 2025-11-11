import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/portfolio.dart';
import '../services/portfolio_provider.dart';
import '../services/cliente_provider.dart';
import '../utils/constants.dart';

class PortfolioFormScreen extends StatefulWidget {
  final Portfolio? portfolio;

  const PortfolioFormScreen({Key? key, this.portfolio}) : super(key: key);

  @override
  State<PortfolioFormScreen> createState() => _PortfolioFormScreenState();
}

class _PortfolioFormScreenState extends State<PortfolioFormScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _avaliacaoController;

  String _tipoPecaSelecionado = 'Blusa';
  String? _clienteSelecionado;
  String _caminhoFoto = '';

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.portfolio?.titulo ?? '');
    _descricaoController = TextEditingController(text: widget.portfolio?.descricao ?? '');
    _avaliacaoController = TextEditingController(text: widget.portfolio?.avaliacao.toString() ?? '5');
    _tipoPecaSelecionado = widget.portfolio?.tipoPeca ?? 'Blusa';
    _clienteSelecionado = widget.portfolio?.clienteId;
    _caminhoFoto = widget.portfolio?.caminhoFoto ?? '';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _avaliacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.portfolio == null ? 'Novo Trabalho' : 'Editar Trabalho'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            _buildSectionTitle('Foto do Trabalho'),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: _caminhoFoto.isNotEmpty
                  ? Image.asset(
                      _caminhoFoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                              SizedBox(height: 8),
                              Text('Erro ao carregar imagem'),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text('Nenhuma foto selecionada'),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selecionarFoto,
                    icon: Icon(Icons.photo_camera),
                    label: Text('Selecionar Foto'),
                  ),
                ),
                if (_caminhoFoto.isNotEmpty)
                  SizedBox(width: 8),
                if (_caminhoFoto.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _caminhoFoto = '';
                      });
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Remover'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24),

            // Detalhes
            _buildSectionTitle('Detalhes do Trabalho'),
            SizedBox(height: 12),
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: 'Título *',
                hintText: 'Nome do trabalho',
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tipoPecaSelecionado,
              items: AppConstants.tiposPeca.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipoPecaSelecionado = value ?? 'Blusa';
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Peça',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Descreva este trabalho',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 24),

            // Cliente e Avaliação
            _buildSectionTitle('Cliente e Avaliação'),
            SizedBox(height: 12),
            Consumer<ClienteProvider>(
              builder: (context, clienteProvider, _) {
                return DropdownButtonFormField<String>(
                  value: _clienteSelecionado,
                  hint: Text('Selecione uma cliente (opcional)'),
                  items: clienteProvider.clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente.id,
                      child: Text(cliente.nome),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _clienteSelecionado = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Cliente',
                  ),
                );
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: _avaliacaoController,
              decoration: InputDecoration(
                labelText: 'Avaliação (0-5)',
                hintText: '5',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvarTrabalho,
                    child: Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void _selecionarFoto() {
    // Simulação de seleção de foto
    // Em produção, usar image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade de câmera/galeria será implementada com image_picker')),
    );
  }

  void _salvarTrabalho() {
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha o título')),
      );
      return;
    }

    final trabalho = Portfolio(
      id: widget.portfolio?.id ?? const Uuid().v4(),
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      tipoPeca: _tipoPecaSelecionado,
      caminhoFoto: _caminhoFoto,
      dataCriacao: widget.portfolio?.dataCriacao ?? DateTime.now(),
      clienteId: _clienteSelecionado ?? '',
      avaliacao: double.tryParse(_avaliacaoController.text) ?? 5,
    );

    final provider = context.read<PortfolioProvider>();

    if (widget.portfolio == null) {
      provider.adicionarTrabalho(trabalho);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trabalho adicionado com sucesso')),
      );
    } else {
      provider.atualizarTrabalho(trabalho);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trabalho atualizado com sucesso')),
      );
    }

    Navigator.pop(context);
  }
}
