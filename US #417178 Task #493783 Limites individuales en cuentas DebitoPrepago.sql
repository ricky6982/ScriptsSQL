IF NOT EXISTS (SELECT 1 FROM TRD_SYSTEM_SERVICE WHERE INTERFACE_NAME = 'IIndividualDebitAccountLimitsService' AND OPERATION_NAME = 'GetCustomersByAccount')
    BEGIN
        INSERT INTO TRD_SYSTEM_SERVICE (INTERFACE_NAME, OPERATION_NAME, IS_IDEMPOTENT)
        VALUES ('IIndividualDebitAccountLimitsService', 'GetActiveIndividualLimitByIssuerAndAccount', 0);
    END;

INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
SELECT 'IIndividualDebitAccountLimitsService', 'GetActiveIndividualLimitByIssuerAndAccount', ID_ROLE, 1, 3
FROM TRD_ROLE r
WHERE lower(r.ROLE_NAME) LIKE 'admin%'
  AND NOT EXISTS (
    SELECT 1 FROM TRD_SERVICE_PERM
    WHERE INTERFACE_NAME = 'IIndividualDebitAccountLimitsService'
      AND OPERATION_NAME = 'GetActiveIndividualLimitByIssuerAndAccount'
      AND ID_ROLE = r.ID_ROLE
      AND ID_PLATFORM = 1
);


IF NOT EXISTS (SELECT 1 FROM TVM_USE_CASE WHERE ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits')
    BEGIN
        INSERT INTO TVM_USE_CASE (ID_USE_CASE, INTERFACE_NAME, OPERATION_NAME, DESCRIPTION, USE_CASE_TYPE, ENTITY_TYPE, ID_MODULE)
        VALUES (
                   'ICSUC078_IndividualDebitAccountLimits',
                   'IIndividualDebitAccountLimitsService',
                   'GetActiveIndividualLimitByIssuerAndAccount',
                   'Gestionar limites individuales de cuenta debito-prepago',
                   3,
                   2,
                   'ICS');
    END;

IF NOT EXISTS (SELECT 1 FROM TVM_USE_CASE_PLATFORM WHERE ID_PLATFORM = 1 AND ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits')
    BEGIN
        INSERT INTO TVM_USE_CASE_PLATFORM (ID_PLATFORM, ID_USE_CASE)
        VALUES (1, 'ICSUC078_IndividualDebitAccountLimits');
    END;

IF NOT EXISTS (SELECT 1 FROM TVM_MENU_ITEM WHERE ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits')
    BEGIN
        INSERT INTO TVM_MENU_ITEM
        VALUES (
                   8,
                   (SELECT MAX(ID_MENU_ITEM) + 1 FROM TVM_MENU_ITEM),
                   'ICS',
                   2,
                   (SELECT ISNULL(MAX(MENU_ITEM_ORDER), 0) + 1
                    FROM TVM_MENU_ITEM
                    WHERE ID_FATHER_MI = (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'MAINTENANCE_KEY' AND ID_CONTEXT_MENU = 8)),
                   'ICSUC078_IndividualDebitAccountLimits',
                   (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'MAINTENANCE_KEY' AND ID_CONTEXT_MENU = 8),
                   NULL,
                   0);
    END;


SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'MAINTENANCE_KEY' AND ID_CONTEXT_MENU = 8;

SELECT ISNULL(MAX(MENU_ITEM_ORDER), 0) + 1
FROM TVM_MENU_ITEM
WHERE ID_FATHER_MI = (SELECT ID_MENU_ITEM FROM TVM_MENU_ITEM WHERE RESOURCE_KEY = 'MAINTENANCE_KEY' AND ID_CONTEXT_MENU = 8)

DELETE FROM TVM_MENU_ITEM
WHERE ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits';

DELETE FROM TVM_USE_CASE_PLATFORM
WHERE ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits';

DELETE FROM TVM_USE_CASE
WHERE ID_USE_CASE = 'ICSUC078_IndividualDebitAccountLimits';

DELETE FROM TRD_SERVICE_PERM
WHERE INTERFACE_NAME = 'IIndividualDebitAccountLimitsService'
  AND OPERATION_NAME = 'GetActiveIndividualLimitByIssuerAndAccount';

DELETE FROM TRD_SYSTEM_SERVICE
WHERE INTERFACE_NAME = 'IIndividualDebitAccountLimitsService' AND OPERATION_NAME = 'GetCustomersByAccount';
