# GitHub Workspace Assistant

## Osnovne informacije
- **Deployment ID:** 14e982c370
- **Deployment Token:** cuva se lokalno u `chatbots/local_secrets.json` (nije versioned)
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
import json
from pathlib import Path

local_secrets = json.loads(Path('chatbots/local_secrets.json').read_text())

response = client.get_chat_response(
    deployment_token=local_secrets['github-workspace-assistant']['deployment_token'],
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
