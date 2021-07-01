export COMPOSE_PROJECT_NAME=mca_flutter

sudo docker-compose \
  -p ${COMPOSE_PROJECT_NAME} \
  -f int_test_new/docker-compose.yml \
  ${@}