#!/bin/sh

#show some color
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
ROOT_PATH=$(pwd)
FILE=""
FILE_NAME=""
FUNNEL_NAME=""
FUNNEL_FOLDER=""
ORDER_BUMP=""
LANDER_PREFIX=""
DOMAIN=""

clear

#colors
C_BLUE="\033[1;34m";C_GREEN="\033[0;32m";C_NONE="\033[0m";C_YELLOW="\033[1;33m";C_RED="\033[1;31m";C_GREY="\033[1;30m";C_PURPLE="\033[1;35m";C_GREEN_U="\033[4;32m"
C_1="\033[38;5;88m";C_2="\033[38;5;89m";C_3="\033[38;5;90m";C_4="\033[38;5;91m";C_5="\033[38;5;92m";C_6="\033[38;5;93m";C_7="\033[38;5;94m";
C_8="\033[38;5;235m";C_9="\033[38;5;236m";C_10="\033[38;5;237m";C_11="\033[38;5;238m";C_12="\033[38;5;239m";C_13="\033[38;5;240m";


function file_selection {

	unset FILE
	unset FILE_NAME
	COUNT=0
	for f in $1; do
		COUNT=$[$COUNT+1]
	    [[  $f ]] || continue
		FILE[$COUNT]=$f
		FILE_NAME[$COUNT]=$(echo "$f" | cut -d "/" -f 2);
	 	echo   $C_GREEN $COUNT")" $C_BLUE ${FILE_NAME[$COUNT]} $C_NONE
	done
	echo  \   "\n $C_YELLOW Please select a file (q=quit) $C_NONE"



	while true;do
		read -n 1 -s USER_OPTION
		if [ "$USER_OPTION" == "q" ]; then
			FILE_NAME=$USER_OPTION
			break
			#return
		fi
		if [ "$USER_OPTION" -gt $COUNT ] || [ "$USER_OPTION" -lt 1 ]; then
			echo  "$C_RED Not a valid option (q=quit) $C_NONE"
			echo  "$C_YELLOW Please select a file (q=quit) $C_NONE"
		fi
		if [ "$USER_OPTION" -lt $[$COUNT+1] ] && [ "$USER_OPTION" -gt 0 ]; then
			FILE_NAME=${FILE[$USER_OPTION]} #$("ls -1 $1 | sed '"$USER_OPTION"q;d'")
			echo  \  "Selected: $C_BLUE $FILE_NAME $C_NONE"
			main_menu
			break
		fi
	done
}

function set_funnel_name {
    while true; do
        echo "\nWhat do you want to name the funnel folder name for git (Default=$FUNNEL_NAME,q=quit)"
        read FUNNEL_FOLDER


        if [ "$FUNNEL_FOLDER" == "q" ]; then exit; fi

        if [ -z "$FUNNEL_FOLDER" ]; then

            FUNNEL_FOLDER=$FUNNEL_NAME
            echo "\n[+] Checking if ../funnels/$FUNNEL_FOLDER exists"

                if [ -d "../funnels/$FUNNEL_FOLDER" ]; then
                    echo "\n[+] Funnel $C_RED ../funnels/$FUNNEL_FOLDER already exists$C_NONE ..$C_YELLOW select another name $C_NONE"

                else
                    FUNNEL_FOLDER=$FUNNEL_NAME
                    return 0
                    break
                fi
        fi


        if [ ! -d "../funnels/$FUNNEL_FOLDER" ]; then
            return 0
            break
        fi
    done
}

function set_order_bump
{
    while true; do
        echo "\nList the order bump product_ids separated by commas (Default=NONE,q=quit)"
        read ORDER_BUMP

        if [ "$ORDER_BUMP" == "q" ]; then main_menu; fi

        if [ -z "$ORDER_BUMP" ]; then
            ORDER_BUMP=""
            return 0
        fi

        if [ ! -z $ORDER_BUMP ]; then
            return 0
            break
        fi
    done
}

