-- ============================================================
-- SPOJENI UPIT: ROBNO + ARTIKLI za aktivne artikle 2025
-- Baza: opp7102025
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
  END AS tip_artikla
FROM robno r
JOIN artikli a ON r.sifra = a.sifra
WHERE r.sifra IN (SELECT sifra FROM tmp_aktivni_2025)
ORDER BY r.sifra, r.datum, r.brnal;
