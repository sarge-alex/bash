#!/bin/bash

# Имя базы данных
DB_NAME="TarkettDashboardDb"

# Пути для резервных копий
DAILY_BACKUP_DIR="/mnt/backup/daily"
WEEKLY_BACKUP_DIR="/mnt/backup/weekly"
MONTHLY_BACKUP_DIR="/mnt/backup/archive"


# Функция для создания резервной копии
create_backup() {
    local backup_dir=$1
    local backup_file="${backup_dir}/${DB_NAME}_$(date +%Y%m%d%H%M%S).dump"
    sudo -u postgres pg_dump $DB_NAME > $backup_file
    echo "Создана резервная копия: $backup_file"
}

# Функция для удаления старых резервных копий
cleanup_backups() {
    local backup_dir=$1
    local max_backups=$2
    local backups=($(ls -t ${backup_dir}/${DB_NAME}_*.dump))
    local count=${#backups[@]}
    if [ $count -gt $max_backups ]; then
        for (( i=$max_backups; i<$count; i++ )); do
            rm "${backups[$i]}"
            echo "Удалена старая резервная копия: ${backups[$i]}"
        done
    fi
}

# Ежедневная копия
create_backup $DAILY_BACKUP_DIR
cleanup_backups $DAILY_BACKUP_DIR 7

# Еженедельная копия (выполняется по воскресеньям)
if [ $(date +%u) -eq 7 ]; then
    create_backup $WEEKLY_BACKUP_DIR
    cleanup_backups $WEEKLY_BACKUP_DIR 4
fi

# Ежемесячная копия (выполняется первого числа каждого месяца)
if [ $(date +%d) -eq 01 ]; then
    create_backup $MONTHLY_BACKUP_DIR
    cleanup_backups $MONTHLY_BACKUP_DIR 2
fi
