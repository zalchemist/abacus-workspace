# 📂 Abacus Workspace

Generalni radni prostor za adhoc projekte, istraživanja, nacrte i sve što ne spada u skills.

Ovaj repo služi kao centralno mesto za rad koji je u toku, eksperimentalne ideje i međurezultate.

## 📁 Struktura foldera

```
abacus-workspace/
├── README.md                 # Ovaj fajl
├── AGENT-INSTRUCTIONS.md     # Instrukcije za agente
├── projects/                 # Aktivni projekti
├── research/                 # Istraživanja i analize
├── drafts/                   # Nacrti i radne verzije
├── logs/                     # Logovi sesija i rezultata
└── archive/                  # Završeni/neaktivni materijali
```

## 📌 Kada koristiti koji folder

### `projects/`

Za **aktivne projekte** koji imaju jasan cilj i više fajlova.

- Svaki projekat u svom podfolderu: `projects/naziv-projekta/`
- Primer: automatizacija nekog procesa, analiza podataka, razvoj alata
- Projekat može sadržati kod, dokumentaciju, podatke

### `research/`

Za **istraživanja i analize** koje rade agenti.

- Rezultati web istraživanja
- Poređenja alata, tehnologija, pristupa
- Analize tržišta, konkurencije
- Format: Markdown fajlovi sa jasnim datumom u imenu (`2026-03-30-tema.md`)

### `drafts/`

Za **nacrte i radne verzije** koje još nisu završene.

- Tekstovi u pripremi
- Početne ideje
- Skice arhitekture
- Sve što je "work in progress"

### `logs/`

Za **logove sesija** i rezultate rada agenata.

- Zapisi važnih sesija sa agentima
- Izlazi dugotrajnih procesa
- Debug logovi

### `archive/`

Za **završene ili neaktivne** materijale.

- Sve što više nije aktivno ali želimo da sačuvamo
- Premestiti iz drugih foldera kada projekat/istraživanje završi

## 🔀 Kada temu prebaciti u poseban repo?

Ne svaki projekat zavređuje svoj repozitorijum. Koristi sledeće kriterijume:

### ✅ Prebaci u poseban repo kada:

- Projekat ima **više od 10 fajlova** i jasnu strukturu
- Projekat zahteva **verzioniranje** (releases, tags)
- Više osoba ili agenata **istovremeno** radi na projektu
- Projekat treba **CI/CD** ili automatizovane testove
- Projekat će se **deliti sa drugima** (public repo)
- Projekat je **skill za Abacus** → prebaci u `abacus-skills`

### ❌ Zadrži u workspace-u kada:

- To je **jednokratna analiza** ili istraživanje
- Projekat ima **manje od 5 fajlova**
- Projekat je **privremenog karaktera**
- Nema potrebe za verzioniranjem
- Samo ti koristiš materijal

### Procedura prebacivanja

1. Kreiraj novi repozitorijum na GitHub-u
2. Premesti fajlove iz `projects/naziv/` u novi repo
3. U workspace-u ostavi `projects/naziv/MOVED.md` sa linkom na novi repo
4. Premesti originalni folder u `archive/`

## 🤖 Kako informisati agenta da koristi ovaj repo

Dodaj u **Custom Instructions** agenta (Agent Settings → Customize & Add Skills → Agent tab):

```markdown
## Radni prostor
- Za čuvanje rezultata rada koristi repo: zalchemist/abacus-workspace
- Istraživanja čuvaj u research/ folderu
- Nacrte u drafts/ folderu
- Logove u logs/ folderu
- Projekat-specifične fajlove u projects/naziv-projekta/
- Pročitaj AGENT-INSTRUCTIONS.md na početku sesije
```

## 📝 Licenca

Privatni repozitorijum — samo za internu upotrebu.
