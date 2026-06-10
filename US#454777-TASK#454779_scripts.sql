-- =====================================================================
-- TODOS los Settlement Models relacionados a un Producto
-- Incluye ambos caminos: directo (por servicio) y por defaults de cuenta
-- =====================================================================
DECLARE @ID_PRODUCT INT = 1;  -- <-- parametro de entrada

-- Camino 1: Vía IBC_SETT_MOD_SERVICE_REL (por servicio)
SELECT DISTINCT
    prod.ID_PRODUCT,
    prod.PRODUCT_NAME,
    sm.ID_SETTLEMENT_MODEL,
    sm.SETTLEMENT_MODEL_NAME,
    sm.WITH_COVERAGE,
    sm.BY_CURRENCY,
    sm.REVOLVING_FACTOR,
    'VIA_SERVICE_REL'           AS ORIGEN,
    svc.SERVICE_NAME            AS DETALLE
FROM IBC_PRODUCT prod
    INNER JOIN IBC_SETT_MOD_SERVICE_REL smsr
        ON smsr.ID_PRODUCT = prod.ID_PRODUCT
    INNER JOIN IBC_SETTLEMENT_MODEL sm
        ON sm.ID_SETTLEMENT_MODEL = smsr.ID_SETTLEMENT_MODEL
    INNER JOIN IBC_SERVICE svc
        ON svc.ID_SERVICE = smsr.ID_SERVICE
WHERE prod.ID_PRODUCT = @ID_PRODUCT

UNION

-- Camino 2: Vía IBC_DEFAULT_ACCOUNT_SERVICE (por issuer/product default)
SELECT DISTINCT
    prod.ID_PRODUCT,
    prod.PRODUCT_NAME,
    sm.ID_SETTLEMENT_MODEL,
    sm.SETTLEMENT_MODEL_NAME,
    sm.WITH_COVERAGE,
    sm.BY_CURRENCY,
    sm.REVOLVING_FACTOR,
    'VIA_DEFAULT_ACCOUNT_SVC'   AS ORIGEN,
    CAST(issProd.ID_ISSUER AS VARCHAR(20)) AS DETALLE
FROM IBC_PRODUCT prod
    INNER JOIN IBC_ISSUER_PRODUCT issProd
        ON issProd.ID_PRODUCT = prod.ID_PRODUCT
    INNER JOIN IBC_DEFAULT_ACCOUNT_SERVICE das
        ON das.ID_ISSUER  = issProd.ID_ISSUER
       AND das.ID_PRODUCT = issProd.ID_PRODUCT
    INNER JOIN IBC_SETTLEMENT_MODEL sm
        ON sm.ID_SETTLEMENT_MODEL = das.ID_SETTLEMENT_MODEL
WHERE prod.ID_PRODUCT = @ID_PRODUCT

ORDER BY
    ORIGEN,
    SETTLEMENT_MODEL_NAME;

-----
-- Buscqueda de producto activo para una cuenta
SELECT
    ga.ID_GENERAL_ACCOUNT, ga.INTERNAL_ACCOUNT_NUMBER,
    accRel.ID_PRODUCT IdProduct,
    ip.EXTERNAL_ISSUER_ID ProductCode,
    accRel.ID_ACCOUNT_RELATION IdAccountRelation,
    pm.ID_AFFINITY_GROUP IdAffinityGroup,
    pmRel.ID_PAYMENT_MEDIA IdPaymentMedia,
    pm.HAS_INSURANCE HasInsurance,
    pm.HAS_ONLINE_PAYMENT HasOnlinePayment,
    pm.TRANSACTION_BIN TransactionBin,
    pm.TRANSACTION_MASKED_PAN TransactionMaskedPan,
    pm.DUE_DATE DueDate,
    pm.CARD_NUMBER CardNumber,
    agroup.AFFINITY_GROUP_CODE AffinityGroupCode,
    product.PRODUCT_NAME ProductName,
    pmStatus.STATUS_CODE PaymentMediaStatusCode,
    pmStatus.STATUS_TYPE PaymentMediaStatusType,
    accRel.IS_RENEWABLE IsRenewable
