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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de dados pessoais
            _buildSectionTitle('Dados Pessoais'),
            SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome *',
                hintText: 'Nome da cliente',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(
                labelText: 'Telefone',
                hintText: '(11) 99999-9999',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'email@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _escolaController,
              decoration: InputDecoration(
                labelText: 'Escola/Instituição',
                hintText: 'Nome da escola',
              ),
            ),
            SizedBox(height: 24),

            // Seção de medidas
            _buildSectionTitle('Medidas (em cm)'),
            SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildMeasurementField('Busto', _bustoController),
                _buildMeasurementField('Cintura', _cinturaController),
                _buildMeasurementField('Quadril', _quadrilController),
                _buildMeasurementField('Manga', _mangaController),
                _buildMeasurementField('Comprimento Blusa', _comprimentoBlusaController),
                _buildMeasurementField('Comprimento Calça', _comprimentoCalcaController),
                _buildMeasurementField('Ombro', _ombroController),
                _buildMeasurementField('Pescoço', _pescocoController),
              ],
            ),
            SizedBox(height: 24),

            // Observações
            _buildSectionTitle('Observações'),
            SizedBox(height: 12),
            TextField(
              controller: _observacoesController,
              decoration: InputDecoration(
                labelText: 'Observações',
                hintText: 'Adicione observações importantes',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
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
                    onPressed: _salvarCliente,
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
        SnackBar(content: Text('Por favor, preencha o nome')),
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
    );

    final provider = context.read<ClienteProvider>();

    if (widget.cliente == null) {
      provider.adicionarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente adicionado com sucesso')),
      );
    } else {
      provider.atualizarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente atualizado com sucesso')),
      );
    }

    Navigator.pop(context);
  }
}
