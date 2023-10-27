#!/bin/bash


clear


function apresenta_banner() {
        echo "        v_0.2"
	echo -e "\033[0;31m──▄────▄▄▄▄▄▄▄────▄───"
	echo -e "\033[0;31m─▀▀▄─▄█████████▄─▄▀▀──"
	echo -e "\033[0;31m─────██─▀███▀─██──────"
	echo -e "\033[0;31m───▄─▀████▀████▀─▄────"
	echo -e "\033[0;31m─▀█────██▀█▀██────█▀──"
	echo -e "\033[0;33m███╗   ███╗ █████╗ ████████╗ █████╗       ██╗   ██╗██╗██████╗ ██╗   ██╗███████╗"
	echo -e "\033[0;33m████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗      ██║   ██║██║██╔══██╗██║   ██║██╔════╝"
	echo -e "\033[0;33m██╔████╔██║███████║   ██║   ███████║█████╗██║   ██║██║██████╔╝██║   ██║███████╗"
	echo -e "\033[0;33m██║╚██╔╝██║██╔══██║   ██║   ██╔══██║╚════╝╚██╗ ██╔╝██║██╔══██╗██║   ██║╚════██║"
	echo -e "\033[0;33m██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║       ╚████╔╝ ██║██║  ██║╚██████╔╝███████║"
	echo -e "\033[0;33m╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
	echo -e "\033[0;32m+-+-+-+-+-+-+-+-+-+-+-+-+        Desenvolvido por: BDSTECNOSYSTEM"
	echo -e "\033[0;32m|R|E|I|N|O|-|H|A|C|K|E|R|        Colaboradores: O Rei dos hackers e Synxhxyz" 
	echo -e "\033[0;32m+-+-+-+-+-+-+-+-+-+-+-+-+        Site: reinohacker.com"
	echo -e "\033[0m"
	sleep 1
}

function permissao_root(){
	# Pergunta ao usuário se deseja executar como root
	echo -e "\033[1;31mAtenção: Essa ferramenta exige privilégios de root"

	# Verifica root
	if [[ $EUID -ne 0 ]]; then
		echo -e "\033[0mReiniciando e usando sudo..."
		sudo "$0" "$@"
		exit
	else
		echo "Iniciando..."
		echo "Eliminando processos concorrentes"
		killall -9 freshclam
	fi
}


function check_clamscan() {
    if ! command -v clamscan &>/dev/null; then
        read -p "ClamAV não está instalado. Pressione (enter) para instalar ou (ctrl+c) para sair."
        apt install clamav -y
    fi
}

function update_clamav_database() {
    echo -e "\033[0;32m[+] Atualizando banco de dados do ClamAV...\033[0m"
    freshclam
    echo -e "\033[0;32m[+] Atualizado com sucesso.\033[0;32m"
    sleep 5
    clear
}

function update_progress() {
    local progress=0
    local pontos=""
    
    while [ $progress -lt 1000 ]; do
 	clear
	echo "MATA-VIRUS v0.2"
	echo "verificação em andamento: "
        echo -n "$pontos"
        progress=$((progress + 1))
        pontos+="."
        sleep 0.1
        if [ ${#pontos} -gt 10 ]; then
        	pontos=""
        fi
    done
}

function scan_file() {
    read -p "Especifique o caminho completo para o arquivo: " caminho_arquivo
    update_progress &
        progress_pid=$!

        resultado=$(clamscan --bell "$caminho_arquivo")

        kill "$progress_pid"  # Parar o contador de progresso
        clear
        
        apresenta_banner

        if echo "$resultado" | grep -q "Infected files: 1"; then
            read -p "O arquivo está infectado. Deseja excluí-lo? (S/N): " resposta
            if [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
                rm -f "$caminho_arquivo"
                echo "O arquivo foi excluído."
            else
                echo "O arquivo não foi excluído."
            fi
        else
            echo "O arquivo não está infectado."

	    # Aguarda o usuário pressionar Enter para concluir
	    echo -e "\033[1;33m"
	    read -p "Pressione Enter para concluir..."

            clear
	fi
}

function scan_directory() {
    read -p "Especifique o diretório: " diretorio
    if [ ! -d "$diretorio" ]; then
        echo "O diretório não existe."
    else
        echo "Iniciando a verificação do diretório..."
        update_progress &
        progress_pid=$!

        resultado=$(clamscan --bell -r "$diretorio")

        kill "$progress_pid"  # Parar o contador de progresso
        clear

        if echo "$resultado" | grep -q "Infected files: 1"; then
            read -p "Existem arquivos infectados. Deseja excluí-los? (S/N): " resposta
            if [ "$resposta" = "S" ] || [ "$resposta" = "s" ]; then
                find "$diretorio" -type f -name "*.lck" -delete
                echo "Os arquivos infectados foram excluídos."
            else
                echo "Os arquivos infectados não foram excluídos."
            fi
        else
            echo "Não foram encontrados arquivos infectados."

	    # Aguarda o usuário pressionar Enter para concluir
	    echo -e "\033[1;33m"
	    read -p "Pressione Enter para concluir..."

            clear
        fi
    fi
}

function scan_system() {
    echo "Iniciando a verificação de todo o sistema..."
        update_progress &
        progress_pid=$!

        clamscan --bell -r /

        kill "$progress_pid"  # Parar o contador de progresso
        
	# Aguarda o usuário pressionar Enter para concluir
	echo -e "\033[1;33m"
	read -p "Pressione Enter para concluir..."

        clear
}

function check_ports(){
	#!/bin/bash

	# Verifica se o usuário é root (necessário para utilizar o nmap)
	if [[ $EUID -ne 0 ]]; then
	    echo "Esse recurso precisa ser executado como root."
	    exit 1
	fi

	# Verifica se o nmap está instalado e instala se não estiver
	if ! command -v nmap &> /dev/null; then
	    echo "O Nmap não está instalado. Instalando..."
	    apt-get update
	    apt-get install -y nmap
	fi

	# Executa o Nmap para encontrar as portas abertas no localhost
	echo -e "Procurando por portas abertas...\033[0;32m"
	nmap -sT -O localhost | awk '/^ *[0-9]+/ {print "Porta:", $1,"| Estado:", $2,"| Serviço:", $3}'

	# Aguarda o usuário pressionar Enter para concluir
	echo -e "\033[1;33m"
	read -p "Pressione Enter para concluir..."
	clear


}

function main_menu() {
    while true; do
    	echo -e "\033[H"
    	apresenta_banner
        echo -e "\033[1;33mESCOLHA O MÉTODO DE SCANNER"
        echo "1- Escanear arquivo"
        echo "2- Escanear diretório"
        echo "3- Escanear todo o sistema"
        echo "4- Checar Portas Abertas"
        echo "5- Sair"
        read -p "Digite o número correspondente ao método desejado: " method
        echo ""

        case $method in
            1) scan_file ;;
            2) scan_directory ;;
            3) scan_system ;;
            4) check_ports ;;
            5) echo "Saindo..." && exit 0 ;;
            *) echo "Opção inválida. Tente novamente." ;;
        esac
    done
}

# Função principal
function main() {
    apresenta_banner
    permissao_root
    check_clamscan
    update_clamav_database
    main_menu
}

# Lidando com sinais para interrupção segura
trap "echo 'Saindo...'; exit 0" SIGINT SIGTERM

# Chamando a função principal
main

