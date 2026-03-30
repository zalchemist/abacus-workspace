# Lekcija: Pristup analizi finansijskih/robnih podataka

## Pogrešan pristup (agregacija i transpozicija)

Kada se analiziraju tabelarni podaci iz ERP sistema, IZBEGAVATI:

1. **Agregaciju** - "VD=KL ima 1250 redova, konta: 13401, 13441..."
2. **Transpoziciju** - rotiranje podataka u nove strukture
3. **Meta-tabele** - tabele O podacima umesto samih podataka
4. **Gubitak konteksta** - kada se iz agregata ne vidi originalna struktura

## Ispravan pristup (filtriranje i reprezentativni primeri)

1. **Originalna struktura** - zadržati kolone i redove kako su u izvoru
2. **Filtriranje** - umesto agregacije, filtrirati reprezentativne primere
3. **Celi nalozi** - nalog je CELINA, prikazati sve redove jednog naloga zajedno
4. **Vizuelno obeležavanje** - koristiti boje za označavanje (npr. robna konta) umesto posebnih sheetova
5. **Različiti tipovi** - ako ista VD ima različite kontne šeme, dati primer svake

## Primer: Analiza finansijskog knjigovodstva

### Pogrešno:
| VD | Konta | Broj_redova |
|----|-------|-------------|
| KL | 13401, 13441, 13451, 2700, 4320 | 1250 |

### Ispravno:
Originalna tabela finansijskog, filtrirano na:
- Jedan tipičan KL nalog (svi redovi tog naloga)
- Ako postoji KL sa drugačijom kontnom šemom, i taj nalog
- Robna konta (13xxx, 9xxx, 5013) obeležena bojom

## Ključno pravilo

**Nalog je celina.** Ako nalog ima BAR JEDNO robno konto, ceo nalog je "robni nalog" - svi redovi tog naloga čine jednu poslovnu transakciju.

## Datum
2026-03-30
