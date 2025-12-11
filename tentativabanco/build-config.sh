#!/bin/sh
# Gera `config.js` a partir da variável de ambiente `API_BASE_URL`
set -e

: "${API_BASE_URL:=}"
cat > config.js <<EOF
// Gerado pelo build-config.sh
window.API_BASE_URL="${API_BASE_URL}";
if (window.API_BASE_URL && !window.API_BASE_URL.endsWith('/')) {
  window.API_BASE_URL = window.API_BASE_URL + '/';
}
EOF

echo "config.js gerado (API_BASE_URL=${API_BASE_URL})"
