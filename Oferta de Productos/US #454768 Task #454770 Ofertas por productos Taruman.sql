
select * from IBC_SETTLEMENT_MODEL
where ID_ISSUER = :IdIssuer


select * from IBC_ISSUER_SETT_MODEL_TYPE
select * from IAC_ACCOUNT_SETT_MODEL
select * from IAC_CREDIT_GENERAL_ACCOUNT where ID_GENERAL_ACCOUNT in (118, 133)
select * from IAC_GENERAL_ACCOUNT WHERE ID_ISSUER = 641 ORDER BY ID_GENERAL_ACCOUNT DESC

select * from IBC_SETTLEMENT_MODEL_PRODUCTS
select * from IBC_PRODUCT
select * from IBC_ISSUER_PRODUCT
select * from accouprod


SELECT
    settMod.ID_SETTLEMENT_MODEL as IdSettlementModel,
    settMod.SETTLEMENT_MODEL_NAME as SettlementModelName,
    settMod.SETTLEMENT_MODEL_CODE as SettlementModelCode,
    settMod.IS_DEFAULT as IsDefault
FROM IBC_SETTLEMENT_MODEL settMod
INNER JOIN IBC_SETTLEMENT_MODEL_PRODUCTS settModProd ON settMod.ID_SETTLEMENT_MODEL = settModProd.ID_SETTLEMENT_MODEL
WHERE settMod.ID_ISSUER = :IdIssuer and settModProd.ID_PRODUCT = :IdProduct


--- FILTRAR CUENTAS
SELECT DISTINCT
    gralAcc.ID_MAIN_PRODUCT as IdMainProduct,

    gralAcc.ID_GENERAL_ACCOUNT IdGeneralAccount,
    gralAcc.ID_ISSUER IdIssuer,
    gralAcc.ID_PRODUCT_GROUP IdProductGroup,
    org.FANTASY_NAME IssuerName,
    mainCustomer.ID_CUSTOMER PpalCustomerId,
    mainPhysicalPerson.NAME PpalCustomerName,
    mainPhysicalPerson.SURNAME PpalCustomerSurname,
    mainPhysicalPerson.SECOND_NAME PpalCustomerSecondName,
    mainPhysicalPerson.SECOND_SURNAME PpalCustomerSecondSurname,
    mainLegalPerson.LEGAL_NAME LegalName,
    mainCustomer.DOCUMENT PpalDocument,
    mainCustomer.ID_DOCUMENT_TYPE PpalDocumentType,
    mainCustomer.IS_INNOMINATE IsInnominate,
    doc.DESCRIPTION DocumentTypeName,
    doc.MASK DocumentMask,
    gralAcc.INTERNAL_ACCOUNT_NUMBER InternalAccountNumber,
    gralAcc.EXTERNAL_ACCOUNT_NUMBER ExternalAccountNumber,
    accStat.DESCRIPTION DescAccStatus,
    prod.PRODUCT_TYPE ProductType,
    mainCustomer.CUSTOMER_TYPE CustomerType,
    gralAcc.ID_ACCOUNT_STATUS AccountStatus,
    prodGroup.DESCRIPTION ProductGroupDescription,
    prodGroup.ID_BRAND Brand,
    orgMaintenanceBranch.FANTASY_NAME as MaintenanceAccountBranch,
    accStat.STATUS_CODE AccountStatusCode -- VERIFICAR
FROM IAC_GENERAL_ACCOUNT gralAcc
     INNER JOIN IBC_ISSUER             iss          ON gralAcc.ID_ISSUER = iss.ID_ISSUER
     INNER JOIN ICS_FINANCIAL_RELATION finRel       ON finRel.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT    -- Interesa?
     INNER JOIN ICS_FINANCIAL_RELATION finRelMain   ON finRelMain.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
     INNER JOIN ICS_CUSTOMER           mainCustomer ON finRelMain.ID_CUSTOMER = mainCustomer.ID_CUSTOMER
     INNER JOIN ICS_CUSTOMER           customer     ON finRel.ID_CUSTOMER = customer.ID_CUSTOMER
     INNER JOIN IBC_ACCOUNT_STATUS     accStat      ON accStat.ID_ACCOUNT_STATUS = gralAcc.ID_ACCOUNT_STATUS  -- Siempre status activo
     INNER JOIN C_ORGANIZATION         org          ON org.ID_ORGANIZATION = iss.ID_ORGANIZATION
     INNER JOIN IBC_PRODUCT_GROUP      prodGroup    ON gralAcc.ID_PRODUCT_GROUP = prodGroup.ID_PRODUCT_GROUP
     INNER JOIN IBC_PRODUCT            prod         ON gralAcc.ID_MAIN_PRODUCT = prod.ID_PRODUCT
     INNER JOIN IBC_ISSUER_BRANCH issuerBranch ON gralAcc.ID_MAINTENANCE_ISSUER_BRANCH = issuerBranch.ID_ISSUER_BRANCH
     INNER JOIN C_ORGANIZATION orgMaintenanceBranch ON issuerBranch.ID_ORGANIZATION = orgMaintenanceBranch.ID_ORGANIZATION
     LEFT OUTER JOIN ICS_CUSTOMER_ADDITIONAL_DOC    addDoc             ON addDoc.ID_CUSTOMER = mainCustomer.ID_CUSTOMER
