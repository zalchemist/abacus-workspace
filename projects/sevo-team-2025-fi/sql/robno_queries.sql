-- ============================================================
-- ROBNO KNJIGOVODSTVO - SQL KVERIJI ZA ANALIZU
-- Baza: opp7102025 (Ševo Tim)
-- Datum: 2026-03-30
-- ============================================================

-- ============================================================
-- 1. STRUKTURA TABELE ROBNO
-- ============================================================
DESCRIBE robno;

-- ============================================================
-- 2. SVE KOLONE IZ ROBNO ZA ARTIKLE SA PROMETOM U 2025
-- (Samo artikli koji su imali bar jedan zapis u 2025)
-- ============================================================
SELECT 
  r.sifobj, r.sifra, r.datum, r.brnal,
  r.ulaz, r.izlaz, r.duguje, r.potrazuje,
  r.rbr, r.cena, r.nabcena, r.cenabezpp, r.cenasapp,
  r.prcruc, r.ddatum, r.condatddat, r.subject, r.posljed,
  r.realizacija, r.rabat, r.komercijalista, r.operater,
  r.mestotr, r.nosioc, r.prernc,
  r.fid1, r.fid2, r.fid3, r.fid4,
  r.datorigdok, r.brdok, r.stornirano,
  r.datumdokumenta, r.originbrnal,
  a.naziv, a.jedmere, a.barkod,
  CASE 
    WHEN a.jesirovina=1 THEN 'SIROVINA'
    WHEN a.jeproizvod=1 THEN 'PROIZVOD'
    WHEN a.jeusluga=1 THEN 'USLUGA'
    ELSE 'ROBA'
  END as tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.sifra IN (
  SELECT DISTINCT sifra 
  FROM robno 
  WHERE datum >= '2025-01-01' AND datum < '2026-01-01'
)
ORDER BY r.sifra, r.datum, r.brnal;

-- ============================================================
-- 3. LISTA ARTIKALA BEZ PROMETA U 2025 (KANDIDATI ZA ELIMINACIJU)
-- Ovi artikli postoje u šifarniku ali NEMAJU nijedan zapis
-- u tabeli robno za 2025. godinu
-- ============================================================
SELECT 
  a.sifra,
  a.naziv,
  a.barkod,
  a.jedmere,
  a.grupa,
  CASE 
    WHEN a.jesirovina=1 THEN 'SIROVINA'
    WHEN a.jeproizvod=1 THEN 'PROIZVOD'
    WHEN a.jeusluga=1 THEN 'USLUGA'
    ELSE 'ROBA'
  END as tip_artikla,
  (SELECT MAX(r.datum) FROM robno r WHERE r.sifra = a.sifra) as poslednji_promet
FROM artikli a
WHERE a.sifra NOT IN (
  SELECT DISTINCT sifra 
  FROM robno 
  WHERE datum >= '2025-01-01' AND datum < '2026-01-01'
)
ORDER BY tip_artikla, a.sifra;

-- ============================================================
-- 4. POČETNA STANJA (PST) - SVE KOLONE
-- Nalozi koji počinju sa 'PST'
-- ============================================================
SELECT 
  r.sifobj, r.sifra, r.datum, r.brnal,
  r.ulaz, r.izlaz, r.duguje, r.potrazuje,
  r.rbr, r.cena, r.nabcena, r.cenabezpp, r.cenasapp,
  r.prcruc, r.ddatum, r.condatddat, r.subject, r.posljed,
  r.realizacija, r.rabat, r.komercijalista, r.operater,
  r.mestotr, r.nosioc, r.prernc,
  r.fid1, r.fid2, r.fid3, r.fid4,
  r.datorigdok, r.brdok, r.stornirano,
  r.datumdokumenta, r.originbrnal,
  a.naziv, a.jedmere,
  CASE 
    WHEN a.jesirovina=1 THEN 'SIROVINA'
    WHEN a.jeproizvod=1 THEN 'PROIZVOD'
    WHEN a.jeusluga=1 THEN 'USLUGA'
    ELSE 'ROBA'
  END as tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.brnal LIKE 'PST%'
ORDER BY r.datum DESC, r.sifra;

-- ============================================================
-- 5. SUMARNI PREGLED: ARTIKLI SA vs BEZ PROMETA PO TIPU
-- ============================================================
SELECT 
  tip,
  ukupno,
  IFNULL(sa_prometom, 0) as sa_prometom,
  ukupno - IFNULL(sa_prometom, 0) as bez_prometa,
  ROUND(IFNULL(sa_prometom, 0) / ukupno * 100, 1) as pct_aktivni
FROM (
  SELECT 
    CASE 
      WHEN jesirovina=1 THEN 'SIROVINA'
      WHEN jeproizvod=1 THEN 'PROIZVOD'
      WHEN jeusluga=1 THEN 'USLUGA'
      ELSE 'ROBA'
    END as tip,
    COUNT(*) as ukupno
  FROM artikli
  GROUP BY tip
) svi
LEFT JOIN (
  SELECT 
    CASE 
      WHEN a.jesirovina=1 THEN 'SIROVINA'
      WHEN a.jeproizvod=1 THEN 'PROIZVOD'
      WHEN a.jeusluga=1 THEN 'USLUGA'
      ELSE 'ROBA'
    END as tip,
    COUNT(DISTINCT r.sifra) as sa_prometom
  FROM robno r
  JOIN artikli a ON r.sifra = a.sifra
  WHERE r.datum >= '2025-01-01' AND r.datum < '2026-01-01'
  GROUP BY tip
) aktivni USING(tip)

UNION ALL

SELECT 
  'UKUPNO' as tip,
  (SELECT COUNT(*) FROM artikli) as ukupno,
  (SELECT COUNT(DISTINCT sifra) FROM robno WHERE datum >= '2025-01-01' AND datum < '2026-01-01') as sa_prometom,
  (SELECT COUNT(*) FROM artikli) - (SELECT COUNT(DISTINCT sifra) FROM robno WHERE datum >= '2025-01-01' AND datum < '2026-01-01') as bez_prometa,
  ROUND((SELECT COUNT(DISTINCT sifra) FROM robno WHERE datum >= '2025-01-01' AND datum < '2026-01-01') / (SELECT COUNT(*) FROM artikli) * 100, 1) as pct_aktivni;

-- ============================================================
-- 6. DISTINCT ŠIFRE ARTIKALA SA PROMETOM U 2025
-- (Lista za dalju analizu)
-- ============================================================
SELECT DISTINCT 
  r.sifra,
  a.naziv,
  CASE 
    WHEN a.jesirovina=1 THEN 'SIROVINA'
    WHEN a.jeproizvod=1 THEN 'PROIZVOD'
    WHEN a.jeusluga=1 THEN 'USLUGA'
    ELSE 'ROBA'
  END as tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.datum >= '2025-01-01' AND r.datum < '2026-01-01'
ORDER BY tip_artikla, r.sifra;
