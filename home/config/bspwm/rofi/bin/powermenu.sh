#!/usr/bin/env bash
#
# Autor:           William Santos - https://plus.diolinux.com.br/u/thespation/summary
# Colaboração:     Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Data:            18/01/2025
# Github:          https://github.com/tuxslack
# Script:          ~/.config/rofi/bin/powermenu.sh
# Versão:          0.2

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3


# Substitua com o caminho correto da pasta tema do Rofi.

# DIR="$HOME/.config/rofi/themes"

DIR="$HOME/.config/bspwm/rofi/themes"


# https://github.com/thespation/dpux_bspwm



clear

# ----------------------------------------------------------------------------------------

# Cores (tabela de cores: https://gist.github.com/avelino/3188137)

VERM="\033[1;31m"	# Deixa a saída na cor vermelho.
VERD="\033[0;32m"	# Deixa a saída na cor verde.
CIAN="\033[0;36m"	# Deixa a saída na cor ciano.

NORM="\033[0m"		# Volta para a cor padrão.


# ----------------------------------------------------------------------------------------

# Função para verificar a conectividade com a internet.

verificar_internet() {

    # Tentando fazer o ping para o Google (8.8.8.8) ou servidor DNS público.

    if ! ping -c 1 -W 3 8.8.8.8 &> /dev/null; then

        # Se o ping falhar, exibe uma tela de erro com YAD.

        yad --center \
            --image="error" \
            --title="Erro de Conexão" \
            --text="Não foi possível conectar à internet.\n\nVerifique sua conexão e tente novamente." \
            --button="OK":0 \
            --width="400" --height="200"

        exit

   # else

        # Se o ping for bem-sucedido, exibe uma mensagem de sucesso.

        # yad --center \
        #     --image="info" \
        #    --title="Conexão Bem-Sucedida" \
        #    --text="Você está conectado à internet." \
        #    --button="OK":0 \
        #    --width="300" --height="150" \


    fi

}


# ----------------------------------------------------------------------------------------

# Certifique-se de ter o yad instalado em seu sistema para que o script funcione corretamente. 

# Verifica se o yad está instalado.

if ! command -v yad &>/dev/null; then

    # Exibe a mensagem de erro em vermelho no terminal se o yad não estiver instalado.

    echo -e "${VERM}\n\nErro: O yad não está instalado. Instale o yad para continuar...\n ${NORM}"

    exit 1
fi

# ----------------------------------------------------------------------------------------

# Lista dos programas a serem verificados.

programas=("rofi" "dmenu" "shutdown" "i3lock" "xdg-open" "fc-list" "sed" "uptime" "ping") # systemctl, bspc

# Variável para armazenar a lista de programas que não estão instalados.

programas_faltando=""

# Verifica se cada programa está instalado.

for programa in "${programas[@]}"; do

    if ! command -v "$programa" &>/dev/null; then

        programas_faltando+="$programa não está instalado.\n"

    fi

done

# ----------------------------------------------------------------------------------------


# Se algum programa não estiver instalado, exibe a tela de erro.

if [ -n "$programas_faltando" ]; then

    yad --center --title "Erro" --text "\nOs seguintes programas não estão instalados:\n\n$programas_faltando" --button="OK" --width="400" --height="200"

    exit 

# else

#    yad --center --title "Sucesso" --text "Todos os programas estão instalados." --button="OK" --width="400" --height="200"

fi


# ----------------------------------------------------------------------------------------

# Verificar se a fonte "Font Awesome" esta instalada no sistema.

# Ela contém uma ampla variedade de ícones e símbolos úteis para interfaces de usuário, 
# sistemas e desenvolvedores. Muitas vezes, é empregada para representar ícones gráficos 
# em aplicações web e sistemas baseados em Linux.

# Além disso, uma fonte bastante conhecida nesse contexto, especialmente para terminal, é 
# a "DejaVu Sans Mono" e a "Nerd Fonts", que é uma coleção de fontes monoespaçadas com 
# ícones adicionais. A Nerd Fonts é uma modificação de fontes populares (como FiraCode, 
# Hack, etc.) para incluir uma grande variedade de ícones e símbolos, sendo amplamente 
# utilizada em terminais e IDEs no Linux.

# Essas fontes são populares em ambientes de desenvolvimento no Linux, especialmente 
# quando se utiliza um terminal ou editores que suportam esses ícones.


# Função para verificar se a fonte Font Awesome está instalada.

verificar_font_awesome() {

    # Usando o comando fc-list para verificar se a Font Awesome está instalada.

    if fc-list | grep -i "font awesome" > /dev/null; then

        return 0  # Fonte instalada
    else
        return 1  # Fonte não instalada
    fi
}

