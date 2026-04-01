# BizniSoft SQL Agent

## Osnovne informacije
- **ID:** biznisoft-sql-agent
- **Model:** Claude V4.5 Sonnet
- **Status:** Pending deployment
- **Deployment ID:** *(dodeliti pri kreiranju na Abacus.AI)*
- **Deployment Token:** *(dodeliti pri kreiranju na Abacus.AI)*

## Namena

Operativni agent za direktan rad sa BizniSoft ERP bazom podataka. Sposoban da:

1. **Analizira SQL tabele** — prepoznaje strukturu, sadržaj i relacije BizniSoft šifarnika i transakcionih tabela
2. **Izvršava korisničke naloge** — prima zadatke u prirodnom jeziku i prevodi ih u SQL operacije
3. **Implementuje softverska rešenja** — definiše šifarnike, uspostavlja pravila i podešavanja prema korisnikovom planu
4. **Radi direktno u bazi** — INSERT, UPDATE, DELETE, DDL prema verifikovanom planu

## Arhitektura

```
Korisnik → [Plan/Nalog] → Agent → [Analiza tabela] → [SQL operacije] → Baza
                                                    ↕
                                        Knowledge Base (BizniSoft referenca)
```

## Kapaciteti

### Šifarnici i konfiguracija
- Definisanje novih stavki u šifarnicima (kupci, dobavljači, artikli, cenovnici)
- Podešavanje tipova dokumenata i poslovnih pravila
- Upravljanje kontnim planom i PDV kategorijama
- Konfiguracija magacina, lokacija i organizacionih jedinica

### Analiza i izveštavanje
- Analiza integriteta podataka (referentni integritet, storno parovi, finansijska ravnoteža)
- Pregled sadržaja šifarnika i transakcionih tabela
- Dijagnoza grešaka u importovanim dump fajlovima
- Cross-database JOIN-ovi između `opp` i `oppXXXYYYY`

### Direktne SQL operacije
- Backup tabele pre svake izmene (UVEK)
- Provera trigera pre UPDATE/DELETE operacija
- Izvršavanje operacija sa verifikacijom rezultata
- Rollback u slučaju greške

## Baza znanja (Knowledge Base)

Agent koristi sledeće dokumente:

| Dokument | Opis |
|----------|------|
| `BIZNISOFT_MASTER_REFERENCE.md` | Kompletna referenca sistema |
| `biznisoft_tables_reference.md` | Struktura 116 transakcionih tabela |
| `biznisoft_opp_tables_reference.md` | Struktura 38 šifarničkih tabela |
| `biznisoft_opp_sifarnici.md` | Sadržaj 33 šifarnika |
| `biznisoft_triggers.md` | 265 trigera — OBAVEZNO pre izmena |
| `biznisoft_stored_procedures.md` | 105 stored procedura |
| `biznisoft_functions.md` | 44 funkcije (FIFO, PDV, NBC) |
| `implicit_relations.md` | Relacije između tabela bez FK |
| `storno_patterns.md` | Logika storniranja |

## DeepAgent protokol

### [DEEP_AGENT_QUERY] — Početak sesije
```
[DEEP_AGENT_QUERY]
Baza: opp7102025
Zadatak: Definisanje novih kupaca u šifarniku
```

### [DEEP_AGENT_REPORT] — Kraj sesije
```
[DEEP_AGENT_REPORT]
Izvršeno: INSERT u tabelu kupci (5 novih stavki)
Backup: kupci_backup_20260401
Status: OK
```

### [DEEP_AGENT_UPDATE] — Tokom sesije
```
[DEEP_AGENT_UPDATE]
Korak 2/5: Analiza postojećih kupaca završena
Pronađeno: 142 aktivnih kupaca
Sledeće: Priprema INSERT naredbi
```

## Tok rada (Workflow)

```
1. Prijem naloga od korisnika
        ↓
2. Analiza relevantnih tabela
        ↓
3. Prezentacija plana korisniku (OBAVEZNO pre izvršenja)
        ↓
4. Čekanje potvrde
        ↓
5. Backup tabele (UVEK pre izmene)
        ↓
6. Provera trigera
        ↓
7. Izvršavanje SQL operacija
        ↓
8. Verifikacija rezultata
        ↓
9. Izveštaj korisniku
```

## Primer korišćenja

```python
from abacusai import ApiClient

client = ApiClient(api_key="<API_KEY>")
response = client.get_chat_response(
    deployment_token='<TOKEN>',
    deployment_id='<ID>',
    messages=[{
        'is_user': True,
        'text': '''[DEEP_AGENT_QUERY]
Baza: opp7102025
Zadatak: Dodaj novog kupca "Firma d.o.o." sa PIB 123456789,
         adresa: Beograd, Nemanjina 1,
         tip: domaće pravno lice'''
    }]
)
print(response.content)
```

## Sigurnosna pravila

- ❌ Nikad bez backup-a pre izmene
- ❌ Nikad bez provere trigera
- ❌ Nikad bez potvrde korisnika za destruktivne operacije
- ✅ Uvek prezentuj plan pre izvršenja
- ✅ Uvek verifikuj rezultat posle izvršenja
- ✅ Uvek loguj svaku operaciju

## Kreiranje na Abacus.AI

### Konfiguracija
- **Agent Type:** DeepAgent (Custom LLM Agent)
- **Model:** Claude V4.5 Sonnet
- **Tools:** Code Tool (za SQL izvršavanje), Git Tool (za verzionisanje)
- **Knowledge Base:** Uploadovati sve fajlove iz `projects/biznisoft_skill_input/knowledge/`
- **System Prompt:** Videti `system-prompt.md` u ovom folderu

### Koraci
1. Otvoriti Abacus.AI konzolu
2. Kreirati novi DeepAgent
3. Uploadovati knowledge base fajlove
4. Podesiti system prompt iz `system-prompt.md`
5. Uključiti Code Tool i Git Tool
6. Deployovati i ažurirati `registry.json` sa dobijenim ID-ovima
