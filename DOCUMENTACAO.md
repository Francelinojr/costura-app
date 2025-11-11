# Costura Fácil - Documentação Completa

## 📱 Visão Geral

**Costura Fácil** é um aplicativo móvel multiplataforma desenvolvido em **Flutter** para gerenciar completamente um negócio de costura. O app funciona em **iOS** e **Android** com interface moderna, responsiva e intuitiva.

## ✨ Funcionalidades Implementadas

### 1. **Gerenciamento de Clientes**
- ✅ Cadastro completo de clientes com dados pessoais
- ✅ Armazenamento de 8 medidas diferentes (busto, cintura, quadril, manga, comprimento blusa, comprimento calça, ombro, pescoço)
- ✅ Busca e filtro de clientes por nome, telefone ou escola
- ✅ Edição e exclusão de clientes
- ✅ Observações personalizadas por cliente
- ✅ Contato direto (telefone e email)

### 2. **Gerenciamento de Pedidos**
- ✅ Criação de novos pedidos com descrição e tipo de peça
- ✅ Sistema de status com 6 estados: Orçamento, Confirmado, Em Progresso, Pronto, Entregue, Cancelado
- ✅ Controle de prazos com alertas de atraso
- ✅ Cálculo automático de dias restantes
- ✅ Filtro por status de pedido
- ✅ Visualização de pedidos em atraso
- ✅ Próximos pedidos a entregar (próximos 7 dias)
- ✅ Valor do pedido customizável

### 3. **Sistema de Orçamentos**
- ✅ Criação de orçamentos detalhados
- ✅ Cálculo automático com 3 componentes: mão de obra, tecido, acabamento
- ✅ Sistema de descontos
- ✅ Data de validade do orçamento
- ✅ Status de aceito/pendente
- ✅ Filtro por status (todos, pendentes, aceitos)
- ✅ Cálculo de receita total

### 4. **Portfólio de Trabalhos**
- ✅ Galeria de trabalhos realizados
- ✅ Upload de fotos de peças
- ✅ Classificação por tipo de peça
- ✅ Sistema de avaliação (0-5 estrelas)
- ✅ Associação com clientes
- ✅ Descrição detalhada de cada trabalho
- ✅ Cálculo de avaliação média

### 5. **Dashboard Principal**
- ✅ Resumo de estatísticas (total de clientes, pedidos, orçamentos, portfólio)
- ✅ Alertas de pedidos em atraso
- ✅ Próximos pedidos a entregar
- ✅ Interface visual com cards informativos

## 🏗️ Arquitetura do Projeto

### Estrutura de Diretórios

```
costura_app/
├── lib/
│   ├── main.dart                 # Entrada do aplicativo
│   ├── models/                   # Modelos de dados
│   │   ├── cliente.dart
│   │   ├── pedido.dart
│   │   ├── orcamento.dart
│   │   └── portfolio.dart
│   ├── screens/                  # Telas do aplicativo
│   │   ├── home_screen.dart
│   │   ├── clientes_screen.dart
│   │   ├── cliente_form_screen.dart
│   │   ├── pedidos_screen.dart
│   │   ├── pedido_form_screen.dart
│   │   ├── orcamentos_screen.dart
│   │   ├── orcamento_form_screen.dart
│   │   ├── portfolio_screen.dart
│   │   └── portfolio_form_screen.dart
│   ├── services/                 # Gerenciamento de estado (Providers)
│   │   ├── cliente_provider.dart
│   │   ├── pedido_provider.dart
│   │   ├── orcamento_provider.dart
│   │   └── portfolio_provider.dart
│   ├── db/                       # Banco de dados
│   │   └── database_service.dart
│   ├── widgets/                  # Widgets reutilizáveis
│   │   ├── cliente_card.dart
│   │   └── pedido_card.dart
│   ├── utils/                    # Utilitários
│   │   ├── theme.dart            # Tema e cores
│   │   └── constants.dart        # Constantes e formatadores
│   └── assets/                   # Imagens e fontes
│       ├── images/
│       ├── icons/
│       └── fonts/
├── android/                      # Configuração Android
├── ios/                          # Configuração iOS
├── pubspec.yaml                  # Dependências do projeto
└── DOCUMENTACAO.md               # Esta documentação
```

### Tecnologias Utilizadas

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| Flutter | 3.16.0 | Framework multiplataforma |
| Dart | 3.2.0 | Linguagem de programação |
| Provider | 6.1.0 | Gerenciamento de estado |
| SQLite | 2.3.0 | Banco de dados local |
| Intl | 0.19.0 | Internacionalização e formatação |
| UUID | 4.0.0 | Geração de IDs únicos |
| Image Picker | 1.0.5 | Seleção de imagens |
| Google Fonts | 6.1.0 | Fontes customizadas |

## 📊 Modelos de Dados

