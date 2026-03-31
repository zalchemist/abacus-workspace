#!/bin/bash
# =============================================================================
# apply_config.sh — Primena MariaDB performance konfiguracije
# =============================================================================
# Koristi: sudo bash apply_config.sh
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_SRC="$SKILL_DIR/config/mariadb_performance.cnf"
CONFIG_DST="/etc/mysql/mariadb.conf.d/99-biznisoft-performance.cnf"

echo "=== Primena MariaDB Performance Konfiguracije ==="

# 1. Provera izvorne konfiguracije
if [ ! -f "$CONFIG_SRC" ]; then
    echo "[ERROR] Konfiguracija nije pronađena: $CONFIG_SRC"
    exit 1
fi

# 2. Kreiranje backup-a ako postoji stara konfiguracija
if [ -f "$CONFIG_DST" ]; then
    BACKUP="${CONFIG_DST}.bak.$(date +%Y%m%d%H%M%S)"
    sudo cp "$CONFIG_DST" "$BACKUP"
    echo "[INFO] Backup stare konfiguracije: $BACKUP"
fi

# 3. Kopiranje nove konfiguracije
sudo mkdir -p /etc/mysql/mariadb.conf.d/
sudo cp "$CONFIG_SRC" "$CONFIG_DST"
echo "[OK] Konfiguracija kopirana u: $CONFIG_DST"

# 4. Kreiranje log direktorijuma
sudo mkdir -p /var/log/mysql
sudo chown mysql:mysql /var/log/mysql 2>/dev/null || true

# 5. Validacija konfiguracije (suva provera)
echo "[INFO] Validacija konfiguracije..."
if sudo mysqld --defaults-file="$CONFIG_DST" --help --verbose &>/dev/null 2>&1; then
    echo "[OK] Konfiguracija je validna."
else
    echo "[WARN] Validacija preskočena (mysqld help nije dostupan)."
fi

# 6. Restart servera za primenu
echo "[INFO] Restart MariaDB servera za primenu konfiguracije..."

if command -v systemctl &>/dev/null && systemctl is-system-running &>/dev/null 2>&1; then
    sudo systemctl restart mariadb
else
    # Non-systemd: pokušaj graceful gašenja pa kontrolisan start.
    if sudo mysqladmin -u root shutdown &>/dev/null; then
        echo "[INFO] MariaDB graceful shutdown uspešan."
    else
        echo "[WARN] Graceful shutdown nije uspeo; pokušavam SIGTERM nad poznatim PID-ovima."
        pids="$(pgrep -x mysqld || true)"
        pids="${pids}"$'\n'"$(pgrep -x mariadbd || true)"
        if [ -n "$(echo "$pids" | tr -d '\n[:space:]')" ]; then
            while IFS= read -r pid; do
                [ -z "$pid" ] && continue
                sudo kill -TERM "$pid" 2>/dev/null || true
            done <<< "$pids"
            sleep 3
        fi
    fi
    sleep 2
    sudo mysqld_safe --defaults-extra-file="$CONFIG_DST" &
    sleep 3
fi

# 7. Čekanje i verifikacija
for i in $(seq 1 30); do
    if sudo mysqladmin ping &>/dev/null 2>&1; then
        echo "[OK] MariaDB restartovan sa novom konfiguracijom."
        echo ""
        echo "=== Ključni parametri ==="
        sudo mysql -u root -e "
            SELECT VARIABLE_NAME, VARIABLE_VALUE
            FROM information_schema.GLOBAL_VARIABLES
            WHERE VARIABLE_NAME IN (
                'innodb_buffer_pool_size',
                'innodb_log_file_size',
                'query_cache_size',
                'max_connections',
                'tmp_table_size',
                'max_allowed_packet',
                'table_open_cache'
            )
            ORDER BY VARIABLE_NAME;
        " 2>/dev/null
        echo ""
        echo "[DONE] Konfiguracija primenjena."
        exit 0
    fi
    sleep 1
done

echo "[ERROR] MariaDB se nije pokrenuo nakon primene konfiguracije."
exit 1
