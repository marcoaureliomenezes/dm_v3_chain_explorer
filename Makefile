DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch = 1.0.0


##################################################################################################################################
##################################    COMANDOS PARA CONFIGURAÇÃO DO AMBIENTE    ##################################################
create_dm_v3_chain_explorer_structure:
	sh scripts/0_create_dm_v3_structure.sh

start_cluster_swarm:
	sh scripts/1_start_cluster_swarm.sh



##################################################################################################################################
#######################    COMANDOS DE INICIALIZAÇÃO DE AMBIENTE DE DESENVOLVIMENTO    ###########################################
##################################################################################################################################

build_app:
	docker build -t marcoaureliomenezes/dm-onchain-stream-txs:$(current_branch) ./docker/app_layer/onchain-stream-txs
	docker build -t marcoaureliomenezes/dm-spark-streaming-jobs:$(current_branch) ./docker/app_layer/spark-streaming-jobs

build_fast:
	docker build -t marcoaureliomenezes/dm-scylladb:$(current_branch) ./docker/fast_layer/scylladb
	docker build -t marcoaureliomenezes/dm-kafka-connect:$(current_branch) ./docker/fast_layer/kafka-connect

build_batch:
	docker build -t marcoaureliomenezes/hadoop-base:$(current_branch) ./docker/batch_layer/hadoop/base
	# docker build -t marcoaureliomenezes/dm-hadoop-namenode:$(current_branch) ./docker/batch_layer/hadoop/namenode
	# docker build -t marcoaureliomenezes/dm-hadoop-datanode:$(current_branch) ./docker/batch_layer/hadoop/datanode
	# docker build -t marcoaureliomenezes/dm-hadoop-resourcemanager:$(current_branch) ./docker/batch_layer/hadoop/resourcemanager
	# docker build -t marcoaureliomenezes/dm-hadoop-nodemanager:$(current_branch) ./docker/batch_layer/hadoop/nodemanager
	# docker build -t marcoaureliomenezes/dm-hadoop-historyserver:$(current_branch) ./docker/batch_layer/hadoop/historyserver
	# docker build -t marcoaureliomenezes/dm-postgres:$(current_branch) ./docker/batch_layer/postgres
	docker build -t marcoaureliomenezes/hive-base:$(current_branch) ./docker/batch_layer/hive/base
	# docker build -t marcoaureliomenezes/dm-hive-metastore:$(current_branch) ./docker/batch_layer/hive/metastore
	# docker build -t marcoaureliomenezes/dm-hive-server:$(current_branch) ./docker/batch_layer/hive/server
	# docker build -t marcoaureliomenezes/dm-hue-webui:$(current_branch) ./docker/batch_layer/hue

build_ops:
	docker build -t marcoaureliomenezes/dm-prometheus:$(current_branch) ./docker/ops_layer/prometheus

##################################################################################################################################
#########################	   COMANDOS DE PUBLICAÇÃO DE IMAGENS NO DOCKER-HUB    ##################################################

publish_apps:
	docker push marcoaureliomenezes/dm-onchain-stream-txs:$(current_branch)
	docker push marcoaureliomenezes/dm-spark-streaming-jobs:$(current_branch)

publish_fast:
	docker push dm_data_lake/scylladb:$(current_branch)
	docker push dm_data_lake/kafka-connect:$(current_branch)

publish_batch:
	# docker push marcoaureliomenezes/dm-scylladb:$(current_branch)
	# docker push marcoaureliomenezes/dm-hadoop-namenode:$(current_branch)
	# docker push marcoaureliomenezes/dm-hadoop-datanode:$(current_branch)
	# docker push marcoaureliomenezes/dm-hadoop-resourcemanager:$(current_branch)
	# docker push marcoaureliomenezes/dm-hadoop-nodemanager:$(current_branch)
	# docker push marcoaureliomenezes/dm-hadoop-historyserver:$(current_branch)
	# docker push marcoaureliomenezes/dm-postgres:$(current_branch)
	# docker push marcoaureliomenezes/dm-hive-base:$(current_branch)
	# docker push marcoaureliomenezes/dm-hive-metastore:$(current_branch)
	# docker push marcoaureliomenezes/dm-hive-server:$(current_branch)
	# docker push marcoaureliomenezes/dm-hue-webui:$(current_branch)
	# docker push marcoaureliomenezes/dm-spark-master:$(current_branch)
	# docker push marcoaureliomenezes/dm-spark-worker:$(current_branch)
	# docker push marcoaureliomenezes/dm-apache-airflow:$(current_branch)

publish_ops:
	docker push marcoaureliomenezes/dm-prometheus:$(current_branch)

##################################################################################################################################
###################    COMANDOS DE DEPLOY DE CONTAINERS EM AMBIENTE DE DESENVOLVIMENTO    ########################################

