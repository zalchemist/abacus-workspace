# Chatbot Registry

Centralni registar svih chatbotova dostupnih DeepAgent-u.

## Kako koristiti

Agent može da:
1. Pročita `registry.json` za listu svih chatbotova
2. Odabere odgovarajući chatbot prema temi
3. Pozove API sa odgovarajućim credentials

## Dostupni chatbotovi

| Naziv | Tema | Deployment ID |
|-------|------|---------------|
| GitHub Workspace Assistant | Biznisoft MySQL, Git operacije | 14e982c370 |
| Abacus Knowledge Brain | Abacus.AI platforma, API | 1127df3f3a |
| Pending Tasks Reporter | Status čekanja, PR-ovi, promene | TBD |

## API poziv

```python
from abacusai import ApiClient

client = ApiClient(api_key="<API_KEY>")
response = client.get_chat_response(
    deployment_token='<TOKEN_IZ_REGISTRY>',
    deployment_id='<ID_IZ_REGISTRY>',
    messages=[{'is_user': True, 'text': 'Pitanje'}]
)
```
