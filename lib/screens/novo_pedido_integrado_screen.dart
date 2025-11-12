import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';
import '../services/cliente_provider.dart';
import '../services/pedido_provider.dart';
import '../utils/theme.dart';

class NovoPedidoIntegradoScreen extends StatefulWidget {
  const NovoPedidoIntegradoScreen({super.key});

  @override
  State<NovoPedidoIntegradoScreen> createState() => _NovoPedidoIntegradoScreenState();
}

class _NovoPedidoIntegradoScreenState extends State<NovoPedidoIntegradoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clienteNomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _escolaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _observacoesController = TextEditingController();

  Cliente? _clienteSelecionado;
  bool _novoCliente = false;
  String? _tipoPecaSelecionado;
  String? _tamanhoBlusaSelecionado;
  final Map<String, TextEditingController> _medidasCalcaControllers = {
    'cintura': TextEditingController(),
    'quadril': TextEditingController(),
    'comprimentoCalca': TextEditingController(),
  };

  final List<String> _tamanhosBlusa = ['PP', 'P', 'M', 'G', 'GG'];
  // Tipos de peça disponíveis especificamente para a criação de novo pedido
  final List<String> _tiposPecaNovoPedido = ['Blusa', 'Calça', 'Conjunto'];

  @override
  void dispose() {
    _clienteNomeController.dispose();
    _telefoneController.dispose();
    _escolaController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    _medidasCalcaControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _selecionarCliente(Cliente cliente) {
    setState(() {
      _clienteSelecionado = cliente;
      _clienteNomeController.text = cliente.nome;
      _telefoneController.text = cliente.telefone;
      _novoCliente = false;
      
      // Preencher medidas de calça se existirem no cliente
      _medidasCalcaControllers['cintura']!.text = cliente.cintura > 0 ? cliente.cintura.toString() : '';
      _medidasCalcaControllers['quadril']!.text = cliente.quadril > 0 ? cliente.quadril.toString() : '';
      _medidasCalcaControllers['comprimentoCalca']!.text = cliente.comprimentoCalca > 0 ? cliente.comprimentoCalca.toString() : '';
      
      // Selecionar tamanho de blusa se existir no cliente
      if (_tamanhosBlusa.contains(cliente.tamanho)) {
        _tamanhoBlusaSelecionado = cliente.tamanho;
      } else {
        _tamanhoBlusaSelecionado = null;
      }
    });
  }

  void _limparSelecaoCliente() {
    setState(() {
      _clienteSelecionado = null;
      _clienteNomeController.clear();
      _telefoneController.clear();
      _novoCliente = false;
      _medidasCalcaControllers.forEach((key, controller) => controller.clear());
      _tamanhoBlusaSelecionado = null;
    });
  }

  void _alternarNovoCliente() {
    setState(() {
      _novoCliente = true;
      _clienteSelecionado = null;
      _telefoneController.clear();
      _escolaController.clear();
      // Limpar campos de medidas se houver
    });
  }

  Future<void> _salvarPedido() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_clienteSelecionado == null && !_novoCliente) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente ou crie um novo.')),
      );
      return;
    }

    // 1. Lidar com o Cliente
    Cliente clienteParaPedido;
    if (_novoCliente) {
      // Criar novo cliente
      final novoCliente = Cliente(
        id: const Uuid().v4(),
        nome: _clienteNomeController.text,
        telefone: _telefoneController.text,
        email: '', // Não solicitado no form, mas necessário no modelo
        escola: _escolaController.text,
        observacoes: '', // Não solicitado no form, mas necessário no modelo
        dataCadastro: DateTime.now(),
        busto: 0,
        cintura: double.tryParse(_medidasCalcaControllers['cintura']!.text) ?? 0,
        quadril: double.tryParse(_medidasCalcaControllers['quadril']!.text) ?? 0,
        comprimentoBlusa: 0,
        comprimentoCalca: double.tryParse(_medidasCalcaControllers['comprimentoCalca']!.text) ?? 0,
        manga: 0,
        ombro: 0,
        pescoco: 0,
        tamanho: (_tipoPecaSelecionado == 'Blusa' || _tipoPecaSelecionado == 'Conjunto') && _tamanhoBlusaSelecionado != null ? _tamanhoBlusaSelecionado! : '',
      );
      await context.read<ClienteProvider>().adicionarCliente(novoCliente);
      clienteParaPedido = novoCliente;
    } else {
      // Usar cliente selecionado
      clienteParaPedido = _clienteSelecionado!;
      
      // Atualizar medidas/tamanho se o cliente já existir
      Cliente clienteAtualizado = clienteParaPedido;
      
      if (_tipoPecaSelecionado == 'Calça' || _tipoPecaSelecionado == 'Conjunto') {
        clienteAtualizado = clienteAtualizado.copyWith(
          cintura: double.tryParse(_medidasCalcaControllers['cintura']!.text) ?? clienteParaPedido.cintura,
          quadril: double.tryParse(_medidasCalcaControllers['quadril']!.text) ?? clienteParaPedido.quadril,
          comprimentoCalca: double.tryParse(_medidasCalcaControllers['comprimentoCalca']!.text) ?? clienteParaPedido.comprimentoCalca,
        );
      }
      if ((_tipoPecaSelecionado == 'Blusa' || _tipoPecaSelecionado == 'Conjunto') && _tamanhoBlusaSelecionado != null) {
        clienteAtualizado = clienteAtualizado.copyWith(
          tamanho: _tamanhoBlusaSelecionado,
        );
      }

      if (clienteAtualizado != clienteParaPedido) {
        await context.read<ClienteProvider>().atualizarCliente(clienteAtualizado);
        clienteParaPedido = clienteAtualizado;
      }
    }

    // 2. Criar o Pedido
    final novoPedido = Pedido(
      id: const Uuid().v4(),
      clienteId: clienteParaPedido.id,
      descricao: _descricaoController.text,
      tipoPeca: _tipoPecaSelecionado ?? 'Outro',
      valor: double.tryParse(_valorController.text) ?? 0.0,
      dataPedido: DateTime.now(),
      dataPrazo: DateTime.now().add(const Duration(days: 7)), // Prazo padrão de 7 dias
      status: StatusPedido.emProgresso, // Já viria selecionado como "A Fazer" (usando Em Progresso)
      observacoes: _observacoesController.text,
      fotosPedido: [],
    );

    await context.read<PedidoProvider>().adicionarPedido(novoPedido);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido e Cliente salvos com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('+ Novo Pedido'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Seção Cliente ---
              Text(
                'Cliente',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Campo de busca/seleção de cliente
              _buildClienteField(),
              const SizedBox(height: 16),

              // Campos de novo cliente (aparecem se _novoCliente for true)
              if (_novoCliente) ...[
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O telefone é obrigatório para um novo cliente.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _escolaController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Escola',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // --- Seção Detalhes do Pedido ---
              Text(
                'Detalhes do Pedido',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Tipo de Peça
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Peça',
                  border: OutlineInputBorder(),
                ),
                initialValue: _tipoPecaSelecionado,
                items: _tiposPecaNovoPedido.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoPecaSelecionado = newValue;
                    _tamanhoBlusaSelecionado = null;
                    _medidasCalcaControllers.forEach((key, controller) => controller.clear());
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o tipo de peça.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campos dinâmicos de medidas/tamanho
              _buildCamposDinamicos(),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição do Pedido',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Valor
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Observações
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvarPedido,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Pedido'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClienteField() {
    if (_clienteSelecionado != null) {
      return Card(
        color: AppTheme.primaryColor.withOpacity(0.1),
        child: ListTile(
          title: Text(_clienteSelecionado!.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(_clienteSelecionado!.telefone),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _limparSelecaoCliente,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _clienteNomeController,
          decoration: InputDecoration(
            labelText: 'Nome do Cliente',
            border: const OutlineInputBorder(),
            suffixIcon: _novoCliente
                ? IconButton(
                    icon: const Icon(Icons.person_remove),
                    onPressed: () {
                      setState(() {
                        _novoCliente = false;
                        _clienteNomeController.clear();
                        _telefoneController.clear();
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            if (!_novoCliente) {
              setState(() {}); // Força a reconstrução para atualizar a lista de sugestões
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'O nome do cliente é obrigatório.';
            }
            return null;
          },
        ),
        if (!_novoCliente && _clienteNomeController.text.isNotEmpty)
          _buildSugestoesCliente(),
        const SizedBox(height: 8),
        if (!_novoCliente)
          TextButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Novo Cliente +'),
            onPressed: _alternarNovoCliente,
          ),
      ],
    );
  }

  Widget _buildSugestoesCliente() {
    final clienteProvider = context.watch<ClienteProvider>();
    final sugestoes = clienteProvider.buscarClientes(_clienteNomeController.text);

    if (sugestoes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: sugestoes.length > 5 ? 5 : sugestoes.length,
        itemBuilder: (context, index) {
          final cliente = sugestoes[index];
          return ListTile(
            title: Text(cliente.nome),
            subtitle: Text(cliente.telefone),
            onTap: () => _selecionarCliente(cliente),
          );
        },
      ),
    );
  }

  Widget _buildCamposDinamicos() {
    if (_tipoPecaSelecionado == 'Blusa') {
      return _buildTamanhoBlusaChips();
    } else if (_tipoPecaSelecionado == 'Calça') {
      return _buildMedidasCalcaFields();
    } else if (_tipoPecaSelecionado == 'Conjunto') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTamanhoBlusaChips(),
          const SizedBox(height: 16),
          _buildMedidasCalcaFields(),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTamanhoBlusaChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tamanho da Blusa:', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: _tamanhosBlusa.map((tamanho) {
            return ChoiceChip(
              label: Text(tamanho),
              selected: _tamanhoBlusaSelecionado == tamanho,
              onSelected: (selected) {
                setState(() {
                  _tamanhoBlusaSelecionado = selected ? tamanho : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMedidasCalcaFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Medidas da Calça:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _medidasCalcaControllers['cintura'],
          decoration: const InputDecoration(
            labelText: 'Cintura (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _medidasCalcaControllers['quadril'],
          decoration: const InputDecoration(
            labelText: 'Quadril (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _medidasCalcaControllers['comprimentoCalca'],
          decoration: const InputDecoration(
            labelText: 'Comprimento da Calça (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
