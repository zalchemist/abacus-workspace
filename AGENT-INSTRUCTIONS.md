# AGENT INSTRUCTIONS v2.0

> Instrukcije za AI agente koji rade sa Abacus ekosistemom repozitorijuma.

---

## 1. KRITIČNO - POČETAK SESIJE

**Ovo MORAŠ uraditi pre bilo kakvog rada:**

### Korak 1: Pročitaj CHANGELOG
```
Učitaj: abacus-workspace/CHANGELOG.md
```
- Pogledaj poslednjih 5-10 unosa
- Razumi šta je rađeno u prethodnim sesijama
- Identifikuj aktivne projekte/zadatke

### Korak 2: Identifikuj tip zadatka
Korisnikov zahtev spada u jednu od kategorija:

| Tip | Opis | Primarni repo |
|-----|------|---------------|
| 🔬 Istraživanje | Nova ideja, analiza, draft | abacus-workspace |
| 🛠️ Razvoj projekta | Rad na postojećem projektu | abacus-workspace/projects/ |
| ⚡ Kreiranje SKILL-a | Novi skill za agente | abacus-skill-creator |
| 📦 Korišćenje SKILL-a | Primena postojećeg skill-a | abacus-skills |

### Korak 3: Učitaj resurse PO POTREBI

| Ako radiš... | Učitaj |
|--------------|--------|
| Kreiranje SKILL-a | `abacus-skill-creator/SKILL.md` |
| Korišćenje SKILL-a | `abacus-skills/{skill-name}/` |
| Nastavak projekta | `abacus-workspace/projects/{projekat}/README.md` |

### Korak 4: Proveri git status
```bash
cd /relevantni-repo
git status
git pull origin main
```

### Korak 5: Potvrdi razumevanje
Reci korisniku:
- Šta si pročitao iz CHANGELOG-a
- Kako razumeš zadatak
- Gde ćeš raditi

---

## 2. HIJERARHIJA REPOZITORIJUMA

```
┌─────────────────────────────────────────────────────────────────┐
│                    ABACUS EKOSISTEM                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────┐                                       │
│  │  abacus-workspace    │ ← RADNI PROSTOR                       │
│  │  ──────────────────  │                                       │
│  │  /projects/          │   Aktivni projekti                    │
│  │  /research/          │   Istraživanja i analize              │
│  │  /drafts/            │   Skice i ideje                       │
│  │  /logs/sessions/     │   Session logovi                      │
│  │  CHANGELOG.md        │   Istorija promena                    │
│  └──────────┬───────────┘                                       │
│             │                                                   │
│             │ projekat prerasta                                 │
│             │ (KORISNIK odlučuje)                               │
│             ▼                                                   │
│  ┌──────────────────────┐      ┌──────────────────────┐         │
│  │  abacus-skills       │ ←────│ abacus-skill-creator │         │
│  │  ──────────────────  │      │ ──────────────────── │         │
│  │  REGISTAR            │      │ FABRIKA              │         │
│  │                      │      │                      │         │
│  │  Gotovi skills-i     │      │ 5-fazni pipeline:    │         │
│  │  spremni za upotrebu │      │ 1. Definicija        │         │
│  │                      │      │ 2. Arhitektura       │         │
│  │  /skill-name/        │      │ 3. Implementacija    │         │
│  │    ├── README.md     │      │ 4. Testiranje        │         │
│  │    ├── prompt.md     │      │ 5. Registracija      │         │
│  │    └── examples/     │      │                      │         │
│  └──────────────────────┘      └──────────────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Tok podataka

```
[Nova ideja] → workspace/drafts/ → workspace/research/ → workspace/projects/
                                                              │
                                    ┌─────────────────────────┘
                                    │ Ako postane reusable skill
                                    ▼
                            skill-creator (pipeline)
                                    │
                                    ▼
                              abacus-skills (registar)
```

---

## 3. CHANGELOG SISTEM

### Lokacija
```
abacus-workspace/CHANGELOG.md
```

### Format unosa

```markdown
## [YYYY-MM-DD] Session: kratak-opis

**Agent:** DeepAgent/ChatLLM  
**Trajanje:** ~Xh  

### Urađeno
- Kratki opis promene 1
- Kratki opis promene 2

### Fajlovi
- `projects/ime-projekta/` - novi projekat
- `research/analiza.md` - nova analiza

### Sledeći koraci
- Šta treba uraditi dalje (opciono)

---
```

### Kada upisivati u CHANGELOG

✅ **UPIŠI ako:**
- Kreiran novi projekat/folder
- Završena značajna faza rada
- Donesena važna odluka
- Promenjene instrukcije ili konfiguracija

❌ **NE UPISUJ za:**
- Sitne ispravke teksta
- Čitanje dokumentacije
- Neuspele pokušaje
- Nedovršen rad (osim ako je značajan)

### Session logovi

Za detaljnije beleške, koristi:
```
abacus-workspace/logs/sessions/YYYY-MM-DD-kratak-opis.md
```

Format session loga:
```markdown
# Session: Kratak opis
**Datum:** YYYY-MM-DD
**Agent:** DeepAgent

