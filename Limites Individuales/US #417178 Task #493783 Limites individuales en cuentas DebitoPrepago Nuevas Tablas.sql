-------------------
-- Nuevas tablas --
-------------------

-- Actualizar constraint de tipo de parámetro para permitir el nuevo tipo ACCOUNT_RELATION
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints cc
             JOIN sys.tables t ON t.object_id = cc.parent_object_id
    WHERE t.name = 'C_PARAMETER'
      AND cc.name = 'CKC_PARAMETER_TYPE_C_PARAME'
      AND cc.definition LIKE '%PARAMETER_TYPE] = 10%'
)
    BEGIN
        ALTER TABLE C_PARAMETER
            DROP CONSTRAINT CKC_PARAMETER_TYPE_C_PARAME;

        ALTER TABLE C_PARAMETER
            ADD CONSTRAINT CKC_PARAMETER_TYPE_C_PARAME
                CHECK (
                    PARAMETER_TYPE = 10 OR PARAMETER_TYPE = 9 OR PARAMETER_TYPE = 8 OR
                    PARAMETER_TYPE = 7 OR PARAMETER_TYPE = 6 OR PARAMETER_TYPE = 5 OR
                    PARAMETER_TYPE = 4 OR PARAMETER_TYPE = 3 OR PARAMETER_TYPE = 2 OR
                    PARAMETER_TYPE = 1
                    );
    END;

-- Se inserta en la tabla C_PARAMETER el nuevo parámetro 'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS'
IF NOT EXISTS (
    SELECT 1
    FROM C_PARAMETER
    WHERE CODE = 'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS'
)
    BEGIN
        INSERT INTO C_PARAMETER (
            ID_PARAMETER,
            PARAMETER_NAME,
            CODE,
            VALUE_TYPE,
            PARAMETER_TYPE,
            MODULE,
            IS_CONFIGURED_BY_SCREEN
        )
        VALUES (
                   (SELECT MAX(ID_PARAMETER) + 1 FROM C_PARAMETER),
                   'Limites individuales por cuenta, persona y producto',
                   'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS',
                   3,
                   10,
                   'ICS',
                   1
               );
    END;

-- Tabla de relación entre cuenta-persona-producto y parámetros de configuración
IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE object_id = OBJECT_ID(N'ICS_ACCOUNT_RELATION_PARAMETER')
)
    BEGIN
        CREATE TABLE ICS_ACCOUNT_RELATION_PARAMETER
          (
              ID_PARAMETER        int            NOT NULL,
              ID_ACCOUNT_RELATION int            NOT NULL,
              VALID_FROM          datetime       NOT NULL,
              VALID_TO            datetime       NULL,
              DATE_VALUE          datetime       NULL,
              STRING_VALUE        nvarchar(400)  NULL,
              REAL_VALUE          decimal(18, 6) NULL,
              INTEGER_VALUE       bigint         NULL,

              CONSTRAINT PK_ICS_ACCOUNT_RELATION_PARAMETER
                  PRIMARY KEY (ID_PARAMETER, ID_ACCOUNT_RELATION, VALID_FROM),

              CONSTRAINT FK_ICS_ACC_REL_PARAM_PARAMETER
                  FOREIGN KEY (ID_PARAMETER)
                      REFERENCES C_PARAMETER (ID_PARAMETER),

              CONSTRAINT FK_ICS_ACC_REL_PARAM_ACCOUNT_REL
                  FOREIGN KEY (ID_ACCOUNT_RELATION)
                      REFERENCES ICS_ACCOUNT_RELATION (ID_ACCOUNT_RELATION)
          );
    END;

