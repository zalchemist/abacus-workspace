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
10. [Cursor kao platforma za agente](#10-cursor-kao-platforma-za-agente)

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

---

## 10. Cursor kao platforma za agente

Da — u Cursor-u **mogu da se prave i koriste agenti**. Cursor nije samo editor koda — on je platforma sa ugrađenim agentskim sistemom koji uključuje lokalne agente, cloud agente, subagente i automatizacije.

### 10.1 Šta Cursor nudi za agente

| Komponenta | Šta radi | Gde se konfiguriše |
|------------|----------|-------------------|
| **Agent Mode** | Autonomno izvršavanje zadataka (fajlovi, terminal, codebase) | Composer panel → Agent mode |
| **Rules** | Stalna uputstva za ponašanje agenta | `.cursor/rules/` (`.mdc` fajlovi) |
| **AGENTS.md** | Markdown instrukcija za agenta na nivou projekta | Root repozitorijuma |
| **Skills** | Dinamička znanja — učitavaju se samo kad trebaju | `SKILL.md` fajlovi |
| **MCP (Model Context Protocol)** | Povezivanje sa eksternim servisima | `.cursor/mcp.json` |
| **Subagenti** | Specijalizovani pod-agenti za specifične zadatke | Ugrađeni + `.cursor/agents/` |
| **Cloud Agenti** | Autonomni agenti u oblaku koji rade u pozadini | Cursor Dashboard |
| **Automacije** | Agenti pokretani triggerima (cron, GitHub, Slack, webhook) | Cursor Dashboard |

### 10.2 Šta je neophodno imati operativno

#### Minimum (lokalni Agent Mode)

Za osnovni rad sa agentom u Cursor-u:

| Zahtev | Detalj |
|--------|--------|
| **Cursor Pro ili Business plan** | Agent mode zahteva plaćenu pretplatu |
| **Repozitorijum** | Agent radi nad kodom u otvorenom projektu |
| **Uključen Agent Mode** | Settings → Features → Agent → Enable |
| **Auto-run terminal** | Settings → Features → Agent → Auto-run terminal commands |

Ovo je dovoljno da agent čita fajlove, piše kod, izvršava komande i iterira dok ne završi zadatak.

#### Za Cloud Agente (pozadinski rad)

| Zahtev | Detalj |
|--------|--------|
| **GitHub konekcija** | Repozitorijum mora biti na GitHub-u |
| **Pro ili Business plan** | Cloud agenti su premium funkcionalnost |
| **AGENTS.md** | Instrukcije za agenta koji radi bez tvog prisustva |
| **Secreti** | Cursor Dashboard → Cloud Agents → Secrets (za API ključeve, tokene) |

Cloud agent klonira tvoj repo, radi autonomno u sandbox-u, i kreira Pull Request sa rezultatima.

#### Za MCP integracije (eksterni alati)

| Zahtev | Detalj |
|--------|--------|
| **`.cursor/mcp.json`** | Konfiguracija MCP servera u projektu |
| **API ključevi/tokeni** | Za svaki servis koji povezuješ |
| **MCP server** | Lokalni (npx komanda) ili remote (URL) |

Primer MCP konfiguracije:

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server"],
      "env": {
        "SUPABASE_URL": "https://xxx.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "tvoj-ključ"
      }
    },
    "slack": {
      "url": "https://mcp.slack.com/sse",
      "headers": {
        "Authorization": "Bearer tvoj-slack-token"
      }
    }
  }
}
```

#### Za automatizacije (always-on agenti)

| Zahtev | Detalj |
|--------|--------|
| **Business plan** | Automatizacije su enterprise funkcionalnost |
| **Trigger konfiguracija** | Cron raspored, GitHub event, Slack poruka, webhook, ili Linear event |
| **MCP serveri** | Konfigurisani u Cloud Agents Dashboard-u |

### 10.3 Cursor-ov multiagentni sistem (subagenti)

Cursor ima ugrađen multiagentni sistem — **glavni agent** može da pokrene **subagente** za specifične zadatke:

```
┌──────────────────────────────────────┐
│          GLAVNI AGENT                │
│  (prima tvoj zahtev, planira, deli)  │
├──────────┬───────────┬───────────────┤
│ Explore  │   Bash    │   Browser     │
│ subagent │ subagent  │   subagent    │
│          │           │               │
│ Pretražu-│ Izvršava  │ Kontroliše   │
│ je code- │ niz shell │ browser za   │
│ base     │ komandi   │ testiranje   │
└──────────┴───────────┴───────────────┘
```

**Tri ugrađena subagenta:**

| Subagent | Namena | Kako radi |
|----------|--------|-----------|
| **Explore** | Brza pretraga codebase-a | Koristi brži model, 10x paralelnih pretraga |
| **Bash** | Izvršavanje shell komandi | Izoluje verbose output od glavnog agenta |
| **Browser** | Testiranje UI-ja | Kontroliše Chrome, pravi screenshot-ove |

Ovi subagenti rade u **izolovanom kontekstnom prozoru** — njihov međurezultat ne zagađuje kontekst glavnog agenta. Glavni agent vidi samo finalni sumarni odgovor.

#### Prilagođeni (custom) subagenti

Mogu se praviti kao Markdown fajlovi sa YAML frontmatter-om:

- **Projektni:** `.cursor/agents/moj-agent.md`
- **Globalni:** `~/.cursor/agents/moj-agent.md`

### 10.4 Rules — kako se „programira" ponašanje agenta

Cursor koristi sistem pravila (Rules) koji funkcioniše kao **system prompt za agenta**. Pravila se čuvaju u `.cursor/rules/` folderu kao `.mdc` fajlovi.

#### Tipovi pravila po načinu primene

| Tip | Kada se primenjuje | Primer upotrebe |
|-----|-------------------|-----------------|
| **Always Apply** | U svakoj konverzaciji | Konvencije kodiranja, stil |
| **Apply Intelligently** | Kad agent proceni da je relevantno | Domensko znanje |
| **Apply to Files** | Samo za specifične fajlove (glob pattern) | `*.sql` → SQL konvencije |
| **Apply Manually** | Samo kad se eksplicitno pozove sa `@` | Retko korišćene procedure |

#### Hijerarhija prioriteta

```
1. Team Rules            (najviši prioritet)
2. Project Rules         (.cursor/rules/)
3. User Rules            (globalna podešavanja)
4. Legacy Rules          (.cursorrules)
5. AGENTS.md             (najniži prioritet)
```

#### Primer `.cursor/rules/sql-konvencije.mdc`

```markdown
---
description: Pravila za rad sa SQL-om u BizniSoft bazi
globs: ["*.sql", "**/*.sql"]
alwaysApply: false
---

