# Plan ekstrakcije podataka - Bottega Grande

## Pregled dosijea
- **Ukupno PDF fajlova:** 190
- **Text-based:** 190 (100%)
- **Partial text:** 0
- **Scanned (potreban OCR):** 0
- **Greške:** 0

## Tipovi dokumenata
- **e-faktura:** 142
- **ugovor:** 30
- **faktura:** 8
- **nepoznato:** 5
- **situacija:** 3
- **ponuda:** 1
- **avans:** 1

## Potencijalni parovi situacija-faktura (rizik duplog knjiženja)
- **Identifikovano parova:** 1
- **A_EBC**: 3 situacija + 3 faktura

## Faze ekstrakcije

### Faza 1: Text-based PDF-ovi (prioritet)
- Alat: pdfminer.six
- Ekstrakcija: broj fakture, datum, iznos, dobavljač, opis
- Fokus: B_Oprema i D_Razno (najviše fajlova)

### Faza 2: Scanned PDF-ovi
- Alat: Tesseract OCR ili Azure Document Intelligence
- Pre-processing: konverzija u slike, deskew, denoise

### Faza 3: Uparivanje i validacija
- Upariti situacije sa fakturama po iznosu i dobavljaču
- Flagovati potencijalna dupla knjiženja
- Cross-check sa C_MIOS lizing ugovorima

### Faza 4: Finalni izveštaj
- Sumarni pregled svih troškova po kategorijama
- Lista svih parova situacija-faktura sa statusom
- Preporuke za revizora
