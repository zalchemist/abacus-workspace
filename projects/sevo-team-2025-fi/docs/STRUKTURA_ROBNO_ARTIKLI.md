# Struktura tabela ROBNO i ARTIKLI — BizniSoft ERP
> Baza: `opp7102025` | Firma: 710 | Godina: 2025
> Generisano: 2026-03-30
> Izvor: DESCRIBE + SKILL knowledge dokumentacija

---

## 1. TABELA: robno (188.619 redova)

**Opis:** Glavni robni promet — SVE ulazno/izlazne promene zaliha. Svaki red = jedna stavka prometa jednog dokumenta.

### 1.1 Kompletna lista kolona

#### KLJUČNE KOLONE (PRI = Primary Key)
| Kolona | Tip | PK | Opis |
|--------|-----|----|------|
| **sifobj** | int(3) | ✅ PRI | Šifra objekta/poslovnice (→ `objekti.sifra`) |
| **sifra** | int(6) | ✅ PRI | Šifra artikla (→ `artikli.sifra`) |
| **brnal** | varchar(50) | ✅ PRI | Broj naloga — interni identifikator dokumenta (format: TIP-GGGG/BBBB, npr. KL-2025/0001) |
| **rbr** | int(4) | ✅ PRI | Redni broj stavke u dokumentu |

#### KOLONE ZA KOLIČINE
| Kolona | Tip | Opis |
|--------|-----|------|
| **ulaz** | double | Količina ulaza (prijem robe, kalkulacija, povrat) |
| **izlaz** | double | Količina izlaza (prodaja, otpis, prenos) |

#### KOLONE ZA CENE
| Kolona | Tip | Opis |
|--------|-----|------|
| **cena** | double(15,2) | Fakturna cena dobavljača (cena sa fakture) |
| **nabcena** | double(15,4) | Nabavna cena — cena + transport + zavisni troškovi (4 decimale za preciznost!) |
| **cenabezpp** | double(15,2) | Maloprodajna cena BEZ poreza na promet (cena bez PDV-a) |
| **cenasapp** | double(15,2) | Maloprodajna cena SA porezom na promet (cena sa PDV-om) |
| **prcruc** | double | Procenat razlike u ceni (marža/RUC u %) |
| **prernc** | double(15,4) | Preračunata nabavna cena (FIFO obračun — rezultat `fifo_calc` procedura) |

#### KOLONE ZA VREDNOSTI (novčane)
| Kolona | Tip | Opis |
|--------|-----|------|
| **duguje** | double | Dugovni promet u dinarima (ulaz × nabavna cena ili druga osnova) |
| **potrazuje** | double | Potražni promet u dinarima (izlaz × nabavna cena ili druga osnova) |
| **realizacija** | double(15,2) | Realizacija — vrednost prodaje (izlaz × prodajna cena). Default: 0.00 |
| **rabat** | double(15,2) | Iznos odobrenog rabata. Default: 0.00 |

#### DATUMSKE KOLONE
| Kolona | Tip | Opis |
|--------|-----|------|
| **datum** | date | Datum prometa (datum knjiženja u robnom) |
| **ddatum** | timestamp | Datum i vreme unosa u bazu (auto: current_timestamp) |
| **datorigdok** | date | Datum originalnog dokumenta (npr. datum fakture dobavljača) |
| **datumdokumenta** | date | Datum dokumenta (može se razlikovati od datuma knjiženja) |

#### KOLONE ZA IDENTIFIKACIJU I VEZE
| Kolona | Tip | Opis |
|--------|-----|------|
| **subject** | varchar(50) | Šifra partnera/kupca/dobavljača (→ `kupci.sifra`) — MUL index |
| **brdok** | varchar(50) | Broj dokumenta (eksterni broj — npr. broj fakture dobavljača) |
| **originbrnal** | varchar(30) | Originalni broj naloga (za storno dokumente — referenca na original) — MUL index |
| **condatddat** | varchar(50) | Concatenirani datum+ddatum (pomoćno polje za sortiranje/identifikaciju) |
| **posljed** | int(4) | Poslednji redni broj (sekvenca unutar dokumenta) |

#### KOLONE ZA ORGANIZACIJU
| Kolona | Tip | Opis |
|--------|-----|------|
| **komercijalista** | varchar(50) | Šifra komercijaliste (→ `komercijalisti.sifra`) |
| **operater** | varchar(10) | Šifra operatera koji je uneo dokument (→ `operateri.sifra`) — MUL index |
| **mestotr** | int(6) | Mesto troška (→ `mestatr.sifra`) — MUL index |
| **nosioc** | int(6) | Nosilac troška (→ `nosioci.sifra`) — MUL index |

