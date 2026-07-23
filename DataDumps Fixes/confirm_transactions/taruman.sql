select
    itx.ID_TX IdTx,
    acc.INTERNAL_ACCOUNT_NUMBER InternalAccountNumber,
    itx.ID_MCC MerchantCategory,
    itx.RESPONSE_CODE ResponseCode,
    itx.TX_TYPE TransactionType,
    aot.LOCAL_DATE LocalDate,
    itx.TRANSACTION_BEGIN_TIME_AAS TransactionBeginTimeAAS,
    itx.PURCHASE_DATE PurchaseDate,
    itx.SALE_AMOUNT SaleAmount,
    saleCurr.ID_CURRENCY SaleCurrency,
    itx.ISSUER_AMOUNT IssuerAmount,
    issuerCurr.ID_CURRENCY IssuerCurrency,
    itx.CARD_NUMBER CardNumber,
    itx.AUTHORIZATION_CODE AuthorizationCode,
    itx.TERMINAL_CODE TerminalId,
    aot.CARD_ACCEPTOR_CODE MerchantId,
    REPLACE(REPLACE(COALESCE(aot.CARD_ACCEPTOR_NAME, ''), ',', ''), ';', '') AS MerchantName,
    itx.MERCHANT_COUNTRY_CODE MerchantCountry,
    state.ID_GEO_STATE MerchantState,
    itx.MERCHANT_CITY MerchantCity,
    itx.MERCHANT_ADDRESS MerchantAddress,
    itx.ENTRY_MODE PosEntryMode,
    arc.DESCRIPTION ResponseDescription,
    itx.ARN ARN,
    itx.PROCESSED_DATE PresentationDate,
    CAST((CASE WHEN aot.ID_TRANSACTION IS NOT NULL THEN aot.ID_TRANSACTION_STATUS ELSE null END) AS VARCHAR) AS Status,
    itx.PROCESSING_CODE ProcessingCode,
    itx.ID_COUNTRY Country,
    aot.TRANSACTION_GEO_STATE_NAME State,
    aot.TRANSACTION_CITY_NAME City,
    itx.MERCHANT_ZIP_CODE ZipCode,
    CASE WHEN itxh.ID_TX IS NOT NULL THEN 1 ELSE 0 END AS IsHonoredTransaction,
    itxh.REASON_CODE HonoredReasonCode,
    CASE WHEN aot.CARD_BILLING_AMNT > 0 THEN 1 ELSE 0 END AS MonetaryIndicator,
    CASE WHEN info.DCC IS NULL THEN '0' ELSE '1' END ApliedDCC,
    CASE WHEN (SELECT COUNT(openToken.ID_TRANSACTION) FROM AUI_OPEN_TOKENIZATION openToken WHERE itx.ID_TX = openToken.ID_TRANSACTION) > 0 THEN 1 ELSE 0 END AS TransactionWasTokenized,
    prod.PRODUCT_TYPE ProductType,
    prod.PRODUCT_NAME CardClass,
    itx.BRAND_SETTLEMENT_AMOUNT SettlementAmount,
    itx.BRAND_SETTLEMENT_CURRENCY_CODE SettlementCurrencyCode,
    aot.ECOMMERCE_INDICATORS  ComunicationDeviceIndicator,
    itx.INSTALLMENT_QUANTITY InstallmentQuantity,
    pln.SALE_PLAN_CODE SalePlanCode,
    pln.SALE_PLAN_NAME SalePlanName,
    rtvle.VALUE InterestRate,
    CASE
        WHEN LEN(itx.SETTLEMENT_DATA) >= 60
            AND NULLIF(SUBSTRING(itx.SETTLEMENT_DATA, 60, 6), '') IS NOT NULL
            THEN SUBSTRING(itx.SETTLEMENT_DATA, 60, 6)
        ELSE itx.BRAND_SETTLEMENT_DATE
        END AS SettlementDate,
    CASE
        WHEN itx.SCOPE = 4
            THEN itx.TRM_REVENUE -- Usas directamente la columna almacenada
        ELSE NULL
        END AS TrmRevenue,
    ' ' as TranscodeDescription,
    CASE
        WHEN O.OPERATION_ENTRY_CHANNEL = 1 THEN 0        -- Local input (online)
        WHEN O.OPERATION_ENTRY_CHANNEL IN (2, 4) THEN 1  -- System-generated
        WHEN O.OPERATION_ENTRY_CHANNEL = 3 THEN 2        -- User input
        ELSE NULL
        END as SourceCode,
    r.RATE_CODE ProductPlan,
    M.TRANS_CODE as TransCode,
    IP.EXTERNAL_ISSUER_ID ProductCode
