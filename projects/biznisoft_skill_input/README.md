# BizniSoft DB Analyst - Skill Input Data

Input podaci za kreiranje agent skill-a za autonomnu analizu BizniSoft ERP baza podataka.

Ovaj repozitorijum sadrži sve potrebne fajlove — knowledge bazu, skripte, toolkite i kompletne instrukcije — za kreiranje AI agenta koji može da importuje, analizira i dokumentuje BizniSoft ERP baze bez prethodnog poznavanja sistema.

---

## 📁 Struktura foldera

```
biznisoft_skill_input/
├── README.md                          # Ovaj fajl
├── meta_skill_creator/
│   └── skills_meta-skill-creator.zip  # Meta-skill creator za generisanje SKILL.md
├── mariadb_toolkit/
│   └── mariadb_toolkit_v2.zip         # MariaDB toolkit (quick_setup.sh + performance config)
├── knowledge/                         # Dokumentacija i referentni materijali
│   ├── BIZNISOFT_MASTER_REFERENCE.md  # Glavni referentni dokument
│   ├── biznisoft_dokumentacija.md     # Uputstva sa sajta proizvođača
│   ├── biznisoft_stored_procedures.md # 105 procedura iz transakcione baze
│   ├── biznisoft_opp_stored_procedures.md # 11 procedura iz master baze
│   ├── biznisoft_functions.md         # 44 funkcije (FIFO, PDV, NBC kalkulacije)
│   ├── biznisoft_triggers.md          # 265 trigera (operdoc_*, zak_*)
│   ├── biznisoft_tables_reference.md  # Struktura 116 ključnih tabela
│   ├── biznisoft_opp_tables_reference.md # Struktura 38 master tabela
│   ├── biznisoft_opp_sifarnici.md     # Sadržaj 33 šifarnika
│   ├── biznisoft_dependency_map.md    # Mapa zavisnosti opp ↔ oppXXXYYYY
│   ├── biznisoft_table_comparison.md  # Poređenje tabela između baza
│   ├── storno_patterns.md            # Logika storniranja (/1, /2 sufiksi)
│   ├── implicit_relations.md         # Kako se tabele povezuju bez FK
│   └── dump_parsing_tips.md          # Saveti za parsiranje SQL dump-ova
└── scripts/                           # Bash skripte za MariaDB operacije
    ├── setup_mariadb.sh               # Instalacija i pokretanje MariaDB
    ├── restart_mariadb.sh             # Brzi restart servera
    ├── import_database.sh             # Import SQL dumpa u bazu
    ├── unzip_and_detect.sh            # Raspakivanje ZIP-a i detekcija SQL fajlova
    ├── check_status.sh                # Provera da li baza radi
    └── apply_config.sh                # Primena performance konfiguracije
```

---

## 🎯 Kompletne instrukcije za skill — ŠTA SKILL TREBA DA UME

### ZADATAK

Koristi meta-skill-creator da kreiraš agent skill za autonomnu analizu BizniSoft ERP baza podataka.

### FAJLOVI KOJE DOBIJAŠ

1. **`skills_meta-skill-creator.zip`** — Pročitaj i primeni za kreiranje skill-a

2. **`mariadb_toolkit_v2.zip`** — Toolkit za MariaDB, sadrži:
   - `quick_setup.sh` - instalacija i pokretanje servera
   - `mariadb_performance.cnf` - optimizovana konfiguracija

3. **`knowledge/` folder sa dokumentima:**
   - `BIZNISOFT_MASTER_REFERENCE.md` - glavni referentni dokument
   - `biznisoft_dokumentacija.md` - uputstva sa sajta proizvođača
   - `biznisoft_stored_procedures.md` - 105 procedura iz transakcione baze
   - `biznisoft_opp_stored_procedures.md` - 11 procedura iz master baze
   - `biznisoft_functions.md` - 44 funkcije (FIFO, PDV, NBC kalkulacije)
   - `biznisoft_triggers.md` - 265 trigera (operdoc_*, zak_*)
   - `biznisoft_tables_reference.md` - struktura 116 ključnih tabela
   - `biznisoft_opp_tables_reference.md` - struktura 38 master tabela
   - `biznisoft_opp_sifarnici.md` - sadržaj 33 šifarnika
   - `biznisoft_dependency_map.md` - mapa zavisnosti opp ↔ oppXXXYYYY
   - `biznisoft_table_comparison.md` - poređenje tabela između baza
   - `storno_patterns.md` - logika storniranja (/1, /2 sufiksi)
   - `implicit_relations.md` - kako se tabele povezuju bez FK
   - `dump_parsing_tips.md` - saveti za parsiranje SQL dump-ova