#### FID KOLONE (vezivanje sa izvornim dokumentom)
| Kolona | Tip | Opis |
|--------|-----|------|
| **fid1** | double(15,2) | Pomoćni ID 1 — koristi se za interno povezivanje sa izvornim dokumentom |
| **fid2** | int(8) | Pomoćni ID 2 |
| **fid3** | int(8) | Pomoćni ID 3 |
| **fid4** | varchar(255) | Pomoćni ID 4 (tekstualni) |

#### STATUS KOLONE
| Kolona | Tip | Opis |
|--------|-----|------|
| **stornirano** | int(1) | Oznaka storniranog zapisa: 0 = aktivan, 1 = storniran. Default: 0 |

---

## 2. TABELA: artikli (šifarnik)

**Opis:** Šifarnik artikala/robe/usluga sa cenama, PDV, barkodovima. Master tabela za sve artikle.

### 2.1 Kompletna lista kolona

#### IDENTIFIKACIJA
| Kolona | Tip | PK | Opis |
|--------|-----|----|------|
| **sifra** | int(6) | ✅ PRI | Šifra artikla — primarni ključ |
| **grupa** | int(4) | MUL | Grupa artikla (klasifikacija) |
| **barkod** | varchar(30) | MUL | Primarni barkod artikla |
| **naziv** | varchar(1000) | | Naziv artikla |
| **katbr** | varchar(100) | MUL | Kataloški broj |
| **jedmere** | char(3) | | Jedinica mere (KOM, KG, LIT, M...) |

#### FISKALNE I PORESKE KOLONE
| Kolona | Tip | Opis |
|--------|-----|------|
| **tarbr** | int(1) | Tarifni broj (→ `tabrac.sifra`) — poreska tarifa |
| **taksa** | double(15,2) | Iznos takse |
| **akciza** | double(15,2) | Iznos akcize |
| **porez** | varchar(2) | Oznaka poreza (PDV grupa: Đ, E, Ž...) |
| **sifakcize** | int(2) | Šifra akcize |
| **ekotaksa** | double(15,2) | Ekološka taksa |

#### CENE U ŠIFARNIKU
| Kolona | Tip | Opis |
|--------|-----|------|
| **planskacena** | double(15,2) | Planska cena (za interne obračune) |
| **vpcenasopst** | double(15,2) | Veleprodajna cena sopstvena |
| **prckala** | double(15,5) | Procenat kalkulacije (marža za obračun) |
| **carst** | double(10,2) | Carinska stopa |
| **akcrabat** | double(5,2) | Akcijski rabat |

#### TIPOVI ARTIKLA (boolean flagovi)
| Kolona | Tip | Opis |
|--------|-----|------|
| **jeusluga** | tinyint(1) | Da li je usluga (1=da) |
| **jesirovina** | tinyint(1) | Da li je sirovina (1=da) |
| **jeproizvod** | tinyint(1) | Da li je proizvod (1=da) |
| **jeambalaza** | tinyint(1) | Da li je ambalaža (1=da) |
| **imaambalazu** | tinyint(1) | Da li ima ambalažu (1=da) |
| **jegrupa** | int(1) | Da li je grupni artikal |
| **kooperacija** | int(1) | Da li je kooperacija |
| **turizam** | int(1) | Da li je turizam |
| **polovnodobro** | int(1) | Da li je polovno dobro |
| **proizvod9120** | tinyint(1) | Proizvod po konto 9120 |
| **komision880** | tinyint(1) | Komision po konto 880 |

#### ORGANIZACIONE KOLONE
| Kolona | Tip | Opis |
|--------|-----|------|
| **sifobj** | int(3) | Objekat kojem pripada (→ `objekti.sifra`) |
| **mestotr** | int(6) | Mesto troška |
| **nosioc** | int(6) | Nosilac troška |
| **konto** | varchar(20) | Konto za knjiženje |
| **odeljenje** | int(6) | Odeljenje |
| **operater** | varchar(50) | Operater poslednje izmene |

#### MERENJE I PAKOVANJE
| Kolona | Tip | Opis |
|--------|-----|------|
| **kasakoef** | double(12,7) | Koeficijent za kasu (pretvaranje JM) |
| **kasajmr** | varchar(3) | Jedinica mere za kasu |
| **faktorjm** | double(15,7) | Faktor jedinice mere |
| **faktoramb** | double(15,4) | Faktor ambalaže |
| **tezina** | double(15,7) | Težina artikla |
| **tezina_amb** | double(15,2) | Težina ambalaže |
| **zapremina** | double(15,5) | Zapremina |
| **tezinski** | int(1) | Da li se meri na vagi |
| **vaga** | int(1) | Da li se koristi vaga |
| **jc_jedmere** | char(3) | JM za jediniču cenu |
| **jc_koef** | double(12,7) | Koeficijent jedinične cene |

