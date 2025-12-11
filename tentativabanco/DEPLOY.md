# Deploy — instruções para PHP + MySQL (Docker)

Este projeto é uma aplicação PHP simples que consome um banco MySQL. Abaixo instruções para executar localmente com Docker e para deploy em provedores como Render ou DigitalOcean App Platform.

Variáveis de ambiente (recomendado configurar no provedor):
- `DB_HOST` — host do MySQL
- `DB_PORT` — porta (opcional)
- `DB_USER` — usuário do DB
- `DB_PASS` — senha do DB
- `DB_NAME` — nome do banco (padrão: `tentativaB1`)

Arquivo de exemplo: existe `.env.example` com as variáveis acima já preenchidas para referência local.

1) Testar localmente com Docker

```bash
# Build
docker build -t tentativabanco .

# Rodar (exemplo com DB remoto)
docker run --rm -p 8080:80 \
  -e DB_HOST=seu_host_mysql \
  -e DB_USER=seu_usuario \
  -e DB_PASS=sua_senha \
  -e DB_NAME=tentativaB1 \
  tentativabanco

# Acesse: http://localhost:8080/index.html
```

2) Deploy no Render

- Crie um novo *Web Service* no Render e conecte seu repositório Git.
- Escolha *Docker* como tipo de ambiente (Render irá usar o `Dockerfile`).
- Configure as variáveis de ambiente listadas acima no painel do serviço.
- Porta padrão: `80`.

3) Deploy na DigitalOcean App Platform

- Ao criar um App, selecione o repositório e escolha usar Dockerfile para o componente web.
- Configure variáveis de ambiente conforme necessário.

4) Observações sobre Vercel

- O Vercel não roda PHP server-side. Você pode:
  - Hospedar apenas o frontend (`index.html` + `estilo.css`) no Vercel e apontar as chamadas `fetch()` para o backend hospedado (ex.: Render).
  - Ou migrar o backend para Node/Next.js se quiser tudo no Vercel.

Frontend no Vercel — fluxo recomendado:

- Passo 1: hospede o backend (PHP) num serviço como Render, Railway ou DigitalOcean. Anote a URL pública da API (ex.: `https://api-seuapp.onrender.com/`).
- Passo 2: no Vercel, crie um novo projeto apontando para este repositório e na seção *Settings > Environment Variables* adicione `API_BASE_URL` com a URL do backend (sem sufixo `/` ou com ele — o build normaliza).
- Passo 3: configure o *Build Command* no Vercel para `./build-config.sh` e o *Output Directory* para `tentativabanco` (ou `.` se você estiver na raiz). Isso gera `config.js` contendo `window.API_BASE_URL` antes do deploy.
- Passo 4: confirme deploy. O frontend usará `window.API_BASE_URL` para enviar requisições ao backend remoto.

Observação: alternativa sem script — você pode editar manualmente `tentativabanco/config.js` com a URL do backend, mas o build script automatiza isso para ambientes CI.

Importar o dump em um MySQL gerenciado

- Após criar um banco gerenciado no provedor, importe `db/dump.sql` com:

```bash
mysql -h HOST -u USER -p < tentativabanco/db/dump.sql
```

ou usando a ferramenta de import do painel do provedor.

Exemplo rápido para Render:

- Crie um novo Postgres/MySQL Managed database no Render.
- No seu Web Service (Docker), adicione as variáveis `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME` no painel *Environment*.
- Importe `tentativabanco/db/dump.sql` pelo `mysql` local apontando para o host e credenciais fornecidas.


5) Segurança e produção

- Nunca commit credenciais no repositório. Use variáveis de ambiente no provedor.
- Considere usar *prepared statements* para evitar SQL injection.
