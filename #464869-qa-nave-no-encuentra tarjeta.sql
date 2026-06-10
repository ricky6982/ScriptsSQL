SELECT
    payMedia.ID_PAYMENT_MEDIA IdPaymentMedia,
    payMedia.CARD_NUMBER CardNumber,
    accRel.ID_PRODUCT IdProduct,
    finRel.ID_GENERAL_ACCOUNT IdGeneralAccount,
    finRel.ID_FINANCIAL_RELATION IdFinancialRelation,
    accRel.ID_ACCOUNT_RELATION IdAccountRelation,
    pms.STATUS_TYPE PaymentMediaStatusType,
    pms.STATUS_CODE PaymentMediaStatusCode,
    pms.DESCRIPTION PaymentMediaStatusDescription,
    payMedia.ID_PAYMENT_MEDIA_STATUS IdPaymentMediaStatus,
    payMedia.TRANSACTION_BIN TransactionBin,
    payMedia.TRANSACTION_MASKED_PAN TransactionMaskedPan,
    payMedia.ID_ISSUER IdIssuer,
    cust.ID_CUSTOMER IdCustomer,
    cust.EMBOSSING_NAME EmbossingName,
    payMedia.CARD_SEQUENCE_NUMBER CardSequenceNumber,
    payMedia.DUE_DATE DueDate,
    payMedia.FULL_DUE_DATE FullDueDate,
    ims.ID_MEDIA_SUPPORT IdMediaSupport,
    ims.MEDIA_SUPPORT_TYPE mediaSupportType,
    prod.ID_BRAND IdBrand,
    cust.ID_DOCUMENT_TYPE DocumentType,
    cust.DOCUMENT DocumentNumber,
    pperson.BIRTH_DATE BirthDate,
    gAcc.INTERNAL_ACCOUNT_NUMBER AccountNumber,
    issProd.EXTERNAL_ISSUER_ID ProductCode,
    prod.PRODUCT_NAME ProductName
FROM
    IAC_PAYMENT_MEDIA payMedia
        INNER JOIN ICS_PAYMENT_MEDIA_RELATION pmRel ON payMedia.ID_PAYMENT_MEDIA = pmRel.ID_PAYMENT_MEDIA
        INNER JOIN ICS_ACCOUNT_RELATION accRel ON accRel.ID_ACCOUNT_RELATION = pmRel.ID_ACCOUNT_RELATION
        INNER JOIN ICS_FINANCIAL_RELATION finRel ON accRel.ID_FINANCIAL_RELATION = finRel.ID_FINANCIAL_RELATION
        INNER JOIN IBC_PAYMENT_MEDIA_STATUS pms on pms.ID_PAYMENT_MEDIA_STATUS = payMedia.ID_PAYMENT_MEDIA_STATUS
        INNER JOIN ICS_CUSTOMER cust ON cust.ID_CUSTOMER = finRel.ID_CUSTOMER
        INNER JOIN IAC_MEDIA_SUPPORT ims ON ims.ID_MEDIA_SUPPORT = payMedia.ID_MEDIA_SUPPORT
        INNER JOIN IBC_PRODUCT prod ON prod.ID_PRODUCT = payMedia.ID_PRODUCT
        LEFT  JOIN ICS_PHYSICAL_PERSON_CUSTOMER pperson ON pperson.ID_CUSTOMER = cust.ID_CUSTOMER
        INNER JOIN IAC_GENERAL_ACCOUNT gAcc ON gAcc.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
        INNER JOIN IBC_ISSUER_PRODUCT issProd ON issProd.ID_PRODUCT = prod.ID_PRODUCT
WHERE
    payMedia.CARD_NUMBER IN ('1000000203209464') AND
    payMedia.ID_ISSUER = '100' AND
    payMedia.DUE_DATE = '2030-11-01 00:00:00'
    AND payMedia.CARD_SEQUENCE_NUMBER = :CardSequenceNumber
  AND payMedia.GENERATION_INSTANCE = :GenerationInstance
  AND payMedia.ID_PAYMENT_MEDIA = :IdPaymentMedia
ORDER BY payMedia.ID_PAYMENT_MEDIA DESC