# Função para mostrar a caixa de diálogo com o YAD.

mostrar_dialogo() {

    yad --center \
        --title="Fonte Font Awesome" \
        --text="A fonte 'Font Awesome' não está instalada no seu sistema.\n\nVocê deseja baixar a fonte diretamente do site oficial?" \
        --button="Baixar":1 --button="Cancelar":2 \
        --width="300" --height="150"
}



    if ! verificar_font_awesome; then

        resposta=$(mostrar_dialogo)

        if [ $? -eq 1 ]; then


           # Chamar a função para verificar a conectividade

            verificar_internet


            # O usuário escolheu "Baixar".

            xdg-open "https://fontawesome.com" &  # Abre o site em um navegador.


            exit


        else

            exit

        fi



     # else


      #  yad --center --title="Fonte Font Awesome" --text="A fonte 'Font Awesome' já está instalada!" --button="OK":0 --width="300" --height="150"
      #
      # ~/.fonts/fontawesome-free-5.15.4-desktop/otfs/Font Awesome 5 Free-Regular-400.otf: Font Awesome 5 Free,Font Awesome 5 Free Regular:style=Regular
      # ~/.fonts/fontawesome-free-5.15.4-desktop/otfs/Font Awesome 5 Free-Solid-900.otf: Font Awesome 5 Free,Font Awesome 5 Free Solid:style=Solid
      # ~/.fonts/fontawesome-free-5.15.4-desktop/otfs/Font Awesome 5 Brands-Regular-400.otf: Font Awesome 5 Brands,Font Awesome 5 Brands Regular:style=Regular



    fi


# ----------------------------------------------------------------------------------------

# Para verificar se a pasta existe.

    if [ ! -d "$DIR" ]; then

        # Se a pasta não existe, exibe a tela de erro com YAD.

        yad --center \
            --image="error" \
            --title="Erro" \
            --text="A pasta '$DIR' não existe.\n\nPor favor, verifique o caminho e crie a pasta.\n\n$ mkdir -p $DIR" \
            --button="OK":0 \
            --width="400" --height="200"

        exit

    fi

# ----------------------------------------------------------------------------------------

    # Para verificar se o arquivo $DIR/powermenu.rasi existe e, caso não exista, informar o usuário.

    if [ ! -f "$DIR/powermenu.rasi" ]; then

        # Se o arquivo não existe, exibe a tela de erro com YAD.

        yad --center \
            --image="error" \
            --title="Erro" \
            --text="O arquivo '$DIR/powermenu.rasi' não foi encontrado.\n\nPor favor, verifique o caminho e crie o arquivo." \
            --button="OK":0 \
            --width="400" --height="200"

        exit

    # else

        # Se o arquivo existe, pode exibir uma mensagem informando que tudo está ok (opcional).

        # yad --center \
        #    --image="info"
        #    --title="Sucesso" \
        #    --text="O arquivo '$DIR/powermenu.rasi' existe." \
        #    --button="OK":0 \
        #    --width="300" --height="150"

    fi

# ----------------------------------------------------------------------------------------

rofi_command="rofi -theme $DIR/powermenu.rasi"

uptime=$(uptime -p | sed -e 's/up //g')


# Opções (usa a fonte Font Awesome)

shutdown=""
reboot=""
lock=""
suspend=""
logout=""


# Variável passada para Rofi.

options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"


#_msg="Options  -  yes / y / no / n"


chosen="$(echo -e "$options" | $rofi_command -p "Tempo ligado - $uptime" -dmenu -selected-row 2)"

case $chosen in

    $shutdown)

       # Esse comando devem funcionar na maioria das distribuições Linux que não utilizam o systemd.

       # Desligar com o comando shutdown.


       # Comando condicional que tenta executar os comandos em sequência e passa para o 
       # próximo comando somente se o anterior falhar (isto é, se o comando retornar um 
       # status de erro).

        systemctl poweroff || shutdown -h now  || poweroff || echo "Falha ao tentar desligar o sistema."

        ;;

    $reboot)

       # Esse comando devem funcionar na maioria das distribuições Linux que não utilizam o systemd.


       # Tenta reiniciar o sistema, testando várias opções.

       # Comando condicional que tenta executar os comandos em sequência e passa para o 
       # próximo comando somente se o anterior falhar (isto é, se o comando retornar um 
       # status de erro).

       # Reiniciar usando shutdown.

        systemctl reboot || shutdown -r now  || reboot || echo "Falha ao tentar reiniciar o sistema."

        ;;

    $lock)

        i3lock -c 000000

        ;;

    $suspend)

       # Esse comando devem funcionar na maioria das distribuições Linux que não utilizam o systemd.


       # Se você não tem systemd, pode usar uma das seguintes alternativas para suspender o sistema:
       # 
       # pm-suspend (se pm-utils estiver instalado)
       # suspend (se uswsusp estiver instalado)


       # Comando condicional que tenta executar os comandos em sequência e passa para o 
       # próximo comando somente se o anterior falhar (isto é, se o comando retornar um 
       # status de erro).

		systemctl suspend || pm-suspend || suspend || echo "Falha ao tentar suspender o sistema."

        ;;

    $logout)


