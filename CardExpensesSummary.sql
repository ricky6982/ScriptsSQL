-------
------- 463870 - 434439 - IMovementService_ExpensesSummary - GetAccountExpensesSummary - GetCardExpensesSummary
-------

------- ------- -------
-- #DML
------- ------- -------
IF (SELECT COUNT(*)
    FROM TRD_SYSTEM_SERVICE
    WHERE INTERFACE_NAME = 'IMovementService'
      AND OPERATION_NAME IN ('GetAccountExpensesSummary', 'GetCardExpensesSummary')) < 2
    BEGIN
        INSERT INTO TRD_SYSTEM_SERVICE values ('IMovementService', 'GetAccountExpensesSummary', 0);
        INSERT INTO TRD_SYSTEM_SERVICE values ('IMovementService', 'GetCardExpensesSummary', 0);

        INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
        SELECT 'IMovementService',
               'GetAccountExpensesSummary',
               ID_ROLE,
               1,
               3
        FROM TRD_ROLE;

        INSERT INTO TRD_SERVICE_PERM (INTERFACE_NAME, OPERATION_NAME, ID_ROLE, ID_PLATFORM, PERMISSION)
        SELECT 'IMovementService',
               'GetCardExpensesSummary',
               ID_ROLE,
               1,
               3
        FROM TRD_ROLE;
    END;

------- ------- -------
-- #BEFORE_AFTER
------- ------- -------

SELECT INTERFACE_NAME, OPERATION_NAME
FROM TRD_SYSTEM_SERVICE
WHERE INTERFACE_NAME = 'IMovementService'
  AND OPERATION_NAME IN ('GetAccountExpensesSummary', 'GetCardExpensesSummary');
SELECT INTERFACE_NAME, OPERATION_NAME, ID_ROLE, PERMISSION
FROM TRD_SERVICE_PERM
WHERE INTERFACE_NAME = 'IMovementService'
  AND OPERATION_NAME IN ('GetAccountExpensesSummary', 'GetCardExpensesSummary');

------- ------- -------
-- #ROLLBACK
------- ------- -------

IF EXISTS (SELECT 1
           FROM TRD_SYSTEM_SERVICE
           WHERE INTERFACE_NAME = 'IMovementService'
             AND OPERATION_NAME = 'GetAccountExpensesSummary')
    BEGIN
        DELETE
        FROM TRD_SERVICE_PERM
        WHERE INTERFACE_NAME = 'IMovementService'
          AND OPERATION_NAME = 'GetAccountExpensesSummary';
        DELETE
        FROM TRD_SYSTEM_SERVICE
        WHERE INTERFACE_NAME = 'IMovementService'
          AND OPERATION_NAME = 'GetAccountExpensesSummary';
    END;

IF EXISTS (SELECT 1
           FROM TRD_SYSTEM_SERVICE
           WHERE INTERFACE_NAME = 'IMovementService'
             AND OPERATION_NAME = 'GetCardExpensesSummary')
    BEGIN
        DELETE
        FROM TRD_SERVICE_PERM
        WHERE INTERFACE_NAME = 'IMovementService'
          AND OPERATION_NAME = 'GetCardExpensesSummary';
        DELETE
        FROM TRD_SYSTEM_SERVICE
        WHERE INTERFACE_NAME = 'IMovementService'
          AND OPERATION_NAME = 'GetCardExpensesSummary';
    END;


-- Account Expenses Summary
SELECT pm.CARD_NUMBER                                      AS CardNumber,
       COALESCE(SUM(mov.AMOUNT * mov.MOVEMENT_SIGN), 0.00) AS Amount
FROM IAC_PAYMENT_MEDIA pm
         JOIN ICS_PAYMENT_MEDIA_RELATION pmr ON pm.ID_PAYMENT_MEDIA = pmr.ID_PAYMENT_MEDIA
         JOIN ICS_ACCOUNT_RELATION ar ON pmr.ID_ACCOUNT_RELATION = ar.ID_ACCOUNT_RELATION
         JOIN ICS_FINANCIAL_RELATION fr ON ar.ID_FINANCIAL_RELATION = fr.ID_FINANCIAL_RELATION
         JOIN IAC_GENERAL_ACCOUNT ga ON fr.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT
         LEFT JOIN IFN_MOVEMENT mov ON ga.ID_GENERAL_ACCOUNT = mov.ID_GENERAL_ACCOUNT_PERF
    AND mov.ID_CYCLE = ga.ID_CYCLE
    AND mov.PERIOD = ga.ACCOUNT_PERIOD
         LEFT JOIN IOP_OPERATION o ON o.ID_OPERATION = mov.ID_OPERATION
