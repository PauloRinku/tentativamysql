# Guia: Deploy no Vercel + Backend no Render

Você já criou o projeto no Vercel, agora é hora de configurar tudo. Este guia assume que você quer:
- **Frontend** (HTML + CSS + JS) hospedado no **Vercel**.
- **Backend** (APIs PHP) hospedado em **Render** (ou outro provedor como Railway/DigitalOcean).

## Passo 1: Conectar o Repositório ao Vercel

1. Acesse seu projeto no [Vercel Dashboard](https://vercel.com/dashboard).
2. Clique em **Import Project** (se ainda não conectado) e selecione este repositório do GitHub.
3. Vercel deve detectar `vercel.json` automaticamente e usar essas configurações:
   - **Build Command**: `cd tentativabanco && bash build-config.sh`
   - **Output Directory**: `tentativabanco`

Se não detectar, configure manualmente em **Settings** → **Build & Development Settings**.

## Passo 2: Adicionar Variável de Ambiente (API_BASE_URL)

1. No painel do seu projeto Vercel, vá para **Settings** → **Environment Variables**.
2. Clique em **Add new variable** e preencha:
   - **Name**: `API_BASE_URL`
   - **Value**: deixe vazio por enquanto (você preencherá após criar o backend no Render)
   - **Environments**: selecione **Production**, **Preview** e **Development** (ou apenas as que usar).

3. Clique **Save**.

Exemplo de valor (depois):
```
API_BASE_URL=https://seu-backend.onrender.com
```

## Passo 3: Fazer Deploy Inicial

1. Volte à aba **Deployments**.
2. Clique em **Redeploy** ou faça um push para o repositório (branches conectados fazem deploy automático).
3. Aguarde o build completar. Você verá `config.js` sendo gerado durante o build.

Neste ponto, o frontend estará ao vivo, mas as chamadas `fetch()` falharão porque `API_BASE_URL` está vazio. É esperado — você preencherá depois.

## Passo 4: Hospedar o Backend no Render

### 4.1 Criar um Serviço Web no Render

1. Acesse [render.com](https://render.com) e faça login/cadastre-se.
2. Clique em **New** → **Web Service**.
3. Selecione **Build and deploy from a Git repository** e escolha este repositório.
4. Preencha:
   - **Name**: `tentativa-banco-backend` (ex.)
   - **Branch**: `main`
   - **Runtime**: Docker
   - **Build Command**: deixe em branco (Render usa o Dockerfile)
   - **Start Command**: deixe em branco

5. Clique em **Create Web Service**. Render iniciará o build.

### 4.2 Criar um Banco de Dados MySQL no Render

1. No painel do Render, clique em **New** → **MySQL Database**.
2. Preencha:
   - **Name**: `tentativa-db` (ex.)
   - **Region**: mesma que seu Web Service (para latência baixa)
   - Mantenha os padrões para as demais opções.

3. Clique **Create Database**. Render provisionará o banco e fornecerá credenciais.
4. Você receberá uma **Connection String** e os detalhes:
   - `Host`
   - `User`
   - `Password`
   - `Database`
   - `Port`

Anote esses valores.

### 4.3 Configurar Variáveis de Ambiente no Serviço Web

1. Volte ao seu Web Service (`tentativa-banco-backend`).
2. Vá para **Environment** (ou **Settings** → **Environment Variables**).
3. Clique **Add Environment Variable** e adicione:

| Name       | Value                          |
|-----------|--------------------------------|
| `DB_HOST` | (do banco MySQL)               |
| `DB_USER` | (do banco MySQL)               |
| `DB_PASS` | (do banco MySQL)               |
| `DB_NAME` | (do banco MySQL, ex. tentativaB1) |
| `DB_PORT` | (do banco MySQL, ex. 3306)     |

4. Clique **Save Changes**. O Web Service irá redeploy automaticamente.

### 4.4 Importar o Schema e Dados

1. Você recebeu credenciais do banco MySQL no passo 4.2. Localmente, execute:

```bash
mysql -h SEU_DB_HOST -u SEU_DB_USER -p SEU_DB_PASS -D SEU_DB_NAME < tentativabanco/db/dump.sql
```

Substitua:
- `SEU_DB_HOST` → valor de `Host` (ex. `dpg-xxxxx.render.com`)
- `SEU_DB_USER` → valor de `User`
- `SEU_DB_PASS` → valor de `Password`
- `SEU_DB_NAME` → valor de `Database` (ex. `tentativaB1`)

2. Quando pedir senha, digite o valor de `Password`.

Pronto! O schema e dados estão importados.

### 4.5 Aguardar o Deploy do Backend

1. Volte ao painel do seu Web Service no Render.
2. Você verá a URL pública (ex. `https://tentativa-banco-backend.onrender.com`). Anote.
3. O serviço deve estar em status **Live**.

## Passo 5: Conectar Frontend e Backend

1. Volte ao Vercel → **Settings** → **Environment Variables**.
2. Atualize `API_BASE_URL` com a URL do seu backend:
   ```
   https://tentativa-banco-backend.onrender.com
   ```
   (Render remove o trailing `/` automaticamente no build-config.sh.)

3. Clique **Save**.
4. Vá para **Deployments** e clique **Redeploy** na aba **Production**.
5. Aguarde o build. Agora `config.js` será gerado com `window.API_BASE_URL="https://tentativa-banco-backend.onrender.com"`.

## Passo 6: Testar

1. Acesse seu site Vercel (ex. `https://seu-projeto.vercel.app`).
2. Clique nas abas: **Dashboard**, **Livros**, **Membros**, **Empréstimos**.
3. Você deve ver os dados carregados (vindo do backend no Render).

## Troubleshooting

**"Erro ao carregar dados"** no frontend:
- Verifique se a URL do backend está correta em `Environment Variables`.
- Abra o console do navegador (F12) e veja qual URL está sendo chamada.
- Teste direto: `curl https://seu-backend.onrender.com/emprestimos.php`.

**Erro de conexão ao banco no backend**:
- Verifique as credenciais `DB_*` no painel do Render (Web Service → Environment).
- Teste a conexão localmente: `mysql -h HOST -u USER -p PASS -D DB`.

**Build falha no Vercel**:
- Verifique os logs em **Deployments** → **Build Logs**.
- Certifique-se de que `build-config.sh` está com permissão de execução (execute `chmod +x tentativabanco/build-config.sh` localmente e commit).

## Resumo dos Arquivos Importantes

| Arquivo | Função |
|---------|--------|
| `tentativabanco/index.html` | Frontend (HTML + JS que usa `window.API_BASE_URL`) |
| `tentativabanco/config.js` | Gerado pelo build (contém `window.API_BASE_URL`) |
| `tentativabanco/build-config.sh` | Script que gera `config.js` a partir da env var |
| `tentativabanco/Dockerfile` | Dockerfile para rodar backend PHP no Render |
| `tentativabanco/db/dump.sql` | Schema + dados para importar no MySQL remoto |
| `tentativabanco/config.php` | Backend que lê `DB_*` do ambiente |
| `vercel.json` | Configuração do Vercel (Build Command + Output Directory) |

---

**Próximos passos após deploy**:
- Adicionar CRUD (criar, editar, deletar) de livros/membros.
- Implementar autenticação.
- Melhorar segurança (prepared statements, validação).
- Adicionar HTTPS everywhere.