-- Tabla de históricos
IF NOT EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE object_id = OBJECT_ID(N'ICS_ACCOUNT_RELATION_PARAMETER_H')
)
    BEGIN
        CREATE TABLE ICS_ACCOUNT_RELATION_PARAMETER_H
        (
            ID_ACCOUNT_RELATION_PARAMETER_H int IDENTITY (1,1) NOT NULL,
            ID_PARAMETER                    int                NOT NULL,
            ID_ACCOUNT_RELATION             int                NOT NULL,
            VALID_FROM                      datetime           NOT NULL,
            LIMIT_AMOUNT                    decimal(18, 2)     NOT NULL,
            ID_USER                         int                NOT NULL,
            REAL_DATETIME                   datetime           NOT NULL DEFAULT GETDATE(),

            CONSTRAINT PK_ICS_ACCOUNT_RELATION_PARAMETER_H
                PRIMARY KEY (ID_ACCOUNT_RELATION_PARAMETER_H),

            CONSTRAINT FK_ICS_ACC_REL_H_PARAM_PARAMETER
                FOREIGN KEY (ID_PARAMETER)
                    REFERENCES C_PARAMETER (ID_PARAMETER),
            CONSTRAINT FK_ICS_ACC_REL_PARAM_H_ACCOUNT_REL
                FOREIGN KEY (ID_ACCOUNT_RELATION)
                    REFERENCES ICS_ACCOUNT_RELATION (ID_ACCOUNT_RELATION),
            CONSTRAINT FK_ICS_ACC_REL_PARAM_H_USER
                FOREIGN KEY (ID_USER)
                    REFERENCES TRD_USER (ID_USER),
            CONSTRAINT CHK_ICS_ACC_REL_PARAM_H_LIMIT_AMOUNT
                CHECK (LIMIT_AMOUNT > 0)
        );
    END;

---------------
-- Rollbacks --
---------------

-- 1. DROP tabla de históricos
IF EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE object_id = OBJECT_ID(N'ICS_ACCOUNT_RELATION_PARAMETER_H')
)
    BEGIN
        DROP TABLE ICS_ACCOUNT_RELATION_PARAMETER_H;
    END;

-- 2. DROP tabla de relación cuenta-persona-producto / parámetros
IF EXISTS (
    SELECT 1
    FROM sys.tables
    WHERE object_id = OBJECT_ID(N'ICS_ACCOUNT_RELATION_PARAMETER')
)
    BEGIN
        DROP TABLE ICS_ACCOUNT_RELATION_PARAMETER;
    END;

-- 3. Eliminar parámetro INDIVIDUAL_DEBIT_ACCOUNT_LIMITS
IF EXISTS (
    SELECT 1
    FROM C_PARAMETER
    WHERE CODE = 'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS'
)
    BEGIN
        DELETE FROM C_PARAMETER
        WHERE CODE = 'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS';
    END;

-- 4. Revertir constraint CKC_PARAMETER_TYPE_C_PARAME
IF EXISTS (
    SELECT 1
    FROM sys.check_constraints cc
             JOIN sys.tables t ON t.object_id = cc.parent_object_id
    WHERE t.name = 'C_PARAMETER'
      AND cc.name = 'CKC_PARAMETER_TYPE_C_PARAME'
      AND cc.definition LIKE '%PARAMETER_TYPE] = 10%'
)
    BEGIN
        ALTER TABLE C_PARAMETER
            DROP CONSTRAINT CKC_PARAMETER_TYPE_C_PARAME;

        ALTER TABLE C_PARAMETER
            ADD CONSTRAINT CKC_PARAMETER_TYPE_C_PARAME
                CHECK (
                    PARAMETER_TYPE = 9 OR PARAMETER_TYPE = 8 OR PARAMETER_TYPE = 7 OR
                    PARAMETER_TYPE = 6 OR PARAMETER_TYPE = 5 OR PARAMETER_TYPE = 4 OR
                    PARAMETER_TYPE = 3 OR PARAMETER_TYPE = 2 OR PARAMETER_TYPE = 1
                    );
    END;

---------------------------------
-- Query para recuperar históricos --
select arph.ID_ACCOUNT_RELATION_PARAMETER_H as Id
     , arph.ID_PARAMETER                    as IdParemeter
     , arph.ID_ACCOUNT_RELATION             as IdAccountRelation
     , arph.VALID_FROM                      as ValidFrom
     , arph.LIMIT_AMOUNT                    as LimitAmount
     , arph.ID_USER                         as IdUser
     , u.FIRST_NAME                         as FirstName
     , u.SURNAME                            as Surname
     , u.E_MAIL                             as Email
     , arph.REAL_DATETIME                   as ValidTo