SELECT
    payMedia.ID_PAYMENT_MEDIA IdPaymentMedia,
    payMedia.CARD_NUMBER CardNumber,
    accRel.ID_PRODUCT IdProduct,
    finRel.ID_GENERAL_ACCOUNT IdGeneralAccount,
    finRel.ID_FINANCIAL_RELATION IdFinancialRelation,
    accRel.ID_ACCOUNT_RELATION IdAccountRelation,
    pms.STATUS_TYPE PaymentMediaStatusType,
    pms.STATUS_CODE PaymentMediaStatusCode,
    pms.DESCRIPTION PaymentMediaStatusDescription,
    payMedia.ID_PAYMENT_MEDIA_STATUS IdPaymentMediaStatus,
    payMedia.TRANSACTION_BIN TransactionBin,
    payMedia.TRANSACTION_MASKED_PAN TransactionMaskedPan,
    payMedia.ID_ISSUER IdIssuer,
    cust.ID_CUSTOMER IdCustomer,
    cust.EMBOSSING_NAME EmbossingName,
    payMedia.CARD_SEQUENCE_NUMBER CardSequenceNumber,
    payMedia.DUE_DATE DueDate,
    payMedia.FULL_DUE_DATE FullDueDate,
    ims.ID_MEDIA_SUPPORT IdMediaSupport,
    ims.MEDIA_SUPPORT_TYPE mediaSupportType,
    prod.ID_BRAND IdBrand,
    cust.ID_DOCUMENT_TYPE DocumentType,
    cust.DOCUMENT DocumentNumber,
    pperson.BIRTH_DATE BirthDate,
    gAcc.INTERNAL_ACCOUNT_NUMBER AccountNumber,
    issProd.EXTERNAL_ISSUER_ID ProductCode,
    prod.PRODUCT_NAME ProductName
FROM
    IAC_PAYMENT_MEDIA payMedia
        INNER JOIN ICS_PAYMENT_MEDIA_RELATION pmRel ON payMedia.ID_PAYMENT_MEDIA = pmRel.ID_PAYMENT_MEDIA
        INNER JOIN ICS_ACCOUNT_RELATION accRel ON accRel.ID_ACCOUNT_RELATION = pmRel.ID_ACCOUNT_RELATION
        INNER JOIN ICS_FINANCIAL_RELATION finRel ON accRel.ID_FINANCIAL_RELATION = finRel.ID_FINANCIAL_RELATION
        INNER JOIN IBC_PAYMENT_MEDIA_STATUS pms on pms.ID_PAYMENT_MEDIA_STATUS = payMedia.ID_PAYMENT_MEDIA_STATUS
        INNER JOIN ICS_CUSTOMER cust ON cust.ID_CUSTOMER = finRel.ID_CUSTOMER
        INNER JOIN IAC_MEDIA_SUPPORT ims ON ims.ID_MEDIA_SUPPORT = payMedia.ID_MEDIA_SUPPORT
        INNER JOIN IBC_PRODUCT prod ON prod.ID_PRODUCT = payMedia.ID_PRODUCT
        LEFT  JOIN ICS_PHYSICAL_PERSON_CUSTOMER pperson ON pperson.ID_CUSTOMER = cust.ID_CUSTOMER
        INNER JOIN IAC_GENERAL_ACCOUNT gAcc ON gAcc.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
        INNER JOIN IBC_ISSUER_PRODUCT issProd ON issProd.ID_PRODUCT = prod.ID_PRODUCT
WHERE
    (payMedia.CARD_NUMBER IN ('1000000203209464') AND
     payMedia.ID_ISSUER = 100 AND
     payMedia.DUE_DATE = '2030-11-1 0:0:0' AND
     1=1 AND
     1=1 AND
     1=1) AND ((payMedia.ID_ISSUER IN (100, 641)) OR (1 = 0))
ORDER BY payMedia.ID_PAYMENT_MEDIA DESC

-- Query count transactions
SELECT COUNT(IdTransaction) CountTransactions
FROM
   (
        SELECT
            TRX.ID_TRANSACTION IdTransaction
        FROM AUI_ISSUER_TRX_REPLICATE TRX
                 LEFT OUTER JOIN TGD_COUNTRY C ON C.ID_COUNTRY = TRX.ID_COUNTRY
                 LEFT OUTER JOIN C_MCC CM ON CM.ID_MCC = TRX.MCC_CODE
        WHERE
            TRX.TRANSACTION_DATE BETWEEN '2025-01-01' AND '2025-12-31'
          AND TRX.TRANSACTION_PAN = '1000000204369255'
          AND TRX.ID_TRANSACTION_STATUS = 3

        UNION ALL

        SELECT
            TRX.ID_OPERATION IdTransaction
        FROM IOP_OPERATION TRX
                 INNER JOIN TGD_CURRENCY CUR ON CUR.ID_CURRENCY = TRX.ID_CURRENCY
                 INNER JOIN IFN_MOVEMENT MOV ON MOV.ID_OPERATION = TRX.ID_OPERATION
                 LEFT OUTER JOIN TGD_COUNTRY C ON C.ID_COUNTRY = CUR.ID_COUNTRY
                 LEFT OUTER JOIN ITX_TRANSACTION ITX ON ITX.ID_OPERATION = TRX.ID_OPERATION
        WHERE
            TRX.OPERATION_TYPE = 9
          AND TRX.REAL_DATE BETWEEN '2025-01-01' AND '2025-12-31'
          AND TRX.ID_GENERAL_ACCOUNT = 54
) result