#### KOLEKTIVNO PAKOVANJE (KP, TP, PP)
| Kolona | Tip | Opis |
|--------|-----|------|
| **kpima** | int(1) | Ima kolektivno pakovanje 1 |
| **kpbarkod** | varchar(15) | Barkod kolektivnog pakovanja 1 |
| **kpkolicina** | double(15,3) | Količina u KP1 |
| **kp_tezina** | double(15,2) | Težina KP1 |
| **tpima** | int(1) | Ima transportno pakovanje |
| **tpbarkod** | varchar(15) | Barkod transportnog pakovanja |
| **tpkolicina** | double(15,3) | Količina u TP |
| **tp_tezina** | double(15,2) | Težina TP |
| **ppima** | int(1) | Ima paletno pakovanje |
| **ppbarkod** | varchar(15) | Barkod paletnog pakovanja |
| **ppkolicina** | double(15,3) | Količina u PP |
| **pp_tezina** | double(15,2) | Težina PP |
| **ambalaza** | int(6) | Šifra artikla ambalaže |

#### OSTALE KOLONE
| Kolona | Tip | Opis |
|--------|-----|------|
| **rokpl** | int(3) | Rok plaćanja (dani) |
| **datotv** | datetime | Datum otvaranja artikla |
| **zamena** | varchar(20) | Šifra zamene za artikal |
| **minzal** | double(15,2) | Minimalna zaliha |
| **garancija** | int(4) | Garantni rok (meseci) |
| **serbr** | int(1) | Da li ima serijski broj |
| **serbrrok** | int(1) | Serijski broj sa rokom |
| **ssbrtip** | int(1) | Tip serijskog broja |
| **ts** | timestamp | Timestamp poslednje izmene |
| **zabranipos** | int(1) | Zabrani prodaju na POS kasi |
| **ignminpos** | int(1) | Ignoriši minimalnu prodajnu cenu |
| **dodaci** | int(1) | Ima dodatke |
| **msort** | int(1) | Redosled za meni sortiranje |
| **imaplusifra** | int(1) | Ima PLU šifru |
| **plusifra** | int(5) | PLU šifra (za kasu) |
| **webshoplink** | varchar(500) | Link ka web shopu |
| **wsstanje** | int(5) | Stanje za web shop |
| **obrnuto** | int(1) | Obrnuti obračun PDV |
| **adresaartikla** | varchar(100) | Adresa artikla (lokacija u magacinu) |
| **stvarnack** | int(1) | Stvarna nabavna cena (flag) |
| **nazivzafakturu** | varchar(500) | Naziv za fakturu (ako se razlikuje) |
| **karaktertudja** | int(2) | Karakter tuđe robe |
| **invbroj** | varchar(50) | Inventurni broj |
| **eotpremnice_akciza_tip** | int(1) | Tip akcize za e-otpremnice |
| **eotpremnice_akciza_vrednost** | double(15,5) | Vrednost akcize za e-otpremnice |
| **eotpremnice_nikotin** | varchar(255) | Nikotin info za e-otpremnice |

---

## 3. MAPA VEZA IZMEĐU TABELA

### 3.1 Glavna veza: robno ↔ artikli
```
robno.sifra  ──→  artikli.sifra (int(6))
```
- Svaki zapis u `robno` referencira artikal iz `artikli`
- Veza je 1:N (jedan artikal → mnogo robnih prometa)
- **NEMA FK CONSTRAINT** — veza se održava na aplikativnom nivou

### 3.2 Sve veze tabele robno
```
robno.sifobj       ──→  objekti.sifra         (objekat/poslovnica)
robno.sifra        ──→  artikli.sifra          (artikal)
robno.subject      ──→  kupci.sifra            (partner/kupac/dobavljač)
robno.komercijalista ──→ komercijalisti.sifra   (komercijalista)
robno.operater     ──→  operateri.sifra         (operater)
robno.mestotr      ──→  mestatr.sifra           (mesto troška)
robno.nosioc       ──→  nosioci.sifra           (nosilac troška)
```

### 3.3 Tabele koje PUNE robno (izvorni dokumenti)
| Izvorni dokument | Tabela | Tip prometa u robno |
|------------------|--------|---------------------|
| Kalkulacija (KL) | `kalkulacije` | Ulaz — prijem robe od dobavljača |
| Faktura (RN) | `fakture` | Izlaz — prodaja kupcu |
| Nivelacija (NC) | `nivelacije` | Promena cene — korekcija vrednosti |
| Kasa (POS) | `kasa` | Izlaz — maloprodajna prodaja |
| Interni račun | `intracun` | Interni prenos između objekata |
| Uvoz | `tbluvoz` | Ulaz — uvozna roba |
| Promena cene (PC) | direktno u `robno` | tip dok 7 |
| Početno stanje (PS) | direktno u `robno` | tip dok 7 |

