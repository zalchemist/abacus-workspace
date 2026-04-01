# Struktura podataka: 12_rekapitulacija_kompletna.xlsx

## Pregled sheet-ova

| # | Sheet | Redova | Kolona | Opis |
|---|-------|--------|--------|------|
| 1 | Rekapitulacija | 16 | 7 | Sumarna tabela svih sekcija (A+B+C+D) |
| 2 | A_EBC | 24 | 6 | Građevinski radovi – 18 grupa, po situacijama |
| 3 | A_EBC_Fakture | 5 | 12 | 3 fakture za EBC adaptaciju |
| 4 | B_Oprema | 13 | 19 | 11 faktura za opremu od 8 dobavljača |
| 5 | C_MIOS | 30 | 17 | 29 lizing ugovora (viljuškari, oprema) |
| 6 | D_Razno | 101 | 18 | 100 raznih faktura od 18 dobavljača |

---

## 1. Sheet: `Rekapitulacija`

**Tip:** Sumarna tabela (nije tabelarni dataset, već formatiran izveštaj sa merged ćelijama)

**Efektivne kolone (red 4 = header):**
| Kolona | Sadržaj |
|--------|---------|
| # | Oznaka sekcije (A, B, C, D) |
| Sekcija | Naziv (EBC Adaptacija, Oprema, MIOS, Razno) |
| Osnovica (RSD) | Iznos bez PDV u dinarima |
| PDV (RSD) | PDV iznos |
| Ukupno sa PDV (RSD) | Ukupan fakturisani iznos |
| Osnovica (EUR) | Preračunato po kursu 117.2 |
| Napomena | Broj faktura/ugovora |

**Primer reda:**
```
A | EBC Adaptacija | 250,120,271.91 RSD | 14,453,943.42 PDV | 264,574,215.33 ukupno | 2,134,132 EUR | 3 fakture, 18 grupa radova
```

---

## 2. Sheet: `A_EBC`

**Tip:** Grupisani radovi po situacijama (građevina)

| # | Kolona | Primer | Bitnost |
|---|--------|--------|---------|
| 1 | Grupa | 1 | ✅ identifikator |
| 2 | Opis radova | PRIPREMNI RADOVI | ✅ ključna |
| 3 | I sit. tekuće (fak. 2024-44) | 2,897,544 | ✅ iznos |
| 4 | II sit. tekuće (fak. 2025-79) | 0 | ✅ iznos |
| 5 | Okončana tekuće (fak. 2025-106) | 0 | ✅ iznos |
| 6 | Ukupna osnovica | 2,897,544 | ✅ ukupno |

> 🟢 **Sve kolone su bitne** – ovo je kompaktna tabela sa 18 grupa radova i 3 situacije.

---

## 3. Sheet: `A_EBC_Fakture`

**Tip:** Fakture vezane za EBC (samo 3 reda)

| # | Kolona | Primer | Bitnost |
|---|--------|--------|---------|
| 1 | Tip situacije | I privremena situacija | ✅ |
| 2 | Broj fakture | 2024-44 | ✅ |
| 3 | Datum izdavanja | 18.09.2024 | ✅ |
| 4 | Datum prometa | 18.09.2024 | ⚠️ redundantno (obično = datum izdavanja) |
| 5 | Izdavalac | EBC S New Construction Technology | ✅ |
| 6 | Primalac | Bottega Grande DOO | ❌ uvek isto |
| 7 | Osnovica | 144,856,374.07 | ✅ |
| 8 | PDV | 6,804,646.42 | ✅ |
| 9 | Ukupno (sa PDV) | 151,661,020.49 | ✅ |
| 10 | PDV režim | mešovit (obrnuti + standardni 20%) | ⚠️ korisno za reviziju |
| 11 | Putanja fakture | A_EBC/A_fak_I_2024-44.pdf | ✅ za linkove |
| 12 | Putanja situacije | A_EBC/A_sit_I_privremena.pdf | ✅ za linkove |

---

## 4. Sheet: `B_Oprema`

**Tip:** Fakture za opremu (11 stavki)

| # | Kolona | Primer | Bitnost |
|---|--------|--------|---------|
| 1 | Folder | B01_Gastronaut_ledomat | ❌ tehničko |
| 2 | Relativna putanja | ~zvAn07a.../B01_fak_7541-2024.pdf | ✅ za linkove |
| 3 | Naziv fajla | B01_fak_7541-2024.pdf | ❌ redundantno sa putanjom |
| 4 | Tip dokumenta | faktura | ⚠️ uglavnom isto |
| 5 | Broj dokumenta | 7541/2024 | ✅ |
| 6 | Datum izdavanja | 25.12.2024 | ✅ |
| 7 | Datum prometa | 25.12.2024 | ❌ redundantno |
| 8 | Izdavalac | GASTRONAUT | ✅ |
| 9 | Primalac | BOTTEGA GRANDE DOO | ❌ uvek isto |
| 10 | Opis usluge/robe | LEDOMAT CB 249W | ✅ ključna |
| 11 | Osnovica (bez PDV) | 108,316 | ✅ |
| 12 | PDV iznos | 21,663.20 | ⚠️ izvediv |
| 13 | Fakturisani iznos | 129,979.20 | ✅ |
| 14 | Umanjenje za avans | 0 | ⚠️ bitno samo kad ≠ 0 |
| 15 | Iznos za plaćanje | 129,979.20 | ✅ finalni iznos |
| 16 | Valuta | RSD | ⚠️ uglavnom isto |
| 17 | Povezani avans br. | None | ⚠️ bitno samo kad postoji |
| 18 | PDV režim | normalan | ⚠️ |
| 19 | Napomena | None | ⚠️ bitno samo kad postoji |