FROM
    ICS_ACCOUNT_RELATION accRel
        JOIN ICS_FINANCIAL_RELATION finRel ON finRel.ID_FINANCIAL_RELATION = accRel.ID_FINANCIAL_RELATION
        JOIN IAC_GENERAL_ACCOUNT ga on ga.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
        JOIN ICS_PAYMENT_MEDIA_RELATION pmRel ON pmRel.ID_ACCOUNT_RELATION = accRel.ID_ACCOUNT_RELATION
        JOIN IAC_PAYMENT_MEDIA pm ON pm.ID_PAYMENT_MEDIA = pmRel.ID_PAYMENT_MEDIA
        JOIN IBC_PAYMENT_MEDIA_STATUS pmStatus ON pmStatus.ID_PAYMENT_MEDIA_STATUS = pm.ID_PAYMENT_MEDIA_STATUS
        JOIN IBC_PRODUCT product ON product.ID_PRODUCT = pm.ID_PRODUCT
        JOIN IBC_ISSUER_PRODUCT ip on ip.ID_PRODUCT = product.ID_PRODUCT and ip.ID_ISSUER = accRel.ID_ISSUER
        LEFT join IBC_AFFINITY_GROUP agroup on agroup.ID_AFFINITY_GROUP = accRel.ID_AFFINITY_GROUP and agroup.ID_ISSUER = accRel.ID_ISSUER
WHERE
    finRel.ID_CUSTOMER = 10 AND
    finRel.ID_GENERAL_ACCOUNT = 7 AND
    --pmStatus.STATUS_TYPE != 0 AND
  -- Debido a que es posible reemitir una tarjeta, debemos considerar únicamente aquellos medios de pago que no tienen solicitudes de reemisión
  -- [existe un caso borde, en el cual puede existir la solicitud pero no el medio de pago asociado a la nueva tarjeta (i.e.: se debe correr el batch);
  -- en este último caso ID_PAYMENT_MEDIA_DEST = NULL]
    NOT EXISTS (SELECT ID_ATTENDANCE_REQUEST FROM ICS_ATTENDANCE_REQUEST
                WHERE ID_PAYMENT_MEDIA_ORIGIN = pmRel.ID_PAYMENT_MEDIA AND
                    ID_PAYMENT_MEDIA_DEST IS NOT NULL)
  AND
    product.PRODUCT_TYPE NOT IN (4)


-- Query que busca productos a los cuales se puede Upgradear una tarjeta, a partir del producto actual de la tarjeta



---
SELECT count(*) FROM ICS_ATTENDANCE_REQUEST
SELECT top 10 * FROM ICS_ATTENDANCE_REQUEST order by ATTENDANCE_REAL_DATE desc
SELECT TOP 10
    ID_ATTENDANCE_REQUEST,
    ID_PAYMENT_MEDIA_ORIGIN,
    ID_PAYMENT_MEDIA_DEST,
    ID_REEMISSION_REASON,
    ATTENDANCE_BUSINESS_DATE,
    ID_USER
-- agregá solo las columnas que realmente necesitás
FROM ICS_ATTENDANCE_REQUEST WITH (NOLOCK)
where id_user = 36
ORDER BY ID_ATTENDANCE_REQUEST DESC;
---

SELECT '0' CANTIDAD_REGISTROS_MAYOR_O_IGUAL, COUNT(*) CANT_REGISTRO_REAL
from TRD_SYSTEM_SERVICE
WHERE OPERATION_NAME = 'UpgradeAccountProductChange';

INSERT INTO TRD_SYSTEM_SERVICE values ('IAccountMaintenance', 'UpgradeAccountProductChange', 0);
INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
SELECT 'IAccountMaintenance',
       'UpgradeAccountProductChange',
       ID_ROLE,
       1,
       3
FROM TRD_ROLE;