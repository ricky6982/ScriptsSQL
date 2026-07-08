--------
-- SQL
--------
SELECT * FROM IAC_ACCOUNT_SETT_MODEL;
SELECT * FROM IBC_ISSUER_SETT_MODEL_TYPE;
SELECT * FROM IBC_SETTLEMENT_MODEL;
SELECT * FROM IAC_CREDIT_GENERAL_ACCOUNT;

SELECT *
FROM IAC_ACCOUNT_SETT_MODEL asm
inner join IBC_SETTLEMENT_MODEL sm on asm.ID_SETTLEMENT_MODEL = sm.ID_SETTLEMENT_MODEL;

-- Cuentas cuyo modelo actual venció
SELECT
    cga.ID_GENERAL_ACCOUNT as IdGeneralAccount,
    cga.ID_SETTLEMENT_MODEL as IdSettlementModel,
    asm.VALID_TO as ValidTo
FROM IAC_CREDIT_GENERAL_ACCOUNT cga
         INNER JOIN IAC_ACCOUNT_SETT_MODEL asm
                    ON  asm.ID_GENERAL_ACCOUNT  = cga.ID_GENERAL_ACCOUNT
                        AND asm.ID_SETTLEMENT_MODEL = cga.ID_SETTLEMENT_MODEL
WHERE CAST(asm.VALID_TO AS DATE) < :CustomDate
    AND asm.ID_ISSUER = :IdIssuer;

-- Buscar el modelo de liquidacion que entra en vigencia
SELECT
    t.ID_GENERAL_ACCOUNT,
    t.ID_SETTLEMENT_MODEL,
    t.VALID_FROM,
    t.VALID_TO,
    t.PRIORITY
FROM (
         SELECT
             asm.ID_GENERAL_ACCOUNT,
             asm.ID_SETTLEMENT_MODEL,
             asm.VALID_FROM,
             asm.VALID_TO,
             ismt.PRIORITY,
             ROW_NUMBER() OVER (
                 PARTITION BY asm.ID_GENERAL_ACCOUNT
                 ORDER BY ismt.PRIORITY ASC
                 ) AS RN
         FROM IAC_ACCOUNT_SETT_MODEL asm
                  INNER JOIN IBC_SETTLEMENT_MODEL sm
                             ON sm.ID_SETTLEMENT_MODEL = asm.ID_SETTLEMENT_MODEL
                  INNER JOIN IBC_ISSUER_SETT_MODEL_TYPE ismt
                             ON ismt.ID_ISS_SETT_MOD_TYPE = asm.ID_ISS_SETT_MOD_TYPE
         WHERE asm.VALID_FROM <= :CustomDate
           AND (asm.VALID_TO IS NULL OR asm.VALID_TO >= :CustomDate)
     ) t
WHERE t.RN = 1;

--- UPDATE v1
UPDATE cga
SET cga.ID_SETTLEMENT_MODEL = t.ID_SETTLEMENT_MODEL
FROM IAC_CREDIT_GENERAL_ACCOUNT cga
         INNER JOIN (SELECT asm.ID_GENERAL_ACCOUNT,
                            asm.ID_SETTLEMENT_MODEL,
                            ROW_NUMBER() OVER (
                                PARTITION BY asm.ID_GENERAL_ACCOUNT
                                ORDER BY ismt.PRIORITY ASC
                                ) AS RN
                     FROM IAC_ACCOUNT_SETT_MODEL asm
                              INNER JOIN IBC_SETTLEMENT_MODEL sm
                                         ON sm.ID_SETTLEMENT_MODEL = asm.ID_SETTLEMENT_MODEL
                              INNER JOIN IBC_ISSUER_SETT_MODEL_TYPE ismt
                                         ON ismt.ID_ISS_SETT_MOD_TYPE = asm.ID_ISS_SETT_MOD_TYPE
                     WHERE asm.VALID_FROM <= :CustomDate
                       AND (asm.VALID_TO IS NULL OR asm.VALID_TO >= :CustomDate)
                       AND asm.ID_GENERAL_ACCOUNT IN :AccountIds) t
             ON t.ID_GENERAL_ACCOUNT = cga.ID_GENERAL_ACCOUNT
    WHERE t.RN = 1 AND cga.ID_SETTLEMENT_MODEL <> t.ID_SETTLEMENT_MODEL;

