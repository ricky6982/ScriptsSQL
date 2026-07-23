select CUSTOMER_INFO, PAYMENT_MEDIA_INFO, ADDITIONAL_CUSTOMER_INFO from IAC_GENERAL_ACCOUNT;
;

select * from IBC_ISSUER_PARAMETER
select * from IAC_ACCOUNT_PROPERTY
select * from DATABASECHANGELOG where id = '506865_DDL_PRODUCTO_AjusteTabla_IAC_ACCOUNT_PROPERTY' order by DATEEXECUTED desc;


SELECT ID_PARAMETER as IdParameter,
       ID_ACCOUNT_RELATION as IdAccountRelation,
       VALID_FROM as ValidFrom,
       VALID_TO as ValidTo,
       REAL_VALUE as LimitValue
FROM ICS_ACCOUNT_RELATION_PARAMETER
WHERE ID_PARAMETER = :idParameter and ID_ACCOUNT_RELATION = :idAccountRelation AND VALID_FROM = :validFrom;

select * from ICS_ACCOUNT_RELATION_PARAMETER_H;

SELECT prod.ID_PRODUCT as IdProduct,
       accRel.ID_ACCOUNT_RELATION as IdAccountRelation,
       prod.PRODUCT_NAME as ProductName,
       prod.PRODUCT_TYPE as ProductType,
       accRelParam.REAL_VALUE as LimitAmount,
       accRelParam.VALID_FROM as ValidFrom,
       accRelParam.VALID_TO as ValidTo--, *
FROM ICS_FINANCIAL_RELATION finRel
         INNER JOIN ICS_ACCOUNT_RELATION accRel ON finRel.ID_FINANCIAL_RELATION = accRel.ID_FINANCIAL_RELATION
         INNER JOIN IBC_ISSUER_PRODUCT issuerProd
                    ON issuerProd.ID_PRODUCT = accRel.ID_PRODUCT AND issuerProd.ID_ISSUER = :IdIssuer
         INNER JOIN IBC_PRODUCT prod ON prod.ID_PRODUCT = issuerProd.ID_PRODUCT
         LEFT JOIN ICS_ACCOUNT_RELATION_PARAMETER accRelParam
                   ON accRel.ID_ACCOUNT_RELATION = accRelParam.ID_ACCOUNT_RELATION and
                      accRelParam.ID_PARAMETER = :IdParameter
WHERE finRel.ID_FINANCIAL_RELATION = :IdFinancialRelation;


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
  AND accRelParam.VALID_FROM = (
    SELECT MAX(VALID_FROM)
    FROM ICS_ACCOUNT_RELATION_PARAMETER
    WHERE ID_ACCOUNT_RELATION = accRel.ID_ACCOUNT_RELATION
      AND ID_PARAMETER = :IdParameter
  )

select * from ICS_ACCOUNT_RELATION_PARAMETER