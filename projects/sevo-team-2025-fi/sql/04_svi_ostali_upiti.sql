-- ============================================================
-- OSTALI KORISNI UPITI
-- Baza: opp7102025 | Datum: 2026-03-30
-- ============================================================

-- 1. POČETNA STANJA (PST)
SELECT r.*, a.naziv, a.jedmere,
  CASE WHEN a.jesirovina=1 THEN 'SIROVINA' WHEN a.jeproizvod=1 THEN 'PROIZVOD'
       WHEN a.jeusluga=1 THEN 'USLUGA' ELSE 'ROBA' END AS tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.brnal LIKE 'PST%'
ORDER BY r.datum DESC, r.sifra;

-- 2. SUMARNI PREGLED: ARTIKLI SA vs BEZ PROMETA PO TIPU
SELECT 
  tip,
  ukupno,
  IFNULL(sa_prometom, 0) AS sa_prometom,
  ukupno - IFNULL(sa_prometom, 0) AS bez_prometa,
  ROUND(IFNULL(sa_prometom, 0) / ukupno * 100, 1) AS pct_aktivni
FROM (
  SELECT 
    CASE WHEN jesirovina=1 THEN 'SIROVINA' WHEN jeproizvod=1 THEN 'PROIZVOD'
         WHEN jeusluga=1 THEN 'USLUGA' ELSE 'ROBA' END AS tip,
    COUNT(*) AS ukupno
  FROM artikli GROUP BY tip
) svi
LEFT JOIN (
  SELECT 
    CASE WHEN a.jesirovina=1 THEN 'SIROVINA' WHEN a.jeproizvod=1 THEN 'PROIZVOD'
         WHEN a.jeusluga=1 THEN 'USLUGA' ELSE 'ROBA' END AS tip,
    COUNT(DISTINCT r.sifra) AS sa_prometom
  FROM robno r JOIN artikli a ON r.sifra = a.sifra
  WHERE r.datum >= '2025-01-01' AND r.datum < '2026-01-01'
  GROUP BY tip
) aktivni USING(tip);

-- 3. ARTIKLI BEZ PROMETA U 2025 (kandidati za eliminaciju)
SELECT a.sifra, a.naziv, a.barkod, a.jedmere, a.grupa,
  CASE WHEN a.jesirovina=1 THEN 'SIROVINA' WHEN a.jeproizvod=1 THEN 'PROIZVOD'
       WHEN a.jeusluga=1 THEN 'USLUGA' ELSE 'ROBA' END AS tip_artikla,
  (SELECT MAX(r.datum) FROM robno r WHERE r.sifra = a.sifra) AS poslednji_promet
FROM artikli a
WHERE a.sifra NOT IN (
  SELECT DISTINCT sifra FROM robno
  WHERE datum >= '2025-01-01' AND datum < '2026-01-01'
)
ORDER BY tip_artikla, a.sifra;

-- 4. DISTINCT ŠIFRE SA PROMETOM U 2025
SELECT DISTINCT r.sifra, a.naziv,
  CASE WHEN a.jesirovina=1 THEN 'SIROVINA' WHEN a.jeproizvod=1 THEN 'PROIZVOD'
       WHEN a.jeusluga=1 THEN 'USLUGA' ELSE 'ROBA' END AS tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.datum >= '2025-01-01' AND r.datum < '2026-01-01'
ORDER BY tip_artikla, r.sifra;