deploy_dev_fast:
	docker compose -f services/transactional/compose_fast.yml up -d --build

deploy_dev_app:
	docker compose -f services/transactional/compose_apps.yml up -d --build

deploy_dev_batch:
	docker compose -f services/data_lake/compose_hadoop_hive.yml up -d --build

deploy_dev_ops:
	docker compose -f services/operations/compose_monitoring.yml up -d --build
	
##################################################################################################################################
#########################    COMANDOS DE STOP CONTAINERS EM AMBIENTE DE DESENVOLVIMENTO    #######################################

stop_dev_fast:
	docker compose -f services/transactional/compose_fast.yml down

stop_dev_app:
	docker compose -f services/transactional/compose_apps.yml down

stop_dev_batch:
	docker compose -f services/data_lake/compose_hadoop_hive.yml down

stop_dev_ops:
	docker compose -f services/operations/compose_monitoring.yml down

##################################################################################################################################
#########################    COMANDOS DE WATCH CONTAINERS EM AMBIENTE DE DESENVOLVIMENTO    ######################################

watch_dev_fast:
	watch docker compose -f services/transactional/compose_fast.yml ps

watch_dev_app:
	watch docker compose -f services/transactional/compose_apps.yml ps

watch_dev_batch:
	watch docker compose -f services/data_lake/compose_hadoop_hive.yml ps

watch_dev_ops:
	watch docker compose -f services/operations/compose_monitoring.yml ps


##################################################################################################################################
#######################    COMANDOS DE INICIALIZAÇÃO DE AMBIENTE DE PRODUÇÃO    ##################################################

# COMANDO DE INICIALIZAÇÃO DO CLUSTER SWARM
start_prod_cluster:
	sh scripts/start_prod_cluster.sh


##################################################################################################################################
#######################    COMANDOS DE DEPLOY DE CONTAINERS EM AMBIENTE DE PRODUÇÃO    ###########################################

deploy_prod_fast:
	docker stack deploy -c services/fast/cluster_swarm.yml layer_fast

deploy_prod_app:
	docker stack deploy -c services/app/cluster_swarm.yml layer_app

deploy_prod_batch:
	docker stack deploy -c services/batch/cluster_swarm.yml layer_batch

deploy_prod_ops:
	docker stack deploy -c services/ops/cluster_swarm.yml layer_ops


##################################################################################################################################
#######################    COMANDOS DE STOP DE CONTAINERS EM AMBIENTE DE PRODUÇÃO    #############################################

stop_prod_fast:
	docker stack rm layer_fast

stop_prod_app:
	docker stack rm layer_app

stop_prod_batch:
	docker stack rm layer_batch

stop_prod_ops:
	docker stack rm layer_ops


##################################################################################################################################
#######################    COMANDOS DE WATCH DE CONTAINERS EM AMBIENTE DE PRODUÇÃO    ############################################

watch_prod_services:
	watch docker service ls


query_api_keys_consumption_table:
	docker exec -it scylladb cqlsh -e "select * from operations.api_keys_node_providers;"


##################################################################################################################################
##############################    COMANDOS DE RELATIVOS A CONNECTORS DO KAFKA CONNECT    #########################################

connect_show_connectors:
	http :8083/connector-plugins -b

deploy_sink_blocks_hdfs:
	http PUT :8083/connectors/block-metadata-hdfs-sink/config @connectors/hdfs-sink/block-metadata.json -b

stop_sink_blocks_hdfs:
	http DELETE :8083/connectors/block-metadata-hdfs-sink -b

status_sink_blocks_hdfs:
	http :8083/connectors/block-metadata-hdfs-sink/status -b

pause_sink_blocks_hdfs:
	http PUT :8083/connectors/block-metadata-hdfs-sink/pause -b


##################################################################################################################################

deploy_sink_contract_call_hdfs:
	http PUT :8083/connectors/contract-call-hdfs-sink/config @connectors/hdfs-sink/contract-call-txs.json -b

status_sink_contract_call_hdfs:
	http :8083/connectors/contract-call-hdfs-sink/status -b

stop_sink_contract_call_hdfs:
	http DELETE :8083/connectors/contract-call-hdfs-sink -b

pause_sink_contract_call_hdfs:
	http PUT :8083/connectors/contract-call-hdfs-sink/pause -b

##################################################################################################################################

deploy_sink_token_transfer_hdfs:
	http PUT :8083/connectors/token-transfer-hdfs-sink/config @connectors/hdfs-sink/token-transfer-txs.json -b

status_sink_token_transfer_hdfs:
	http :8083/connectors/token-transfer-hdfs-sink/status -b

stop_sink_token_transfer_hdfs:
	http DELETE :8083/connectors/token-transfer-hdfs-sink -b

pause_sink_token_transfer_hdfs:
	http PUT :8083/connectors/token-transfer-hdfs-sink/pause -b