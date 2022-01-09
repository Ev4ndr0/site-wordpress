#!/bin/bash
OS := $(shell uname)
UID := $(shell id -u)

ifneq ("$(wildcard .env)","")
  $(info ${Y} using .env)
  include .env
else
  $(info ${Y} using .env.example)
  include .env.example
endif

# NAMESERVER_IP := $(shell ip address | grep docker0)
NAMESERVER_IP := 172.17.0.1
THIS_PROJECT_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

ifeq ($(OS),Darwin)
	NAMESERVER_IP = host.docker.internal
else ifeq ($(NAMESERVER_IP),)
	NAMESERVER_IP = $(shell grep nameserver /etc/resolv.conf  | cut -d ' ' -f2)
endif

#################################################################################

.PHONY: help
help:
	@echo " ===================================================================================================== "
	@echo "                          SERVICE WORDPRESS FOR SITES                             								      "
	@echo " ===================================================================================================== "
	@echo "                       																	                                              "
	@echo " CONTAINERS            																	                                              "
	@echo " ===================================================================================================== "
	@echo " up                    => Sube um container    														                            "
	@echo " down                  => Baixar o container															                              "
	@echo "                                                                                                       "
	@echo " logs                  => Exibe logs do container       												                        "
	@echo " ===================================================================================================== "

.PHONY: env
env:
	@bash ./.utils/message.sh info "[INFO] Env file generator"
	cp .env.example .env

#################################################################################

.PHONY: stop
stop:
	@bash ./.utils/message.sh info "[INFO] ✋ Stop containers 🛑"
	U_ID=${UID} docker-compose -f docker-compose.yml stop

#################################################################################
.PHONY: pre-build
pre-build:
	@bash ./.utils/message.sh info "[INFO] Pré-build containers"
	mkdir -p ${SERVICE_SOURCE_DIR} 
	sudo chmod -R 777 ${SERVICE_SOURCE_DIR} 
	sudo mkdir -p ${SERVICE_SOURCE_DIR}/wp-content/themes/	
	@bash ./.utils/message.sh info "[INFO] add permiss for plugins folder"
	sudo mkdir -p ${SERVICE_SOURCE_DIR}/wp-content/plugins/ 
	@make stop
#################################################################################

.PHONY: up
up:
	@make env
	@make pre-build
	@bash ./.utils/message.sh info "[INFO] 🚀 Building the Service 🚀"
	@make down
	U_ID=${UID} HOST=${NAMESERVER_IP} docker-compose -f docker-compose.yml build
	U_ID=${UID} HOST=${NAMESERVER_IP} docker-compose -f docker-compose.yml up -d
	@make logs
	sudo chmod 777 -R ${SERVICE_SOURCE_DIR}/wp-content/plugins/ 
	sudo chmod 777 -R ${SERVICE_SOURCE_DIR}/wp-content/themes/ 
	@bash ./.utils/message.sh success "✔️ Container build successfully"
	@echo " "
	@bash ./.utils/message.sh info "🎯 Show localhost domains (CONTROL + click)"
	@echo " "
	@bash ./.utils/message.sh link "📌 http://localhost:${SERVICE_SERVER_PORT}"
	@echo " "

#################################################################################

.PHONY: down
down:
	@bash ./.utils/message.sh info "[INFO] Bringing done"
	U_ID=${UID} HOST=${NAMESERVER_IP} docker-compose -f docker-compose.yml down --remove-orphans

#################################################################################

.PHONY: logs
logs:
	@bash ./.utils/message.sh info "[INFO] Show containers logs"
	docker-compose logs $(filter-out $@,$(MAKECMDGOALS)) --tail="100"

.PHONY: remove-work
remove-work:
	@bash ./.utils/message.sh info "[INFO] Remove files"
	@make down
	sudo rm -rf mysql/*
	sudo rm -rf src/br.com.site/

