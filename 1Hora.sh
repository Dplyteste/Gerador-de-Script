#!/bin/bash

######################################################################
#
# Script: atualiza_hora.sh
# Funcao: Executa a atualizacao da data e hora do sistema, através de
# servidor externo NTP.
#
# Autor: Luciano Pereira Areal - IT
# Data: 02/01/2006
#
#
# Versao: 1.0.0
# Ultima modificacao: 02/01/2006
# Modificacao realizada: Nenhuma.
#
#

### VARIAVEIS DE EXECUCAO

# Local de armazenamento do log de atualizacao de data e hora
ATUALIZA_LOG=/var/log/messages
SERVIDOR_NTP=ntp.cais.rnp.br

### BLOCO DO CORPO DO SCRIPT

# Header de descrição de entrada de log
echo "**********************************************************************" >> $ATUALIZA_LOG
echo "atualiza_hora.sh - Script de atualizacao de data e hora" >> $ATUALIZA_LOG
echo -e "Inicio do processo de atualizacao - `date`\n" >> $ATUALIZA_LOG
ntpdate $SERVIDOR_NTP >> $ATUALIZA_LOG
hwclock --systohc
echo " " >> $ATUALIZA_LOG
echo "Fim da execucao - atualiza_hora.sh" >> $ATUALIZA_LOG
echo "**********************************************************************" >> $ATUALIZA_LOG

#
######################################################################