-- 1. Registrar servicio: GetOfferSettlementModels
IF NOT EXISTS (SELECT 1 FROM TRD_SYSTEM_SERVICE WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService' AND OPERATION_NAME = 'GetOfferSettlementModels')
    BEGIN
        INSERT INTO TRD_SYSTEM_SERVICE (INTERFACE_NAME, OPERATION_NAME, IS_IDEMPOTENT)
        VALUES ('IAccountSettlementModelBulkService', 'GetOfferSettlementModels', 0);
    END;

-- 2. Asignar permisos a roles admin: GetOfferSettlementModels
INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
SELECT 'IAccountSettlementModelBulkService', 'GetOfferSettlementModels', ID_ROLE, 1, 3
FROM TRD_ROLE r
WHERE lower(r.ROLE_NAME) LIKE 'admin%'
  AND NOT EXISTS (
    SELECT 1 FROM TRD_SERVICE_PERM
    WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
      AND OPERATION_NAME = 'GetOfferSettlementModels'
      AND ID_ROLE = r.ID_ROLE
      AND ID_PLATFORM = 1
);

-- 3. Registrar servicio: FilterAccountsForBulkUpdate
IF NOT EXISTS (SELECT 1 FROM TRD_SYSTEM_SERVICE WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService' AND OPERATION_NAME = 'FilterAccountsForBulkUpdate')
    BEGIN
        INSERT INTO TRD_SYSTEM_SERVICE (INTERFACE_NAME, OPERATION_NAME, IS_IDEMPOTENT)
        VALUES ('IAccountSettlementModelBulkService', 'FilterAccountsForBulkUpdate', 0);
    END;

-- 4. Asignar permisos a roles admin: FilterAccountsForBulkUpdate
INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
SELECT 'IAccountSettlementModelBulkService', 'FilterAccountsForBulkUpdate', ID_ROLE, 1, 3
FROM TRD_ROLE r
WHERE lower(r.ROLE_NAME) LIKE 'admin%'
  AND NOT EXISTS (
    SELECT 1 FROM TRD_SERVICE_PERM
    WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
      AND OPERATION_NAME = 'FilterAccountsForBulkUpdate'
      AND ID_ROLE = r.ID_ROLE
      AND ID_PLATFORM = 1
);

-- 5. Registrar servicio: SaveBulk
IF NOT EXISTS (SELECT 1 FROM TRD_SYSTEM_SERVICE WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService' AND OPERATION_NAME = 'SaveBulk')
    BEGIN
        INSERT INTO TRD_SYSTEM_SERVICE (INTERFACE_NAME, OPERATION_NAME, IS_IDEMPOTENT)
        VALUES ('IAccountSettlementModelBulkService', 'SaveBulk', 0);
    END;

-- 6. Asignar permisos a roles admin: SaveBulk
INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
SELECT 'IAccountSettlementModelBulkService', 'SaveBulk', ID_ROLE, 1, 3
FROM TRD_ROLE r
WHERE lower(r.ROLE_NAME) LIKE 'admin%'
  AND NOT EXISTS (
    SELECT 1 FROM TRD_SERVICE_PERM
    WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
      AND OPERATION_NAME = 'SaveBulk'
      AND ID_ROLE = r.ID_ROLE
      AND ID_PLATFORM = 1
);

-- 7. Registrar use case: ICSUC080_AccountSettlementModelBulk
IF NOT EXISTS (SELECT 1 FROM TVM_USE_CASE WHERE ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk')
    BEGIN
        INSERT INTO TVM_USE_CASE (ID_USE_CASE, INTERFACE_NAME, OPERATION_NAME, DESCRIPTION, USE_CASE_TYPE, ENTITY_TYPE, ID_MODULE)
        VALUES (
                   'ICSUC080_AccountSettlementModelBulk',
                   'IAccountSettlementModelBulkService',
                   'GetOfferSettlementModels',
                   'Actualización masiva de modelo de liquidación de cuenta por oferta de producto',
                   3,
                   2,
                   'ICS');
    END;

-- 8. Asociar use case a plataforma
IF NOT EXISTS (SELECT 1 FROM TVM_USE_CASE_PLATFORM WHERE ID_PLATFORM = 1 AND ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk')
    BEGIN
        INSERT INTO TVM_USE_CASE_PLATFORM (ID_PLATFORM, ID_USE_CASE)
        VALUES (1, 'ICSUC080_AccountSettlementModelBulk');
    END;

-- 9. Agregar ítem al menú de mantenimiento
IF NOT EXISTS (SELECT 1 FROM TVM_MENU_ITEM WHERE ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk')
    BEGIN
        INSERT INTO TVM_MENU_ITEM
        VALUES (
                   1,
                   (SELECT MAX(ID_MENU_ITEM) + 1 FROM TVM_MENU_ITEM),
                   'ICS',
                   2,
                   (SELECT ISNULL(MAX(MENU_ITEM_ORDER), 0) + 1
                    FROM TVM_MENU_ITEM
                    WHERE ID_FATHER_MI = (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'CUSTOMER_KEY')),
                   'ICSUC080_AccountSettlementModelBulk',
                   (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'CUSTOMER_KEY'),
                   NULL,
                   0);
    END;
------ ROLLBACK

-- 9. Eliminar ítem del menú de mantenimiento
DELETE FROM TVM_MENU_ITEM
WHERE ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk';

-- 8. Eliminar asociación de use case a plataforma
DELETE FROM TVM_USE_CASE_PLATFORM
WHERE ID_PLATFORM = 1
  AND ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk';

-- 7. Eliminar use case: ICSUC080_AccountSettlementModelBulk
DELETE FROM TVM_USE_CASE
WHERE ID_USE_CASE = 'ICSUC080_AccountSettlementModelBulk';

-- 6. Eliminar permisos a roles admin: SaveBulk
DELETE FROM TRD_SERVICE_PERM
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'SaveBulk'
  AND ID_PLATFORM = 1;

-- 5. Eliminar servicio: SaveBulk
DELETE FROM TRD_SYSTEM_SERVICE
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'SaveBulk';

-- 4. Eliminar permisos a roles admin: FilterAccountsForBulkUpdate
DELETE FROM TRD_SERVICE_PERM
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'FilterAccountsForBulkUpdate'
  AND ID_PLATFORM = 1;

-- 3. Eliminar servicio: FilterAccountsForBulkUpdate
DELETE FROM TRD_SYSTEM_SERVICE
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'FilterAccountsForBulkUpdate';

-- 2. Eliminar permisos a roles admin: GetOfferSettlementModels
DELETE FROM TRD_SERVICE_PERM
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'GetOfferSettlementModels'
  AND ID_PLATFORM = 1;

-- 1. Eliminar servicio: GetOfferSettlementModels
DELETE FROM TRD_SYSTEM_SERVICE
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
  AND OPERATION_NAME = 'GetOfferSettlementModels';

----- skip payment
INSERT INTO TRD_SYSTEM_SERVICE VALUES ('IAccount','SkipPaymentMassive',0);
INSERT INTO TRD_SERVICE_PERM VALUES('IAccount','SkipPaymentMassive',1,1,3);
INSERT INTO TVM_USE_CASE VALUES('ICSU077_SkipPaymentMassive','IAccount','SkipPaymentMassive','Setear Skip Payment',3,1,'ICS');
INSERT INTO TVM_USE_CASE_PLATFORM VALUES(1,'ICSU077_SkipPaymentMassive');

INSERT INTO TVM_MENU_ITEM
VALUES (
           1,
           (SELECT MAX(ID_MENU_ITEM) +1 FROM TVM_MENU_ITEM),
           'ICS',
           2,
           (SELECT MAX(MENU_ITEM_ORDER)+1 FROM TVM_MENU_ITEM
            WHERE ID_FATHER_MI = (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'CUSTOMER_KEY')),
           'ICSU077_SkipPaymentMassive',
           (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'CUSTOMER_KEY'),
           NULL,
           0
       );


select * from TVM_CONTEXT_MENU
select * from TVM_MENU_ITEM;
SELECT * FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'MAINTENANCE_KEY'
SELECT * FROM TVM_MENU_ITEM mi
        inner join TVM_CONTEXT_MENU cm on mi.ID_CONTEXT_MENU = cm.ID_CONTEXT_MENU
WHERE mi.RESOURCE_KEY = 'CUSTOMER_KEY' OR  mi.RESOURCE_KEY = 'MAINTENANCE_KEY'

select * from IBC_PRODUCT
select * from IAC_ACCOUNT_SETT_MODEL

SELECT ID_ACC_SETT_MOD as IdAccSettMod,
       ID_GENERAL_ACCOUNT as IdGeneralAccount,
       ID_SETTLEMENT_MODEL as IdSettlementModel,
       VALID_FROM as ValidFrom,
       VALID_TO as ValidTo
FROM IAC_ACCOUNT_SETT_MODEL
WHERE ID_ISSUER = :IdIssuer
  AND ID_GENERAL_ACCOUNT in :IdGeneralAccount
  AND ID_ISS_SETT_MOD_TYPE = 3;

INSERT INTO IAC_ACCOUNT_SETT_MODEL (
    ID_ACC_SETT_MOD,
    ID_ISSUER,
    ID_GENERAL_ACCOUNT,
    VALID_FROM,
    VALID_TO,
    ID_SETTLEMENT_MODEL,
    CREATION_DATE,
    ID_ISS_SETT_MOD_TYPE
)
VALUES (
    (SELECT ISNULL(MAX(ID_ACC_SETT_MOD), 0) + 1 FROM IAC_ACCOUNT_SETT_MODEL),
    :IdIssuer,
    :IdGeneralAccount,
    :ValidFrom,
    :ValidTo,
    :IdSettlementModel,
    GETDATE(),
    3
);

UPDATE asm
SET asm.ID_SETTLEMENT_MODEL = :IdSettlementModel,
    asm.VALID_FROM = :ValidFrom,
    asm.VALID_TO = :ValidTo
FROM IAC_ACCOUNT_SETT_MODEL asm
WHERE
  asm.ID_ACC_SETT_MOD in :IdAccSettMod;

select *
FROM IAC_ACCOUNT_SETT_MODEL asm
INNER JOIN IAC_GENERAL_ACCOUNT ga ON asm.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT
WHERE
    asm.ID_ISSUER = :IdIssuer
    AND asm.VALID_FROM <= :customDate AND :customDate <= asm.VALID_TO;

select *
FROM IBC_ISSUER_SETT_MODEL_TYPE

select *
FROM IAC_ACCOUNT_SETT_MODEL;

ALTER TABLE IAC_ACCOUNT_SETT_MODEL
    ADD ID_ISS_SETT_MOD_TYPE BIGINT NULL;

ALTER TABLE IAC_ACCOUNT_SETT_MODEL
    ADD CONSTRAINT FK_IAC_ACCSM_REFERENCE_IBC_ISMT
        FOREIGN KEY (ID_ISS_SETT_MOD_TYPE)
            REFERENCES IBC_ISSUER_SETT_MODEL_TYPE (ID_ISS_SETT_MOD_TYPE);

-- Rollback: Eliminar FK constraint
ALTER TABLE IAC_ACCOUNT_SETT_MODEL
    DROP CONSTRAINT FK_IAC_ACCSM_REFERENCE_IBC_ISMT;

-- Rollback: Eliminar columna
ALTER TABLE IAC_ACCOUNT_SETT_MODEL
    DROP COLUMN ID_ISS_SETT_MOD_TYPE;

select * from DATABASECHANGELOG where AUTHOR = 'csulbaran'

select *
FROM


select * FROM IAC_GENERAL_ACCOUNT
select * FROM ICS_FINANCIAL_RELATION
select * FROM ICS_CUSTOMER
select * FROM ICS_ACCOUNT_RELATION

-- Eliminar historico de requests/resultados
DELETE FROM TRD_SESN_REQ_RES_H
WHERE ID_SESSION_REQ_RESULT_H IN (
    SELECT ID_SESSION_REQUEST_H
    FROM TRD_SESSION_REQ_H
    WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
       OR INTERFACE_NAME LIKE 'IResto%'
);

DELETE FROM TRD_SESSION_REQ_H
WHERE INTERFACE_NAME = 'IAccountSettlementModelBulkService'
   OR INTERFACE_NAME LIKE 'IResto%';

select * from DATABASECHANGELOG where AUTHOR = 'rsarapura'
select * from TRD_SERVICE_PERM where INTERFACE_NAME = 'IAccountSettlementModelBulkService' or INTERFACE_NAME LIKE 'IResto%'