4. **Skripte:**
   - `setup_mariadb.sh` - instalacija i pokretanje MariaDB
   - `restart_mariadb.sh` - brzi restart servera
   - `import_database.sh` - import SQL dumpa u bazu
   - `unzip_and_detect.sh` - raspakivanje ZIP-a i detekcija SQL fajlova
   - `check_status.sh` - provera da li baza radi
   - `apply_config.sh` - primena performance konfiguracije

### ŠTA SKILL TREBA DA UME

#### 1. Pokretanje okruženja
- Kada dobije ZIP sa SQL dump-om, automatski ga raspakuje
- Pokrene MariaDB server ako nije aktivan
- Importuje baze (opp + oppXXXYYYY format)
- UVEK koristi `sudo mysql -u root`
- Zna da VM može da se resetuje - ima proceduru brzog restarta

#### 2. Razumevanje BizniSoft arhitekture
- Multi-tenant model: `opp` = master baza, `oppXXXYYYY` = transakciona
- 95 tipova dokumenata (definisani u opp.documents)
- Implicitne relacije (nema FK constraints)
- Zna naming conventions za JOIN-ove (sifpar→kupci, sifrob→artikli...)

#### 3. Analiza integriteta podataka
- Referentni integritet (šifre moraju postojati u šifarnicima)
- Storno parovi (svaki /1 mora imati original)
- Finansijska ravnoteža (duguje = potražuje u finprom)
- Statusna konzistentnost (1=aktivan, 2=potvrđen, 9=storniran)

#### 4. Poznavanje poslovne logike
- Robno-trgovinsko poslovanje (kalkulacije, fakture, nivelacije)
- Finansijsko knjigovodstvo (nalozi, izvodi, IOS)
- PDV evidencija i rekapitulacija
- FIFO obračun nabavne cene
- Trigeri: operdoc_* (registar dokumenata), zak_* (zaključavanje perioda)

#### 5. Dokumentovanje nalaza
- Kreira `/home/ubuntu/session_findings/` za nova saznanja
- Generiše izveštaje o pronađenim problemima

### PRAVILA RADA

- Dump fajlovi se čuvaju u `/home/ubuntu/db_dumps/`
- Knowledge ostaje u `/home/ubuntu/knowledge/`
- Za import UVEK koristi `--force` flag (data truncation upozorenja)
- Ne upisuj broj redova u dokumentaciju (varira) - samo strukturu

**Cilj:** Kreiraj skill koji će moći odmah da krene sa analizom čim dobije BizniSoft bazu, bez potrebe da ponovo otkriva arhitekturu i pravila.

---

## 🚀 Uputstvo za korišćenje

### Korak 1: Priprema
Prenesite ceo `biznisoft_skill_input/` folder u novu DeepAgent konverzaciju.

### Korak 2: Pokretanje
Dajte agentu instrukciju:
```
Koristi priložene fajlove da kreiraš BizniSoft DB Analyst skill.
Pročitaj meta-skill-creator za format, a ostale fajlove koristi kao knowledge i scripts.
Prati instrukcije iz README.md sekcije "ŠTA SKILL TREBA DA UME".
```

### Korak 3: Verifikacija
Agent će kreirati skill sa SKILL.md, scripts/ i references/ folderom.
Proverite da li su svi knowledge fajlovi uključeni i da skripte rade.

### Korak 4: Testiranje
Upload-ujte BizniSoft SQL dump i testirajte da li skill:
- ✅ Automatski pokreće MariaDB
- ✅ Importuje dump bez grešaka
- ✅ Prepoznaje opp/oppXXXYYYY strukturu
- ✅ Izvršava analizu integriteta
- ✅ Dokumentuje nalaze

---

## 📊 Statistike knowledge baze

| Kategorija | Broj fajlova | Opis |
|---|---|---|
| Master referenca | 1 | Glavni dokument sa pregledom |
| Tabele | 3 | 116 + 38 tabela dokumentovano |
| Procedure | 2 | 105 + 11 stored procedura |
| Funkcije | 1 | 44 funkcije |
| Trigeri | 1 | 265 trigera |
| Šifarnici | 1 | 33 šifarnika sa sadržajem |
| Zavisnosti i relacije | 3 | Dependency map, implicit relations, comparison |
| Obrasci | 2 | Storno patterns, dump parsing tips |
| Dokumentacija | 1 | Sajt proizvođača |
| **Ukupno knowledge** | **14** | |
| Skripte | 6 | Bash skripte za MariaDB |
| Toolkiti (ZIP) | 2 | Meta-skill creator + MariaDB toolkit |
