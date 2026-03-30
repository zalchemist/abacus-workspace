# Pravila analize baze podataka

## Baza: opp7102025 (Ševo Tim, godina 2025)

### Isključeni artikli iz analize

**1.108 artikala bez prometa u 2025. godini je ISKLJUČENO iz svih analiza.**

Razlog: Nemaju ni početno stanje ni promet - nisu relevantni za analizu tokova robe i materijala.

#### Implementacija:
- Pomoćna tabela: `tmp_aktivni_2025` sadrži 241 aktivnu šifru artikla
- Svaki upit na tabelu `robno` MORA filtrirati po ovoj tabeli:
```sql
WHERE sifra IN (SELECT sifra FROM tmp_aktivni_2025)
```

#### Aktivni artikli po tipu:
| Tip | Broj aktivnih |
|-----|---------------|
| Roba | 98 |
| Proizvod | 111 |
| Sirovina | 28 |
| Usluga | 4 |
| **UKUPNO** | **241** |

### Struktura tabele robno
- 33 kolone (detalji u /home/ubuntu/sql_queries/ANALIZA_ROBNO.md)
- Ključne kolone za analizu: ulaz, izlaz, duguje, potrazuje, nabavnacena, prodajnacena

---
*Poslednje ažuriranje: 30.03.2026*

#### Status implementacije:
✅ Tabela `tmp_aktivni_2025` KREIRANA (30.03.2026)
- 241 aktivna šifra artikla
- Baza: opp7102025