from ICS_ACCOUNT_RELATION_PARAMETER_H arph
         inner join TRD_USER u on u.ID_USER = arph.ID_USER
where ID_PARAMETER = :IdParameter
  and ID_ACCOUNT_RELATION = :IdAccountRelation
order by REAL_DATETIME desc
SELECT
    arph.ID_ACCOUNT_RELATION_PARAMETER_H AS Id,
    arph.ID_PARAMETER                    AS IdParameter,
    arph.ID_ACCOUNT_RELATION             AS IdAccountRelation,
    arph.VALID_FROM                      AS ValidFrom,
    arph.LIMIT_AMOUNT                    AS LimitAmount,
    arph.ID_USER                         AS IdUser,
    u.FIRST_NAME                         AS FirstName,
    u.SURNAME                            AS Surname,
    u.E_MAIL                             AS Email,
    arph.REAL_DATETIME                   AS ValidTo
FROM ICS_ACCOUNT_RELATION_PARAMETER_H arph
         INNER JOIN TRD_USER u
                    ON u.ID_USER = arph.ID_USER
WHERE arph.ID_PARAMETER = :IdParameter
  AND arph.ID_ACCOUNT_RELATION = :IdAccountRelation
ORDER BY arph.REAL_DATETIME DESC;
;

-- id_user = 1
-- id_account_relation = 287
-- id_parameter = 545

select * from C_PARAMETER
where CODE = 'INDIVIDUAL_DEBIT_ACCOUNT_LIMITS';
select * from TRD_USER
select * from ICS_ACCOUNT_RELATION
where ID_ISSUER = 100
order by ID_ACCOUNT_RELATION desc


-- Datos de prueba para la tabla de históricos
INSERT INTO dbo.ICS_ACCOUNT_RELATION_PARAMETER_H
    (ID_PARAMETER, ID_ACCOUNT_RELATION, VALID_FROM, LIMIT_AMOUNT, ID_USER, REAL_DATETIME)
VALUES
    (545, 270, '2025-01-01 00:00:00', 1000.00, 1, '2025-01-15 00:00:00'),
    (545, 270, '2025-01-15 00:00:00', 1500.00, 1, '2025-02-01 00:00:00'),
    (545, 270, '2025-02-01 00:00:00', 2000.00, 1, '2025-02-15 00:00:00'),
    (545, 270, '2025-02-15 00:00:00', 1800.00, 1, '2025-03-01 00:00:00'),
    (545, 270, '2025-03-01 00:00:00', 2500.00, 1, '2025-03-15 00:00:00'),
    (545, 270, '2025-03-15 00:00:00', 3000.00, 1, '2025-04-01 00:00:00'),
    (545, 271, '2025-04-01 00:00:00', 2800.00, 1, '2025-04-15 00:00:00'),
    (545, 271, '2025-04-15 00:00:00', 3200.00, 1, '2025-05-01 00:00:00'),
    (545, 271, '2025-05-01 00:00:00', 1200.00, 1, '2025-05-15 00:00:00'),
    (545, 271, '2025-05-15 00:00:00', 1750.00, 1, '2025-06-01 00:00:00'),
    (545, 271, '2025-06-01 00:00:00', 2100.00, 1, '2025-06-15 00:00:00'),
    (545, 271, '2025-06-15 00:00:00', 2600.00, 1, '2025-07-01 00:00:00'),
    (545, 271, '2025-07-01 00:00:00', 3100.00, 1, '2025-07-15 00:00:00'),
    (545, 271, '2025-07-15 00:00:00', 2900.00, 1, '2025-08-01 00:00:00'),
    (545, 271, '2025-08-01 00:00:00', 3500.00, 1, '2025-08-15 00:00:00'),
    (545, 271, '2025-08-15 00:00:00', 4000.00, 1, '2025-09-01 00:00:00'),
    (545, 271, '2025-09-01 00:00:00', 3800.00, 1, '2025-10-01 00:00:00'),
    (545, 271, '2025-10-01 00:00:00', 4200.00, 1, '2025-11-01 00:00:00'),
    (545, 271, '2025-11-01 00:00:00', 3600.00, 1, '2025-12-01 00:00:00'),
    (545, 271, '2025-12-01 00:00:00', 5000.00, 1, '9999-12-31 00:00:00'); -- aún vigente


