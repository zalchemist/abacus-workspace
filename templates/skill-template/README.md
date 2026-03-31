# Šablon za nove skills

Ovaj folder služi kao šablon za kreiranje novih AI skills-a.

## Struktura skill-a

```
skill-name-vX/
├── SKILL.md            # Glavna definicija skill-a
├── SKILL.pdf           # PDF verzija za distribuciju
├── knowledge/          # Baza znanja skill-a
├── references/         # Reference i dokumentacija
├── examples/           # Primeri korišćenja
├── scripts/            # Pomoćne skripte
└── learning/           # Iterativno učenje
```

## SKILL.md struktura

```yaml
---
name: skill-name-vX
description: >-
  Kratak opis šta skill radi i kada se aktivira.
allowed-tools:
  - FileRead
  - FileWrite
  - Bash
---

## Svrha skill-a
...

## Workflow
...

## Pravila
...
```

## Konvencije

- Naziv: kebab-case sa verzijom (npr. `moj-skill-v1`)
- Verzionisanje: vX gde je X broj verzije
- Jezik: srpski za komunikaciju, engleski za tehničke termine
- Registracija: dodaj u SKILL-INDEX.md i skills-registry.json
