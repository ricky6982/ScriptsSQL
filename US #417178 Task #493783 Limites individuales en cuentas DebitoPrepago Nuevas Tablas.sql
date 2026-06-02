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

            CONSTRAINT FK_ICS_ACC_REL_PARAM_C_PARAMETER
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
            ID_ACCOUNT_RELATION_PARAMETER_H bigint IDENTITY(1,1) NOT NULL,
            ID_ACCOUNT_RELATION             int                NOT NULL,
            LIMIT_AMOUNT                    decimal(18,2)      NOT NULL,
            VALID_FROM                      datetime           NOT NULL,
            VALID_TO                        datetime           NULL,
            CREATED_BY                      varchar(100)       NOT NULL,
            CREATED_DATETIME                datetime           NOT NULL DEFAULT GETDATE(),
            CLOSED_BY                       varchar(100)       NULL,
            CLOSED_DATETIME                 datetime           NULL,

            CONSTRAINT PK_ICS_ACCOUNT_RELATION_PARAMETER_H
                PRIMARY KEY (ID_ACCOUNT_RELATION_PARAMETER_H),

            CONSTRAINT FK_ICS_ACC_REL_PARAM_H_ACCOUNT_REL
                FOREIGN KEY (ID_ACCOUNT_RELATION)
                    REFERENCES ICS_ACCOUNT_RELATION (ID_ACCOUNT_RELATION),

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

