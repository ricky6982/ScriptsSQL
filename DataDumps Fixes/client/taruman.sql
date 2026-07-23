SELECT
    DISTINCT customer.ID_CUSTOMER IdCustomer,
             customer.DOCUMENT Document,
             physicalPersonCustomer.NAME Name,
             physicalPersonCustomer.SURNAME Lastname,
             physicalPersonCustomer.BIRTH_DATE Birthday,
             physicalPersonCustomer.MARITAL_STATUS MaritalStatus,
             TRIM(street.STREET_NAME) Street,
             TRIM(address.DOOR_NUMBER) DoorNumber,
             TRIM(address.APARTMENT) AptoNumber,
             TRIM(address.COMPLEMENT) Complement,
             CASE address.NEIGHBOURHOOD_INPUT_MODE
                 WHEN 1
                     THEN TRIM(Neighbourhood.NEIGHBOURHOOD_NAME)
                 ELSE TRIM(address.NEIGHBOURHOOD)
                 END NeightbourhoodName,
             CASE address.NEIGHBOURHOOD_INPUT_MODE
                 WHEN 1
                     THEN Neighbourhood.CODE
                 ELSE ''
                 END NeightbourhoodCode,
             TRIM(city.CITY_NAME) CityName,
             city.CODE CityCode,
             0 CityExternalCode,
             TRIM(TGS.GEO_STATE_NAME) StateName,
             TGS.ISO_CODE StateCode,
             geoStateExternal.CODE StateExternalCode,
             TRIM(address.POSTAL_CODE) PostalCode,
             (
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
             ) CellularPhone,
             (
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
             ) Phone,
             (
                 SELECT personalEmail.EMAIL
                 FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                          INNER JOIN ICS_EMAIL_CONTACT_INFO personalEmail ON contactInfo.ID_CUSTOMER_CONTACT_INFO = personalEmail.ID_CUSTOMER_CONTACT_INFO
                          INNER JOIN (
                     SELECT MAX(personalEmail.ID_CUSTOMER_CONTACT_INFO) CCI, contactInfo.ID_CUSTOMER
                     FROM ICS_CUSTOMER_CONTACT_INFO contactInfo
                              INNER JOIN ICS_EMAIL_CONTACT_INFO personalEmail ON contactInfo.ID_CUSTOMER_CONTACT_INFO = personalEmail.ID_CUSTOMER_CONTACT_INFO
                         AND EMAIL_TYPE = 1 --PERSONAL
                     WHERE contactInfo.CONTACT_TYPE = 1 --OWN
                       AND contactInfo.CONTACT_INFO_TYPE = 2 -- EMAIL
                       AND contactInfo.ID_CUSTOMER = customer.ID_CUSTOMER
                     GROUP BY contactInfo.ID_CUSTOMER
                 )maxCCI on contactInfo.ID_CUSTOMER_CONTACT_INFO = maxCCI.cci
             ) Email,
             CASE address.STREET_INPUT_MODE
                 WHEN 1 --SELECTED_FROM_CONFIGURED
                     THEN street.ID_STREET_TYPE
                 ELSE 1
                 END StreetType,
             address.IS_BIS IsBis,
             TRIM(address.FLOOR)Floor,
             customer.ID_DOCUMENT_TYPE DocumentType,
             TRIM(documentType.DESCRIPTION) DocumentTypeName,
             customer.DOCUMENT_EMISSION_DATE EmisionDate,
             customer.DOCUMENT_DUE_DATE DueDate,
             CAD.ID_DOCUMENT_TYPE SecondaryDocumentType,
             TRIM(documentTypeAdittional.DESCRIPTION) SecondaryDocumentTypeName,
             CAD.DOCUMENT SecondaryDocument,
             TRIM(customer.EMBOSSING_NAME) EmbossingName,
             TRIM(physicalPersonCustomer.SECOND_NAME) SecondName,
             TRIM(physicalPersonCustomer.SECOND_SURNAME) secondSurName,
             CASE
                 WHEN MONTH(businesDate.TODAY_DATE) > MONTH(physicalPersonCustomer.BIRTH_DATE)
                     OR (MONTH(businesDate.TODAY_DATE) = MONTH(physicalPersonCustomer.BIRTH_DATE) AND DAY(businesDate.TODAY_DATE) >= DAY(physicalPersonCustomer.BIRTH_DATE))
                     THEN DATEDIFF(YEAR, physicalPersonCustomer.BIRTH_DATE, businesDate.TODAY_DATE)
                 ELSE DATEDIFF(YEAR, physicalPersonCustomer.BIRTH_DATE, businesDate.TODAY_DATE) - 1
                 END Age,
             physicalPersonCustomer.BIRTH_PLACE BirthPlace,
             physicalPersonCustomer.NATIONALITY Nationality,
             physicalPersonCustomer.GENDER Sex,
             physicalPersonCustomer.NUMBER_OF_CHILDREN NumberChildren