## Kontekst
Šta je korisnik tražio...

## Proces
1. Korak 1...
2. Korak 2...

## Rezultat
Šta je postignuto...

## Napomene
Dodatne informacije za buduće sesije...
```

---

## 4. PRAVILA ZA RAD

### Tabela: gde šta ide

| Tip sadržaja | Folder | Primer |
|--------------|--------|--------|
| Nova ideja, skica | `drafts/` | `drafts/ideja-chatbot.md` |
| Istraživanje, analiza | `research/` | `research/llm-comparison-2024.md` |
| Aktivan projekat | `projects/{ime}/` | `projects/api-monitor/` |
| Gotov skill | `abacus-skills/{ime}/` | `abacus-skills/code-reviewer/` |
| Session log | `logs/sessions/` | `logs/sessions/2024-03-30-setup.md` |

### Konvencije imenovanja

```
Folderi:    kebab-case        primer: my-project-name
Fajlovi:    kebab-case.md     primer: project-plan.md
Datumi:     YYYY-MM-DD        primer: 2024-03-30
```

### Git pravila

**Commit poruke na SRPSKOM:**
```bash
# Format
git commit -m "tip: kratak opis"

# Tipovi
feat:     nova funkcionalnost
fix:      ispravka
docs:     dokumentacija
refactor: refaktorisanje
chore:    održavanje
```

**Primeri:**
```bash
git commit -m "feat: dodat changelog sistem"
git commit -m "docs: ažurirane instrukcije za agente"
git commit -m "fix: ispravljena putanja do skills-a"
```

**Obavezne komande pre push-a:**
```bash
git status              # proveri šta se menja
git diff                # pregledaj promene
git add .               # ili specifični fajlovi
git commit -m "..."     
git push origin main
```

---

## 5. TRIGGERI ZA SPECIJALNE AKCIJE

### 🔴 TRIGGER: Potreban SKILL

**Prepoznaj po:**
- Korisnik kaže "napravi skill", "kreiraj skill"
- Potrebna je reusable komponenta za agente
- Nešto treba da bude u abacus-skills

**Akcija:**
```
1. STOP - ne improvizuj
2. Učitaj: abacus-skill-creator/SKILL.md
3. Prati 5-fazni pipeline do kraja
4. Registruj rezultat u abacus-skills
```

### 🟡 TRIGGER: Projekat prerasta

**Prepoznaj po:**
- Projekat u workspace postaje prevelik
- Treba mu sopstveni repo
- Postaje production-ready

**Akcija:**
```
⚠️ NE ODLUČUJ SAM!

Reci korisniku:
"Ovaj projekat je dorastao za sopstveni repozitorijum. 
Da li želiš da ga:
a) Zadržimo u workspace-u
b) Prebacimo u novi repo
c) Prebacimo u abacus-skills (ako je skill)"
```

### 🟢 TRIGGER: Nejasnoća

**Prepoznaj po:**
- Nisi siguran gde nešto ide
- Instrukcije su dvosmislene
- Više opcija ima smisla

**Akcija:**
```
PITAJ, NE PRETPOSTAVLJAJ!

Formuliši pitanje jasno:
"Razumem da treba X. Imam dve opcije:
A) ...
B) ...
Koja ti više odgovara?"
```

---

## 6. KRAJ SESIJE

### Checklist pre završetka

```
□ Da li je bilo značajnih promena?
  └─ DA → Ažuriraj CHANGELOG.md
  
□ Da li je sesija bila kompleksna?
  └─ DA → Kreiraj session log u logs/sessions/
  
□ Da li ima uncommitted promena?
  └─ DA → git add, commit, push
  
□ Da li ima nedovršenog posla?
  └─ DA → Zabeleži u "Sledeći koraci" u CHANGELOG-u
```

### Završna poruka korisniku

Uključi:
- Šta je urađeno
- Gde su fajlovi (putanje)
- Šta je sledeće (ako ima)
- Link na CHANGELOG ako je ažuriran

---

## QUICK REFERENCE

```
┌─────────────────────────────────────────────────────┐
│ POČETAK: Pročitaj CHANGELOG → Identifikuj zadatak  │
│ RAD:     Koristi pravi repo → Prati konvencije     │
│ SKILL:   Učitaj SKILL.md → Prati pipeline          │
│ ODLUKE:  Pitaj korisnika → Ne pretpostavljaj       │
│ KRAJ:    CHANGELOG → Session log → Commit & Push   │
└─────────────────────────────────────────────────────┘
```

---

*Verzija: 2.0*  
*Poslednje ažuriranje: 2024-03-30*  
*Autor: Korisnik + DeepAgent*
