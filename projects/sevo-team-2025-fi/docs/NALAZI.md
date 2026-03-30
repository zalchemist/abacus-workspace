# Ključni nalazi - Ševo Tim 2025

## 30.03.2026 - Inicijalna analiza

### Šifarnik artikala
- Ukupno 1.349 artikala u bazi
- Tip se određuje kolonama: jesirovina, jeproizvod, jeusluga (ako sve 0 = Roba)
- 241 artikal ima promet u 2025, ostali isključeni iz analize

### Početna stanja (01.01.2025)
- Ukupna vrednost: 87.661.872,09 RSD
- Dokumentovano pod tipom PST000

### Promene tipa artikla
- 08.02.2025 - masovna reklasifikacija ~200 artikala
- 4 artikla menjala tip dok su imali aktivno stanje (potencijalni problem)

---
*Živi dokument - dopunjavati tokom rada*

### 30.03.2026 - Implementacija filtera aktivnih artikala
- Kreirana tabela `tmp_aktivni_2025` sa 241 šifrom
- Svi dalji upiti na `robno` koriste ovu tabelu kao filter

## Sesija 30.03.2026

- [Session Log](logs/SESSION_LOG_2026-03-30.md)
- [Resume](RESUME.md)
- [Struktura Robno Artikli](STRUKTURA_ROBNO_ARTIKLI.md)
- SQL upiti: [sql/](../sql/)
