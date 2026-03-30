-- ============================================================
-- KREIRANJE TABELE tmp_aktivni_2025
-- Sadrži šifre artikala koji imaju promet u 2025. godini
-- Baza: opp7102025 | Datum: 2026-03-30
-- ============================================================

CREATE TABLE IF NOT EXISTS tmp_aktivni_2025 (
  sifra INT(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Popuni sa artiklima koji imaju bar jedan zapis u robno za 2025
INSERT INTO tmp_aktivni_2025 (sifra)
SELECT DISTINCT sifra
FROM robno
WHERE datum >= '2025-01-01' AND datum < '2026-01-01';

-- Verifikacija: treba da vrati 241
SELECT COUNT(*) AS broj_aktivnih_artikala FROM tmp_aktivni_2025;
