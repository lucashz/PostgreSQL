#/bin/bash!

#Variaveis 
endereco=""
diretorio=""
usuario=""
arqReplicacao=""
logDir="./replicacao.log"

echo "" > $logDir

while true; do
    read -p "Eeste procedimento é critico, que leva um certo tempo, deseja continuar?  " sn

    case $sn in
        [SsYy]* )


############ Coleta Endereço

                read -p "Insira o endereço do host (Master)  " endereco

		echo "Endereço = $endereco"  | tee -a $logDir

############ Coleta Diretorio

                read -p "Insira o diretorio onde serão salvos os arquivos  " diretorio

		echo "Endereço = $diretorio"  | tee -a $logDir

############ Coleta Usuario

                read -p "Insira o usuario que será usado para replicação  " usuario

		echo "Endereço = $usuario"  | tee -a $logDir

############ Coleta diretorio do arquivo recovery.conf

                read -p "Insira o diretorio de onde será copiado o arquivo recovery.conf  " arqReplicacao

		echo "Endereço = $arqReplicacao"  | tee -a $logDir

############ Executar replicação
	
		echo "Efetuando a replicação de arquivos" | tee -a $logDir
	
			time pg_basebackup -h $endereco -D $diretorio -F plain -P -v -U $usuario  | tee -a $logDir
	
		echo "Replicação finalizada"  | tee -a $logDir

############ Criar arquivo de recovery
		echo "Copiando o arquivos de recovery"  | tee -a $logDir

			cp $arqReplicacao $diretorio

		echo "Copiado com sucesso"  | tee -a $logDir

############ Alterar permissões do diretorio

			 #Remover o arquivo de configuração
                        rm -rf /database/postgresql.conf
                        #Copiar o novo darquivo
                        cp /root/postgresql.conf /database/

		echo "Alterando permicao do diretorio $diretorio"  | tee -a $logDir

			chown  -R postgres:postgres $diretorio

			chmod 700 $diretorio

		echo "Alterando com sucesso"  | tee -a $logDir

############ Iniciar serviço
		
		echo "Iniciando serviço do banco de dados"  | tee -a $logDir

			service postgresql-10 restart

		echo "iniciado com sucesso"  | tee -a $logDir
############ Aviso de conclusão

		echo "Script de replicação executado, para validar verifique o log em $logDir"  | tee -a $logDir


        exit;;
        [Nn]* ) exit;;
        * ) echo "Favor responder com sim ou não.";;
    esac
done

exit
