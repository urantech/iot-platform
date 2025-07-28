# IoT Microservice Platform

IoT Microservice Platform – учебный проект, демонстрирующий архитектуру микросервисов для IoT-системы. Содержит полную инфраструктуру (Apache Kafka, PostgreSQL, Redis, мониторинг) и примеры реализации процессов сбора, обработки и анализа данных с IoT-устройств.

## Состав и архитектура

Платформа построена на принципах микросервисной архитектуры и включает следующие компоненты:

**Инфраструктурные компоненты:**
- **Apache Kafka** – брокер сообщений для event-driven архитектуры
- **PostgreSQL** – основная база данных для persistence слоя
- **Redis** – кэширование и хранение сессий
- **Keycloak** – сервер аутентификации и авторизации (OAuth 2.0/OIDC)
- **Prometheus + Grafana** – мониторинг и визуализация метрик
- **Camunda** – оркестрация процессов
- **Cassandra** – хранилище телеметрии
- **MinIO** – объектное хранилище

Диаграммы архитектуры доступны в каталоге `diagrams/`:
- [Контекстная диаграмма](diagrams/context.puml) – общий обзор системы
- [Диаграмма контейнеров](diagrams/containers.puml) – детализация компонентов

## Структура репозитория

```
.
├── LICENSE
├── Makefile
├── README.md
├── diagrams
│   ├── containers.puml
│   └── context.puml
└── infrastructure
    ├── docker-compose.yaml
    ├── kafka-meta.properties
    └── monitoring
        ├── alloy
        │   └── config.alloy
        ├── loki
        │   └── loki-config.yml
        ├── prometheus
        │   ├── alert.rules.yml
        │   └── prometheus.yml
        └── tempo
            └── tempo.yml

```

## Требования (Prerequisites)

Для запуска платформы локально необходимо установить:

- **Docker** (версия 20.10+)
- **Docker Compose** (версия 2.0+)
- **Git** для клонирования репозитория

## Настройка (Setup)

### 1. Клонирование репозитория
```bash
git clone https://github.com/urantech/iot-platform.git
cd iot-microservice-platform
```

### 2. Настройка переменных окружения
```bash
# Скопируйте файл с примером переменных окружения
cp .env.example .env

# Отредактируйте .env файл при необходимости
# По умолчанию настройки подходят для локального запуска
nano .env
```

### 3. Инициализация данных (опционально)
```bash
# Создание каталогов для persistent volumes
mkdir -p data/{postgres,grafana,prometheus}
```

## Запуск (Usage)

### Запуск полной платформы
```bash
# Запуск всех сервисов в фоновом режиме
make up

# Проверка статуса контейнеров
make status
```

### Остановка платформы
```bash
# Остановка с удалением volumes (полная очистка)
make down
```

## Проверка работы

После успешного запуска (обычно 2-3 минуты) проверьте доступность основных компонентов:

### Web-интерфейсы
- **Grafana** (мониторинг): http://localhost:3000
    - Логин: `admin` / Пароль: `admin`
    - Предустановленные дашборды для мониторинга PostgreSQL

- **Keycloak** (аутентификация): http://localhost:9091
    - Admin Console: http://localhost:9091/admin
    - Логин: `admin` / Пароль: `admin`

- **Prometheus** (метрики): http://localhost:9090
    - Targets status: http://localhost:9090/targets

### Просмотр метрик в Grafana
1. Откройте http://localhost:3000
2. Перейдите в раздел "Dashboards"
3. Выберите "IoT Platform Overview"
4. Настройте временный диапазон для просмотра данных
---

**Важно**: При первом запуске инициализация может занять до 5 минут. Если какой-либо сервис не отвечает, подождите немного и повторите проверку.
