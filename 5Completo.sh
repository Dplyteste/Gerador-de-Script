#!/bin/bash

echo "

#########################################################
#########################################################
################### BACKUP SYSTEM #######################
#########################################################
#########################################################
############## by www.linux4sec.com.br ##################
#########################################################
#########################################################
#########################################################

"

#ATENÇÂO!
#
#Este script deve estar na seguinte estrutura:
#Na pasta raiz / dentro de uma pasta denominada backup ( ou seja /backup/ ).
#
#As montagens dos servidores devem ser feitas em MODO LEITURA dentro da pasta:
#/home/servidores/ que deverá ser criada e cada servidor deverá ser montado em sua
#subpasta. Ex: /home/servidores/servidor1 /home/servidores/servidor1 ...
#Pode ser usado para montagem "mount com cifs" para servidores Windows e "mount com sshfs" para servidores Linux.
#
#Este script deve ser posto para execução diária no crontab.


#########################################################
################## CONFIGURACAO #########################
#
#Escreva abaixo seu e-mail completo:
email=seuemail@provedor.com.br
#
#Digite o email de destino aonde será enviado os alertas:
destino=destino@provedor.com.br
#
#Digite abaixo o endereço SMTP de seu provedor:
smtp=smtp.provedor.com.br
#
#Digite a senha de seu e-mail:
senha=suasenha
#
#Digite abaixo o numero de servidores que irá efetuar backup:
numero=2
#
#Digite o numero de dias que os arquivos deletados e logs ficarao guardados:
dellog=60
#
#Digite abaixo o nome das subpastas criadas no /home/servidores/, ( Pastas criadas
#para mapear os servidores). Respeitando letras maiúsculas e minusculas e separe cada 
#um com uma vírgula e sem espaços. Ex: servidorweb,servidordados,servidorftp :
ordem=seniorbd
#
#Depois de mapeado as raizes dos servidores a serem efetuado os backups, adicione agora
#as pastas a serem feito os backups e as exeções conforme exemplo abaixo ( sem barra no final ):
#
#backups:
backups="
servidor1/
servidor2/users/
"
#
#exceções:
excessao="
servidor1/tmp
servidor1/etc
"

############# FIM DAS CONFIGURAÇÕES #####################


#INFORMAÇÕES:
#
#O backup será sincornizado na pasta BACKUP/
#
#Os arquivos modificados antigos e deletados ficarão em BACKUP/incremental/l4smod-data/
#
#Os logs ficarão em LOG/
#
#Os arquivos modificados anitgos e deletados serão excluidos de acordo com o número de dias configurado.











########## NAO ALTERE NADA DAQUI PARA BAIXO #############

### CRIANDO PASTAS NECESSARIAS:
cd /backup/
mkdir BACKUP 2>&1&>/dev/null
mkdir LOG 2>&1&>/dev/null
mkdir BACKUP/incremental 2>&1&>/dev/null

### CHECA SE TODAS AS PASTAS ESTAO MONTADAS E SOMENTE LEITURA, CASO HAJA ALGUM PROBLEMA NAO EXECUTA O BACKUP E ENVIA UM EMAIL AVISANDO:
servidores=$numero
novaordem=$(echo -n "$ordem"|sed 's/,/)|(/g')
montalog=$(mount| egrep -E "($novaordem)"|sed 's/ //g'|grep -v "^$")
monta=$(echo -n "$montalog"|grep -v "^$"|wc|cut -c7-8|sed 's/ //g'|grep -v "^$")
if [ "$monta" != "$servidores" ];then
echo "Um dos servidores não está montado, verifique!"
sendemail -f "$email" -t "$destino" -u "Backup L4S - ERRO" -m "Backup NAO efetuado, um dos servidores nao esta mapeado! Existem $monta servidores montados de $servidores - Servidores mapeados: $montalog"  -xu "$email" -xp "$senha" -s "$smtp:587" -o tls="no"
exit
else
touch /home/servidores/*/1.txt 2>&1&>/dev/null
ronly=$(echo $?)
if [ $ronly != "1" ]; then
echo "Uma das unidades montadas está em modo escrita, verifique e deixe-a somente leitura!"
sendemail -f "$email" -t "$destino" -u "Backup L4S - ERRO" -m "Backup NAO efetuado, um dos servidores nao esta somente leitura por favor verifique!"  -xu "$email" -xp "$senha" -s "$smtp:587" -o tls="no"
exit
else 

### GERANDO ARQUIVOS DE INCLUSAO OU EXCLUSAO:
echo -n "$backups"|sed 's/ //g'|sed '/^$/d' >/tmp/.dentro.txt
echo -n "$excessao"|sed 's/ //g'|sed '/^$/d' >/tmp/.fora.txt

### INICIANDO O BACKUP: 
rsync -vrtpzb --progress --backup-dir=incremental/l4smod-`date +%d_%m_%Y` /home/servidores/ /backup/BACKUP/ --files-from=/tmp/.dentro.txt --exclude-from=/tmp/.fora.txt --delete --log-file=/backup/LOG/`date +%d-%m-%Y`.log

### VERIFICA SE O BACKUP FOI FEITO COM SUCESSO E ENVIA UM EMAIL COM O LOG:
if [ "$?" == "0" ];then
sendemail -f "$email" -t "$destino" -u "Backup L4S - Sucesso" -m "Backup efetuado com sucesso" -xu "$email" -xp "$senha" -s "$smtp:587" -o tls="no" -a "/backup/LOG/`date +%d-%m-%Y`.log"
else
sendemail -f "$email" -t "$destino" -u "Backup L4S - ERRO" -m "Backup NAO efetuado" -xu "$email" -xp "$senha" -s "$smtp:587" -o tls="no" -a "/backup/LOG/`date +%d-%m-%Y`.log"
fi

### APAGA OS ARQUIVOS MODIFICADOS E DELETADOS ANTIGOS COM MAIS DE X DIAS ( ESPECIFICAR EM CONFIGURACOES ):
find /backup/BACKUP/incremental/ -name l4smod-* -ctime +$dellog -exec rm -rf {} \;

### APAGA OS LOGS ANTIGOS COM MAIS DE X DIAS ( ESPECIFICAR EM CONFIGURACOES ):
find /backup/LOG/ -name *.log -ctime +$dellog -exec rm -rf {} \;

fi
fi