FROM
    ITX_TRANSACTION itx
        INNER JOIN (
        SELECT MIN(itx.ID_TX) IDTX
        FROM ITX_TRANSACTION itx
                 INNER JOIN ITX_INCOMING_TRANSACTION incTrx ON incTrx.ID_TX = itx.ID_TX
        WHERE itx.ID_ISSUER = :IdIssuer
          AND CAST(incTrx.CREATION_DATE AS DATE) = :FilterDate
        GROUP BY EXTERNAL_AUTHORIZATION_ID, CARD_NUMBER
    ) filterItx  ON filterItx.IDTX = ITX.ID_TX
        LEFT OUTER JOIN IAC_PAYMENT_MEDIA pm ON pm.ID_PAYMENT_MEDIA = itx.ID_PAYMENT_MEDIA
        LEFT OUTER JOIN ICS_PAYMENT_MEDIA_RELATION pmr ON pmr.ID_PAYMENT_MEDIA = pm.ID_PAYMENT_MEDIA
        LEFT OUTER JOIN ICS_ACCOUNT_RELATION ar ON ar.ID_ACCOUNT_RELATION = pmr.ID_ACCOUNT_RELATION
        LEFT OUTER JOIN ICS_FINANCIAL_RELATION fr ON fr.ID_FINANCIAL_RELATION = ar.ID_FINANCIAL_RELATION
        LEFT OUTER JOIN IAC_GENERAL_ACCOUNT acc ON acc.ID_GENERAL_ACCOUNT = fr.ID_GENERAL_ACCOUNT
        LEFT JOIN AU_RESPONSE_CODE arc ON itx.RESPONSE_CODE = arc.ID_RESPONSE_CODE
        LEFT JOIN AU_OPEN_TRANSACTION aot ON itx.EXTERNAL_AUTHORIZATION_ID = aot.ID_TRANSACTION
        LEFT JOIN ITX_HONORED_TRANSACTION itxh ON itx.ID_TX = itxh.ID_TX
        LEFT JOIN IBC_PRODUCT prod ON itx.ID_PRODUCT = prod.ID_PRODUCT
        LEFT JOIN C_BRAND_PRODUCT_CATEGORY prodCateg ON prod.ID_BRAND_PRODUCT_CATEGORY = prodCateg.ID_BRAND_PRODUCT_CATEGORY
        LEFT JOIN TGD_GEO_STATE geoState ON itx.ID_GEO_STATE = geoState.ID_GEO_STATE
        LEFT JOIN TGD_COUNTRY country ON itx.ID_COUNTRY = country.ID_COUNTRY
        LEFT JOIN TGD_CURRENCY saleCurr ON saleCurr.ID_CURRENCY = itx.ID_SALE_CURRENCY
        LEFT JOIN TGD_CURRENCY issuerCurr ON issuerCurr.ID_CURRENCY = itx.ID_ISSUER_CURRENCY
        LEFT JOIN AUI_TRX_ISSUER_DATA info ON info.ID_TRANSACTION = aot.ID_TRANSACTION
        LEFT JOIN IBC_SALE_PLAN pln ON pln.ID_SALE_PLAN = itx.ID_SALE_PLAN
        LEFT JOIN IBC_RATE R ON R.ID_RATE = pln.ID_RATE
        LEFT JOIN AUI_RATE_VALUE rtvle ON rtvle.ID_RATE = pln.ID_RATE
        AND rtvle.VALID_FROM =(
            SELECT MAX(VALID_FROM )  FROM AUI_RATE_VALUE
            WHERE ID_RATE = pln.ID_RATE AND VALID_FROM <= CAST(:FilterDate  AS DATE)
        )
        LEFT OUTER JOIN TGD_GEO_STATE state ON state.ID_COUNTRY = itx.ID_COUNTRY AND state.ISO_CODE = itx.MERCHANT_PROVINCE_CODE
        LEFT JOIN IOP_OPERATION O ON O.ID_OPERATION = itx.ID_OPERATION
        LEFT JOIN IFN_MOVEMENT M ON M.ID_OPERATION = O.ID_OPERATION AND M.IS_FINANCIAL = 1
        LEFT JOIN IBC_ISSUER_PRODUCT IP ON IP.ID_PRODUCT = prod.ID_PRODUCT
WHERE itx.ID_ISSUER = :IdIssuer