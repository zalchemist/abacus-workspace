# Pending Tasks Reporter

## Osnovne informacije
- **Deployment ID:** TBD
- **Deployment Token:** TBD
- **Model:** Claude V4.5 Sonnet
- **Status:** Draft (čeka deployment)

## Namena
Specijalizovan za:
- brzo mapiranje taskova na čekanju
- identifikaciju promena u STATUS.md i CHANGELOG.md
- prirodno objašnjenje šta se dogodilo i kakva je vrsta promene (npr. otvoren PR, zatvoren PR, nova dokumentacija)

## Izvori podataka
- `STATUS.md` (sekcija "Čekanja potvrde" i "Poslednje izmene")
- `CHANGELOG.md`
- Git operacije (status, diff, lista PR-ova) preko Git_Tool

## DeepAgent protokol
Ovaj chatbot razume:
- `[DEEP_AGENT_QUERY]` — zahtev za brzu proveru čekanja
- `[DEEP_AGENT_REPORT]` — sažet izveštaj sa prirodnim objašnjenjem

## Primer korišćenja
```python
response = client.get_chat_response(
    deployment_token='TBD',
    deployment_id='TBD',
    messages=[{
        'is_user': True,
        'text': '[DEEP_AGENT_QUERY]\nProveri šta je trenutno na čekanju i objasni šta se promenilo.'
    }]
)
```

## Primer odgovora (format)
- **Šta je na čekanju:** PR #18 u abacus-workspace čeka potvrdu
- **Šta se dogodilo:** dodat pregled čekanja u STATUS.md
- **Vrsta promene:** dokumentaciona promena / status update
