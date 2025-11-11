import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/pedido.dart';
import '../models/cliente.dart';
import '../services/pedido_provider.dart';
import '../services/cliente_provider.dart';
import '../utils/constants.dart';

class PedidoFormScreen extends StatefulWidget {
  final Pedido? pedido;

  const PedidoFormScreen({Key? key, this.pedido}) : super(key: key);

  @override
  State<PedidoFormScreen> createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _observacoesController;
  
  String? _clienteSelecionado;
  String _tipoPecaSelecionado = 'Blusa';
  StatusPedido _statusSelecionado = StatusPedido.orcamento;
  DateTime? _dataPrazo;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.pedido?.descricao ?? '');
    _valorController = TextEditingController(text: widget.pedido?.valor.toString() ?? '');
    _observacoesController = TextEditingController(text: widget.pedido?.observacoes ?? '');
    _clienteSelecionado = widget.pedido?.clienteId;
    _tipoPecaSelecionado = widget.pedido?.tipoPeca ?? 'Blusa';
    _statusSelecionado = widget.pedido?.status ?? StatusPedido.orcamento;
    _dataPrazo = widget.pedido?.dataPrazo;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pedido == null ? 'Novo Pedido' : 'Editar Pedido'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seleção de cliente
            _buildSectionTitle('Cliente'),
            SizedBox(height: 12),
            Consumer<ClienteProvider>(
              builder: (context, clienteProvider, _) {
                return DropdownButtonFormField<String>(
                  value: _clienteSelecionado,
                  hint: Text('Selecione uma cliente'),
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
                    labelText: 'Cliente *',
                  ),
                );
              },
            ),
            SizedBox(height: 24),

            // Tipo de peça
            _buildSectionTitle('Detalhes do Pedido'),
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
                labelText: 'Descrição *',
                hintText: 'Descreva o pedido',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
                hintText: '0,00',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),

            // Status e prazo
            _buildSectionTitle('Status e Prazo'),
            SizedBox(height: 12),
            DropdownButtonFormField<StatusPedido>(
              value: _statusSelecionado,
              items: StatusPedido.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusLabel(status)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _statusSelecionado = value ?? StatusPedido.orcamento;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text('Data Prazo'),
              subtitle: Text(
                _dataPrazo != null
                    ? AppConstants.formatarData(_dataPrazo!)
                    : 'Selecione uma data',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selecionarDataPrazo,
              contentPadding: EdgeInsets.zero,
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
                    onPressed: _salvarPedido,
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

  void _selecionarDataPrazo() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataPrazo ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (data != null) {
      setState(() {
        _dataPrazo = data;
      });
    }
  }

  void _salvarPedido() {
    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecione uma cliente')),
      );
      return;
    }

    if (_descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha a descrição')),
      );
      return;
    }

    if (_dataPrazo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecione uma data de prazo')),
      );
      return;
    }

    final pedido = Pedido(
      id: widget.pedido?.id ?? const Uuid().v4(),
      clienteId: _clienteSelecionado!,
      descricao: _descricaoController.text,
      tipoPeca: _tipoPecaSelecionado,
      valor: double.tryParse(_valorController.text) ?? 0,
      dataPedido: widget.pedido?.dataPedido ?? DateTime.now(),
      dataPrazo: _dataPrazo!,
      status: _statusSelecionado,
      observacoes: _observacoesController.text,
      fotosPedido: widget.pedido?.fotosPedido ?? [],
    );

    final provider = context.read<PedidoProvider>();

    if (widget.pedido == null) {
      provider.adicionarPedido(pedido);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido adicionado com sucesso')),
      );
    } else {
      provider.atualizarPedido(pedido);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido atualizado com sucesso')),
      );
    }

    Navigator.pop(context);
  }

  String _getStatusLabel(StatusPedido status) {
    switch (status) {
      case StatusPedido.orcamento:
        return 'Orçamento';
      case StatusPedido.confirmado:
        return 'Confirmado';
      case StatusPedido.emProgresso:
        return 'Em Progresso';
      case StatusPedido.pronto:
        return 'Pronto';
      case StatusPedido.entregue:
        return 'Entregue';
      case StatusPedido.cancelado:
        return 'Cancelado';
    }
  }
}
