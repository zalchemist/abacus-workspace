# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This is a **knowledge-management and AI-agent workspace** for analyzing BizniSoft ERP databases. It is written in Serbian (Latin script). There is no traditional frontend/backend application — the core functionality is **MariaDB** with imported BizniSoft ERP SQL dumps, plus markdown documentation and bash scripts.

### Services

| Service | Purpose | How to start |
|---------|---------|-------------|
| MariaDB | Import and query BizniSoft ERP SQL dumps | `sudo mysqld_safe &` (non-systemd) |

### Starting MariaDB

This is a non-systemd environment. To start MariaDB:

```bash
sudo mysqld_safe &
sleep 3
sudo mysqladmin ping  # verify it's running
```

All MySQL commands use `sudo mysql -u root` (no password, socket auth).

### Database architecture

- `opp` — master/shared database (196 tables: document types, codebooks/šifarnici)
- `opp7102025` — transactional database (645 tables: financial, inventory, invoicing data)
- Cross-database JOINs work: e.g. `opp.documents` joined with `opp7102025.finprom`

### Importing databases

SQL dump files are in `projects/sevo-team-2025-fi/` as `.sql.gz`. To import:

```bash
gunzip -k -f file.sql.gz -c > /home/ubuntu/db_dumps/name.sql
sudo bash projects/biznisoft_skill_input/scripts/import_database.sh /home/ubuntu/db_dumps/name.sql dbname
```

### Key scripts

All in `projects/biznisoft_skill_input/scripts/`:
- `check_status.sh` — check MariaDB status and list databases
- `restart_mariadb.sh` — restart MariaDB server
- `import_database.sh` — import SQL dump into a database
- `setup_mariadb.sh` — full install + start (use for first-time setup)

### Performance config caveat

The bundled `mariadb_toolkit_v2.zip` contains a config tuned for 61GB RAM. On Cloud Agent VMs (16GB), a scaled-down config is applied at `/etc/mysql/mariadb.conf.d/99-biznisoft-performance.cnf` with 4GB buffer pool instead of 40GB.

### No lint/build/test

This repo has no linters, build systems, or automated test suites. Verification is done by running SQL queries against the imported databases and checking the bash scripts execute correctly.
