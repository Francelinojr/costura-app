import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/orcamento.dart';
import '../services/orcamento_provider.dart';
import '../services/cliente_provider.dart';
import '../utils/constants.dart';

class OrcamentoFormScreen extends StatefulWidget {
  final Orcamento? orcamento;

  const OrcamentoFormScreen({Key? key, this.orcamento}) : super(key: key);

  @override
  State<OrcamentoFormScreen> createState() => _OrcamentoFormScreenState();
}

class _OrcamentoFormScreenState extends State<OrcamentoFormScreen> {
  late TextEditingController _descricaoController;
  late TextEditingController _valorMaoDeObraController;
  late TextEditingController _valorTecidoController;
  late TextEditingController _valorAcabamentoController;
  late TextEditingController _descontoController;
  late TextEditingController _observacoesController;

  String? _clienteSelecionado;
  String _tipoPecaSelecionado = 'Blusa';
  DateTime? _dataValidade;
  bool _aceito = false;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.orcamento?.descricao ?? '');
    _valorMaoDeObraController = TextEditingController(text: widget.orcamento?.valorMaoDeObra.toString() ?? '');
    _valorTecidoController = TextEditingController(text: widget.orcamento?.valorTecido.toString() ?? '');
    _valorAcabamentoController = TextEditingController(text: widget.orcamento?.valorAcabamento.toString() ?? '');
    _descontoController = TextEditingController(text: widget.orcamento?.desconto.toString() ?? '');
    _observacoesController = TextEditingController(text: widget.orcamento?.observacoes ?? '');
    _clienteSelecionado = widget.orcamento?.clienteId;
    _tipoPecaSelecionado = widget.orcamento?.tipoPeca ?? 'Blusa';
    _dataValidade = widget.orcamento?.dataValidade;
    _aceito = widget.orcamento?.aceito ?? false;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorMaoDeObraController.dispose();
    _valorTecidoController.dispose();
    _valorAcabamentoController.dispose();
    _descontoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orcamento == null ? 'Novo Orçamento' : 'Editar Orçamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleção de cliente
            _buildSectionTitle('Cliente'),
            const SizedBox(height: 12),
            Consumer<ClienteProvider>(
              builder: (context, clienteProvider, _) {
                return DropdownButtonFormField<String>(
                  initialValue: _clienteSelecionado,
                  hint: const Text('Selecione uma cliente'),
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
                  decoration: const InputDecoration(
                    labelText: 'Cliente *',
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Detalhes
            _buildSectionTitle('Detalhes do Orçamento'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _tipoPecaSelecionado,
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
              decoration: const InputDecoration(
                labelText: 'Tipo de Peça',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição *',
                hintText: 'Descreva o orçamento',
              ),
            ),
            const SizedBox(height: 24),

            // Valores
            _buildSectionTitle('Valores'),
            const SizedBox(height: 12),
            TextField(
              controller: _valorMaoDeObraController,
              decoration: const InputDecoration(
                labelText: 'Mão de Obra (R\$)',
                hintText: '0,00',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valorTecidoController,
              decoration: const InputDecoration(
                labelText: 'Tecido (R\$)',
                hintText: '0,00',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valorAcabamentoController,
              decoration: const InputDecoration(
                labelText: 'Acabamento (R\$)',
                hintText: '0,00',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descontoController,
              decoration: const InputDecoration(
                labelText: 'Desconto (R\$)',
                hintText: '0,00',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    AppConstants.formatarMoeda(_calcularTotal()),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data de validade
            _buildSectionTitle('Validade'),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Data de Validade'),
              subtitle: Text(
                _dataValidade != null
                    ? AppConstants.formatarData(_dataValidade!)
                    : 'Selecione uma data',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarDataValidade,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // Status
            _buildSectionTitle('Status'),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Orçamento Aceito'),
              value: _aceito,
              onChanged: (value) {
                setState(() {
                  _aceito = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),

            // Observações
            _buildSectionTitle('Observações'),
            const SizedBox(height: 12),
            TextField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Adicione observações importantes',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvarOrcamento,
                    child: const Text('Salvar'),
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

  void _selecionarDataValidade() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataValidade ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (data != null) {
      setState(() {
        _dataValidade = data;
      });
    }
  }

  double _calcularTotal() {
    final maoDeObra = double.tryParse(_valorMaoDeObraController.text) ?? 0;
    final tecido = double.tryParse(_valorTecidoController.text) ?? 0;
    final acabamento = double.tryParse(_valorAcabamentoController.text) ?? 0;
    final desconto = double.tryParse(_descontoController.text) ?? 0;
    return maoDeObra + tecido + acabamento - desconto;
  }

  void _salvarOrcamento() {
    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma cliente')),
      );
      return;
    }

    if (_descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha a descrição')),
      );
      return;
    }

    if (_dataValidade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma data de validade')),
      );
      return;
    }

    final orcamento = Orcamento(
      id: widget.orcamento?.id ?? const Uuid().v4(),
      clienteId: _clienteSelecionado!,
      descricao: _descricaoController.text,
      tipoPeca: _tipoPecaSelecionado,
      valorMaoDeObra: double.tryParse(_valorMaoDeObraController.text) ?? 0,
      valorTecido: double.tryParse(_valorTecidoController.text) ?? 0,
      valorAcabamento: double.tryParse(_valorAcabamentoController.text) ?? 0,
      desconto: double.tryParse(_descontoController.text) ?? 0,
      dataCriacao: widget.orcamento?.dataCriacao ?? DateTime.now(),
      dataValidade: _dataValidade!,
      observacoes: _observacoesController.text,
      aceito: _aceito,
    );

    final provider = context.read<OrcamentoProvider>();

    if (widget.orcamento == null) {
      provider.adicionarOrcamento(orcamento);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orçamento adicionado com sucesso')),
      );
    } else {
      provider.atualizarOrcamento(orcamento);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orçamento atualizado com sucesso')),
      );
    }

    Navigator.pop(context);
  }
}
