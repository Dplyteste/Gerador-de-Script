#!/bin/bash
###########################################################
########## Script Criado Por Gabriel Santana ############## 
################### FLUXOGRAMA ############################
#                      INÍCIO                    FIM      #
#                   +-----------+            +----------+ #
#          +------> |    menu   |--Esc-----> |  sai do  | #
#          |        | principal |--Cancel--> | programa | #
#          |        +-----Ok----+       +--> +----------+ #
#          |              |             |                 #
#          +--<--1 2 3-4--+--Zero--->---+                 #
#                                                         #
###########################################################

#Coletando informacoes do usuario.

echo "Digite Seu nome"
read nome

#Informando o local dos scripts que seram gerados.
mkdir Script
echo "Foi Criado um diretorio com nome Script na sua area de trabalho"
sleep 2
echo "Os scripts gerados seram adicionados nela"
sleep 2 


# Loop que mostra o menu principal

while : ; do

    # Mostra o menu na tela, com as ações disponíveis
    resposta=$(
      dialog --stdout               \
             --title 'Gerador De Scripts'  \
             --menu $nome' Escolha o Script Deseajado:' \
            0 0 0                   \
            1 'Atualiza Hora' \
            2 'Backup via FTP'  \
            3 'Backup SQL'     \
            4 'Cadastro De Usuarios'        \
            5 'Backup Completo'        \
	    6 'Criar Script'        \
            0 'Sair'                )

    #  Caso Pressione CANCELAR ou ESC, Para o Script...
    [ $? -ne 0 ] && break

    # Gera os scripts de acordo com a opcao selecionada.
    case "$resposta" in
         1)  cp -a  /home/mint/Desktop/Base/1Hora.sh /home/mint/Desktop/Script ;;
         2)  cp -a  /home/mint/Desktop/Base/2Ftp.sh /home/mint/Desktop/Script ;;
         3)  cp -a  /home/mint/Desktop/Base/3Sql.sh /home/mint/Desktop/Script ;; 
         4)  cp -a  /home/mint/Desktop/Base/4Cadastro.sh /home/mint/Desktop/Script ;;
	 5)  cp -a  /home/mint/Desktop/Base/5Completo.sh /home/mint/Desktop/Script ;;
	 6)   nano $nome.sh ;;
         0) break ;;
    esac

done

# Mensagem final :)
echo 'Tenha um bom dia' $nome ! 
