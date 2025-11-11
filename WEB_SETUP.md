# 🌐 Costura Fácil - Versão Web

## Visão Geral

O aplicativo Costura Fácil agora está disponível em **versão web** usando **Flutter Web**. Isso significa que o mesmo código funciona em:

- ✅ **Aplicativos móveis** (iOS e Android)
- ✅ **Website responsivo** (Desktop, Tablet, Mobile)
- ✅ **Aplicativos desktop** (Windows, macOS, Linux)

## 🚀 Como Executar a Versão Web

### Pré-requisitos

- Flutter 3.16.0+
- Dart 3.2.0+
- Um navegador moderno (Chrome, Firefox, Safari, Edge)

### Passos para Executar

1. **Navegue até a pasta do projeto**:
   ```bash
   cd costura_app
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Execute a versão web**:
   ```bash
   flutter run -d web
   ```

   Ou especifique o navegador:
   ```bash
   flutter run -d chrome
   flutter run -d firefox
   ```

4. **Acesse no navegador**:
   O aplicativo abrirá automaticamente em `http://localhost:5000` (ou outra porta)

## 📦 Build para Produção

### Gerar arquivo web otimizado

```bash
flutter build web --release
```

Os arquivos compilados estarão em `build/web/`

### Estrutura dos arquivos gerados

```
build/web/
├── index.html          # Página principal
├── flutter.js          # Runtime do Flutter
├── main.dart.js        # Código da aplicação
├── assets/             # Imagens e fontes
└── ...
```

## 🌐 Deploy na Internet

### Opção 1: Firebase Hosting (Recomendado)

1. **Instale Firebase CLI**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Faça login**:
   ```bash
   firebase login
   ```

3. **Inicialize o projeto**:
   ```bash
   firebase init hosting
   ```

4. **Configure o diretório público como `build/web`**

5. **Deploy**:
   ```bash
   flutter build web --release
   firebase deploy
   ```

### Opção 2: Netlify

1. **Instale Netlify CLI**:
   ```bash
   npm install -g netlify-cli
   ```

2. **Faça login**:
   ```bash
   netlify login
   ```

3. **Deploy**:
   ```bash
   flutter build web --release
   netlify deploy --prod --dir=build/web
   ```

### Opção 3: GitHub Pages

1. **Crie um repositório no GitHub**

2. **Configure o repositório**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/seu-usuario/seu-repo.git
   git branch -M main
   git push -u origin main
   ```

3. **Build e deploy**:
   ```bash
   flutter build web --release --base-href=/seu-repo/
   ```

4. **Copie os arquivos de `build/web/` para a branch `gh-pages`**

### Opção 4: Servidor Próprio

1. **Build a aplicação**:
   ```bash
   flutter build web --release
   ```

2. **Copie os arquivos de `build/web/` para seu servidor web**

3. **Configure seu servidor web (Nginx, Apache, etc.) para servir os arquivos**

## 💾 Armazenamento de Dados na Web

Na versão web, os dados são armazenados usando **IndexedDB** (armazenamento local do navegador).

- ✅ Os dados persistem entre sessões
- ✅ Cada navegador tem seu próprio armazenamento
- ✅ Limite de armazenamento: ~50MB (varia por navegador)
- ⚠️ Limpar cache/cookies do navegador apaga os dados

## 📱 Responsividade

A interface se adapta automaticamente para:

- **Desktop** (>1200px): Sidebar lateral com navegação
- **Tablet** (600-1200px): BottomNavigationBar
- **Mobile** (<600px): Drawer com menu

## 🔒 Segurança

- ✅ Dados armazenados localmente no navegador
- ✅ Nenhum dado é enviado para servidores
- ✅ HTTPS recomendado para produção
- ✅ Sem coleta de dados pessoais

## 🐛 Troubleshooting

### Erro: "Flutter not found"
```bash
export PATH="$PATH:/caminho/para/flutter/bin"
```

### Erro ao compilar web
```bash
flutter clean
flutter pub get
flutter run -d web
```

### Dados não persistem
- Verifique se o navegador permite armazenamento local
- Tente em modo incógnito
- Limpe cache e cookies

### Aplicação lenta
- Use o build de produção: `flutter build web --release`
- Verifique a conexão de internet
- Use um navegador moderno

## 🎯 Funcionalidades Web

Todas as funcionalidades do aplicativo móvel estão disponíveis na versão web:

- ✅ Gerenciamento de clientes
- ✅ Controle de pedidos
- ✅ Sistema de orçamentos
- ✅ Portfólio de trabalhos
- ✅ Dashboard com alertas
- ✅ Busca e filtros
- ✅ Edição e exclusão de dados

## 📊 Performance

- Tamanho inicial: ~5-10MB (comprimido)
- Tempo de carregamento: 2-5 segundos (primeira vez)
- Tempo de carregamento: <1 segundo (cache)

## 🔄 Sincronização entre Dispositivos

Atualmente, cada dispositivo/navegador tem seus próprios dados. Para sincronizar entre dispositivos, você pode:

1. **Exportar dados** (futura funcionalidade)
2. **Usar um backend** (Firebase, Supabase, etc.)
3. **Sincronizar manualmente** (copiar dados)

## 📞 Suporte

Para problemas específicos da versão web:

1. Consulte a [documentação do Flutter Web](https://flutter.dev/docs/get-started/web)
2. Verifique o console do navegador (F12)
3. Teste em diferentes navegadores

---

**Desenvolvido com ❤️ para costureiras**
