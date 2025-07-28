# IoT Microservice Platform - Makefile
# Упрощенное управление Docker Compose окружением

# Переменные
COMPOSE_FILE = infrastructure/docker-compose.yaml
ENV_FILE = .env

# Цвета для вывода
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help up down status health

# По умолчанию показываем справку
.DEFAULT_GOAL := help

help: ## Показать справку по доступным командам
	@echo "$(GREEN)IoT Microservice Platform - Management Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Доступные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

up: ## Запуск всех контейнеров
	@echo "$(GREEN)Запуск IoT Platform...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)✓ Все контейнеры запущены$(NC)"
	@echo "$(YELLOW)Ожидайте 2-3 минуты для полной инициализации$(NC)"

down: ## Остановка всех контейнеров
	@echo "$(RED)Остановка IoT Platform...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down
	@echo "$(RED)✓ Все контейнеры остановлены$(NC)"

status: ## Показать статус контейнеров
	@echo "$(GREEN)Статус контейнеров:$(NC)"
	@docker-compose -f $(COMPOSE_FILE) ps

health: ## Проверка работоспособности сервисов
	@echo "$(GREEN)Проверка работоспособности сервисов:$(NC)"
	@echo ""
	@printf "%-15s " "Grafana:"; \
	if curl -s -f http://localhost:3000/api/health > /dev/null 2>&1; then \
		echo "$(GREEN)✓ Работает$(NC)"; \
	else \
		echo "$(RED)✗ Недоступен$(NC)"; \
	fi
	@printf "%-15s " "Prometheus:"; \
	if curl -s -f http://localhost:9090/-/healthy > /dev/null 2>&1; then \
		echo "$(GREEN)✓ Работает$(NC)"; \
	else \
		echo "$(RED)✗ Недоступен$(NC)"; \
	fi
	@printf "%-15s " "Keycloak:"; \
	if curl -s -f http://localhost:9091/health > /dev/null 2>&1; then \
		echo "$(GREEN)✓ Работает$(NC)"; \
	else \
		echo "$(RED)✗ Недоступен$(NC)"; \
	fi
	@printf "%-15s " "MinIO:"; \
	if curl -s -f http://localhost:9000/minio/health/live > /dev/null 2>&1; then \
		echo "$(GREEN)✓ Работает$(NC)"; \
	else \
		echo "$(RED)✗ Недоступен$(NC)"; \
	fi
