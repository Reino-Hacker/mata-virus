#!/bin/bash

if ! command -v clamscan &>/dev/null; then
    read -p "ClamAV não está instalado. Press (enter) para prosseguir e instalar ou (ctrl+c) para sair."
    sudo apt install clamav -y
fi

clear
echo "Primeiro vamos atualizar o banco de dados do MATA-VIRUS"
sudo freshclam

clear
echo "Atualizado com sucesso."
sleep 3
clear

echo "        v_0.1"
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
echo ""
sleep 10

function update_progress() {
    local progress=0
    while [ $progress -lt 1000 ]; do
        sleep 1
	clear
	echo "verificação em andamento: "
        progress=$((progress + 1))
        echo "$progress%"
    done
}

while true; do
    echo -e "\033[1;33mESCOLHA O MÉTODO DE SCANNER"
    echo "1- Escanear arquivo"
    echo "2- Escanear diretório"
    echo "3- Escanear todo o sistema"
    echo "4- Sair"
    read -p "Digite o número correspondente ao método desejado: " metodo

    if [ $metodo -eq 1 ]; then
        clear
        read -p "Especifique o caminho completo para o arquivo: " caminho_arquivo
        if [ ! -e "$caminho_arquivo" ]; then
            echo "O arquivo não existe."
        else
            echo "Iniciando a verificação do arquivo, aguarde..."
            update_progress &
            progress_pid=$!

            resultado=$(clamscan --bell "$caminho_arquivo")

            kill "$progress_pid"  # Parar o contador de progresso
            clear

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
               sleep 3
               clear
            fi
        fi
    elif [ $metodo -eq 2 ]; then
        clear
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
                 sleep 3
                 clear
            fi
        fi
    elif [ $metodo -eq 3 ]; then
        clear
        echo "Iniciando a verificação de todo o sistema..."
        update_progress &
        progress_pid=$!

        sudo clamscan --bell -r /

        kill "$progress_pid"  # Parar o contador de progresso
        clear
    elif [ $metodo -eq 4 ]; then
        clear
        echo "Saindo..."
        sleep 3
       firefox reinohacker.com &
        exit 0
    else
        clear
        echo "Opção inválida. Tente novamente."
    fi
done