function set_lander_prefix
{
    while true; do
        echo "\nWhat do you want the lander prefix to be in Click Funnels? Must be unique, no spaces. (Default=$FUNNEL_NAME,q=quit)"
        read LANDER_PREFIX

        if [ "$LANDER_PREFIX" == "q" ]; then main_menu; fi

        if [ -z "$LANDER_PREFIX" ]; then
            LANDER_PREFIX=$FUNNEL_NAME
            return 0
        fi

        if [ ! -z $LANDER_PREFIX ]; then
            return 0
            break
        fi
    done
}


function build_funnel {

    set_funnel_name
    mkdir "../funnels/$FUNNEL_FOLDER"
    echo "\n[+] Created directory $C_RED ../funnels/$FUNNEL_FOLDER $C_NONE"
    echo "\n[+] Unzipping$C_RED $FILE_NAME $C_NONE to$C_YELLOW ../funnels/$FUNNEL_FOLDER$C_NONE"
    unzip ./$FILE_NAME -d ../funnels/$FUNNEL_FOLDER
    echo "\n[+] decompression $C_GREEN Done$C_NONE"


    echo "\n[+] What is the base domain name for this funnel (e.g. ultracoolair.co)"
    read DOMAIN

    set_lander_prefix
    echo "\n[+] Funnel prefix set to$C_GREEN www.$DOMAIN.com/$LANDER_PREFIX$C_NONE"

    set_order_bump
    echo "\n[+] Order bump on order page set to$C_GREEN [$ORDER_BUMP$C_NONE]"

    echo "\n[+] Copying template file$C_GREEN async.php$C_NONE"
    rm ../funnels/$FUNNEL_FOLDER/resources/async.php
    cp template/async.php ../funnels/$FUNNEL_FOLDER/resources/async.php

    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n[+] Copying template file$C_GREEN js.php$C_NONE"
    cp template/js.php ../funnels/$FUNNEL_FOLDER/js.php
    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n[+] Copying template file$C_GREEN kform.css$C_NONE"
    rm ../funnels/$FUNNEL_FOLDER/resources/css/kform.css
    cp template/kform.css ../funnels/$FUNNEL_FOLDER/resources/css/kform.css
    echo "\n[+]$C_GREEN Done$C_NONE"


    echo "\n[+] Copying template file$C_GREEN klander.js$C_NONE"
    rm ../funnels/$FUNNEL_FOLDER/resources/js/klander.js
    cp template/klander.js ../funnels/$FUNNEL_FOLDER/resources/js/klander.js
    sed -i -e "s/{CG_LANDER_NAME}/$FUNNEL_FOLDER/g" ../funnels/$FUNNEL_FOLDER/resources/js/klander.js

    echo "\n[+]$C_GREEN Done$C_NONE"


    echo "\n[+] Copying template file$C_GREEN konnektiveSDK.php$C_NONE"
    rm ../funnels/$FUNNEL_FOLDER/resources/konnektiveSDK.php
    cp template/konnektiveSDK.php ../funnels/$FUNNEL_FOLDER/resources/konnektiveSDK.php
    echo "\n[+]$C_GREEN Done $C_NONE"

    echo "\n[+] Modifying resource path in $C_GREEN config.php$C_NONE"
    sed -i -e "s/resources\//https:\/\/secure.$DOMAIN\/funnels\/$FUNNEL_FOLDER\/resources\//g" ../funnels/$FUNNEL_FOLDER/resources/config.php
    echo "\n[+]$C_GREEN Done $C_NONE"


    echo "\n[+] Copying template file$C_GREEN .htaccess$C_NONE"
    cp template/.htaccess ../funnels/$FUNNEL_FOLDER/.htaccess
    echo "\n[+]$C_GREEN Done $C_NONE"


    echo "\n[+] Copying$C_GREEN cg-checkout.js$C_NONE"
    cp template/cg-checkout.js ../funnels/$FUNNEL_FOLDER/resources/js/cg-checkout.js

    echo "\n[+] Writing order bump "
    sed -i -e "s/{CG_ORDER_BUMP}/$ORDER_BUMP/g" ../funnels/$FUNNEL_FOLDER/resources/js/cg-checkout.js
    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n[+] Writing lander prefix "
    sed -i -e "s/{CG_LANDER_PREFIX}/$LANDER_PREFIX/g" ../funnels/$FUNNEL_FOLDER/resources/js/cg-checkout.js
    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n[+] Writing funnel name "
    sed -i -e "s/{CG_LANDER_NAME}/$FUNNEL_FOLDER/g" ../funnels/$FUNNEL_FOLDER/resources/js/cg-checkout.js
    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n[+] Updating Konnektive config file "
    sed -i -e "s/\"apiLoginId\"=>\"\"/\"apiLoginId\"=>\"clickgamma_api\"/g" ../funnels/$FUNNEL_FOLDER/resources/config.php
    sed -i -e "s/\"apiPassword\"=>\"\"/\"apiPassword\"=>\"desapark!!api\"/g" ../funnels/$FUNNEL_FOLDER/resources/config.php

    echo "\n[+]$C_GREEN Done$C_NONE"



    echo "\n $C_YELLOW Please put the following HTML in the ClickFunnels Settings:$C_NONE \n"

    echo "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js$C_NONE\"></script>"
    echo "<link type=\"text/css\" href=\"https://secure.${C_RED}${DOMAIN}${C_NONE}/funnels/$FUNNEL_FOLDER/resources/css/kform.css$C_NONE\" rel=\"stylesheet\">"
    echo "<script src=\"https://cf.############.com/dist/js/cf-ef_tracking.js$C_NONE\"></script>"
    echo "<script src=\"https://secure.${C_RED}${DOMAIN}${C_NONE}/funnels/$FUNNEL_FOLDER/resources/js/cg-checkout.js$C_NONE\"></script>"



    echo "\n ... press ENTER to continue"
    READ -n1 BLAH
    main_menu

    exit
}

