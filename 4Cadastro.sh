#!/bin/sh
##########################################################################
# Script elaborado por Gabriel Santana
##########################################################################
Principal() {
clear
echo "********************** Menu Principal **********************"
echo "------------------------------------------------------------"
echo ""
echo "Lista de opções:"
echo ""
echo "[1] Inclusão de usuários"
echo "[2] Exclusão de usuários"
echo "[3] Exclusão de grupos"
echo "[4] Exibir lista de usuários cadastrados"
echo "[5] Exibir lista de grupos cadastrados"
echo "[6] Sair"
echo ""
echo -n "Digite a opção desejada: "
read opção
case $opção in
    1) Inclusão ;;
    2) Exclusãouser ;;
    3) Exclusãogroup ;;
    4) Listauser ;;
    5) Listagroup ;;
    6) Sair ;;
    *) echo "Opção inválida"
	echo ""
	echo "Tecle enter para voltar"
	read
	Principal ;;
esac
}
# Inclusão de usuários no sistema
Inclusão() {    
    clear
    echo "********************** Inclusão de Usuários **********************"
    echo "------------------------------------------------------------------"
    echo ""
    echo -n "Digite o nome do novo usuário: "
    read nome
    if [ $nome = 'cut -d: -f1 /etc/passwd | grep -i $nome' ] ; then
        clear
	echo ""
	echo "*************** Aviso do Sistema **************"
	echo "-----------------------------------------------"
	echo ""
    	echo "Usuário já cadastrado!"
	echo ""
	echo "Tecle enter para voltar"
	read
	Inclusão
	else
    	    useradd $nome
    	    passwd $nome
	    Grupos    
    fi    
}    
# Inclusão de usuários nos grupos
Grupos() {
    clear
    echo ""
    echo "*************** Grupos Cadastrados **************"
    echo "-------------------------------------------------"
    echo ""
    echo -n "Incluir o usuário em grupo existente? (s/n): "
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
	    echo "Operação realizada com sucesso!"
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
		echo "Operação realizada com sucesso!"
		echo ""
		echo "Tecle enter para voltar ao Menu"
		read
		Principal
	fi
    fi		
}    	    
# Exclusão de usuários cadastrados no sistema
Exclusãouser() {
    clear
    echo "********************** Exclusão de Usuários **********************"
    echo "------------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/passwd
    echo ""
    echo -n "Digite o nome do usuário: "
    read nome
    clear
    echo "********************** Pedido de Confirmação **********************"
    echo "-------------------------------------------------------------------"
    echo ""
    echo -n "Deseja realmente excluir o usuário '$nome'? (s/n): "
    read resp
    if [ $resp = "s" ] || [ $resp = "n" ] ; then
	if [ $resp = "s" ] ; then
	    userdel -r $nome
	    clear
	    echo "********************** Confirmação de Exclusão **********************"
	    echo "---------------------------------------------------------------------"
	    echo ""
	    cut -d: -f1 /etc/passwd
	    echo ""
	    echo "Usuário excluido com sucesso!"
	    echo ""
	    echo "Tecle enter para voltar ao Menu"
	    read
	    Principal
	    else [ $resp = "n" ]
		Exclusãouser
	fi
    fi		
}
# Exclusão de grupos cadastrados no sistema
Exclusãogroup() {
    clear
    echo "********************** Exclusão de Grupos **********************"
    echo "----------------------------------------------------------------"
    echo ""
    cut -d: -f1 /etc/group
    echo ""
    echo -n "Digite o nome do grupo: "
    read grupo
    clear
    echo "********************** Pedido de Confirmação **********************"
    echo "-------------------------------------------------------------------"
    echo ""
    echo -n "Deseja realmente excluir o grupo '$grupo'? (s/n): "
    read resp
    if [ $resp = "s" ] || [ $resp = "n" ] ; then
	if [ $resp = "s" ] ; then
	    groupdel $grupo
	    clear
	    echo "********************** Confirmação de Exclusão **********************"
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
		Exclusãogroup
	fi
    fi		
}
# Imprime na tela uma listagem com os usuários cadastrados no sistema    
Listauser() {
    clear
    echo "********************** Usuários Cadastrados **********************"
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
# Sai do sistema ./cadusuário
Sair() {
    exit
}
Principal