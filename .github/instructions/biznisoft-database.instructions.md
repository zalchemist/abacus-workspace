---
applyTo: "**/*.sql"
description: "Use when: working with BizniSoft ERP SQL files, database queries, or any SQL operations on opp/opp7102025 databases. Loads BizniSoft database context automatically."
---

# BizniSoft Database Context

## Arhitektura
- `opp` — master šifarnička baza (196 tabela)
- `opp7102025` — transakciona baza firme 710/2025 (645 tabela, 105 procedura, 265 trigera)
- Nema eksplicitnih FK constrainta — sve relacije su implicitne

## Pristup bazi
```bash
sudo mysql -u root -e "SQL"
```

## Referentna dokumentacija
Sve u `projects/biznisoft_skill_input/knowledge/`:
- `BIZNISOFT_MASTER_REFERENCE.md` — kompletna referenca sistema
- `biznisoft_opp_sifarnici.md` — šifarničke tabele
- `biznisoft_tables_reference.md` — transakcione tabele
- `biznisoft_triggers.md` — trigeri (265)
- `implicit_relations.md` — implicitne relacije bez FK

## Pravila za SQL operacije
1. Pre UPDATE/DELETE: napravi backup tabelu
2. Proveri trigere na tabeli pre izmene
3. Koristi konkretne nazive kolona, ne generalizuj
4. Svi nazivi su na srpskom (latinica) ili BizniSoft konvenciji