function check_in_git {
    git status
    git add -A;
    git commit -m "Adding new funnel $FUNNEL_FOLDER to the repository";
    git push
    echo "\n[+]$C_GREEN Done$C_NONE"

    echo "\n ... press ENTER to continue"
    READ -n1 BLAH
    clear
    return 0

}

function main_menu {
    clear
    echo "$C_GREY\n\n+------------------------------------------------------------+"
    echo "$C_GREY|$C_1    ___ _ _      _      ___                                 $C_GREY|"
    echo "$C_GREY|$C_2   / __\ (_) ___| | __ / _ \__ _ _ __ ___  _ __ ___   __ _  $C_GREY|"
    echo "$C_GREY|$C_3  / /  | | |/ __| |/ // /_\/ _\` | '_ \` _ \| '_ \` _ \ / _\` | $C_GREY|"
    echo "$C_GREY|$C_4 / /___| | | (__|   </  /_\\ (_| | | | | | | | | | | | (_| | $C_GREY|"
    echo "$C_GREY|$C_5 \____/|_|_|\___|_|\_\____/\__,_|_| |_| |_|_| |_| |_|\__,_| $C_GREY|"
    echo "$C_GREY+------------------------------------------------------------+"

    echo "$C_GREY|$C_GREEN           $C_BLUE Funnel Builder $C_GREY paul@############.com             |"

    echo "$C_GREY+------------------------------------------------------------+$C_NONE\n\n"

    echo   \  $C_GREEN_U"S"$C_NONE"elect a funnel to build"


    if [ -f $FILE_NAME ]; then
        FUNNEL_NAME=${FILE_NAME##*/};
        FUNNEL_NAME=${FUNNEL_NAME%.zip*}
        echo   \  $C_GREEN_U"B"$C_NONE"uild selected funnel $C_RED$FUNNEL_NAME";
    fi
    echo   \  $C_GREEN_U"C"$C_NONE"heck all code on secure.############.com to GIT\n"
    echo   \  $C_GREEN_U"Q"$C_NONE"uit Funnel Builder\n"
    echo   \  $C_YELLOW"Please make a selection:\n$C_NONE"


        while [ ! "$USER_OPTION" == "q" ]
        do
            case $USER_OPTION in
                s)
                    file_selection "zip/*.zip"
                    break;
                    #FILE_NAME #FILE
                ;;
                b)
                    build_funnel
                    break;
                ;;
                c)
                    check_in_git
                    break;
                ;;
            esac

            read -n 1 -s USER_OPTION
        done
}

main_menu