---

## 5. Sheet: `C_MIOS`

**Tip:** Lizing ugovori (29 stavki) sa verifikacijom podataka

| # | Kolona | Primer | Bitnost |
|---|--------|--------|---------|
| 1 | Br. ugovora | 457/2025 | ✅ |
| 2 | Predmet | REGALNI VILJUŠKAR TOYOTA RRE140H | ✅ ključna |
| 3 | Kol. (ugovor) | 1 | ⚠️ za verifikaciju |
| 4 | Kol. (excel) | 1 | ⚠️ za verifikaciju |
| 5 | Kol. OK? | OK | ✅ status |
| 6 | Rata (ugovor) | 725.87 | ⚠️ za verifikaciju |
| 7 | Rata (excel) | 725.87 | ⚠️ za verifikaciju |
| 8 | Rata OK? | OK | ✅ status |
| 9 | Depozit (ugovor) | 1,743.47 | ⚠️ za verifikaciju |
| 10 | Depozit (excel) | 1,743.47 | ⚠️ za verifikaciju |
| 11 | Depozit OK? | OK | ✅ status |
| 12 | Otkupna (ugovor) | 12,204.30 | ⚠️ za verifikaciju |
| 13 | Otkupna (excel) | 12,204.30 | ⚠️ za verifikaciju |
| 14 | Otkupna OK? | OK | ✅ status |
| 15 | Nabavna (excel) | 34,841.76 | ✅ iznos |
| 16 | SVMP (excel) | 41,515.61 | ✅ iznos |
| 17 | Putanja u dosijeu | C_MIOS/C_ugovor_457.pdf | ✅ za linkove |

> 💡 **Ova tabela ima dual-check strukturu** – parovi kolona (ugovor vs excel) + OK? status. Za prikaz u tabeli dovoljni su: Br. ugovora, Predmet, Nabavna, SVMP, i 4× OK? statusa.

---

## 6. Sheet: `D_Razno`

**Tip:** Razne fakture (100 stavki, 18 dobavljača) – NAJVEĆI dataset

| # | Kolona | Primer | Bitnost |
|---|--------|--------|---------|
| 1 | Folder | D01_Volans | ❌ tehničko |
| 2 | Relativna putanja | D_Razno/D01_Volans/D01_fak_04-24_1.pdf | ✅ za linkove |
| 3 | Naziv fajla | D01_fak_04-24_1.pdf | ❌ redundantno |
| 4 | Broj dokumenta | 04-24 | ✅ |
| 5 | Datum izdavanja | 01.04.2024 | ✅ |
| 6 | Datum prometa | 29.03.2024 | ❌ redundantno |
| 7 | Izdavalac | Volans Design Hub doo Beograd | ✅ |
| 8 | Primalac | BOTTEGA GRANDE DOO Beograd | ❌ uvek isto |
| 9 | Opis | Usluga projektantskog nadzora... | ✅ ključna |
| 10 | Osnovica (bez PDV) | 160,459.20 | ✅ |
| 11 | PDV iznos | 32,091.84 | ⚠️ izvediv |
| 12 | Fakturisani iznos | 192,551.04 | ✅ |
| 13 | Umanjenje za avans | 0 | ⚠️ |
| 14 | Iznos za plaćanje | 192,551.04 | ✅ finalni |
| 15 | Valuta | RSD | ⚠️ |
| 16 | Povezani avans br. | None | ⚠️ |
| 17 | PDV režim | normalan PDV 20% | ⚠️ |
| 18 | Napomena | Broj narudžbenice 02-01/24... | ⚠️ |

---

## 📋 Preporuka za prikaz u tabeli

### Ključne kolone za svaki sheet:

| Sheet | Preporučene kolone za prikaz | Skrivene/sporedne |
|-------|------------------------------|-------------------|
| **Rekapitulacija** | Sve (samo 4 reda) | – |
| **A_EBC** | Sve 6 kolona (kompaktna tabela) | – |
| **A_EBC_Fakture** | Tip, Br.fakture, Datum, Izdavalac, Osnovica, PDV, Ukupno, Putanje | Primalac, Datum prometa |
| **B_Oprema** | Br.dokumenta, Datum, Izdavalac, Opis, Fakturisani iznos, Iznos za plaćanje, Putanja | Folder, Naziv fajla, Primalac, Datum prometa |
| **C_MIOS** | Br.ugovora, Predmet, Kol.OK?, Rata OK?, Depozit OK?, Otkupna OK?, Nabavna, SVMP, Putanja | Parovi ugovor/excel vrednosti (prikaži samo kad OK?≠OK) |
| **D_Razno** | Br.dokumenta, Datum, Izdavalac, Opis, Fakturisani iznos, Iznos za plaćanje, Putanja | Folder, Naziv fajla, Primalac, Datum prometa |

### Kolone koje su **uvek nepotrebne** za prikaz:
- **Primalac** – uvek "BOTTEGA GRANDE DOO" (konstantno)
- **Folder** – tehničko ime foldera
- **Naziv fajla** – redundantno sa putanjom
- **Datum prometa** – 95% isto kao datum izdavanja

### Kolone za **conditional prikaz** (prikaži samo kad imaju vrednost):
- Umanjenje za avans, Povezani avans br., Napomena
