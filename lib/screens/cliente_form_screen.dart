import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/cliente.dart';
import '../services/cliente_provider.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({Key? key, this.cliente}) : super(key: key);

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _escolaController;
  late TextEditingController _observacoesController;
  late TextEditingController _bustoController;
  late TextEditingController _cinturaController;
  late TextEditingController _quadrilController;
  late TextEditingController _comprimentoBlusaController;
  late TextEditingController _comprimentoCalcaController;
  late TextEditingController _mangaController;
  late TextEditingController _ombroController;
  late TextEditingController _pescocoController;
  String? _tamanhoSelecionado;
  final List<String> _tamanhos = ['PP', 'P', 'M', 'G', 'GG'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    _telefoneController = TextEditingController(text: widget.cliente?.telefone ?? '');
    _emailController = TextEditingController(text: widget.cliente?.email ?? '');
    _escolaController = TextEditingController(text: widget.cliente?.escola ?? '');
    _observacoesController = TextEditingController(text: widget.cliente?.observacoes ?? '');
    _bustoController = TextEditingController(text: widget.cliente?.busto.toString() ?? '');
    _cinturaController = TextEditingController(text: widget.cliente?.cintura.toString() ?? '');
    _quadrilController = TextEditingController(text: widget.cliente?.quadril.toString() ?? '');
    _comprimentoBlusaController = TextEditingController(text: widget.cliente?.comprimentoBlusa.toString() ?? '');
    _comprimentoCalcaController = TextEditingController(text: widget.cliente?.comprimentoCalca.toString() ?? '');
    _mangaController = TextEditingController(text: widget.cliente?.manga.toString() ?? '');
    _ombroController = TextEditingController(text: widget.cliente?.ombro.toString() ?? '');
    _pescocoController = TextEditingController(text: widget.cliente?.pescoco.toString() ?? '');
    _tamanhoSelecionado = widget.cliente?.tamanho.isEmpty == false ? widget.cliente!.tamanho : null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _escolaController.dispose();
    _observacoesController.dispose();
    _bustoController.dispose();
    _cinturaController.dispose();
    _quadrilController.dispose();
    _comprimentoBlusaController.dispose();
    _comprimentoCalcaController.dispose();
    _mangaController.dispose();
    _ombroController.dispose();
    _pescocoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Nova Cliente' : 'Editar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de dados pessoais
            _buildSectionTitle('Dados Pessoais'),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                hintText: 'Nome da cliente',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                hintText: '(11) 99999-9999',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'email@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _escolaController,
              decoration: const InputDecoration(
                labelText: 'Escola/Instituição',
                hintText: 'Nome da escola',
              ),
            ),
            const SizedBox(height: 24),

            // Seção de medidas
            _buildSectionTitle('Medidas (em cm)'),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tamanho da Roupa',
                border: OutlineInputBorder(),
              ),
              initialValue: _tamanhoSelecionado,
              hint: const Text('Selecione o Tamanho'),
              items: _tamanhos.map((String tamanho) {
                return DropdownMenuItem<String>(
                  value: tamanho,
                  child: Text(tamanho),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _tamanhoSelecionado = newValue;
                });
              },
            ),

            const SizedBox(height: 12),

            // Versão moderna usando Wrap
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                SizedBox(width: 200, child: _buildMeasurementField('Busto', _bustoController)),
                SizedBox(width: 200, child: _buildMeasurementField('Cintura', _cinturaController)),
                SizedBox(width: 200, child: _buildMeasurementField('Quadril', _quadrilController)),
                SizedBox(width: 200, child: _buildMeasurementField('Manga', _mangaController)),
                SizedBox(width: 200, child: _buildMeasurementField('Comprimento Blusa', _comprimentoBlusaController)),
                SizedBox(width: 200, child: _buildMeasurementField('Comprimento Calça', _comprimentoCalcaController)),
                SizedBox(width: 200, child: _buildMeasurementField('Ombro', _ombroController)),
                SizedBox(width: 200, child: _buildMeasurementField('Pescoço', _pescocoController)),
              ],
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
                    onPressed: _salvarCliente,
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

  Widget _buildMeasurementField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0',
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _salvarCliente() {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o nome')),
      );
      return;
    }

    if (_tamanhoSelecionado == null || _tamanhoSelecionado!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione o tamanho da roupa')),
      );
      return;
    }

    final cliente = Cliente(
      id: widget.cliente?.id ?? const Uuid().v4(),
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
      escola: _escolaController.text,
      observacoes: _observacoesController.text,
      dataCadastro: widget.cliente?.dataCadastro ?? DateTime.now(),
      busto: double.tryParse(_bustoController.text) ?? 0,
      cintura: double.tryParse(_cinturaController.text) ?? 0,
      quadril: double.tryParse(_quadrilController.text) ?? 0,
      comprimentoBlusa: double.tryParse(_comprimentoBlusaController.text) ?? 0,
      comprimentoCalca: double.tryParse(_comprimentoCalcaController.text) ?? 0,
      manga: double.tryParse(_mangaController.text) ?? 0,
      ombro: double.tryParse(_ombroController.text) ?? 0,
      pescoco: double.tryParse(_pescocoController.text) ?? 0,
      tamanho: _tamanhoSelecionado!,
    );

    final provider = context.read<ClienteProvider>();

    if (widget.cliente == null) {
      provider.adicionarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente adicionado com sucesso')),
      );
    } else {
      provider.atualizarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente atualizado com sucesso')),
      );
    }

    Navigator.pop(context);
  }
}