WHERE ga.INTERNAL_ACCOUNT_NUMBER = ''
  AND ((o.OPERATION_TYPE = 1 AND mov.MOVEMENT_TYPE = 4) OR (o.OPERATION_TYPE = 2 AND mov.MOVEMENT_TYPE = 13))
GROUP BY pm.CARD_NUMBER

-- Card Expenses Summary
SELECT pm.CARD_NUMBER                                      AS CardNumber,
       COALESCE(SUM(mov.AMOUNT * mov.MOVEMENT_SIGN), 0.00) AS Amount
FROM IAC_PAYMENT_MEDIA pm
         JOIN ICS_PAYMENT_MEDIA_RELATION pmr ON pm.ID_PAYMENT_MEDIA = pmr.ID_PAYMENT_MEDIA
         JOIN ICS_ACCOUNT_RELATION ar ON pmr.ID_ACCOUNT_RELATION = ar.ID_ACCOUNT_RELATION
         JOIN ICS_FINANCIAL_RELATION fr ON ar.ID_FINANCIAL_RELATION = fr.ID_FINANCIAL_RELATION
         JOIN IAC_GENERAL_ACCOUNT ga ON fr.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT
         LEFT JOIN IFN_MOVEMENT mov ON ga.ID_GENERAL_ACCOUNT = mov.ID_GENERAL_ACCOUNT_PERF
    AND mov.ID_CYCLE = ga.ID_CYCLE
    AND mov.PERIOD = ga.ACCOUNT_PERIOD
         LEFT JOIN IOP_OPERATION o ON o.ID_OPERATION = mov.ID_OPERATION
WHERE pm.CARD_NUMBER = '1000000203703207'
  AND pm.DUE_DATE = '2030-10-01 00:00:00'
  AND ((o.OPERATION_TYPE = 1 AND mov.MOVEMENT_TYPE = 4) OR (o.OPERATION_TYPE = 2 AND mov.MOVEMENT_TYPE = 13))
GROUP BY pm.CARD_NUMBER

-- Obtener resumén de cada tarjeta
SELECT pm.CARD_NUMBER                                      AS CardNumber,
       COALESCE(SUM(mov.AMOUNT * mov.MOVEMENT_SIGN), 0.00) AS Amount
FROM IAC_PAYMENT_MEDIA pm
         JOIN ICS_PAYMENT_MEDIA_RELATION pmr ON pm.ID_PAYMENT_MEDIA = pmr.ID_PAYMENT_MEDIA
         JOIN ICS_ACCOUNT_RELATION ar ON pmr.ID_ACCOUNT_RELATION = ar.ID_ACCOUNT_RELATION
         JOIN ICS_FINANCIAL_RELATION fr ON ar.ID_FINANCIAL_RELATION = fr.ID_FINANCIAL_RELATION
         JOIN IAC_GENERAL_ACCOUNT ga ON fr.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT
         LEFT JOIN IFN_MOVEMENT mov ON ga.ID_GENERAL_ACCOUNT = mov.ID_GENERAL_ACCOUNT_PERF
    AND mov.ID_CYCLE = ga.ID_CYCLE
    AND mov.PERIOD = ga.ACCOUNT_PERIOD
    AND ((mov.MOVEMENT_TYPE = 4) OR (mov.MOVEMENT_TYPE = 13))
         LEFT JOIN IOP_OPERATION o ON o.ID_OPERATION = mov.ID_OPERATION
    AND ((o.OPERATION_TYPE = 1 AND mov.MOVEMENT_TYPE = 4) OR (o.OPERATION_TYPE = 2 AND mov.MOVEMENT_TYPE = 13))
GROUP BY pm.CARD_NUMBER