### 3.4 Robno → Stanje zaliha (automatski trigeri)
```
robno INSERT/UPDATE/DELETE
    ↓ (trigeri: insstanje, updstanje, delstanje)
trstanje (sifobj, sifra) — ažurira se automatski
    ↓ (čita opp.zirklista za kurseve)
trstanje.eurcena, .usdcena, .chfcena — preračun u valute
```

### 3.5 Veze tabele artikli
```
artikli.tarbr      ──→  tabrac.sifra           (tarifni broj)
artikli.sifobj     ──→  objekti.sifra          (objekat)
artikli.mestotr    ──→  mestatr.sifra           (mesto troška)
artikli.nosioc     ──→  nosioci.sifra           (nosilac troška)
artikli.operater   ──→  operateri.sifra         (operater)
```
Artikli se pojavljuju u: `robno`, `trgovacka`, `kasa`, `fakture`, `kalkulacije`, `cenovnik`, `serbr`, `trstanje`

---

## 4. KLASIFIKACIJA KOLONA PO NAMENI

### 4.1 Kolone za KOLIČINE
| Tabela | Kolona | Smer |
|--------|--------|------|
| robno | **ulaz** | Količina ulaza (prijem, povrat, početno stanje) |
| robno | **izlaz** | Količina izlaza (prodaja, otpis, prenos) |

### 4.2 Kolone za CENE
| Tabela | Kolona | Vrsta cene |
|--------|--------|------------|
| **robno** | **cena** | Fakturna cena (sa fakture dobavljača) |
| **robno** | **nabcena** | Nabavna cena (fakturna + zavisni troškovi) |
| **robno** | **prernc** | Preračunata NC (FIFO metoda) |
| **robno** | **cenabezpp** | Prodajna cena BEZ PDV-a |
| **robno** | **cenasapp** | Prodajna cena SA PDV-om |
| **robno** | **prcruc** | % razlike u ceni (marža) |
| **artikli** | **planskacena** | Planska cena (šifarnička) |
| **artikli** | **vpcenasopst** | Veleprodajna cena (šifarnička) |
| **artikli** | **prckala** | % kalkulacije (šifarnička marža) |
| **trstanje** | **faktcena** | Fakturna cena (trenutna) |
| **trstanje** | **nabcena** | Nabavna cena (trenutna) |
| **trstanje** | **vpcena** | Veleprodajna cena (trenutna) |
| **trstanje** | **mpcena** | Maloprodajna cena (trenutna sa PDV) |

### 4.3 Kolone za VREDNOSTI (novčane iznose)
| Tabela | Kolona | Šta predstavlja |
|--------|--------|-----------------|
| **robno** | **duguje** | Dugovni promet u RSD (ulaz × nabavna cena) |
| **robno** | **potrazuje** | Potražni promet u RSD (izlaz × nabavna cena) |
| **robno** | **realizacija** | Vrednost prodaje (izlaz × prodajna cena) |
| **robno** | **rabat** | Iznos odobrenog rabata |

### 4.4 Formule za obračun (poslovana logika)
```
NABAVNA CENA:   nabcena = cena + zavisni troškovi (transport, carina...)
PRODAJNA CENA:  cenabezpp = nabcena × (1 + prcruc/100)
CENA SA PDV:    cenasapp = cenabezpp × (1 + PDV_stopa/100)
DUGUJE:         duguje = ulaz × nabcena  (približno)
POTRAZUJE:      potrazuje = izlaz × nabcena  (približno)
REALIZACIJA:    realizacija = izlaz × prodajna_cena (približno)
FIFO NC:        prernc = rezultat FIFO kalkulacije (procedure fifo_calc)
```

---

## 5. POMOĆNA TABELA: tmp_aktivni_2025

**Opis:** Privremena tabela sa 241 aktivnim artiklom iz 2025. godine.
Koristi se za filtriranje u analitičkim upitima umesto celog šifarnika artikala.

---

## 6. NAPOMENE ZA ANALIZU

1. **Robno NEMA FK** — sve veze su implicitne, provere se rade JOIN-om
2. **brnal format** govori o tipu dokumenta (KL=kalkulacija, RN=faktura, NC=nivelacija...)
3. **stornirano** kolona NIJE uvek pouzdana — treba proveriti i `storniranja` tabelu
4. **prernc** se razlikuje od **nabcena** — prernc je FIFO obračun, nabcena je sa dokumenta
5. **subject** u robno je šifra partnera — VARCHAR, ne INT (paziti na JOIN sa kupci!)
6. **Trigeri na robno** automatski ažuriraju `trstanje` i čitaju kurseve iz `opp.zirklista`
7. **4 kolone čine PK**: (sifobj, sifra, brnal, rbr) — jedinstveno identifikuju svaku stavku