--- UPDATE v2
UPDATE IAC_CREDIT_GENERAL_ACCOUNT
SET ID_SETTLEMENT_MODEL = (
    SELECT TOP 1 asm.ID_SETTLEMENT_MODEL
    FROM IAC_ACCOUNT_SETT_MODEL asm
             INNER JOIN IBC_SETTLEMENT_MODEL sm
                        ON sm.ID_SETTLEMENT_MODEL = asm.ID_SETTLEMENT_MODEL
             INNER JOIN IBC_ISSUER_SETT_MODEL_TYPE ismt
                        ON ismt.ID_ISS_SETT_MOD_TYPE = asm.ID_ISS_SETT_MOD_TYPE
    WHERE asm.ID_GENERAL_ACCOUNT = IAC_CREDIT_GENERAL_ACCOUNT.ID_GENERAL_ACCOUNT
      AND asm.VALID_FROM <= :CustomDate
      AND (asm.VALID_TO IS NULL OR asm.VALID_TO >= :CustomDate)
      AND asm.ID_GENERAL_ACCOUNT IN :AccountIds
    ORDER BY ismt.PRIORITY ASC
)
WHERE ID_GENERAL_ACCOUNT IN :AccountIds
  AND ID_SETTLEMENT_MODEL <> (
    SELECT TOP 1 asm.ID_SETTLEMENT_MODEL
    FROM IAC_ACCOUNT_SETT_MODEL asm
             INNER JOIN IBC_SETTLEMENT_MODEL sm
                        ON sm.ID_SETTLEMENT_MODEL = asm.ID_SETTLEMENT_MODEL
             INNER JOIN IBC_ISSUER_SETT_MODEL_TYPE ismt
                        ON ismt.ID_ISS_SETT_MOD_TYPE = asm.ID_ISS_SETT_MOD_TYPE
    WHERE asm.ID_GENERAL_ACCOUNT = IAC_CREDIT_GENERAL_ACCOUNT.ID_GENERAL_ACCOUNT
      AND asm.VALID_FROM <= :CustomDate
      AND (asm.VALID_TO IS NULL OR asm.VALID_TO >= :CustomDate)
      AND asm.ID_GENERAL_ACCOUNT IN :AccountIds
    ORDER BY ismt.PRIORITY ASC
);

select * from IBC_ISSUER_SETT_MODEL_TYPE
select * from IAC_ACCOUNT_SETT_MODEL
select * from IAC_CREDIT_GENERAL_ACCOUNT where ID_GENERAL_ACCOUNT in (118, 133)
select * from IBC_SETTLEMENT_MODEL
select * from IAC_GENERAL_ACCOUNT WHERE ID_ISSUER = 641 ORDER BY ID_GENERAL_ACCOUNT DESC
--
--  Y si el Batch debe fijarse que Modelo de Liquidacion entra en vigencia segun la business Date.. Este proceso debe ejecutarse a diario,
--  y si hay algo por actualizar procede
--
-- La tabla que mantienen los Modelos de liquidacion por cuenta es la IAC_ACCOUNT_SETT_MODEL, Va existir un Modelo de liquidacion que
-- tendra el ValidFrom impactado pero el ValidTo en NULL ese es el modelo base, y el resto tendra ValidFrom y ValidTo,
-- hay que jugar con estos campo para identificar cual sera el definitivo.
--
-- Si hay varios modelos de liquidacion que coincide en fecha, la prioridad te la da la tabla select * from IBC_ISSUER_SETT_MODEL_TYPE
-- donde menor valor toma mayor prioridad
--
-- El SettModel definitivo debe quedar impactado en la tabla IAC_CREDIT_GENERAL_ACCOUNT

SELECT
    fk.name                         AS FK_NAME,
    tp.name                         AS TABLA_ORIGEN,
    cp.name                         AS COLUMNA_ORIGEN,
    tr.name                         AS TABLA_DESTINO,
    cr.name                         AS COLUMNA_DESTINO
FROM sys.foreign_keys fk
         INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
         INNER JOIN sys.tables tp  ON tp.object_id  = fk.parent_object_id
         INNER JOIN sys.columns cp ON cp.object_id  = fk.parent_object_id  AND cp.column_id = fkc.parent_column_id
         INNER JOIN sys.tables tr  ON tr.object_id  = fk.referenced_object_id
         INNER JOIN sys.columns cr ON cr.object_id  = fk.referenced_object_id AND cr.column_id = fkc.referenced_column_id
WHERE tr.name = 'IBC_ISSUER_SETT_MODEL_TYPE'
   OR tp.name = 'IBC_ISSUER_SETT_MODEL_TYPE';
