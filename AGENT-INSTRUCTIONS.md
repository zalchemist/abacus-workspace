> ⚠️ **OBAVEZNO PRVO PROČITAJ CEO OVAJ FAJL**
> 
> Pre nego što postaviš bilo kakvo pitanje ili započneš rad:
> 1. Pročitaj kompletan sadržaj ovog dokumenta
> 2. Zapamti strukturu repozitorijuma i gde se šta nalazi
> 3. NE postavljaj pitanja o lokaciji fajlova, strukturi foldera ili povezanim repozitorijumima - sve je dokumentovano ispod
> 4. Tek nakon čitanja, nastavi sa korisnikovim zadatkom

---

# Agent instrukcije — abacus-workspace

## Jezik komunikacije

- Sva komunikacija sa korisnikom: **srpski jezik, latinica, ekavski dijalekt**
- Bez reči bosanskog/hrvatskog porekla
- Interna dokumentacija i reference ostaju na engleskom

## O ovom repozitorijumu

Ovo je generalni radni prostor za adhoc projekte, istraživanja i nacrte.
Korisnik: **zalchemist**
Repo: `zalchemist/abacus-workspace`

## Pravila za rad

### Gde šta čuvati

| Tip sadržaja | Folder | Primer |
|-------------|--------|--------|
| Aktivni projekti sa više fajlova | `projects/naziv/` | Automatizacija procesa |
| Istraživanja i analize | `research/` | Analiza tržišta |
| Radne verzije i skice | `drafts/` | Nacrt dokumenta |
| Logovi sesija | `logs/` | Debug zapisi |
| Završeni materijali | `archive/` | Prošli projekti |

### Konvencije imenovanja

- Fajlovi u `research/`: `YYYY-MM-DD-tema.md` (npr. `2026-03-30-analiza-trzista.md`)
- Folderi u `projects/`: kebab-case (npr. `projects/api-monitor/`)
- Logovi: `YYYY-MM-DD-opis.md`

### Git pravila

- Napravi feature branch za veće izmene
- Za brze beleške i logove — direktan commit na main je prihvatljiv
- Commit poruke na srpskom, jasne i koncizne
- Nikad force push na main

### Kada prebaciti u poseban repo

Ako projekat u `projects/` preraste u nešto veće:
- Više od 10 fajlova
- Potrebno verzioniranje
- Više agenata radi na tome
- Treba CI/CD

→ Kreiraj novi repo, premesti sadržaj, ostavi `MOVED.md` sa linkom.

### Ako je skill za Abacus

Ako se nešto iz workspace-a razvije u agent skill:
1. Premesti u `zalchemist/abacus-skills/skills/naziv/`
2. Dodaj `SKILL.md` po šablonu
3. Obriši iz workspace-a ili premesti u `archive/`

## Povezani repozitorijumi

- `zalchemist/abacus-skills` — centralno mesto za agent skills
- `zalchemist/abacus-skill-creator` — alat za automatsko kreiranje skills-a
