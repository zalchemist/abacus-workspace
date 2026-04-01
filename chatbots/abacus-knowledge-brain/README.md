# Abacus Knowledge Brain

## Osnovne informacije
- **Deployment ID:** 1127df3f3a
- **Deployment Token:** cuva se lokalno u `chatbots/local_secrets.json` (nije versioned)
- **Model:** Claude V4.5 Sonnet
- **Document Retriever ID:** 1088ad145a
- **Status:** Active

## Namena
Ekspert za:
- Abacus.AI platforma
- API dokumentacija
- Chatbot konfiguracija
- Document Retrieveri i Feature Groups
- Deployment i integracije

## Knowledge Base
✅ Ima Document Retriever sa Abacus.AI dokumentacijom

## Primer korišćenja
```python
import json
from pathlib import Path

local_secrets = json.loads(Path('chatbots/local_secrets.json').read_text())

response = client.get_chat_response(
    deployment_token=local_secrets['abacus-knowledge-brain']['deployment_token'],
    deployment_id='1127df3f3a',
    messages=[{
        'is_user': True,
        'text': 'Kako da programatski dodam dokument u Feature Group?'
    }]
)
```

## Ograničenja
- ❌ Nema DeepAgent protokol ([DEEP_AGENT_QUERY] itd.)
- Može se dodati u budućnosti
