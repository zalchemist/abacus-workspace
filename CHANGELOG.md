# CHANGELOG

Ovaj fajl beleži značajne promene u repozitorijumu. Svaki agent čita ovo na početku sesije.

---
## [2026-03-31] Session: check-pending-reviews

**Agent:** GitHub Copilot Coding Agent

### Urađeno

- Dodata sekcija **"Čekanja potvrde"** u STATUS.md sa pregledom otvorenih PR-ova po repozitorijumu
- Zabeležen rezultat provere (otvoren samo draft PR #18 u abacus-workspace)
- Ažurirana CHECKPOINT pravila u AGENT-INSTRUCTIONS.md za obaveznu proveru te sekcije

### Fajlovi

- `STATUS.md`
- `AGENT-INSTRUCTIONS.md`

---

## [2026-03-31] Session: registry-templates-knowledge-index

**Agent:** DeepAgent

### Urađeno

- **Kreiran skills-registry.json u abacus-skills:**
  - Automatski parsiranje svih skills iz abacus-skill-creator/skills/
  - Izvučeni: naziv, verzija, opis, lokacija za svaki skill
  - Registrovana 3 skill-a: biznisoft-db-analyst-v1, excel-serbian-standard-v3, komunikacija-sa-korisnikom

- **Kreirana templates/ struktura u abacus-workspace:**
  - `templates/project-template/README.md` — šablon za nove projekte
  - `templates/research-template/README.md` — šablon za istraživanja
  - `templates/skill-template/README.md` — šablon za nove skills

- **Kreiran knowledge-index.md:**
  - Indeks svih 14 knowledge fajlova u projects/biznisoft_skill_input/knowledge/
  - Tabela sa nazivom fajla i kratkim opisom sadržaja

### Fajlovi

- `abacus-skills/skills-registry.json` — novi registar skills-a
- `abacus-workspace/templates/*/README.md` — 3 nova šablona
- `abacus-workspace/projects/biznisoft_skill_input/knowledge/knowledge-index.md` — novi indeks

### Napomene

- Skills su sada centralizovani u abacus-skill-creator/skills/
- skills-registry.json omogućava programski pristup registru
- Templates olakšavaju kreiranje novih projekata/istraživanja/skills-a

---


## [2026-03-30] Session: uklanjanje-repo-i-analiza-ekosistema

**Agent:** GitHub Copilot Coding Agent

### Urađeno

- **Uklanjanje 3 neaktivna repozitorijuma:**
  - `zalchemist/Online_MS` — uklonjen
  - `zalchemist/Final_TD-Cycle-test-just-to-handshake` — uklonjen
  - `zalchemist/MSONLINE` — uklonjen
- **Analiza strukture i kvaliteta preostalih repozitorijuma:**
  - `abacus-workspace` — odlična struktura, aktivni projekti (biznisoft, sevo-team)
  - `abacus-skills` — dobra struktura ali prazan registar (skills su u workspace)
  - `abacus-skill-creator` — funkcionalan alat baziran na open-source rešenju
- **Inicijalizovan `research/` folder** sa prvim dokumentom analize

### Fajlovi

- `research/2026-03-30-analiza-repozitorijuma.md` — nova analiza ekosistema

### Nalazi

- Skills (`biznisoft-db-analyst-v1`, `excel-serbian-standard-v3`) su u `workspace/skills/` umesto u `abacus-skills/skills/`
- `abacus-skills/SKILL-INDEX.md` ne odražava stvarno stanje
- `projects/biznisoft_skill_input/` koristi underscore umesto kebab-case konvencije

### Sledeći koraci

- Migrirati skillove iz `workspace/skills/` u `abacus-skills/skills/`
- Ažurirati `SKILL-INDEX.md` u `abacus-skills`
- Dodati `.gitignore` u `abacus-workspace` i `abacus-skills`

---

## 2026-03-30

### Sistemske promene
- **Nova verzija AGENT-INSTRUCTIONS.md (v2)**
  - Uveden CHANGELOG sistem za komunikaciju između agenata
  - Definisana hijerarhija repozitorijuma
  - Protokoli za početak i kraj sesije
  - Triggeri za specijalne akcije (SKILL kreiranje, prebacivanje projekata)
  - Detalji: pogledaj AGENT-INSTRUCTIONS.md