### Cliente
```dart
- id: String (UUID)
- nome: String
- telefone: String
- email: String
- escola: String
- observacoes: String
- dataCadastro: DateTime
- busto: double
- cintura: double
- quadril: double
- comprimentoBlusa: double
- comprimentoCalca: double
- manga: double
- ombro: double
- pescoco: double
```

### Pedido
```dart
- id: String (UUID)
- clienteId: String (FK)
- descricao: String
- tipoPeca: String
- valor: double
- dataPedido: DateTime
- dataPrazo: DateTime
- dataEntrega: DateTime?
- status: StatusPedido (enum)
- observacoes: String
- fotosPedido: List<String>
```

### Orçamento
```dart
- id: String (UUID)
- clienteId: String (FK)
- descricao: String
- tipoPeca: String
- valorMaoDeObra: double
- valorTecido: double
- valorAcabamento: double
- desconto: double
- dataCriacao: DateTime
- dataValidade: DateTime
- observacoes: String
- aceito: bool
```

### Portfolio
```dart
- id: String (UUID)
- titulo: String
- descricao: String
- tipoPeca: String
- caminhoFoto: String
- dataCriacao: DateTime
- clienteId: String?
- avaliacao: double
```

## 🎨 Tema e Design

### Paleta de Cores
- **Primária**: Roxo (#7C3AED)
- **Primária Claro**: Roxo Claro (#A78BFA)
- **Primária Escuro**: Roxo Escuro (#5B21B6)
- **Secundária**: Rosa (#EC4899)
- **Sucesso**: Verde (#10B981)
- **Aviso**: Amarelo/Laranja (#F59E0B)
- **Erro**: Vermelho (#EF4444)

### Componentes de UI
- Material Design 3
- Cards com sombra e bordas arredondadas
- Botões com ripple effect
- TextField com validação
- BottomNavigationBar para navegação
- FloatingActionButton para ações principais

## 🗄️ Banco de Dados

O aplicativo usa **SQLite** para armazenamento local de dados. O banco é criado automaticamente na primeira execução com as seguintes tabelas:

- **clientes**: Dados de clientes e medidas
- **pedidos**: Informações de pedidos
- **orcamentos**: Dados de orçamentos
- **portfolio**: Galeria de trabalhos

## 📱 Navegação

O aplicativo possui 5 abas principais:

1. **Início (Home)**: Dashboard com resumo e alertas
2. **Clientes**: Lista e gerenciamento de clientes
3. **Pedidos**: Controle de pedidos com filtro por status
4. **Orçamentos**: Gerenciamento de orçamentos
5. **Portfólio**: Galeria de trabalhos realizados

## 🚀 Como Usar

### Instalação e Execução

1. **Pré-requisitos**:
   - Flutter 3.16.0 ou superior
   - Dart 3.2.0 ou superior
   - Android Studio ou Xcode (para emuladores)

2. **Clonar/Copiar o projeto**:
   ```bash
   cd costura_app
   ```

3. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

4. **Executar em emulador/dispositivo**:
   ```bash
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   
   # Ambos (selecionar qual usar)
   flutter run
   ```

5. **Build para produção**:
   ```bash
   # Android (APK)
   flutter build apk --release
   
   # Android (App Bundle)
   flutter build appbundle --release
   
   # iOS
   flutter build ios --release
   ```

## 💾 Dados Persistentes

Todos os dados são armazenados localmente no dispositivo usando SQLite. Não há sincronização com servidor, garantindo privacidade total dos dados.

### Backup de Dados
Para fazer backup dos dados:
- **Android**: Acessar `/data/data/com.costureira.costura_app/databases/`
- **iOS**: Usar iTunes ou iCloud para backup do app

## 🔒 Segurança

- Dados armazenados localmente no dispositivo
- Sem transmissão de dados para servidores externos
- Sem coleta de dados pessoais
- Sem rastreamento de usuários

## 📝 Funcionalidades Futuras (Sugestões)

- [ ] Sincronização com nuvem (Firebase, iCloud)
- [ ] Notificações push para prazos
- [ ] Exportação de relatórios em PDF
- [ ] Integração com WhatsApp para contato com clientes
- [ ] Modo escuro
- [ ] Múltiplos idiomas
- [ ] Backup automático
- [ ] Compartilhamento de portfólio
- [ ] Integração com redes sociais
- [ ] Sistema de pagamentos

## 🐛 Troubleshooting

### Erro: "Flutter not found"
```bash
export PATH="$PATH:/home/ubuntu/flutter/bin"
```

### Erro ao compilar Android
```bash
flutter clean
flutter pub get
flutter run
```

### Erro ao compilar iOS
```bash
cd ios
pod install
cd ..
flutter run
```

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a documentação do Flutter: https://flutter.dev/docs
2. Consulte a documentação dos packages utilizados
3. Revise os arquivos de log do projeto

## 📄 Licença

Este projeto é fornecido como está para uso pessoal e comercial.

---

**Desenvolvido com ❤️ para costureiras**