FROM ICS_CUSTOMER customer
         INNER JOIN ICS_FINANCIAL_RELATION finRel ON finRel.ID_CUSTOMER = customer.ID_CUSTOMER
         INNER JOIN IAC_GENERAL_ACCOUNT gralAcc ON gralAcc.ID_GENERAL_ACCOUNT = finRel.ID_GENERAL_ACCOUNT
         INNER JOIN IBC_ACCOUNT_STATUS accSta ON accSta.ID_ACCOUNT_STATUS = gralAcc.ID_ACCOUNT_STATUS
         INNER JOIN IBC_BUSINESS_DATE businesDate ON customer.ID_ISSUER = businesDate.ID_ISSUER
         INNER JOIN TGD_DOCUMENT_TYPE documentType ON  customer.ID_DOCUMENT_TYPE = documentType.ID_DOCUMENT_TYPE
         INNER JOIN ICS_PHYSICAL_PERSON_CUSTOMER physicalPersonCustomer ON customer.ID_CUSTOMER = physicalPersonCustomer.ID_CUSTOMER
         LEFT  JOIN ICS_CUSTOMER_ADDITIONAL_DOC CAD ON customer.ID_CUSTOMER = CAD.ID_CUSTOMER
         LEFT  JOIN TGD_DOCUMENT_TYPE documentTypeAdittional ON  CAD.ID_DOCUMENT_TYPE= documentTypeAdittional.ID_DOCUMENT_TYPE
         LEFT  OUTER JOIN ICS_CUSTOMER_ADDRESS ICA ON customer.ID_CUSTOMER = ICA.ID_CUSTOMER
    AND ICA.ADDRESS_TYPE = 1
         LEFT OUTER JOIN TGD_ADDRESS address ON ICA.ID_ADDRESS = address.ID_ADDRESS
         LEFT OUTER JOIN TGD_STREET street ON address.ID_STREET = street.ID_STREET
         LEFT OUTER JOIN TGD_NEIGHBOURHOOD Neighbourhood ON address.ID_NEIGHBOURHOOD = Neighbourhood.ID_NEIGHBOURHOOD
         LEFT OUTER JOIN TGD_CITY city ON address.ID_CITY = city.ID_CITY AND address.ID_COUNTRY = city.ID_COUNTRY
         LEFT JOIN IBC_CITY_EXTERNAL_CODE cityExternal ON address.ID_COUNTRY = cityExternal.ID_COUNTRY
    AND address.ID_GEO_STATE = cityExternal.ID_GEO_STATE
    AND address.ID_CITY = cityExternal.ID_CITY
    AND customer.ID_ISSUER = cityExternal.ID_ISSUER
         LEFT JOIN (SELECT ID_CITY, MIN(CODE) AS CODE
                    FROM IBC_CITY_EXTERNAL_CODE  GROUP BY ID_CITY)
    cityExternal2 ON cityExternal.CODE = cityExternal2.CODE

         LEFT OUTER JOIN TGD_GEO_STATE TGS ON address.ID_GEO_STATE = TGS.ID_GEO_STATE AND address.ID_COUNTRY = TGS.ID_COUNTRY
         LEFT JOIN IBC_GEO_STATE_EXTERNAL_CODE geoStateExternal ON TGS.ID_COUNTRY = geoStateExternal.ID_COUNTRY
    AND TGS.ID_GEO_STATE = geoStateExternal.ID_GEO_STATE
WHERE
    customer.ID_ISSUER = :IdIssuer AND customer.IS_INNOMINATE = 0 AND accSta.STATUS_TYPE <> 4
ORDER BY customer.ID_CUSTOMER