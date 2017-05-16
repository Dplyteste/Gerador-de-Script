#!/bin/bash
# Script para realizar o backup e enviar via FTP
#
DATA=`date +%d%m%Y`

MAQUINA=`hostname`
#---- parte editável --------------------------
#coloque os diretórios que serão backapeados
DIRETORIOS="/firebird/dat0/xml/"
#  Dados do arquivo de backup - mude se desejar
ARQUIVO="backup-xml-$MAQUINA-$DATA.tar.gz"

# Dados do servidor FTP para onde o backup serah enviado
HOST_FTP="192.168.0.250"
USUARIO_FTP="login"
SENHA_FTP="password"

# ---- não precisa mais editar abaixo ---------
# Cria o arquivo .tar.gz no /tmp (Temporário)
cd /tmp
#find $DIRETORIOS -mtime -1 -type f -print |
find $DIRETORIOS -type f -print |
tar czf /tmp/$ARQUIVO -T -

# Acessa o FTP e envia os arquivos de backup
ftp -in <<EOF
open $HOST_FTP
user $USUARIO_FTP $SENHA_FTP
bin
lcd /tmp
cd /bkpnfe/nfe/
mput $ARQUIVO
bye
EOF

# Apaga o backup em /tmp
rm -rf /tmp/backup-xml-*.tar.gz