-- Query para recuperar Customers --
SELECT finRel.ID_FINANCIAL_RELATION    as IdFinancialRelation,
       customer.ID_CUSTOMER            AS IdCustomer,
       customer.DOCUMENT               AS Document,
       customer.ID_DOCUMENT_TYPE       AS DocumentType,
       customer.CUSTOMER_TYPE          AS CustomerType,
       physicalCustomer.NAME           AS CustomerName,
       physicalCustomer.SURNAME        AS CustomerSurname,
       physicalCustomer.SECOND_NAME    AS CustomerSecondName,
       physicalCustomer.SECOND_SURNAME AS CustomerSecondSurname,
       doc.DESCRIPTION                 AS DocumentTypeName,
       doc.MASK                        AS DocumentMask,
       accStat.DESCRIPTION             AS DescAccStatus,
       accStat.STATUS_TYPE             AS AccStatusType,
       MAX(
               CASE
                   WHEN arp.REAL_VALUE > 0 THEN 1
                   ELSE 0
                   END
       )                               AS HasIndividualLimits
FROM IAC_GENERAL_ACCOUNT gralAcc
         INNER JOIN ICS_FINANCIAL_RELATION finRel
                    ON gralAcc.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
         INNER JOIN ICS_CUSTOMER customer
                    ON finRel.ID_CUSTOMER = customer.ID_CUSTOMER
         INNER JOIN TGD_DOCUMENT_TYPE doc
                    ON customer.ID_DOCUMENT_TYPE = doc.ID_DOCUMENT_TYPE
         INNER JOIN IBC_ACCOUNT_STATUS accStat
                    ON accStat.ID_ACCOUNT_STATUS = gralAcc.ID_ACCOUNT_STATUS
         LEFT JOIN ICS_PHYSICAL_PERSON_CUSTOMER physicalCustomer
                   ON physicalCustomer.ID_CUSTOMER = customer.ID_CUSTOMER
         LEFT JOIN ICS_CUSTOMER_ADDITIONAL_DOC customerAdd
                   ON customer.ID_CUSTOMER = customerAdd.ID_CUSTOMER
         INNER JOIN ICS_ACCOUNT_RELATION accRel
                    ON accRel.ID_FINANCIAL_RELATION = finRel.ID_FINANCIAL_RELATION
         LEFT JOIN ICS_ACCOUNT_RELATION_PARAMETER arp
                   ON arp.ID_ACCOUNT_RELATION = accRel.ID_ACCOUNT_RELATION
WHERE customer.CUSTOMER_TYPE = 1
  AND gralAcc.ID_ISSUER = :IdIssuer
  AND gralAcc.INTERNAL_ACCOUNT_NUMBER = :InternalAccountNumber
GROUP BY customer.ID_CUSTOMER,
         customer.DOCUMENT,
         customer.ID_DOCUMENT_TYPE,
         customer.CUSTOMER_TYPE,
         physicalCustomer.NAME,
         physicalCustomer.SURNAME,
         physicalCustomer.SECOND_NAME,
         physicalCustomer.SECOND_SURNAME,
         doc.DESCRIPTION,
         doc.MASK,
         gralAcc.ID_GENERAL_ACCOUNT,
         gralAcc.INTERNAL_ACCOUNT_NUMBER,
         gralAcc.ID_MAIN_PRODUCT,
         accStat.DESCRIPTION,
         accStat.STATUS_TYPE,
         customerAdd.DOCUMENT,
         gralAcc.APPLY_PROMOTIONS, finRel.ID_FINANCIAL_RELATION;

