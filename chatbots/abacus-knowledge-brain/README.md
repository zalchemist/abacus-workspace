# Abacus Knowledge Brain

## Osnovne informacije
- **Deployment ID:** 1127df3f3a
- **Deployment Token:** 3f07cef6548d4c1c99925bb65c41a239
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
response = client.get_chat_response(
    deployment_token='3f07cef6548d4c1c99925bb65c41a239',
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
