-- ============================================================
-- ANALIZA TIPOVA DOKUMENATA U 2025
-- Baza: opp7102025 | Tabela: robno
-- ============================================================

SELECT 
  SUBSTRING_INDEX(brnal, '-', 1) AS tip_dokumenta,
  COUNT(*) AS broj_zapisa,
  COUNT(DISTINCT sifra) AS broj_artikala,
  MIN(datum) AS prvi_datum,
  MAX(datum) AS poslednji_datum
FROM robno
WHERE datum >= '2025-01-01' AND datum < '2026-01-01'
GROUP BY tip_dokumenta
ORDER BY broj_zapisa DESC;