select * from ICS_CUSTOMER where DOCUMENT like '%03%'
select * from ICS_PHYSICAL_PERSON_CUSTOMER
select * from IAC_GENERAL_ACCOUNT where INTERNAL_ACCOUNT_NUMBER like '%111%' or EXTERNAL_ACCOUNT_NUMBER like '%111%'

-- Query para contar el número de clientes asociados a cada cuenta --
SELECT
    gralAcc.ID_GENERAL_ACCOUNT as IdGeneralAccount,
    gralAcc.INTERNAL_ACCOUNT_NUMBER AS InternalAccountNumber,
    COUNT(DISTINCT customer.ID_CUSTOMER) AS CustomerCount
FROM IAC_GENERAL_ACCOUNT gralAcc
         INNER JOIN ICS_FINANCIAL_RELATION finRel
                    ON gralAcc.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
         INNER JOIN ICS_CUSTOMER customer
                    ON finRel.ID_CUSTOMER = customer.ID_CUSTOMER
GROUP BY
    gralAcc.INTERNAL_ACCOUNT_NUMBER, gralAcc.ID_GENERAL_ACCOUNT;

select * from ICS_ACCOUNT_RELATION_PARAMETER

-- Query para recuperar los productos asociados a un cliente
SELECT prod.ID_PRODUCT as IdProduct,
       accRel.ID_ACCOUNT_RELATION as IdAccountRelation,
       prod.PRODUCT_NAME as ProductName,
       prod.PRODUCT_TYPE as ProductType,
       accRelParam.REAL_VALUE as LimitAmount,
       accRelParam.VALID_FROM as ValidFrom,
       accRelParam.VALID_TO as ValidTo
FROM ICS_FINANCIAL_RELATION finRel
         INNER JOIN ICS_ACCOUNT_RELATION accRel ON finRel.ID_FINANCIAL_RELATION = accRel.ID_FINANCIAL_RELATION
         INNER JOIN IBC_ISSUER_PRODUCT issuerProd
                    ON issuerProd.ID_PRODUCT = accRel.ID_PRODUCT AND issuerProd.ID_ISSUER = :IdIssuer
         INNER JOIN IBC_PRODUCT prod ON prod.ID_PRODUCT = issuerProd.ID_PRODUCT
         LEFT JOIN ICS_ACCOUNT_RELATION_PARAMETER accRelParam
                   ON accRel.ID_ACCOUNT_RELATION = accRelParam.ID_ACCOUNT_RELATION and
                      accRelParam.ID_PARAMETER = :IdParameter
WHERE finRel.ID_FINANCIAL_RELATION = :IdFinancialRelation

select
    IAR.ID_ACCOUNT_RELATION,
    *

from ICS_FINANCIAL_RELATION
         inner join dbo.ICS_ACCOUNT_RELATION IAR on ICS_FINANCIAL_RELATION.ID_FINANCIAL_RELATION = IAR.ID_FINANCIAL_RELATION
         WHERE ID_GENERAL_ACCOUNT = 248

-- Insert ICS_ACCOUNT_RELATION_PARAMETER
INSERT INTO ICS_ACCOUNT_RELATION_PARAMETER
    (ID_PARAMETER, ID_ACCOUNT_RELATION, VALID_FROM, REAL_VALUE)
VALUES (:IdParameter, :IdAccountRelation, :ValidFrom, :LimitAmount)


INSERT INTO ICS_ACCOUNT_RELATION_PARAMETER_H
(ID_PARAMETER, ID_ACCOUNT_RELATION, VALID_FROM, LIMIT_AMOUNT, ID_USER, REAL_DATETIME)
VALUES (:IdParameter, :IdAccountRelation, :ValidFrom, :LimitAmount, :IdUser, GETDATE())

select * from ICS_ACCOUNT_RELATION_PARAMETER
select * from dbo.IBC_ISSUER_BRAND_PARAMETER where ID_PARAMETER = 302
select * from dbo.IBC_ISSUER_PARAMETER where ID_PARAMETER = 302
select ID_PARAMETER, count(*) from dbo.IBC_ISSUER_BRAND_PARAMETER group by ID_PARAMETER