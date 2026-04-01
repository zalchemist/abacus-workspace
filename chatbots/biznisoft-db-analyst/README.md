# BizniSoft DB Analyst

## Osnovne informacije
- **ID:** biznisoft-db-analyst
- **Model:** Claude V4.5 Sonnet
- **Status:** Active
- **Agent fajl:** `.claude/agents/myCustom_agent.agent.md`

## Namena

Autonomni agent za rad sa BizniSoft ERP MySQL/MariaDB bazama podataka. Specijalizovan za:

- **Import dump-ova** — učitavanje `.sql` / `.sql.gz` fajlova iz BizniSofta i podešavanje baze
- **Analize i uvidi** — finansijski KPI-jevi, robni promet, kadrovska statistika, anomalije i rizici koji nisu vidljivi kroz standardni softver
- **SQL izvršavanje** — ad-hoc upiti, izveštaji, export u CSV/SQL
- **Izmena podataka** — direktan UPDATE/INSERT/DELETE uz backup i protokol potvrde
- **Preporuke za implementaciju** — instrukcije za softverska rešenja kroz direktne izmene u bazi

## Arhitektura BizniSoft baze

```
opp                 → Master baza (šifarnici, definicije)
opp{firma}{godina}  → Transakciona baza (dokumenti, transakcije)
                      Primer: opp7102025 = firma 710, godina 2025
```

## Pokretanje

Agent koristi MariaDB servis koji se pokreće komandom:

```bash
sudo mysqld_safe --user=mysql &
sleep 5
sudo mysqladmin ping
```

Sve MySQL komande koriste `sudo mysql -u root` (socket autentikacija, bez lozinke).

## Tipovi analiza

### Finansijske
- Promet po kontima (glavna knjiga)
- Top kupci/dobavljači po prometu
- Neizmirene obaveze i potraživanja
- PDV evidencija i POPDV usaglašenost

### Robno-trgovinske
- Stanje zaliha (uključujući negativne — anomalije)
- Promet artikala po periodu
- Kalkulacije i marže
- Popisne liste

### Anomalije i skriven rizici
- Duplikati u šifarnicima
- Fakture bez stavki ili plaćanja
- Neuparene e-fakture (SEF)
- Kašnjenja u plaćanjima > 30 dana

### Kadrovi i zarade
- Pregled zaposlenih i obračuna plata
- Doprinosi i porezi

## Protokol izmene podataka

1. Backup dotične tabele
2. Prikaz plana izmene (SELECT koji pokazuje šta će biti promenjeno)
3. Čekanje eksplicitne potvrde korisnika
4. Izvršenje uz transakciju (START TRANSACTION / COMMIT / ROLLBACK)
5. Verifikacioni upit nakon izmene

## DeepAgent protokol

Chatbot razume strukturirane poruke:

- `[DEEP_AGENT_QUERY]` — početak sesije, dobijanje konteksta
- `[DEEP_AGENT_REPORT]` — kraj sesije, slanje izveštaja
- `[DEEP_AGENT_UPDATE]` — tokom sesije, slanje značajnog update-a

## Primer korišćenja

```python
response = client.get_chat_response(
    deployment_token='<token>',
    deployment_id='<deployment_id>',
    messages=[{
        'is_user': True,
        'text': '[DEEP_AGENT_QUERY]\nAnaliza: Top 10 kupaca po prometu za 2025. godinu iz baze opp7102025'
    }]
)
```

## Napomene

- Uvek proverava da li MariaDB radi pre izvršavanja upita
- Koristi skripte iz `projects/biznisoft_skill_input/scripts/` za import i upravljanje bazom
- Referentna dokumentacija u `projects/biznisoft_skill_input/knowledge/`
