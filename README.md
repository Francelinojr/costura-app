# 👗 Costura Fácil - Aplicativo de Gerenciamento de Costura

![Flutter](https://img.shields.io/badge/Flutter-3.16.0-blue)
![Dart](https://img.shields.io/badge/Dart-3.2.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-brightgreen)

Um aplicativo móvel multiplataforma completo para gerenciar seu negócio de costura. Organize clientes, pedidos, orçamentos e portfólio em um único lugar.

## ✨ Principais Funcionalidades

- 📋 **Gerenciamento de Clientes**: Cadastro com até 8 medidas diferentes
- 📦 **Controle de Pedidos**: Sistema de status com 6 estados
- 💰 **Orçamentos**: Cálculo automático com componentes customizáveis
- 🎨 **Portfólio**: Galeria de trabalhos com avaliações
- 📊 **Dashboard**: Resumo visual de todas as informações
- ⏰ **Alertas**: Notificações de prazos e atrasos
- 💾 **Armazenamento Local**: Dados seguros no seu dispositivo

## 🚀 Quick Start

### Pré-requisitos
- Flutter 3.16.0+
- Dart 3.2.0+
- Android Studio ou Xcode

### Instalação

```bash
# Clone ou copie o projeto
cd costura_app

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

## 📱 Plataformas Suportadas

- ✅ Android 5.0+
- ✅ iOS 11.0+
- ✅ Funciona offline

## 📚 Documentação

- [Documentação Completa](DOCUMENTACAO.md) - Guia técnico detalhado
- [Guia Rápido](GUIA_RAPIDO.md) - Como usar o aplicativo

## 🏗️ Arquitetura

```
lib/
├── main.dart              # Entrada do app
├── models/                # Modelos de dados
├── screens/               # Telas do app
├── services/              # Gerenciamento de estado
├── db/                    # Banco de dados
├── widgets/               # Componentes reutilizáveis
└── utils/                 # Utilitários
```

## 🛠️ Tecnologias

- **Flutter**: Framework multiplataforma
- **Provider**: Gerenciamento de estado
- **SQLite**: Banco de dados local
- **Intl**: Formatação de datas e moeda
- **Image Picker**: Seleção de imagens

## 📊 Funcionalidades Detalhadas

### Clientes
- Cadastro com dados pessoais e medidas
- Busca por nome, telefone ou escola
- Edição e exclusão
- Observações personalizadas

### Pedidos
- 6 estados: Orçamento, Confirmado, Em Progresso, Pronto, Entregue, Cancelado
- Controle de prazos
- Alertas de atraso
- Filtro por status

### Orçamentos
- Cálculo automático (mão de obra + tecido + acabamento - desconto)
- Data de validade
- Status de aceito/pendente
- Histórico de orçamentos

### Portfólio
- Galeria de trabalhos
- Classificação por tipo
- Avaliação em estrelas
- Associação com clientes

## 💾 Dados

Todos os dados são armazenados **localmente** no seu dispositivo usando SQLite. Nenhum dado é enviado para servidores externos.

## 🔒 Privacidade

- ✅ Dados armazenados localmente
- ✅ Sem sincronização com nuvem
- ✅ Sem coleta de dados pessoais
- ✅ Sem rastreamento

## 📦 Build para Produção

### Android
```bash
# APK
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🐛 Troubleshooting

### Erro de dependências
```bash
flutter clean
flutter pub get
```

### Erro ao compilar
```bash
flutter clean
flutter pub upgrade
flutter run
```

## 📝 Roadmap

- [ ] Sincronização com nuvem
- [ ] Notificações push
- [ ] Exportação em PDF
- [ ] Integração WhatsApp
- [ ] Modo escuro
- [ ] Múltiplos idiomas

## 👥 Contribuições

Sugestões e melhorias são bem-vindas!

## 📄 Licença

MIT License - veja LICENSE para detalhes

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a [Documentação Completa](DOCUMENTACAO.md)
2. Verifique o [Guia Rápido](GUIA_RAPIDO.md)
3. Revise os logs do Flutter

---

**Desenvolvido com ❤️ para costureiras**

Versão: 1.0.0