# SQL konvencije

- Koristi `sudo mysql -u root` za pristup bazi
- Baze: `opp` (master/šifarnici), `opp7102025` (transakcije)
- Cross-database JOIN: `opp.tabela` JOIN `opp7102025.tabela`
- Uvek koristi utf8mb4 charset
- Datumi: FORMAT(datum, '%d.%m.%Y')
```

### 10.5 AGENTS.md — uputstvo za cloud agente

`AGENTS.md` u root-u repozitorijuma je **instrukcija koju cloud agent čita pre nego što počne da radi**. Koristi se kad agent radi autonomno u pozadini (bez tvog prisustva).

Naš `AGENTS.md` već sadrži:
- kako pokrenuti MariaDB (non-systemd)
- arhitekturu baza (`opp`, `opp7102025`)
- ključne skripte
- napomenu o performansama

Ovo znači da kad Cloud Agent dobije zadatak vezan za naš repo, on **zna** kako da se poveže na bazu i gde su skripte, bez da mu ti to objašnjavaš.

### 10.6 Automatizacije — agenti koji rade bez tebe

Cursor Automations su agenti koji se pokreću na osnovu trigera:

| Trigger | Primer |
|---------|--------|
| **Cron** | Svakog ponedeljka proveri dependency-je |
| **GitHub PR otvoren** | Automatski review koda |
| **GitHub push** | Pokreni lint/test suite |
| **Slack poruka** | Nova poruka u kanalu → agent reaguje |
| **Webhook** | Eksterni sistem pošalje HTTP zahtev |
| **Linear issue** | Kreiran task → agent počinje implementaciju |

Svaka automatizacija radi u **izolovanom sandbox-u** — klonira repo, uradi posao, i rezultat ostavi za tvoj pregled. Ne može direktno da zapiše u produkciju.

### 10.7 Kompletna operativna lista za pokretanje

```
┌─────────────────────────────────────────────────────────┐
│            OPERATIVNA CHECKLIST                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  OBAVEZNO (za bilo koji agent rad):                     │
│  ☐ Cursor Pro ili Business pretplata                    │
│  ☐ Agent Mode uključen u Settings                      │
│  ☐ Repozitorijum otvoren u Cursor-u                    │
│                                                         │
│  ZA PRILAGOĐAVANJE AGENTA:                              │
│  ☐ .cursor/rules/ folder sa .mdc pravilima              │
│  ☐ AGENTS.md u root-u repozitorijuma                    │
│  ☐ SKILL.md fajlovi za domensko znanje (opciono)        │
│                                                         │
│  ZA CLOUD AGENTE:                                       │
│  ☐ GitHub repozitorijum (povezan sa Cursor-om)          │
│  ☐ Secrets konfigurisani u Cursor Dashboard-u           │
│  ☐ AGENTS.md sa uputstvima za autonoman rad             │
│                                                         │
│  ZA EKSTERNE INTEGRACIJE (MCP):                         │
│  ☐ .cursor/mcp.json sa serverskim konfiguracijama       │
│  ☐ API ključevi / tokeni za svaki servis                │
│  ☐ MCP serveri instalirani (npx) ili dostupni (URL)     │
│                                                         │
│  ZA AUTOMATIZACIJE:                                     │
│  ☐ Business plan                                        │
│  ☐ Trigger konfiguracija (cron/GitHub/Slack/webhook)     │
│  ☐ MCP serveri u Cloud Agents Dashboard-u               │
│                                                         │
│  ZA SUBAGENTE (CUSTOM):                                 │
│  ☐ .cursor/agents/ folder sa .md definicijama           │
│  ☐ YAML frontmatter sa konfiguracijom                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
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
| Može li u Cursor-u? | Da — Agent Mode, Cloud Agenti, subagenti, MCP integracije, automatizacije |
| Šta je operativno neophodno? | Cursor Pro/Business + repo + Rules/AGENTS.md + MCP za integracije + Secrets za cloud agente |

