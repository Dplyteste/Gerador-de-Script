#!/bin/sh
##########################################################################
# Script elaborado por Gabriel Santana
##########################################################################
Principal() {
clear
echo "********************** Menu Principal **********************"
echo "------------------------------------------------------------"
echo ""
echo "Lista de op��es:"
echo ""
echo "[1] Inclus�o de usu�rios"
echo "[2] Exclus�o de usu�rios"
echo "[3] Exclus�o de grupos"
echo "[4] Exibir lista de usu�rios cadastrados"
echo "[5] Exibir lista de grupos cadastrados"
echo "[6] Sair"
echo ""
echo -n "Digite a op��o desejada: "
read op��o
case $op��o in
    1) Inclus�o ;;
    2) Exclus�ouser ;;
    3) Exclus�ogroup ;;
    4) Listauser ;;
    5) Listagroup ;;
    6) Sair ;;
    *) echo "Op��o inv�lida"
	echo ""
	echo "Tecle enter para voltar"
	read
	Principal ;;
esac
}
# Inclus�o de usu�rios no sistema
Inclus�o() {    
    clear
    echo "********************** Inclus�o de Usu�rios **********************"
    echo "------------------------------------------------------------------"
    echo ""
    echo -n "Digite o nome do novo usu�rio: "
    read nome
    if [ $nome = 'cut -d: -f1 /etc/passwd | grep -i $nome' ] ; then
        clear
	echo ""
	echo "*************** Aviso do Sistema **************"
	echo "-----------------------------------------------"
	echo ""
    	echo "Usu�rio j� cadastrado!"
	echo ""
	echo "Tecle enter para voltar"
	read
	Inclus�o
	else
    	    useradd $nome
    	    passwd $nome
	    Grupos    
    fi    
}    
# Inclus�o de usu�rios nos grupos
Grupos() {
    clear
    echo ""
    echo "*************** Grupos Cadastrados **************"
    echo "-------------------------------------------------"
    echo ""
    echo -n "Incluir o usu�rio em grupo existente? (s/n): "
    read resp
    if [ $resp = "s" ] || [ $resp = "n" ] ; then
	if [ $resp = "s" ] ; then
	    clear
	    echo "*************** Cadastrado de Grupo **************"
	    echo "--------------------------------------------------"
	    echo ""
	    cut -d: -f1 /etc/group
	    echo ""
	    echo -n "Digite o nome do grupo: "
	    read grupo
	    gpasswd -a $nome $grupo
	    clear
	    cut -d: -f1 /etc/group
	    echo ""
	    echo "Opera��o realizada com sucesso!"
	    echo ""
	    echo "Tecle enter para voltar ao Menu"
	    read
	    Principal
	    else [ $resp = "n" ]
		clear
		echo "*************** Cadastrado de Grupo **************"
		echo "--------------------------------------------------"
		echo ""
		echo -n "Digite o nome do novo grupo: "
		read ngrupo
		groupadd $ngrupo
		cut -d: -f1 /etc/group
		echo ""
		echo "Opera��o realizada com sucesso!"
		echo ""
		echo "Tecle enter para voltar ao Menu"
		read
		Principal
	fi
    fi		
}    	    
# Exclus�o de usu�rios cadastrados no sistema
Exclus�ouser() {
    clear
    echo "********************** Exclus�o de Usu�rios **********************"
    echo "------------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/passwd
    echo ""
    echo -n "Digite o nome do usu�rio: "
    read nome
    clear
    echo "********************** Pedido de Confirma��o **********************"
    echo "-------------------------------------------------------------------"
    echo ""
    echo -n "Deseja realmente excluir o usu�rio '$nome'? (s/n): "
    read resp
    if [ $resp = "s" ] || [ $resp = "n" ] ; then
	if [ $resp = "s" ] ; then
	    userdel -r $nome
	    clear
	    echo "********************** Confirma��o de Exclus�o **********************"
	    echo "---------------------------------------------------------------------"
	    echo ""
	    cut -d: -f1 /etc/passwd
	    echo ""
	    echo "Usu�rio excluido com sucesso!"
	    echo ""
	    echo "Tecle enter para voltar ao Menu"
	    read
	    Principal
	    else [ $resp = "n" ]
		Exclus�ouser
	fi
    fi		
}
# Exclus�o de grupos cadastrados no sistema
Exclus�ogroup() {
    clear
    echo "********************** Exclus�o de Grupos **********************"
    echo "----------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/group
    echo ""
    echo -n "Digite o nome do grupo: "
    read grupo
    clear
    echo "********************** Pedido de Confirma��o **********************"
    echo "-------------------------------------------------------------------"
    echo ""
    echo -n "Deseja realmente excluir o grupo '$grupo'? (s/n): "
    read resp
    if [ $resp = "s" ] || [ $resp = "n" ] ; then
	if [ $resp = "s" ] ; then
	    groupdel $grupo
	    clear
	    echo "********************** Confirma��o de Exclus�o **********************"
	    echo "---------------------------------------------------------------------"
	    echo ""
	    cut -d: -f1 /etc/group
	    echo ""
	    echo "Grupo excluido com sucesso!"
	    echo ""
	    echo "Tecle enter para voltar ao Menu"
	    read
	    Principal
	    else [ $resp = "n" ]
		Exclus�ogroup
	fi
    fi		
}
# Imprime na tela uma listagem com os usu�rios cadastrados no sistema    
Listauser() {
    clear
    echo "********************** Usu�rios Cadastrados **********************"
    echo "------------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/passwd
    echo ""
    echo "Tecle enter para voltar ao Menu"
    read
    Principal
}
# Imprime na tela uma listagem com os grupos cadastrados no sistema    
Listagroup() {
    clear
    echo "********************** Grupos Cadastrados **********************"
    echo "------------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/group
    echo ""
    echo "Tecle enter para voltar ao Menu"
    read
    Principal
}
# Sai do sistema ./cadusu�rio
Sair() {
    exit
}
Principal