# Detecta o gerenciador de janelas.

if [[ "$XDG_SESSION_DESKTOP" == "i3" || "$XDG_SESSION_TYPE" == "x11" && $(ps -e | grep -q i3 && echo true) ]]; then

    echo -e "${VERD}Usando i3wm. Realizando logout... ${NORM}"

    # sleep 1

    # Executar o comando "i3-msg exit" e capturar a saída de erro.

    erro=$(1i3-msg exit 2>&1)  # Captura a saída de erro, se houver.

    if [ $? -ne 0 ]; then

        # Se o comando falhar, exibe a tela de erro com YAD.

        yad --center \
            --title="Erro" \
            --image="error" \
            --text="Erro ao tentar sair do i3 com o comando 'i3-msg exit'.\n\nDetalhes do erro:\n\n$erro\n\nPor favor, verifique se o i3 está em execução." \
            --button="OK":0 \
            --width="300" --height="150"
    
    fi

    clear


elif [[ "$XDG_SESSION_DESKTOP" == "bspwm" || "$XDG_SESSION_TYPE" == "x11" && $(ps -e | grep -q bspwm && echo true) ]]; then

    echo -e "${VERD}Usando bspwm. Realizando logout... ${NORM}"

    # sleep 1
   
    # Executar o comando "bspc quit" e capturar a saída de erro.

    erro=$(bspc quit 2>&1)  # Captura a saída de erro, se houver.

    if [ $? -ne 0 ]; then

        # Se o comando falhar, exibe a tela de erro com YAD.

        yad --center \
            --title="Erro" \
            --image="error" \
            --text="Erro ao tentar sair do bspwm com o comando 'bspc quit'.\n\nDetalhes do erro:\n\n$erro\n\nPor favor, verifique se o bspwm está em execução." \
            --button="OK":0 \
            --width="300" --height="150"
    
    fi

    clear

elif [[ "$XDG_SESSION_DESKTOP" == "fluxbox" || "$XDG_SESSION_TYPE" == "x11" && $(ps -e | grep -q fluxbox && echo true) ]]; then

    echo -e "${VERD}Usando fluxbox. Realizando logout... ${NORM}"

    # sleep 1

    # Executar o comando "fluxbox -exit" e capturar a saída de erro.

    erro=$(fluxbox -exit 2>&1)  # Captura a saída de erro, se houver.

    if [ $? -ne 0 ]; then

        # Se o comando falhar, exibe a tela de erro com YAD.

        yad --center \
            --title="Erro" \
            --image="error" \
            --text="Erro ao tentar sair do fluxbox com o comando 'fluxbox -exit'.\n\nDetalhes do erro:\n\n$erro\n\nPor favor, verifique se o fluxbox está em execução." \
            --button="OK":0 \
            --width="300" --height="150"
    
    fi

    clear


elif [[ "$XDG_SESSION_DESKTOP" == "openbox" || "$XDG_SESSION_TYPE" == "x11" && $(ps -e | grep -q openbox && echo true) ]]; then

    echo -e "${VERD}Usando openbox. Realizando logout... ${NORM}"

   # sleep 1

   # Executar o comando "openbox --exit" e capturar a saída de erro.

    erro=$(openbox --exit 2>&1)  # Captura a saída de erro, se houver.

    if [ $? -ne 0 ]; then

        # Se o comando falhar, exibe a tela de erro com YAD.

        yad --center \
            --title="Erro" \
            --image="error" \
            --text="Erro ao tentar sair do openbox com o comando 'openbox --exit'.\n\nDetalhes do erro:\n\n$erro\n\nPor favor, verifique se o openbox está em execução." \
            --button="OK":0 \
            --width="300" --height="150"
    
    fi

    clear


else

    echo -e "${VERM}\n\nGerenciador de janelas não reconhecido ou sessão não detectada corretamente.\n ${NORM}"

    # sleep 1


        yad --center \
            --title="Erro" \
            --image="error" \
            --text="Gerenciador de janelas não reconhecido ou sessão não detectada corretamente." \
            --button="OK":0 \
            --width="300" --height="150"

    exit 1

fi


        ;;

esac

# ----------------------------------------------------------------------------------------


exit 0