--      LEFT OUTER JOIN ICS_LEGAL_PERSON_CUSTOMER      legalPerson        ON legalPerson.ID_CUSTOMER = customer.ID_CUSTOMER
--      LEFT OUTER JOIN ICS_PHYSICAL_PERSON_CUSTOMER   physicalPerson     ON physicalPerson.ID_CUSTOMER = customer.ID_CUSTOMER
     LEFT OUTER JOIN ICS_LEGAL_PERSON_CUSTOMER      mainLegalPerson    ON mainLegalPerson.ID_CUSTOMER = mainCustomer.ID_CUSTOMER
     LEFT OUTER JOIN ICS_PHYSICAL_PERSON_CUSTOMER   mainPhysicalPerson ON mainPhysicalPerson.ID_CUSTOMER = mainCustomer.ID_CUSTOMER
     LEFT OUTER JOIN TGD_DOCUMENT_TYPE              doc                ON mainCustomer.ID_DOCUMENT_TYPE = doc.ID_DOCUMENT_TYPE

    --Para filtrar por Nro De tarjeta.
--          LEFT OUTER JOIN ICS_ACCOUNT_RELATION accRelation ON accRelation.ID_FINANCIAL_RELATION = finRel.ID_FINANCIAL_RELATION
--          LEFT OUTER JOIN ICS_PAYMENT_MEDIA_RELATION pmRelation ON pmRelation.ID_ACCOUNT_RELATION = accRelation.ID_ACCOUNT_RELATION
--          LEFT OUTER JOIN IAC_PAYMENT_MEDIA pm ON pm.ID_PAYMENT_MEDIA = pmRelation.ID_PAYMENT_MEDIA

WHERE gralAcc.ID_ISSUER = :idIssuer
  AND gralAcc.ID_MAIN_PRODUCT = :idProduct
  AND mainCustomer.CUSTOMER_TYPE = :customerType
  AND customer.CUSTOMER_TYPE = :customerType
  AND prod.PRODUCT_TYPE = :accountType
--   AND gralAcc.ID_ACCOUNT_STATUS = :accountStatus
--   AND (gralAcc.INTERNAL_ACCOUNT_NUMBER = :accountNumber OR gralAcc.EXTERNAL_ACCOUNT_NUMBER = :accountNumber)
--   AND prodGroup.ID_PRODUCT_GROUP = :idProductGroup
--   AND finRelMain.FINANCIAL_RELATION_TYPE = :finRelType
--   AND (pm.TRANSACTION_MASKED_PAN  =:maskedPan or pm.CARD_NUMBER = :maskedPan)
--
--   AND (
--     (mainCustomer.DOCUMENT = :document AND mainCustomer.ID_DOCUMENT_TYPE = :documentType) OR
--     (mainCustomer.ID_CUSTOMER IN (SELECT ID_CUSTOMER
--                                   FROM ICS_CUSTOMER_ADDITIONAL_DOC
--                                   WHERE ID_DOCUMENT_TYPE =:documentType
--                                     AND DOCUMENT = :document))
--     )
--   AND ((RTRIM(upper(physicalPerson.NAME)) LIKE '%' || :firstName || '%' OR RTRIM(upper(physicalPerson.SECOND_NAME)) LIKE :firstName)
--         OR (RTRIM(upper(mainPhysicalPerson.NAME)) LIKE '%' || :firstName|| '%' OR RTRIM(upper(mainPhysicalPerson.SECOND_NAME)) LIKE :firstName))
--   AND ((RTRIM(upper(physicalPerson.SURNAME)) LIKE '%' || :lastName|| '%' OR RTRIM(upper(physicalPerson.SECOND_SURNAME)) LIKE :lastName)
--         OR (RTRIM(upper(mainPhysicalPerson.SURNAME)) LIKE '%' || :lastName|| '%' OR RTRIM(upper(mainPhysicalPerson.SECOND_SURNAME)) LIKE :lastName))
--   AND UPPER(legalPerson.LEGAL_NAME) LIKE '%' || :legalName|| '%'