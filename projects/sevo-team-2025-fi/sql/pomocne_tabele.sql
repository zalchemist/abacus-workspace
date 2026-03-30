-- Pomoćne tabele za analizu Ševo Tim 2025
-- Baza: opp7102025

-- Tabela aktivnih artikala (241 artikal sa prometom u 2025)
CREATE TABLE IF NOT EXISTS tmp_aktivni_2025 AS
SELECT DISTINCT sifra 
FROM robno 
WHERE YEAR(datum) = 2025;

-- Korišćenje u upitima:
-- SELECT * FROM robno WHERE sifra IN (SELECT sifra FROM tmp_aktivni_2025);
