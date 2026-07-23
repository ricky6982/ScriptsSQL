SELECT DISTINCT
    gralAcc.INTERNAL_ACCOUNT_NUMBER InternalAccountNumber,
    customer.ID_DOCUMENT_TYPE DocumentType,
    TRIM(documentType.DESCRIPTION) DocumentTypeName,
    customer.DOCUMENT Document,
    finRelMain.FINANCIAL_RELATION_TYPE FinancialRelation,
    gralAcc.EXTERNAL_ACCOUNT_NUMBER ExternalAccountNumber,
    finRelMain.ACCOUNT_HOLDER_RELATIONSHIP AccountHolderRelationship,
    finRelmain.IS_CODEBTOR IsCodebtor,
    CASE
        WHEN customerPhysicalAddres.ID_ADDRESS = cusCorresponAddres.ID_ADDRESS
            THEN 1 ELSE 0
        END CorresponAddresSomePhysicalAnddress,
    -----------Address (Correspondance if FINANCIAL_RELATION_TYPE = 1, Physical otherwise)
    CASE
        WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1
            THEN CASE corresponAddres.STREET_INPUT_MODE
                     WHEN 1 THEN corresponStreet.ID_STREET_TYPE
                     ELSE 1
                 END
        ELSE CASE physicalAddres.STREET_INPUT_MODE
                 WHEN 1 THEN physicalStreet.ID_STREET_TYPE
                 ELSE 1
             END
        END IdStreetType,
    CASE
        WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1
            THEN CASE corresponAddres.STREET_INPUT_MODE
                     WHEN 1 THEN corresponStreet.STREET_NAME
                     ELSE corresponAddres.STREET
                 END
        ELSE CASE physicalAddres.STREET_INPUT_MODE
                 WHEN 1 THEN physicalStreet.STREET_NAME
                 ELSE physicalAddres.STREET
             END
        END Street,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponAddres.DOOR_NUMBER ELSE physicalAddres.DOOR_NUMBER END DoorNumber,
    CASE
        WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1
            THEN CASE corresponAddres.NEIGHBOURHOOD_INPUT_MODE
                     WHEN 1 THEN corresponNeigHood.NEIGHBOURHOOD_NAME
                     ELSE corresponAddres.NEIGHBOURHOOD
                 END
        ELSE CASE physicalAddres.NEIGHBOURHOOD_INPUT_MODE
                 WHEN 1 THEN physicalNeigHood.NEIGHBOURHOOD_NAME
                 ELSE physicalAddres.NEIGHBOURHOOD
             END
        END NeighbourhoodName,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponNeigHood.CODE ELSE physicalNeigHood.CODE END NeighbourhoodCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponCity.CITY_NAME ELSE physicalCity.CITY_NAME END CityName,
    0 CityExternalCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN CAST(corresponCity.CODE AS VARCHAR) ELSE CAST(physicalCity.CODE AS VARCHAR) END CityCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponGeostate.GEO_STATE_NAME ELSE physicalGeostate.GEO_STATE_NAME END GeographicName,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN CAST(corresponGeoStateExternal.CODE AS VARCHAR) ELSE CAST(physicalGeoStateExternal.CODE AS VARCHAR) END GeographicExternalCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN CAST(corresponGeostate.ISO_CODE AS VARCHAR) ELSE CAST(physicalGeostate.ISO_CODE AS VARCHAR) END GeographicCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponAddres.POSTAL_CODE ELSE physicalAddres.POSTAL_CODE END PostalCode,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponAddres.IS_BIS ELSE physicalAddres.IS_BIS END IsBis,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponAddres.FLOOR ELSE physicalAddres.FLOOR END Floor,
    CASE WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1 THEN corresponAddres.APARTMENT ELSE physicalAddres.APARTMENT END Apartment,
    CASE
        WHEN finRelMain.FINANCIAL_RELATION_TYPE = 1
            THEN (case when cusCorresponAddres.SAMEASPHYSICAL = 1 then physicalAddres.COMPLEMENT else corresponAddres.COMPLEMENT end)
        ELSE physicalAddres.COMPLEMENT
        END as AdditionalInfo,
    --------ContactPhone (OWN if FINANCIAL_RELATION_TYPE != 1, else Correspondance logic)
    (case when finRelMain.FINANCIAL_RELATION_TYPE != 1 or cusCorresponAddres.SAMEASPHYSICAL = 1 then (
        SELECT CONCAT( personalPhone.country_code,personalPhone.AREA_CODE,personalPhone.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN
             (
                 SELECT MAX(personalPhone.ID_CUSTOMER_CONTACT_INFO) CCI, contactInfo.ID_CUSTOMER
                 FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                          INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                     AND personalPhone.PHONE_TYPE = 1 --PHONE
                 WHERE contactInfo.CONTACT_TYPE = 1 --OWN
                   AND contactInfo.CONTACT_INFO_TYPE = 1 -- PHONE
                   AND contactInfo.ID_CUSTOMER = customer.ID_CUSTOMER
                 GROUP BY contactInfo.ID_CUSTOMER
             )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) else (
        SELECT CONCAT( personalPhone.country_code,personalPhone.AREA_CODE,personalPhone.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN
             (
                 SELECT MAX(personalPhone.ID_CUSTOMER_CONTACT_INFO) CCI, contactInfo.ID_CUSTOMER
                 FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                          INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                     AND personalPhone.PHONE_TYPE = 1 --PHONE
                 WHERE contactInfo.CONTACT_TYPE = 3 --CORRESPONDENCE
                   AND contactInfo.CONTACT_INFO_TYPE = 1 -- PHONE
                   AND contactInfo.ID_CUSTOMER = customer.ID_CUSTOMER
                 GROUP BY contactInfo.ID_CUSTOMER
             )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) end ) PhoneNumber,
    ------ContactCel (OWN if FINANCIAL_RELATION_TYPE != 1, else Correspondance logic)
    (case when finRelMain.FINANCIAL_RELATION_TYPE != 1 or cusCorresponAddres.SAMEASPHYSICAL = 1 then (
        SELECT CONCAT( personalCel.country_code,personalCel.AREA_CODE,personalCel.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalCel on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalCel.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN (SELECT MAX(personalCelMax.ID_CUSTOMER_CONTACT_INFO) CCI
                             FROM ICS_CUSTOMER_CONTACT_INFO contactInfoMax
                                      INNER JOIN ICS_PHONE_CONTACT_INFO personalCelMax on contactInfoMax.ID_CUSTOMER_CONTACT_INFO = personalCelMax.ID_CUSTOMER_CONTACT_INFO
                                 AND  personalCelMax.PHONE_TYPE = 3 --CELLULAR
                             WHERE contactInfoMax.CONTACT_TYPE = 1 --OWN
                               AND contactInfoMax.CONTACT_INFO_TYPE = 1 -- PHONE
                               AND contactInfoMax.ID_CUSTOMER = customer.ID_CUSTOMER
                             GROUP BY contactInfoMax.ID_CUSTOMER
        )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) else (
        SELECT CONCAT( personalCel.country_code,personalCel.AREA_CODE,personalCel.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalCel on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalCel.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN (SELECT MAX(personalCelMax.ID_CUSTOMER_CONTACT_INFO) CCI
                             FROM ICS_CUSTOMER_CONTACT_INFO contactInfoMax
                                      INNER JOIN ICS_PHONE_CONTACT_INFO personalCelMax on contactInfoMax.ID_CUSTOMER_CONTACT_INFO = personalCelMax.ID_CUSTOMER_CONTACT_INFO
                                 AND  personalCelMax.PHONE_TYPE = 3 --CELLULAR
                             WHERE contactInfoMax.CONTACT_TYPE = 3 --CORRESPONDENCE
                               AND contactInfoMax.CONTACT_INFO_TYPE = 1 -- PHONE
                               AND contactInfoMax.ID_CUSTOMER = customer.ID_CUSTOMER
                             GROUP BY contactInfoMax.ID_CUSTOMER
        )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) end ) CeeLNumber,
    warranty.WARRANTY_TYPE WarrantyType,
    warranty.DESCRIPTION WarrantyDescription
FROM
    IAC_GENERAL_ACCOUNT gralAcc
        INNER JOIN IBC_ACCOUNT_STATUS accSta ON accSta.ID_ACCOUNT_STATUS = gralAcc.ID_ACCOUNT_STATUS
        INNER JOIN ICS_FINANCIAL_RELATION finRelMain ON finRelMain.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
        INNER JOIN ICS_CUSTOMER customer ON finRelMain.ID_CUSTOMER = customer.ID_CUSTOMER
        AND customer.ID_ISSUER = :IdIssuer
        INNER JOIN TGD_DOCUMENT_TYPE documentType ON  customer.ID_DOCUMENT_TYPE = documentType.ID_DOCUMENT_TYPE
        LEFT JOIN ICS_CUSTOMER_WARRANTY warranty ON finRelMain.ID_FINANCIAL_RELATION = warranty.ID_FINANCIAL_RELATION
        --------customerPhysicalAddress
        LEFT  JOIN ICS_CUSTOMER_ADDRESS customerPhysicalAddres ON customer.ID_CUSTOMER = customerPhysicalAddres.ID_CUSTOMER
        AND customerPhysicalAddres.ADDRESS_TYPE = 1  --PHYSYCAL_ADDRESS
        AND customerPhysicalAddres.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
        LEFT JOIN TGD_ADDRESS physicalAddres ON customerPhysicalAddres.ID_ADDRESS = physicalAddres.ID_ADDRESS
        LEFT OUTER JOIN TGD_STREET physicalStreet ON physicalAddres.ID_STREET = physicalStreet.ID_STREET
        LEFT OUTER JOIN TGD_NEIGHBOURHOOD physicalNeigHood ON physicalNeigHood.ID_NEIGHBOURHOOD = physicalAddres.ID_NEIGHBOURHOOD
        AND physicalNeigHood.ID_CITY = physicalAddres.ID_CITY
        AND physicalNeigHood.ID_GEO_STATE = physicalAddres.ID_GEO_STATE
        AND physicalNeigHood.ID_COUNTRY = physicalAddres.ID_COUNTRY
        LEFT OUTER JOIN TGD_CITY physicalCity ON physicalAddres.ID_CITY = physicalCity.ID_CITY
        AND physicalAddres.ID_COUNTRY = physicalCity.ID_COUNTRY
        LEFT OUTER JOIN TGD_GEO_STATE physicalGeostate ON physicalGeostate.ID_GEO_STATE = physicalAddres.ID_GEO_STATE
        AND physicalGeostate.ID_COUNTRY = physicalAddres.ID_COUNTRY
        LEFT JOIN IBC_GEO_STATE_EXTERNAL_CODE physicalGeoStateExternal ON physicalGeostate.ID_COUNTRY = physicalGeoStateExternal.ID_COUNTRY
        AND physicalGeostate.ID_GEO_STATE = physicalGeoStateExternal.ID_GEO_STATE
        ----------CorrespondanceAddress
        LEFT  JOIN ICS_CUSTOMER_ADDRESS cusCorresponAddres ON customer.ID_CUSTOMER = cusCorresponAddres.ID_CUSTOMER
        AND cusCorresponAddres.ADDRESS_TYPE = 3  --CORRESPONDANCE
        AND  cusCorresponAddres.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
        LEFT JOIN TGD_ADDRESS corresponAddres ON cusCorresponAddres.ID_ADDRESS = corresponAddres.ID_ADDRESS
        LEFT JOIN TGD_COUNTRY corresponCountry ON corresponAddres.ID_COUNTRY = corresponCountry.ID_COUNTRY
        LEFT JOIN TGD_CITY corresponCity ON corresponCountry.ID_COUNTRY = corresponCity.ID_COUNTRY
        AND corresponCity.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponAddres.ID_COUNTRY = corresponCity.ID_COUNTRY
        AND corresponAddres.ID_CITY = corresponCity.ID_CITY
        LEFT JOIN IBC_CITY_EXTERNAL_CODE corresponCityExternal ON corresponCountry.ID_COUNTRY = corresponCityExternal.ID_COUNTRY
        AND corresponCity.ID_GEO_STATE = corresponCityExternal.ID_GEO_STATE
        AND corresponAddres.ID_CITY = corresponCityExternal.ID_CITY
        AND customer.ID_ISSUER = corresponCityExternal.ID_ISSUER
        AND corresponAddres.ID_COUNTRY = corresponCityExternal.ID_COUNTRY
        LEFT JOIN (SELECT ID_CITY, MIN(CODE) AS CODE
                   FROM IBC_CITY_EXTERNAL_CODE  GROUP BY ID_CITY)
        cityExternal2 ON corresponCityExternal.CODE = cityExternal2.CODE
        LEFT OUTER JOIN TGD_GEO_STATE corresponGeostate ON corresponGeostate.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponGeostate.ID_COUNTRY = corresponAddres.ID_COUNTRY
        LEFT JOIN IBC_GEO_STATE_EXTERNAL_CODE  corresponGeoStateExternal ON  corresponGeostate.ID_COUNTRY =  corresponGeoStateExternal.ID_COUNTRY
        AND  corresponGeostate.ID_GEO_STATE =  corresponGeoStateExternal.ID_GEO_STATE
        LEFT OUTER JOIN TGD_STREET corresponStreet ON corresponAddres.ID_STREET = corresponStreet.ID_STREET
        LEFT OUTER JOIN TGD_NEIGHBOURHOOD corresponNeigHood ON corresponNeigHood.ID_NEIGHBOURHOOD = corresponAddres.ID_NEIGHBOURHOOD
        AND corresponNeigHood.ID_CITY = corresponAddres.ID_CITY
        AND corresponNeigHood.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponNeigHood.ID_COUNTRY = corresponAddres.ID_COUNTRY
WHERE
    gralAcc.ID_ISSUER = :IdIssuer AND
    customer.IS_INNOMINATE = 0 AND
    accSta.STATUS_TYPE <> 4
order by gralAcc.INTERNAL_ACCOUNT_NUMBER
;

-- old version:
SELECT DISTINCT
    gralAcc.INTERNAL_ACCOUNT_NUMBER InternalAccountNumber,
    customer.ID_DOCUMENT_TYPE DocumentType,
    TRIM(documentType.DESCRIPTION) DocumentTypeName,
    customer.DOCUMENT Document,
    finRelMain.FINANCIAL_RELATION_TYPE FinancialRelation,
    gralAcc.EXTERNAL_ACCOUNT_NUMBER ExternalAccountNumber,
    finRelMain.ACCOUNT_HOLDER_RELATIONSHIP AccountHolderRelationship,
    finRelmain.IS_CODEBTOR IsCodebtor,
    CASE
        WHEN customerPhysicalAddres.ID_ADDRESS = cusCorresponAddres.ID_ADDRESS
            THEN 1 ELSE 0
        END CorresponAddresSomePhysicalAnddress,
    -----------CorrespondanceAddress
    CASE corresponAddres.STREET_INPUT_MODE
        WHEN 1 --SELECTED_FROM_CONFIGURED
            THEN corresponStreet.ID_STREET_TYPE
        ELSE 1
        END IdStreetType,
    CASE corresponAddres.STREET_INPUT_MODE
        WHEN 1 --SELECTED_FROM_CONFIGURED
            THEN corresponStreet .STREET_NAME
        ELSE corresponAddres.STREET
        END Street,
    corresponAddres.DOOR_NUMBER DoorNumber,
    CASE corresponAddres.NEIGHBOURHOOD_INPUT_MODE
        WHEN 1
            THEN corresponNeigHood.NEIGHBOURHOOD_NAME
        ELSE corresponAddres.NEIGHBOURHOOD
        END                     NeighbourhoodName,
    corresponNeigHood.CODE  NeighbourhoodCode,
    corresponCity.CITY_NAME	CityName,
    0 CityExternalCode,
    CAST(corresponCity.CODE AS VARCHAR) CityCode,
    corresponGeostate.GEO_STATE_NAME GeographicName,
    CAST(corresponGeoStateExternal.CODE AS VARCHAR) GeographicExternalCode,
    CAST(corresponGeoState.ISO_CODE AS VARCHAR) GeographicCode,
    corresponAddres.POSTAL_CODE PostalCode,
    corresponAddres.IS_BIS	   IsBis,
    corresponAddres.FLOOR      Floor,
    corresponAddres.APARTMENT  Apartment,
    (case when cusCorresponAddres.SAMEASPHYSICAL = 1 then physicalAddres.COMPLEMENT else corresponAddres.COMPLEMENT end) as AdditionalInfo,
    --------ContactPhoneCorrespondance
    (case when cusCorresponAddres.SAMEASPHYSICAL = 1 then (
        SELECT CONCAT( personalPhone.country_code,personalPhone.AREA_CODE,personalPhone.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN
             (
                 SELECT MAX(personalPhone.ID_CUSTOMER_CONTACT_INFO) CCI, contactInfo.ID_CUSTOMER
                 FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                          INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                     AND personalPhone.PHONE_TYPE = 1 --PHONE
                 WHERE contactInfo.CONTACT_TYPE = 1 --OWN
                   AND contactInfo.CONTACT_INFO_TYPE = 1 -- PHONE
                   AND contactInfo.ID_CUSTOMER = customer.ID_CUSTOMER
                 GROUP BY contactInfo.ID_CUSTOMER
             )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) else (
        SELECT CONCAT( personalPhone.country_code,personalPhone.AREA_CODE,personalPhone.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN
             (
                 SELECT MAX(personalPhone.ID_CUSTOMER_CONTACT_INFO) CCI, contactInfo.ID_CUSTOMER
                 FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                          INNER JOIN ICS_PHONE_CONTACT_INFO personalPhone on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalPhone.ID_CUSTOMER_CONTACT_INFO
                     AND personalPhone.PHONE_TYPE = 1 --PHONE
                 WHERE contactInfo.CONTACT_TYPE = 3 --CORRESPONDENCE
                   AND contactInfo.CONTACT_INFO_TYPE = 1 -- PHONE
                   AND contactInfo.ID_CUSTOMER = customer.ID_CUSTOMER
                 GROUP BY contactInfo.ID_CUSTOMER
             )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) end ) PhoneNumber,
    ------ContactCelCorrespondance
    (case when cusCorresponAddres.SAMEASPHYSICAL = 1 then (
        SELECT CONCAT( personalCel.country_code,personalCel.AREA_CODE,personalCel.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalCel on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalCel.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN (SELECT MAX(personalCelMax.ID_CUSTOMER_CONTACT_INFO) CCI
                             FROM ICS_CUSTOMER_CONTACT_INFO contactInfoMax
                                      INNER JOIN ICS_PHONE_CONTACT_INFO personalCelMax on contactInfoMax.ID_CUSTOMER_CONTACT_INFO = personalCelMax.ID_CUSTOMER_CONTACT_INFO
                                 AND  personalCelMax.PHONE_TYPE = 3 --CELLULAR
                             WHERE contactInfoMax.CONTACT_TYPE = 1 --OWN
                               AND contactInfoMax.CONTACT_INFO_TYPE = 1 -- PHONE
                               AND contactInfoMax.ID_CUSTOMER = customer.ID_CUSTOMER
                             GROUP BY contactInfoMax.ID_CUSTOMER
        )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) else (
        SELECT CONCAT( personalCel.country_code,personalCel.AREA_CODE,personalCel.PHONE_NUMBER)
        FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                 INNER JOIN ICS_PHONE_CONTACT_INFO personalCel on contactInfo.ID_CUSTOMER_CONTACT_INFO = personalCel.ID_CUSTOMER_CONTACT_INFO
                 INNER JOIN (SELECT MAX(personalCelMax.ID_CUSTOMER_CONTACT_INFO) CCI
                             FROM ICS_CUSTOMER_CONTACT_INFO contactInfoMax
                                      INNER JOIN ICS_PHONE_CONTACT_INFO personalCelMax on contactInfoMax.ID_CUSTOMER_CONTACT_INFO = personalCelMax.ID_CUSTOMER_CONTACT_INFO
                                 AND  personalCelMax.PHONE_TYPE = 3 --CELLULAR
                             WHERE contactInfoMax.CONTACT_TYPE = 3 --CORRESPONDENCE
                               AND contactInfoMax.CONTACT_INFO_TYPE = 1 -- PHONE
                               AND contactInfoMax.ID_CUSTOMER = customer.ID_CUSTOMER
                             GROUP BY contactInfoMax.ID_CUSTOMER
        )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
    ) end ) CeeLNumber,
    warranty.WARRANTY_TYPE WarrantyType,
    warranty.DESCRIPTION WarrantyDescription
FROM
    IAC_GENERAL_ACCOUNT gralAcc
        INNER JOIN IBC_ACCOUNT_STATUS accSta ON accSta.ID_ACCOUNT_STATUS = gralAcc.ID_ACCOUNT_STATUS
        INNER JOIN ICS_FINANCIAL_RELATION finRelMain ON finRelMain.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
        INNER JOIN ICS_CUSTOMER customer ON finRelMain.ID_CUSTOMER = customer.ID_CUSTOMER
        AND customer.ID_ISSUER = :IdIssuer
        INNER JOIN TGD_DOCUMENT_TYPE documentType ON  customer.ID_DOCUMENT_TYPE = documentType.ID_DOCUMENT_TYPE
        LEFT JOIN ICS_CUSTOMER_WARRANTY warranty ON finRelMain.ID_FINANCIAL_RELATION = warranty.ID_FINANCIAL_RELATION
        --------customerPhysicalAddress
        LEFT  JOIN ICS_CUSTOMER_ADDRESS customerPhysicalAddres ON customer.ID_CUSTOMER = customerPhysicalAddres.ID_CUSTOMER
        AND customerPhysicalAddres.ADDRESS_TYPE = 1  --PHYSYCAL_ADDRESS
        LEFT JOIN TGD_ADDRESS physicalAddres ON customerPhysicalAddres.ID_ADDRESS = physicalAddres.ID_ADDRESS
        ----------CorrespondanceAddress
        LEFT  JOIN ICS_CUSTOMER_ADDRESS cusCorresponAddres ON customer.ID_CUSTOMER = cusCorresponAddres.ID_CUSTOMER
        AND cusCorresponAddres.ADDRESS_TYPE = 3  --CORRESPONDANCE
        AND  cusCorresponAddres.ID_GENERAL_ACCOUNT = gralAcc.ID_GENERAL_ACCOUNT
        LEFT JOIN TGD_ADDRESS corresponAddres ON cusCorresponAddres.ID_ADDRESS = corresponAddres.ID_ADDRESS
        LEFT JOIN TGD_COUNTRY corresponCountry ON corresponAddres.ID_COUNTRY = corresponCountry.ID_COUNTRY
        LEFT JOIN TGD_CITY corresponCity ON corresponCountry.ID_COUNTRY = corresponCity.ID_COUNTRY
        AND corresponCity.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponAddres.ID_COUNTRY = corresponCity.ID_COUNTRY
        AND corresponAddres.ID_CITY = corresponCity.ID_CITY
        LEFT JOIN IBC_CITY_EXTERNAL_CODE corresponCityExternal ON corresponCountry.ID_COUNTRY = corresponCityExternal.ID_COUNTRY
        AND corresponCity.ID_GEO_STATE = corresponCityExternal.ID_GEO_STATE
        AND corresponAddres.ID_CITY = corresponCityExternal.ID_CITY
        AND customer.ID_ISSUER = corresponCityExternal.ID_ISSUER
        AND corresponAddres.ID_COUNTRY = corresponCityExternal.ID_COUNTRY
        LEFT JOIN (SELECT ID_CITY, MIN(CODE) AS CODE
                   FROM IBC_CITY_EXTERNAL_CODE  GROUP BY ID_CITY)
        cityExternal2 ON corresponCityExternal.CODE = cityExternal2.CODE
        LEFT OUTER JOIN TGD_GEO_STATE corresponGeostate ON corresponGeostate.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponGeostate.ID_COUNTRY = corresponAddres.ID_COUNTRY
        LEFT JOIN IBC_GEO_STATE_EXTERNAL_CODE  corresponGeoStateExternal ON  corresponGeostate.ID_COUNTRY =  corresponGeoStateExternal.ID_COUNTRY
        AND  corresponGeostate.ID_GEO_STATE =  corresponGeoStateExternal.ID_GEO_STATE
        LEFT OUTER JOIN TGD_STREET corresponStreet ON corresponAddres.ID_STREET = corresponStreet.ID_STREET
        LEFT OUTER JOIN TGD_NEIGHBOURHOOD corresponNeigHood ON corresponNeigHood.ID_NEIGHBOURHOOD = corresponAddres.ID_NEIGHBOURHOOD
        AND corresponNeigHood.ID_CITY = corresponAddres.ID_CITY
        AND corresponNeigHood.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
        AND corresponNeigHood.ID_COUNTRY = corresponAddres.ID_COUNTRY
WHERE
    gralAcc.ID_ISSUER = :IdIssuer AND
    customer.IS_INNOMINATE = 0 AND
    accSta.STATUS_TYPE <> 4
    and gralAcc.INTERNAL_ACCOUNT_NUMBER = '0000000109' -- temporal para filtrar solo una cuenta
order by gralAcc.INTERNAL_ACCOUNT_NUMBER


--    and gralAcc.INTERNAL_ACCOUNT_NUMBER = '0000000062' -- temporal para filtrar solo una cuenta

select * --customer.document, count(*)
from ICS_CUSTOMER customer
         inner join ics_customer_address cusCorresponAddress on customer.ID_CUSTOMER = cusCorresponAddress.ID_CUSTOMER
--  left join TGD_ADDRESS corresponAddres on cusCorresponAddress.ID_ADDRESS = corresponAddres.ID_ADDRESS
--           LEFT JOIN TGD_COUNTRY corresponCountry ON corresponAddres.ID_COUNTRY = corresponCountry.ID_COUNTRY
--           LEFT JOIN TGD_CITY corresponCity ON corresponCountry.ID_COUNTRY = corresponCity.ID_COUNTRY
--                                                   AND corresponCity.ID_GEO_STATE = corresponAddres.ID_GEO_STATE
--                 AND corresponAddres.ID_COUNTRY = corresponCity.ID_COUNTRY
--                 AND corresponAddres.ID_CITY = corresponCity.ID_CITY
where customer.DOCUMENT in (
--'111111112',
'345678765'
    ,'767676767'
    )


select * from ICS_CUSTOMER_ADDRESS where ID_CUSTOMER = 11
select * from TGD_ADDRESS where ID_ADDRESS in (18,28)

--- report.tql
SELECT
    ga.ID_ISSUER                                     AS IdIssuer,
    COALESCE(ga.INTERNAL_ACCOUNT_NUMBER, '')         AS InternalAccountNumber,
    ga.ID_GENERAL_ACCOUNT                            AS IdGeneralAccount,

    COALESCE(pm.CARD_NUMBER, '')                     AS CardNumber,
    pm.DUE_DATE                                      AS CardDueDate,

    COALESCE(issuerProduct.EXTERNAL_ISSUER_ID, '')   AS ProductCode,
    accStatus.STATUS_CODE                            AS AccountStatusCode,
    pmStatus.STATUS_TYPE                             AS PaymentMediaStatusType,

    COALESCE(cust.DOCUMENT, '')                      AS DocumentNumber,
    cust.ID_DOCUMENT_TYPE                            AS DocumentType,

    COALESCE(person.NAME, '')                        AS FirstName,
    COALESCE(person.SECOND_NAME, '')                 AS SecondName,
    COALESCE(person.SURNAME, '')                     AS LastName,
    person.BIRTH_DATE                                AS BirthDate,

    COALESCE(addr.STREET, '')                        AS StreetName,
    COALESCE(CAST(addr.DOOR_NUMBER AS VARCHAR(50)), '') AS DoorNumber,
    COALESCE(addr.APARTMENT, '')                     AS Apartment,
    COALESCE(addr.FLOOR, '')                         AS Floor,
    COALESCE(addr.COMPLEMENT, '')                    AS Complement,
    COALESCE(CAST(addr.POSTAL_CODE AS VARCHAR(50)), '') AS PostalCode,
    COALESCE(city.CITY_NAME, '')                     AS CityName,
    COALESCE(geo.ISO_CODE, '')                       AS StateName,

    COALESCE(emailData.EMAIL, '')                    AS Email,

    COALESCE(phoneData.Phone, '')                    AS Phone,

    COALESCE(creditGen.CREDIT_LIMIT_FIXED_VALUE, 0)  AS CreditLimit,
    COALESCE(accProp.PENALTY_DAYS, 0)                AS DelinquencyDays,

    -- IFN_BALANCE: filtrado según GA (correcto)
    COALESCE(bal.LOCAL_BALANCE_AMOUNT, 0)            AS StatementBalance,
    COALESCE(bal.LOCAL_MINIMUM_PAYMENT_AMOUNT, 0)    AS CurrentPaymentDue,
    COALESCE(bal.LOCAL_TOTAL_PAYMENT_AMOUNT, 0)      AS PaymentTotalAmountDue,

    cal.DUE_DATE                                     AS NextPaymentDueDate,

    pm.DUE_DATE                                      AS DatePaymentDue,

    COALESCE(officePhoneData.OfficePhone, '')         AS OfficePhone,
    accProp.CREATION_DATE                             AS DateOpened,
    accProp.BUSSINES_DATE                             AS LastActivityDate

FROM IAC_GENERAL_ACCOUNT ga
         INNER JOIN ICS_FINANCIAL_RELATION fr
                    ON fr.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT

         INNER JOIN ICS_CUSTOMER cust
                    ON cust.ID_CUSTOMER = fr.ID_CUSTOMER
                        AND cust.IS_INNOMINATE = 0

         INNER JOIN ICS_PHYSICAL_PERSON_CUSTOMER person
                    ON person.ID_CUSTOMER = cust.ID_CUSTOMER

         INNER JOIN IBC_ACCOUNT_STATUS accStatus
                    ON accStatus.ID_ACCOUNT_STATUS = ga.ID_ACCOUNT_STATUS

         LEFT JOIN IAC_CREDIT_GENERAL_ACCOUNT creditGen
                   ON creditGen.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT

         LEFT JOIN IAC_ACCOUNT_PROPERTY accProp
                   ON accProp.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT

         LEFT JOIN (
    SELECT cci.ID_CUSTOMER,
           emi.EMAIL
    FROM ICS_CUSTOMER_CONTACT_INFO cci
             INNER JOIN ICS_EMAIL_CONTACT_INFO emi
                        ON emi.ID_CUSTOMER_CONTACT_INFO = cci.ID_CUSTOMER_CONTACT_INFO
             INNER JOIN (
        SELECT MAX(cci2.ID_CUSTOMER_CONTACT_INFO) AS MaxCCI, cci2.ID_CUSTOMER
        FROM ICS_CUSTOMER_CONTACT_INFO cci2
                 INNER JOIN ICS_EMAIL_CONTACT_INFO emi2
                            ON emi2.ID_CUSTOMER_CONTACT_INFO = cci2.ID_CUSTOMER_CONTACT_INFO
        WHERE cci2.CONTACT_INFO_TYPE = 2  -- EMAIL
          AND cci2.CONTACT_TYPE = 1
        GROUP BY cci2.ID_CUSTOMER
    ) maxEmail ON cci.ID_CUSTOMER_CONTACT_INFO = maxEmail.MaxCCI
) emailData ON emailData.ID_CUSTOMER = cust.ID_CUSTOMER

         LEFT JOIN (
    SELECT cci.ID_CUSTOMER,
           CONCAT(COALESCE(phi.AREA_CODE, ''), COALESCE(phi.PHONE_NUMBER, '')) AS Phone
    FROM ICS_CUSTOMER_CONTACT_INFO cci
             INNER JOIN ICS_PHONE_CONTACT_INFO phi
                        ON phi.ID_CUSTOMER_CONTACT_INFO = cci.ID_CUSTOMER_CONTACT_INFO
             INNER JOIN (
        SELECT MAX(cci2.ID_CUSTOMER_CONTACT_INFO) AS MaxCCI, cci2.ID_CUSTOMER
        FROM ICS_CUSTOMER_CONTACT_INFO cci2
                 INNER JOIN ICS_PHONE_CONTACT_INFO phi2
                            ON phi2.ID_CUSTOMER_CONTACT_INFO = cci2.ID_CUSTOMER_CONTACT_INFO
        WHERE cci2.CONTACT_INFO_TYPE = 1   -- PHONE
          AND cci2.CONTACT_TYPE = 1        -- OWN (domicilio)
          AND phi2.PHONE_TYPE = 1          -- fijo
        GROUP BY cci2.ID_CUSTOMER
    ) maxPhone ON cci.ID_CUSTOMER_CONTACT_INFO = maxPhone.MaxCCI
) phoneData ON phoneData.ID_CUSTOMER = cust.ID_CUSTOMER

         LEFT JOIN (
    SELECT cci.ID_CUSTOMER,
           CONCAT(COALESCE(phi.AREA_CODE, ''), COALESCE(phi.PHONE_NUMBER, '')) AS OfficePhone
    FROM ICS_CUSTOMER_CONTACT_INFO cci
             INNER JOIN ICS_PHONE_CONTACT_INFO phi
                        ON phi.ID_CUSTOMER_CONTACT_INFO = cci.ID_CUSTOMER_CONTACT_INFO
             INNER JOIN (
        SELECT MAX(cci2.ID_CUSTOMER_CONTACT_INFO) AS MaxCCI, cci2.ID_CUSTOMER
        FROM ICS_CUSTOMER_CONTACT_INFO cci2
                 INNER JOIN ICS_PHONE_CONTACT_INFO phi2
                            ON phi2.ID_CUSTOMER_CONTACT_INFO = cci2.ID_CUSTOMER_CONTACT_INFO
        WHERE cci2.CONTACT_INFO_TYPE = 1   -- PHONE
          AND cci2.CONTACT_TYPE = 2        -- LABORAL (datos laborales)
          AND phi2.PHONE_TYPE = 1          -- fijo
        GROUP BY cci2.ID_CUSTOMER
    ) maxOfficePhone ON cci.ID_CUSTOMER_CONTACT_INFO = maxOfficePhone.MaxCCI
) officePhoneData ON officePhoneData.ID_CUSTOMER = cust.ID_CUSTOMER

         LEFT JOIN IFN_BALANCE bal
                   ON bal.ID_GENERAL_ACCOUNT = ga.ID_GENERAL_ACCOUNT
                       AND bal.ID_CYCLE           = ga.ID_CYCLE
                       AND bal.PERIOD             = ga.ACCOUNT_PERIOD

         LEFT JOIN IBC_CYCLE_CALENDAR cal
                   ON cal.ID_CYCLE = ga.ID_CYCLE
                       AND cal.PERIOD   = ga.ACCOUNT_PERIOD

         INNER JOIN ICS_ACCOUNT_RELATION accRel
                    ON accRel.ID_FINANCIAL_RELATION = fr.ID_FINANCIAL_RELATION

         INNER JOIN ICS_PAYMENT_MEDIA_RELATION pmRel
                    ON pmRel.ID_ACCOUNT_RELATION = accRel.ID_ACCOUNT_RELATION

         INNER JOIN IAC_PAYMENT_MEDIA pm
                    ON pm.ID_PAYMENT_MEDIA = pmRel.ID_PAYMENT_MEDIA

         INNER JOIN IBC_PAYMENT_MEDIA_STATUS pmStatus
                    ON pmStatus.ID_PAYMENT_MEDIA_STATUS = pm.ID_PAYMENT_MEDIA_STATUS

         INNER JOIN IBC_PRODUCT prod
                    ON prod.ID_PRODUCT = pm.ID_PRODUCT

         INNER JOIN IBC_ISSUER_PRODUCT issuerProduct
                    ON issuerProduct.ID_PRODUCT = prod.ID_PRODUCT

    -- Dirección: una sola por cliente (MAX ID) para evitar duplicados
         LEFT JOIN (
    SELECT MAX(ca.ID_CUSTOMER_ADDRESS) AS MaxCA, ca.ID_CUSTOMER
    FROM ICS_CUSTOMER_ADDRESS ca
    WHERE ca.ADDRESS_TYPE = 1
    GROUP BY ca.ID_CUSTOMER
) maxAddr ON maxAddr.ID_CUSTOMER = cust.ID_CUSTOMER

         LEFT JOIN ICS_CUSTOMER_ADDRESS custAddr
                   ON custAddr.ID_CUSTOMER_ADDRESS = maxAddr.MaxCA

         LEFT JOIN TGD_ADDRESS addr
                   ON addr.ID_ADDRESS = custAddr.ID_ADDRESS

         LEFT JOIN TGD_CITY city
                   ON city.ID_CITY     = addr.ID_CITY
                       AND city.ID_COUNTRY = addr.ID_COUNTRY

         LEFT JOIN TGD_GEO_STATE geo
                   ON geo.ID_GEO_STATE = city.ID_GEO_STATE
                       AND geo.ID_COUNTRY  = city.ID_COUNTRY

WHERE ga.ID_ISSUER = :IdIssuer and INTERNAL_ACCOUNT_NUMBER = '0000000109' -- temporal para filtrar solo una cuenta

