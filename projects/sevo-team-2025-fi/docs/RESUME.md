# RESUME — Ševo Tim BizniSoft ERP Analiza
## Poslednje ažuriranje: 30.03.2026

---

## 🟢 Gde smo stali

Završena je **inicijalna analiza robnog knjigovodstva** za firmu Ševo Tim (šifra 710), poslovna godina 2025.

Kompletiran je pregled:
- Strukture tabela `robno` (191.422 redova) i `artikli` (1.349 artikala)
- Identifikacija aktivnih artikala u 2025 → **241 artikal** (tabela `tmp_aktivni_2025`)
- Tipovi dokumenata u robnom prometu (RC, RD, KL, UK, PST, NC, TF, IR, RN)
- Detaljni opisi kolona i relacija između tabela

---

## 🔵 Šta je sledeći korak

1. **Dublja analiza prometa po artiklima** — količinski i vrednosno za svakog od 241 aktivnog artikla
2. **Analiza po tipovima dokumenata** — šta je ulaz (RC=račun, UK=ulazna kalkulacija), šta je izlaz (RD=robni dokument/otpremnica)
3. **Zalihe na dan** — kalkulacija trenutnog stanja zaliha (PST + ulazi - izlazi)
4. **Analiza partnera/subjekata** — ko su kupci, ko su dobavljači
5. **Cross-tabela sa finansijskim modulom** — ako je potrebno

---

## 📊 Učitane tabele u MariaDB

### Baza: `opp` (master šifarnici)
- **196 tabela** ukupno
- Ključne: konfiguracija, korisnici, sistemske tabele

### Baza: `opp7102025` (poslovna godina 2025)
- **645 tabela** ukupno
- Ključne tabele za robno:
  - `artikli` — 1.349 redova (šifarnik artikala, 84 kolone)
  - `robno` — 191.422 redova (robni promet, 34 kolone)
  - `tmp_aktivni_2025` — 241 red (kreirana, šifre aktivnih artikala)

---

## 🔧 Kako nastaviti rad

### Opcija 1: Nova sesija sa istim VM
Ako je MariaDB još aktivan:
```bash
# Proveri da li su baze dostupne
sudo mysql -e "SHOW DATABASES;"
sudo mysql -e "SELECT COUNT(*) FROM tmp_aktivni_2025;" opp7102025
```

### Opcija 2: Potpuno nova sesija
Ako treba ponovo učitati baze:
```bash
# 1. Instaliraj MariaDB
sudo apt-get update && sudo apt-get install -y mariadb-server
sudo systemctl start mariadb

# 2. Importuj baze (iz /home/ubuntu/baze_sql/)
sudo mysql -e "CREATE DATABASE IF NOT EXISTS opp;"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS opp7102025;"
sudo mysql opp < /home/ubuntu/baze_sql/opp.sql
sudo mysql opp7102025 < /home/ubuntu/baze_sql/opp7102025.sql

# 3. Rekreiraj tmp_aktivni_2025
sudo mysql opp7102025 < /home/ubuntu/sevo_tim_2025_backup/sql/01_kreiranje_tmp_aktivni_2025.sql
```

### Opcija 3: Samo analiza bez baze
Svi rezultati su sačuvani u:
- `sevo_tim_2025_backup/findings/` — kompletni izveštaji (MD + PDF)
- `sevo_tim_2025_backup/data/` — exportovani podaci (TSV)
- `sevo_tim_2025_backup/sql/` — svi upiti za reprodukciju

---

## 📁 Struktura backup foldera

```
sevo_tim_2025_backup/
├── RESUME.md                          ← OVAJ FAJL
├── logs/
│   └── SESSION_LOG_2026-03-30.md      ← Hronološki log sesije
├── sql/
│   ├── 01_kreiranje_tmp_aktivni_2025.sql
│   ├── 02_tipovi_dokumenata.sql
│   ├── 03_spojeni_robno_artikli.sql
│   ├── 04_svi_ostali_upiti.sql
│   ├── robno_queries.sql              ← Originalni SQL upiti
│   ├── ANALIZA_ROBNO.md
│   └── ANALIZA_ROBNO.pdf
├── findings/
│   ├── 2026-03-30-import-status.md/.pdf
│   ├── 2026-03-30-robno-inicijalna-analiza.md/.pdf
│   ├── 2026-03-30-sifarnik-artikala-analiza.md/.pdf
│   └── STRUKTURA_ROBNO_ARTIKLI.md/.pdf
└── data/
    ├── tmp_aktivni_2025.tsv           ← 241 šifra aktivnih artikala
    ├── aktivni_artikli_241_lista.tsv   ← Sa nazivima i tipovima
    └── tipovi_dokumenata_2025.tsv      ← Svi tipovi dokumenata
```

---

## 📌 Ključni brojevi za pamćenje

| Metrika | Vrednost |
|---------|----------|
| Ukupno artikala u šifarniku | 1.349 |
| Aktivnih u 2025 | **241** (17.9%) |
| Redova u robno | 191.422 |
| Tipova dokumenata | ~450+ varijanti (osnovnih ~10) |
| Baza opp tabela | 196 |
| Baza opp7102025 tabela | 645 |
