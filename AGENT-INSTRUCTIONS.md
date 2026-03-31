# Agent Instructions v3.0
> Poslednje ažuriranje: 2026-03-31
> Jezik: srpski, latinica, ekavica

## OBAVEZNO ČITANJE

Ovaj dokument je OBAVEZAN za svakog agenta pre bilo kakvog rada. Ako nisi pročitao ovaj dokument u celosti, STANI i pročitaj ga sada.

---

## 1. PRIORITET DOKUMENATA

### Nivo 1: ALWAYS (uvek pročitaj)
- `AGENT-INSTRUCTIONS.md` - ovaj fajl
- `STATUS.md` - pre SVAKOG deliverable-a

### Nivo 2: AUTO ATTACHED (kada radiš na projektu)
- `projects/[ime_projekta]/README.md`
- `projects/[ime_projekta]/CHECKPOINT.md` (ako postoji)

### Nivo 3: AGENT REQUESTED (kada ti treba skill)
- Prvo pročitaj `SKILL-INDEX.md` u abacus-skill-creator repozitorijumu
- Zatim učitaj potreban skill

### Nivo 4: MANUAL (samo kada korisnik kaže)
- Specifične instrukcije date u chatu

---

## 2. KONTEKST DETEKCIJA

Pre nego što počneš da radiš, odredi tip zadatka:

| Tip | Primeri | Pristup |
|-----|---------|---------||
| **Jednostavan** | Prevod, kratko pitanje, definicija | Odgovori direktno, bez primera |
| **Srednji** | Analiza, izveštaj, pregled | Daj nacrt/primer, čekaj potvrdu |
| **Kompleksan** | Razvoj, multifile, sistem | Checkpoint na svakom koraku |

### Kako prepoznati kompleksan zadatak:
- Više od 3 fajla
- Više od 1 sat rada
- Uključuje bazu podataka ili API
- Korisnik kaže "detaljno", "kompletno", "sve"

---

## 3. CHECKPOINT PRAVILA

### Pre SVAKOG deliverable-a:
1. Pročitaj `STATUS.md`
2. Pregledaj sekciju **"Čekanja potvrde"** i prijavi otvorene stavke
3. Proveri da li je neko drugi radio na istom
4. Daj PRIMER pre izvršenja (osim za jednostavne zadatke)
5. Čekaj potvrdu korisnika

### Ako je prošlo više od 5 poruka:
- Pročitaj ponovo `STATUS.md`
- Proveri da li se nešto promenilo

### Ako korisnik kaže "nastavi" posle pauze:
- Pročitaj `STATUS.md`
- Rezimiraj gde smo stali
- Pitaj da li da nastaviš

---

## 4. PRAVILA KOMUNIKACIJE

### NE RADI:
- Ne istrčavaj sa deliverable-om bez primera
- Ne agregiraj podatke ako korisnik traži originalne
- Ne pretpostavljaj - PITAJ
- Ne preskači korake da bi bio brži

### RADI:
- Daj primer pre izvršenja
- Zadrži originalnu strukturu podataka
- Pitaj ako nešto nije jasno
- Logiraj svoj rad u STATUS.md

### Format primera:
```
Pre nego što nastavim, evo primera kako će izgledati:
[primer]
Da li je ovo ok? Ako jeste, nastavljam.
```

---

## 5. LOGOVANJE

### Posle SVAKOG završenog zadatka:
Upiši u `STATUS.md`:
- Datum i vreme
- Šta je urađeno
- Gde su rezultati
- Sledeći korak (ako postoji)

### Format:
```markdown
## [DATUM] - [KRATAK OPIS]
- **Agent:** [ime sesije ako je poznato]
- **Urađeno:** [šta]
- **Rezultat:** [gde je fajl/link]
- **Sledeće:** [šta treba dalje]
```

---

## 6. RAD SA GITHUB-om

### Pravila:
- Nikad `force push`
- Za izmene koristi feature branch
- Commit poruke na srpskom, jasne i kratke
- PR za sve osim hitnih ispravki

### Brisanje grane posle merge-a
- Poruka „Pull request successfully merged and closed… branch can be safely deleted“ znači da su izmene iz grane uspešno spojene u ciljnu granu i PR je zatvoren.
- Bezbedno je obrisati granu ako **nema daljeg rada** na njoj i **nema nemergovanih commit-a**.
- Ako planiraš dodatne izmene ili želiš istoriju, ostavi granu ili napravi tag/backup pre brisanja.
- Lokalnu granu briši tek kad proveriš da nemaš lokalne izmene koje nisu pushovane.

### Struktura repozitorijuma:
```
abacus-workspace/          ← Projekti i radni prostor
├── AGENT-INSTRUCTIONS.md  ← Ovaj fajl
├── STATUS.md              ← Trenutno stanje
└── projects/              ← Aktivni projekti

abacus-skill-creator/      ← Alat za kreiranje + biblioteka skills-a
├── SKILL.md               ← Uputstvo za kreiranje
└── skills/                ← Svi kreirani skills-i
```

---

## 7. SKILLS

### Gde su skills-i:
- Repozitorijum: `zalchemist/abacus-skill-creator`
- Folder: `skills/`
- Indeks: `SKILL-INDEX.md`

### Kada koristiti skill:
1. Pročitaj `SKILL-INDEX.md`
2. Pronađi odgovarajući skill
3. Kloniraj/pročitaj skill sa GitHub-a
4. Prati uputstva iz `SKILL.md` unutar skill-a

### Kreiranje novog skill-a:
- Koristi metodologiju iz `abacus-skill-creator/SKILL.md`
- 5 faza: Discovery, Design, Architecture, Detection, Implementation
- Po završetku, dodaj u `skills/` folder i ažuriraj indeks

---

## 8. GREŠKE I UČENJE

### Ako napraviš grešku:
1. Priznaj grešku
2. Objasni šta je pošlo naopako
3. Predloži ispravku
4. Upiši u STATUS.md kao "LEKCIJA NAUČENA"

### Česte greške koje treba izbegavati:
- Agregacija umesto originalnih podataka
- Preskakanje primera
- Pretpostavljanje umesto pitanja
- Zaboravljanje da se pročita STATUS.md

---

## VERZIJA I ISTORIJA

| Verzija | Datum | Izmene |
|---------|-------|--------|
| 3.0 | 2026-03-31 | Kompletna reorganizacija, dodati prioriteti, checkpoint, logovanje |
| 2.0 | 2024-03-30 | Prethodna verzija |
