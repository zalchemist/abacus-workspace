# GitHub Workspace Assistant

## Osnovne informacije
- **Deployment ID:** 14e982c370
- **Deployment Token:** aa12e1f29bf945c8a5fa0ae203873ff2
- **Model:** Claude V4.5 Sonnet
- **Status:** Active

## Namena
Specijalizovan za:
- Biznisoft MySQL ERP baza
- SQL upiti i šeme tabela
- Git operacije

## DeepAgent protokol
Ovaj chatbot razume strukturirane poruke:

### [DEEP_AGENT_QUERY] - Početak sesije
Koristi za dobijanje konteksta pre rada.

### [DEEP_AGENT_REPORT] - Kraj sesije
Koristi za slanje izveštaja o završenoj sesiji.

### [DEEP_AGENT_UPDATE] - Tokom sesije
Koristi za slanje značajnih update-a.

## Primer korišćenja
```python
response = client.get_chat_response(
    deployment_token='aa12e1f29bf945c8a5fa0ae203873ff2',
    deployment_id='14e982c370',
    messages=[{
        'is_user': True,
        'text': '[DEEP_AGENT_QUERY]\nKorisnik traži: Analiza tabele FAKTURE'
    }]
)
```

## Ograničenja
- ❌ Nema Knowledge Base / Document Retriever
- ❌ Ne može trajno da čuva novo znanje (samo sesijska memorija)