---

## Izvori

- [AI Agent Architecture Patterns: 6 Designs That Work in Production (2026)](https://dev.to/paxrel/ai-agent-architecture-patterns-6-designs-that-work-in-production-2026-1f0h)
- [How to Build AI Agents in 2026: The Complete Guide](https://amirbrooks.com.au/guides/how-to-build-ai-agents-2026-complete-guide)
- [Multi-Agent Orchestration Patterns (2026)](https://amirbrooks.com.au/guides/multi-agent-orchestration-patterns)
- [AI Agent Memory: How Agents Remember, Learn & Persist Context](https://dev.to/paxrel/ai-agent-memory-how-agents-remember-learn-amp-persist-context-2026-guide-48dn)
- [OpenAI Agents SDK](https://openai.github.io/openai-agents-python)
- [LangGraph vs CrewAI vs AutoGen: Choosing an Agent Framework in 2026](https://yoyo.bot/blog/langgraph-vs-crewai-vs-autogen-2026)
- [Abacus AI / OpenClaw dokumentacija](https://docs.abacus.ai)
- [Cursor — Customizing Agents](https://cursor.com/learn/customizing-agents)
- [Cursor — Subagents](https://cursor.com/docs/agent/subagents)
- [Cursor — Rules](https://cursor.com/help/customization/rules)
- [Cursor — MCP Integrations](https://cursor.com/help/customization/mcp)
- [Cursor — Automations](https://cursor.com/docs/cloud-agent/automations)
- [Cursor — Cloud Agents](https://cursor.com/help/ai-features/cloud-agents)
- Interno: `chatbots/registry.json`, `Nova_Struktura_abacus.txt`, `AGENTS.md`, DeepAgent sesija 2026-04-01