-- recupera las transacciones
SELECT IdTransaction,Amount,CurrencyNumericCode,CurrencyCharCode,CountryNumericCode,CountryCharCode,CountryIsoCode,TransactionDate,MerchantName,MCC,MCCDescription,IdIssuer,TransactionChannel,AuthorizationCode,CurrencyCode, txType, txCategory, OperationCode
FROM (
         SELECT ROW_NUMBER() OVER ( ORDER BY Result.TransactionDate DESC, Result.IdTransaction DESC ) AS RowId,
                IdTransaction,Amount,CurrencyNumericCode,CurrencyCharCode,CountryNumericCode,CountryCharCode,CountryIsoCode,TransactionDate,MerchantName,MCC,MCCDescription,IdIssuer,TransactionChannel,AuthorizationCode,CurrencyCode,txType, txCategory, OperationCode
         FROM
             (

                 SELECT
                     CONCAT('', TRX.ID_TRANSACTION) AS IdTransaction,
                     TRX.CARD_BILLING_AMNT AS Amount,
                     CURR.DEFAULT_NUMERIC_CODE AS CurrencyNumericCode,
                     CURR.CHAR_CODE AS CurrencyCharCode,
                     C.NUMERIC_CODE AS CountryNumericCode,
                     C.CHAR_CODE AS CountryCharCode,
                     C.ISO_CODE AS CountryIsoCode,
                     TRX.TRANSACTION_DATE AS TransactionDate,
                     TRX.CARD_ACCEPTOR_NAME AS MerchantName,
                     TRX.MCC_CODE AS MCC,
                     CM.DESCRIPTION AS MCCDescription,
                     TRX.ID_ISSUER AS IdIssuer,
                     1 AS TransactionChannel,
                     TRX.AUTHORIZATION_CODE AS AuthorizationCode,
                     TRX.CARD_BILLING_CURRENCY_CODE AS CurrencyCode,
                     TRX.TRANSACTION_TYPE txType,
                     TRX.TRANSACTION_CATEGORY txCategory,
                     null OperationCode
                 FROM AUI_ISSUER_TRX_REPLICATE TRX
                          LEFT OUTER JOIN TGD_COUNTRY C ON C.ID_COUNTRY = TRX.ID_COUNTRY
                          LEFT OUTER JOIN TGD_CURRENCY CURR on CURR.ID_CURRENCY = TRX.CARD_BILLING_CURRENCY_CODE
                          LEFT OUTER JOIN C_MCC CM ON CM.ID_MCC = TRX.MCC_CODE
                 WHERE
                     --TRX.TRANSACTION_DATE BETWEEN :InitialDate AND :FinalDate
                   --AND
                     TRX.TRANSACTION_PAN = '1000000204369255'
                   AND TRX.ID_TRANSACTION_STATUS = 3

                 UNION ALL

                 SELECT
                     CONCAT('OP', TRX.ID_OPERATION) AS IdTransaction,
                     TRX.AMOUNT AS Amount,
                     CURR.DEFAULT_NUMERIC_CODE AS CurrencyNumericCode,
                     CURR.CHAR_CODE AS CurrencyCharCode,
                     C.NUMERIC_CODE AS CountryNumericCode,
                     C.CHAR_CODE AS CountryCharCode,
                     C.ISO_CODE AS CountryIsoCode,
                     TRX.REAL_DATE AS TransactionDate,
                     null AS MerchantName,
                     null AS MCC,
                     null AS MCCDescription,
                     MOV.ID_ISSUER_PERF AS IdIssuer,
                     TRX.OPERATION_ENTRY_CHANNEL AS TransactionChannel,
                     ITX.AUTHORIZATION_CODE AS AuthorizationCode,
                     TRX.ID_CURRENCY AS CurrencyCode,
                     null txType,
                     null txCategory,
                     CASE
                         WHEN MOV.ID_MOVEMENT IS NOT NULL AND MOV.MOVEMENT_SIGN = 1  THEN 'CREDIT'
                         WHEN MOV.ID_MOVEMENT IS NOT NULL AND MOV.MOVEMENT_SIGN = -1 THEN 'DEBIT'
                         ELSE null
                         END OperationCode
                 FROM IOP_OPERATION TRX
                          INNER JOIN TGD_CURRENCY CUR ON CUR.ID_CURRENCY = TRX.ID_CURRENCY
                          INNER JOIN IFN_MOVEMENT MOV ON MOV.ID_OPERATION = TRX.ID_OPERATION
                          LEFT OUTER JOIN TGD_COUNTRY C ON C.ID_COUNTRY = CUR.ID_COUNTRY
                          LEFT OUTER JOIN TGD_CURRENCY CURR on CURR.ID_CURRENCY = TRX.ID_CURRENCY
                          LEFT OUTER JOIN ITX_TRANSACTION ITX ON ITX.ID_OPERATION = TRX.ID_OPERATION
                 WHERE
                     TRX.OPERATION_TYPE = 9
                   --AND TRX.REAL_DATE BETWEEN :InitialDate AND :FinalDate
                   AND TRX.ID_GENERAL_ACCOUNT = 54
             ) Result
     ) p
--WHERE p.RowId BETWEEN :FromRow AND :ToRow
ORDER BY p.RowId;