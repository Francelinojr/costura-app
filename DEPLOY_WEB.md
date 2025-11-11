# 🚀 Guia de Deploy - Costura Fácil Web

## Opções de Deploy

### 1. Firebase Hosting (Recomendado - Gratuito até 10GB)

#### Passo 1: Preparação
```bash
# Instale Firebase CLI
npm install -g firebase-tools

# Faça login na sua conta Google
firebase login
```

#### Passo 2: Inicializar Firebase
```bash
cd costura_app
firebase init hosting
```

Quando perguntado:
- **Projeto**: Crie um novo projeto ou selecione um existente
- **Diretório público**: Digite `build/web`
- **Single-page app**: Responda `y` (sim)

#### Passo 3: Build e Deploy
```bash
# Build da versão web
flutter build web --release

# Deploy
firebase deploy
```

Seu site estará disponível em: `https://seu-projeto.firebaseapp.com`

---

### 2. Netlify (Gratuito com domínio próprio)

#### Passo 1: Preparação
```bash
# Instale Netlify CLI
npm install -g netlify-cli

# Faça login
netlify login
```

#### Passo 2: Build
```bash
cd costura_app
flutter build web --release
```

#### Passo 3: Deploy
```bash
# Deploy automático
netlify deploy --prod --dir=build/web

# Ou crie um site novo
netlify sites:create --name seu-site-costura
netlify deploy --prod --dir=build/web --site seu-site-id
```

Seu site estará disponível em: `https://seu-site-costura.netlify.app`

---

### 3. GitHub Pages (Gratuito)

#### Passo 1: Criar Repositório
1. Vá para [github.com](https://github.com)
2. Crie um novo repositório chamado `costura-app`
3. Copie a URL do repositório

#### Passo 2: Configurar Git
```bash
cd costura_app

# Inicializar git
git init
git add .
git commit -m "Initial commit"

# Adicionar remote
git remote add origin https://github.com/seu-usuario/costura-app.git
git branch -M main
git push -u origin main
```

#### Passo 3: Build com base-href
```bash
flutter build web --release --base-href=/costura-app/
```

#### Passo 4: Deploy
```bash
# Criar branch gh-pages
git checkout --orphan gh-pages
git rm -rf .

# Copiar arquivos compilados
cp -r build/web/* .
git add .
git commit -m "Deploy web"
git push origin gh-pages
```

Seu site estará disponível em: `https://seu-usuario.github.io/costura-app`

---

### 4. Vercel (Gratuito com GitHub)

#### Passo 1: Conectar GitHub
1. Vá para [vercel.com](https://vercel.com)
2. Faça login com GitHub
3. Autorize Vercel

#### Passo 2: Importar Projeto
1. Clique em "New Project"
2. Selecione seu repositório `costura-app`
3. Configure:
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`

#### Passo 3: Deploy
Vercel fará deploy automaticamente quando você fazer push para o GitHub.

Seu site estará disponível em: `https://costura-app.vercel.app`

---

### 5. Servidor Próprio (VPS/Hosting)

#### Passo 1: Build
```bash
flutter build web --release
```

#### Passo 2: Transferir Arquivos
```bash
# Via SCP
scp -r build/web/* usuario@seu-servidor:/var/www/costura-app/

# Ou via FTP usando um cliente FTP
```

#### Passo 3: Configurar Servidor Web

**Nginx:**
```nginx
server {
    listen 80;
    server_name seu-dominio.com;

    root /var/www/costura-app;
    index index.html;

    location / {
        try_files $uri /index.html;
    }

    # Cache de assets
    location /assets {
        expires 1y;
    }

    location /flutter.js {
        expires 1d;
    }
}
```

**Apache:**
```apache
<Directory /var/www/costura-app>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted

    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </IfModule>
</Directory>
```

#### Passo 4: Configurar SSL (HTTPS)
```bash
# Usando Let's Encrypt (gratuito)
sudo certbot certonly --webroot -w /var/www/costura-app -d seu-dominio.com
```

---

## ✅ Checklist de Deploy

Antes de fazer deploy em produção:

- [ ] Testou a aplicação localmente (`flutter run -d web`)
- [ ] Fez build de produção (`flutter build web --release`)
- [ ] Verificou se os dados estão sendo salvos corretamente
- [ ] Testou em diferentes navegadores (Chrome, Firefox, Safari, Edge)
- [ ] Testou em dispositivos móveis (responsividade)
- [ ] Configurou HTTPS/SSL
- [ ] Configurou cache de assets
- [ ] Testou performance (DevTools do navegador)
- [ ] Criou backup dos dados (se necessário)

---

## 🔒 Segurança em Produção

### HTTPS Obrigatório
```bash
# Redirecionar HTTP para HTTPS (Nginx)
server {
    listen 80;
    server_name seu-dominio.com;
    return 301 https://$server_name$request_uri;
}
```

### Headers de Segurança
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
```

### Compressão Gzip
```nginx
gzip on;
gzip_types text/plain text/css text/javascript application/javascript;
gzip_min_length 1000;
```

---

## 📊 Monitoramento

### Google Analytics
1. Crie uma conta em [analytics.google.com](https://analytics.google.com)
2. Adicione o código de rastreamento ao `web/index.html`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

### Monitoramento de Performance
Use as DevTools do navegador (F12) para monitorar:
- Tempo de carregamento
- Uso de memória
- Performance de rede

---

## 🆘 Troubleshooting

### Aplicação não carrega
- Verifique o console do navegador (F12)
- Limpe cache: Ctrl+Shift+Delete
- Tente em modo incógnito

### Dados não persistem
- Verifique se o navegador permite IndexedDB
- Teste em outro navegador
- Verifique o limite de armazenamento

### Erro 404 em rotas
- Configure o servidor para redirecionar tudo para `index.html`
- Verifique a configuração do `base-href`

---

## 📞 Suporte

Para problemas de deploy:
1. Consulte a documentação da plataforma escolhida
2. Verifique os logs do servidor
3. Teste localmente antes de fazer deploy

---

**Desenvolvido com ❤️ para costureiras**
