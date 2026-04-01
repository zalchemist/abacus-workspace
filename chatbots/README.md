# Chatbot Registry

Centralni registar svih chatbotova dostupnih DeepAgent-u.

## Kako koristiti

Agent može da:
1. Pročita `registry.json` za listu svih chatbotova
2. Odabere odgovarajući chatbot prema temi
3. Pozove API sa odgovarajućim credentials


## Lokalna tajna konfiguracija

Versioned fajlovi vise ne sadrze deployment tokene. Lokalno napravi `chatbots/local_secrets.json` na osnovu `chatbots/local_secrets.example.json` i nikada ga nemoj commit-ovati.

## Dostupni chatbotovi

| Naziv | Tema | Deployment ID |
|-------|------|---------------|
| GitHub Workspace Assistant | Biznisoft MySQL, Git operacije | 14e982c370 |
| Abacus Knowledge Brain | Abacus.AI platforma, API | 1127df3f3a |

## API poziv

```python
import json
from pathlib import Path
from abacusai import ApiClient

local_secrets = json.loads(Path('chatbots/local_secrets.json').read_text())
client = ApiClient(api_key="<API_KEY>")
response = client.get_chat_response(
    deployment_token=local_secrets['<BOT_ID>']['deployment_token'],
    deployment_id='<ID_IZ_REGISTRY>',
    messages=[{'is_user': True, 'text': 'Pitanje'}]
)
```
