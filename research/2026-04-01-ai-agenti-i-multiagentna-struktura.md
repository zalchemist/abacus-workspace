# AI agenti i multiagentna struktura — kako se prave i kako dele zadatke

**Datum:** 2026-04-01  
**Tip:** Tehničko istraživanje  
**Scope:** Arhitektura AI agenata, multiagentna orkestracija, memorijski sistemi

---

## Sadržaj

1. [Šta je AI agent](#1-šta-je-ai-agent)
2. [Komponente AI agenta](#2-komponente-ai-agenta)
3. [Kako se pravi agent — korak po korak](#3-kako-se-pravi-agent--korak-po-korak)
4. [Arhitekturni obrasci za agente](#4-arhitekturni-obrasci-za-agente)
5. [Memorija — kako agent pamti](#5-memorija--kako-agent-pamti)
6. [Multiagentna struktura — podela zadataka](#6-multiagentna-struktura--podela-zadataka)
7. [Obrasci orkestracije](#7-obrasci-orkestracije)
8. [Alati i frejmvorci](#8-alati-i-frejmvorci)
9. [Primenljivost na naš sistem (Abacus + Claw)](#9-primenljivost-na-naš-sistem-abacus--claw)

---

## 1. Šta je AI agent

AI agent je softverski sistem koji **autonomno radi ka cilju** koristeći LLM (veliki jezički model) kao jezgro za donošenje odluka. Za razliku od chatbota koji samo odgovara na pitanja, agent:

| Osobina | Chatbot | Agent |
|---------|---------|-------|
| Inicijativa | Reaktivan — čeka upit | Proaktivan — sam planira korake |
| Alati | Nema ili ograničeno | Koristi alate (API, baza, fajlovi, browser) |
| Autonomija | Jedan krug pitanje–odgovor | Višekoračna petlja dok ne završi cilj |
| Memorija | Samo unutar sesije | Može imati perzistentnu memoriju |
| Izvršenje | Ne izvršava kod | Izvršava kod, piše fajlove, poziva servise |

Agent funkcioniše u **zatvorenoj petlji**:

```
Cilj → Planiraj → Izvrši alat → Posmatraj rezultat → Ažuriraj stanje → Ponovi
```

Petlja se ponavlja dok agent ne odluči da je cilj postignut ili dok ne naiđe na blokadu koja zahteva ljudsku intervenciju.

---

## 2. Komponente AI agenta

Svaki agent ima četiri fundamentalne komponente:

### 2.1 Jezgro (LLM)

Model koji rezonuje, planira i donosi odluke. Može biti GPT-4o, Claude, Gemini, DeepSeek ili bilo koji drugi LLM. Izbor modela utiče na:
- kvalitet rezonovanja
- veličinu kontekstnog prozora
- brzinu odgovora
- cenu po tokenu

### 2.2 Alati (Tools)

Funkcije koje agent može da pozove da bi delovao na spoljni svet:

| Tip alata | Primeri |
|-----------|---------|
| API pozivi | REST/GraphQL endpointi, SDK metode |
| Fajl sistem | Čitanje, pisanje, pretraga fajlova |
| Baza podataka | SQL upiti, CRUD operacije |
| Browser | Pretraga weba, scraping |
| Kod | Izvršavanje Python/JS koda |
| Komunikacija | Slanje poruka, email, Slack |

Alati se definišu sa jasnom schemom (naziv, opis, parametri, povratna vrednost) da bi LLM znao kada i kako da ih koristi.

### 2.3 Memorija

Sistem za čuvanje konteksta. Detalji u [sekciji 5](#5-memorija--kako-agent-pamti).

### 2.4 Instrukcije (System Prompt)

Tekstualni okvir koji definiše:
- **identitet** agenta (ko je, šta radi)
- **pravila** ponašanja (šta sme, šta ne sme)
- **format** komunikacije (kako struktuira odgovore)
- **prioritete** (čime se baviti prvo)

---

## 3. Kako se pravi agent — korak po korak

### Korak 1: Definisanje misije

Svaki agent počinje od jasnog cilja. Nije dovoljno reći „pametni asistent" — treba precizno:

```
Loše:  "Pomozi korisniku sa bazom podataka"
Dobro: "Analiziraj BizniSoft ERP SQL bazu — izvršavaj upite, 
        tumači rezultate, generiši izveštaje u traženom formatu"
```

### Korak 2: Izbor alata

Na osnovu misije, definišu se alati koji su agentu potrebni. Princip: **minimalan skup alata koji pokriva sve potrebne akcije**. Svaki nepotreban alat povećava šansu za grešku.

### Korak 3: Pisanje instrukcije (System Prompt)

Instrukcija treba da bude:
- **kratka** — samo suština, bez dugih objašnjenja
- **struktuirana** — jasna hijerarhija prioriteta
- **striktna** — ne ostavlja prostor za tumačenje

Primer strukture:

```markdown
# IDENTITET
Ti si [uloga]. Tvoja misija je [cilj].

# PRAVILA (NIKAD ne krši)
1. Pre svake akcije proveri [izvor]
2. Ne generiši izveštaj pre nego što [uslov]
3. Format odgovora: [specifikacija]

# ALATI
- [alat1]: koristi za [namenu]
- [alat2]: koristi za [namenu]

# ESKALACIJA
Ako ne znaš odgovor: [postupak]
```

### Korak 4: Konfiguracija memorije

Odlučiti šta agent treba da pamti i koliko dugo. Tri pitanja:
1. Da li treba da pamti između sesija? → Perzistentna memorija
2. Šta tačno treba da pamti? → Preferencije, lekcije, ili sve?
3. Gde se čuva? → Fajl, baza, RAG, Feature Group

### Korak 5: Testiranje i iteracija

Nikad agent ne radi savršeno iz prvog pokušaja. Proces je:

```
Napravi → Testiraj → Analiziraj greške → Popravi instrukciju → Ponovi
```

Posebno obratiti pažnju na:
- da li agent koristi prave alate u pravom trenutku
- da li preterano eskalira (pita korisnika za stvari koje bi trebalo da zna)
- da li „halucira" — izmišlja podatke umesto da prizna da ne zna

---

## 4. Arhitekturni obrasci za agente

### 4.1 ReAct (Reasoning + Acting)

Najčešći obrazac u produkciji. Agent se **smenjuje između razmišljanja i delovanja**:

```
Razmišljanje: "Treba mi lista faktura za mart 2026"
Akcija:       SQL_QUERY("SELECT * FROM fakture WHERE mesec = 3")
Opservacija:  [rezultat upita — 47 redova]
Razmišljanje: "Korisnik traži ukupan iznos, ne listu"
Akcija:       SQL_QUERY("SELECT SUM(iznos) FROM fakture WHERE mesec = 3")
Opservacija:  [1,234,567.89 RSD]
Odgovor:      "Ukupan iznos faktura za mart: 1.234.567,89 RSD"
```

Prednosti: jednostavno za implementaciju, transparentno razmišljanje.  
Mane: može da se „zaglavi" u petlji ili da napravi nepotreban broj koraka.

### 4.2 Plan-and-Execute

Za kompleksne zadatke sa 5+ koraka. Agent **prvo napravi plan, pa ga izvršava**:

```
Plan:
  1. Učitaj fakturu #1234
  2. Proveri stavke
  3. Uporedi sa magacinskim stanjem
  4. Generiši izveštaj o razlikama

Izvršavanje:
  Korak 1: [izvršen] ✅
  Korak 2: [izvršen] ✅
  Korak 3: [greška — nema pristupa magacinu]
  → Replaniranje: traži pristup → ponovi korak 3
```

Prednosti: bolji za duže zadatke, moguće preplaniranje.  
Mane: početni plan može biti pogrešan, replaniranje troši resurse.

### 4.3 Refleksija (Self-Reflection)

Agent evaluira sopstveni rad pre nego što ga isporuči:

```
[Uradi zadatak] → [Pregledaj rezultat] → [Da li je tačno?]
                                              ↓ NE
                                         [Popravi] → [Ponovi pregled]
```

Koristi se kad su greške skupe ili kad je kvalitet kritičan.

---

## 5. Memorija — kako agent pamti

Ovo je jedan od najvažnijih i najslabijih delova većine agenata. Memorija ima četiri nivoa:

### 5.1 Radna memorija (kontekstni prozor)

To je „RAM" agenta — prostor u koji staje trenutna konverzacija plus instrukcije. Ograničen je veličinom kontekstnog prozora modela (128K–1M tokena). Sve što agent zna u datom trenutku mora stati ovde.

**Problem:** Kada se prozor napuni, ranije informacije se gube ili degradiraju kvalitet odgovora (poznat kao „lost in the middle" efekat).

### 5.2 Kratkoročna memorija (istorija sesije)

Zapisi unutar jedne sesije — prethodne poruke, rezultati alata, međurezultati. Nestaje kad se sesija završi.

### 5.3 Dugoročna memorija (perzistentna)

Čuva se **van kontekstnog prozora**, u spoljnom skladištu. Omogućava agentu da pamti između sesija. Implementacije:

| Metod | Kako radi | Najbolje za |
|-------|-----------|-------------|
| RAG (Retrieval-Augmented Generation) | Vektorska pretraga dokumenata | Veliki korpus znanja |
| Knowledge Graph | Struktuirani graf entiteta i relacija | Složene veze između podataka |
| Key-Value Store | Ključ → vrednost | Korisničke preferencije, podešavanja |
| Feature Groups (Abacus) | Struktuirane tabele | Istorijski i tabelarni podaci |
| Fajl sistem | JSON/MD fajlovi u agentDir | Jednostavni zapisi |
| Claw memorija (Abacus) | Perzistentni fajlovi u Cloud Computer-u | Agenti koji rade 24/7 |

### 5.4 Proceduralna memorija

Naučeni obrasci ponašanja — ne šta agent zna, već **kako se ponaša**. Primer: „Kad korisnik kaže 'napravi analizu', prvo pitaj bota za format, pa tek onda generiši."

### Ključna lekcija o memoriji

Memorija nije samo skladištenje — podjednako je važno **šta se pamti, kako se pretražuje, i kada se zaboravlja**. Loša memorija je gora od nikakve jer generiše šum koji zagađuje kontekst.

---

## 6. Multiagentna struktura — podela zadataka

Multiagentni sistem se koristi kad je zadatak **prevelik ili preraznovrstan za jednog agenta**. Umesto jednog „sveznajućeg" agenta, pravi se tim specijalizovanih agenata koji sarađuju.

### 6.1 Zašto više agenata?

| Problem jednog agenta | Rešenje sa više agenata |
|----------------------|------------------------|
| Preopširna instrukcija | Svaki agent ima fokusiranu instrukciju |
| Previše alata → konfuzija | Svaki agent ima samo svoje alate |
| Gubitak konteksta na dugim zadacima | Zadatak se deli na kraće podzadatke |
| Jedna greška kvari sve | Izolacija — greška u jednom agentu ne utiče na druge |
| Sporo — sve sekvencijalno | Paralelizacija — više agenata radi istovremeno |

### 6.2 Uloge u multiagentnom sistemu

Tipičan multiagentni tim:

```
┌─────────────────────────────────────────┐
│            KOORDINATOR                  │
│  (prima zadatak, deli ga, prati)        │
├─────────┬──────────┬───────────┬────────┤
│ PLANER  │IZVRŠILAC │ISTRAŽIVAČ │REVIEWER│
│ (pravi  │(izvršava │(pretražuje│(prover-│
│  plan)  │ korake)  │ izvore)   │ ava)   │
└─────────┴──────────┴───────────┴────────┘
```

Svaka uloga može biti poseban agent sa sopstvenom instrukcijom, alatima i memorijom.

### 6.3 Kako se dele zadaci

Postoje tri osnovna pristupa:

**a) Statička podela** — unapred definisani tokovi

```yaml
Korisnik pita o bazi → Agent za bazu
Korisnik pita o dokumentima → Agent za dokumente
Korisnik traži izveštaj → Agent za izveštaje
```

Jednostavno, predvidivo, ali nefleksibilno.

**b) Dinamička podela** — koordinator odlučuje u realnom vremenu

```
Korisnik: "Uporedi prošlogodišnje fakture sa ovogodišnjim i napravi grafikon"

Koordinator razmišlja:
  → Podzadatak 1: Izvuci fakture za 2025 → Agent za bazu
  → Podzadatak 2: Izvuci fakture za 2026 → Agent za bazu (paralelno)
  → Podzadatak 3: Napravi grafikon → Agent za vizualizaciju (čeka 1 i 2)
  → Podzadatak 4: Sastavi izveštaj → Agent za formatiranje
```

Fleksibilno, ali koordinator mora biti dovoljno pametan.

**c) Handoff (predaja)** — agent predaje drugom agentu

Agent A radi dok ne naiđe na nešto van svog domena, pa „preda" konverzaciju Agentu B sa celim kontekstom. Kao kad te u banci upute na drugog šaltera.

```python
# OpenAI Agents SDK — primer handoff-a
triage_agent = Agent(
    name="Triage",
    instructions="Klasifikuj upit i prosledi odgovarajućem agentu",
    handoffs=[agent_za_bazu, agent_za_dokumente, agent_za_analizu]
)
```

---

## 7. Obrasci orkestracije

### 7.1 Hijerarhijski (Supervisor/Worker)

```
        ┌──────────┐
        │SUPERVISOR│  ← prima zadatak, deli, sintetiše
        └────┬─────┘
     ┌───────┼───────┐
     ▼       ▼       ▼
  ┌─────┐ ┌─────┐ ┌─────┐
  │  W1 │ │  W2 │ │  W3 │  ← izvršavaju podzadatke
  └─────┘ └─────┘ └─────┘
```

- Supervisor dekompozuje zadatak i delegira worker-ima
- Worker-i rade nezavisno i vraćaju rezultat
- Supervisor sintetiše krajnji odgovor

**Kada koristiti:** kompleksni zadaci sa jasnom podelom, potrebna centralna kontrola.  
**Rizik:** supervisor može postati usko grlo (bottleneck).

### 7.2 Hub-and-Spoke

```
            ┌─────┐
     ┌──────┤ HUB ├──────┐
     │      └──┬──┘      │
     ▼         ▼         ▼
  ┌─────┐  ┌─────┐  ┌─────┐
  │  S1 │  │  S2 │  │  S3 │
  └─────┘  └─────┘  └─────┘
```

Hub upravlja svim porukama, rutira upite ka odgovarajućem spoke agentu. Spoke agenti ne komuniciraju međusobno — sva komunikacija ide kroz hub.

**Kada koristiti:** kad treba routing po temama/domenima, multi-tenant okruženja.

### 7.3 Pipeline (sekvencijalni)

```
  ┌────┐    ┌────┐    ┌────┐    ┌────┐
  │ A1 │───▶│ A2 │───▶│ A3 │───▶│ A4 │
  └────┘    └────┘    └────┘    └────┘
  Prikupi   Analiziraj Formatiraj Dostavi
```

Svaki agent obradi svoj deo i prosledi rezultat sledećem. Kao na pokretnoj traci.

**Kada koristiti:** dokument processing, ETL pipeline-ovi, revizija koda.

### 7.4 Peer-to-Peer (Mesh)

```
  ┌────┐ ◄──► ┌────┐
  │ A1 │      │ A2 │
  └────┘ ◄──► └────┘
     ▲           ▲
     │           │
     ▼           ▼
  ┌────┐ ◄──► ┌────┐
  │ A3 │      │ A4 │
  └────┘      └────┘
```

Agenti komuniciraju direktno, bez centralnog koordinatora. Otporno na padove, ali teško za debagovanje.

**Kada koristiti:** distribuirani sistemi, otpornost na greške.

### 7.5 Event-Driven (Pub/Sub)

```
  A1 ─publish→ [Message Broker] ─subscribe→ A2
  A3 ─publish→ [Message Broker] ─subscribe→ A4
```

Agenti objavljuju i pretplaćuju se na događaje kroz posrednika (message broker). Skalabilno, labavo spregnuto.

**Kada koristiti:** visok obim, real-time obrada, sistemi sa mnogo agenata.

---

## 8. Alati i frejmvorci

### 8.1 OpenAI Agents SDK

- **Filozofija:** minimalne apstrakcije, pet primitiva (Agent, Tool, Handoff, Guardrail, Tracing)
- **Posebno dobar za:** handoff obrasce (trijažni agent → specijalisti)
- **Prednost:** zero-config tracing u OpenAI Dashboard-u, najjednostavniji setup

```python
from agents import Agent, Runner

agent = Agent(
    name="Analizator",
    instructions="Analiziraj SQL bazu i odgovori na pitanja",
    tools=[sql_tool, chart_tool]
)

result = Runner.run_sync(agent, "Koji je ukupan promet za mart?")
```

### 8.2 LangGraph

- **Filozofija:** workflow kao usmereni graf — čvorovi su akcije, ivice su prelazi
- **Posebno dobar za:** kompleksne workflow-ove sa uslovima, petljama, checkpoint-ima
- **Prednost:** precizna kontrola toka izvršavanja, state persistence

### 8.3 CrewAI

- **Filozofija:** agenti kao članovi tima sa ulogama, backstory-jem i ciljevima
- **Posebno dobar za:** brzo prototipovanje, role-based timovi
- **Prednost:** najmanji barrier to entry, YAML konfiguracija

```python
from crewai import Agent, Task, Crew

researcher = Agent(role="Istraživač", goal="Pronađi relevantne podatke")
analyst = Agent(role="Analitičar", goal="Analiziraj i zaključi")

crew = Crew(agents=[researcher, analyst], tasks=[...])
crew.kickoff()
```

### 8.4 AutoGen (Microsoft)

- **Filozofija:** agenti kao učesnici u konverzaciji, event-driven
- **Posebno dobar za:** istraživačke zadatke, konverzacijske obrasce
- **Prednost:** fleksibilnost, async arhitektura

### 8.5 Abacus AI (Claw + DeepAgent)

- **Filozofija:** managed platforma — agenti sa Cloud Computer-om, perzistentnom memorijom, multi-channel pristupom
- **Posebno dobar za:** 24/7 agente, integraciju sa Slack/Telegram/WhatsApp
- **Prednost:** nije potrebna infrastruktura, Abacus Claw čuva memoriju trajno

---

## 9. Primenljivost na naš sistem (Abacus + Claw)

Na osnovu postojeće infrastrukture (`chatbots/registry.json`, DeepAgent sesije, Claw Meta-Bot) i dosadašnjeg rada, evo kako se gore opisani principi mapiraju na naš konkretan slučaj.

### 9.1 Trenutna arhitektura

```
Korisnik
    ↓
DeepAgent (Cursor / Abacus)
    ↓
[Izvršavanje zadatka]
    ↓
Rezultat → korisnik
```

**Problem:** svaka sesija počinje od nule. Agent ne zna šta je prethodni agent naučio, niti koje su korisnikove preferencije.

### 9.2 Ciljna arhitektura (multiagentna)

```
Korisnik
    ↓
Claw Meta-Bot (Domaćin) ← 24/7, perzistentna memorija
    ├── Čuva: preferencije, lekcije, pravila, istoriju
    ├── Klasifikuje: tip zadatka, potreban agent
    ├── Rutira: prosleđuje odgovarajućem agentu
    │
    ├──→ DeepAgent (izvršilac) ← kompleksni zadaci
    │        ├── [UPIT_BOTU] → pita Claw za kontekst pre akcije
    │        └── [LOG_SESIJE] → šalje log po završetku
    │
    ├──→ BizniSoft Specialist ← baza podataka
    │
    ├──→ Dokument Agent ← analiza dokumenata
    │
    └──→ Izveštaj Agent ← formatiranje i isporuka
```

### 9.3 Ključni principi za naš sistem

1. **Memorija živi kod Claw-a**, ne kod agenta. Agent pita Claw-a pre nego što pita korisnika.
2. **Instrukcije su kratke** — detalji su kod Claw-a, agent dobija samo esencijalno.
3. **Logovi se parsiraju** — svaka interakcija se automatski analizira i izvlači se znanje.
4. **Korisnik se pita što manje** — Claw postepeno uči preferencije i preuzima ulogu „objašnjivača".
5. **Svaki agent ima usku specijalnost** — bolje tri fokusirana agenta nego jedan generalni.

### 9.4 Tehnički sloj (Abacus SDK)

Komunikacija agent → Claw:

```python
import abacusai
client = abacusai.ApiClient()
response = client.get_chat_response(
    deployment_token="[TOKEN]",
    deployment_id="8986a1a12",  # Claw Meta-Bot
    messages=[{
        "is_user": True,
        "text": "[UPIT_BOTU] Korisnik traži analizu faktura. Koji format? Koja pravila?"
    }]
)
```

Claw → agent (odgovor sa kontekstom):

```json
{
  "type": "ODGOVOR_BOTA",
  "preferencije": {
    "format_brojeva": "1.234.567,89",
    "jezik": "srpski",
    "stil_izveštaja": "kratak, bez uvoda"
  },
  "pravila": [
    "Ne agregiraj bez eksplicitnog zahteva",
    "Prikaži originalne podatke, pa tek onda zaključak"
  ]
}
```

---

## Rezime

| Pitanje | Odgovor |
|---------|---------|
| Šta je agent? | LLM + alati + memorija + instrukcije, u petlji dok ne završi cilj |
| Kako se pravi? | Definiši misiju → izaberi alate → napiši instrukciju → konfiguriši memoriju → testiraj |
| Šta je multiagentna struktura? | Tim specijalizovanih agenata koji dele zadatke |
| Kako se dele zadaci? | Statički (routing), dinamički (koordinator deli), ili handoff (predaja) |
| Koji obrazac koristiti? | Hijerarhijski za kontrolu, Pipeline za sekvencijalne tokove, Hub-and-Spoke za routing |
| Koji frejmvork? | Zavisi od potreba — OpenAI SDK za handoff, LangGraph za workflow, CrewAI za brzo, Abacus Claw za 24/7 |
| Kako mi to koristimo? | Claw kao domaćin sa memorijom, DeepAgent kao izvršilac, specijalizovani botovi po domenima |

---

## Izvori

- [AI Agent Architecture Patterns: 6 Designs That Work in Production (2026)](https://dev.to/paxrel/ai-agent-architecture-patterns-6-designs-that-work-in-production-2026-1f0h)
- [How to Build AI Agents in 2026: The Complete Guide](https://amirbrooks.com.au/guides/how-to-build-ai-agents-2026-complete-guide)
- [Multi-Agent Orchestration Patterns (2026)](https://amirbrooks.com.au/guides/multi-agent-orchestration-patterns)
- [AI Agent Memory: How Agents Remember, Learn & Persist Context](https://dev.to/paxrel/ai-agent-memory-how-agents-remember-learn-amp-persist-context-2026-guide-48dn)
- [OpenAI Agents SDK](https://openai.github.io/openai-agents-python)
- [LangGraph vs CrewAI vs AutoGen: Choosing an Agent Framework in 2026](https://yoyo.bot/blog/langgraph-vs-crewai-vs-autogen-2026)
- [Abacus AI / OpenClaw dokumentacija](https://docs.abacus.ai)
- Interno: `chatbots/registry.json`, `Nova_Struktura_abacus.txt`, DeepAgent sesija 2026-04-01
