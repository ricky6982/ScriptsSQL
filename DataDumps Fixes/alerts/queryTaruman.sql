SELECT
    en.ID_EXTERNAL_NOTIFICATION        ReferenceNumber,
    en.INTERNAL_ACCOUNT_NUMBER         Account,
    en.GENERATION_DATE                 GeneratedDate,
    en.EXTERNAL_NOTIFICATION_STATUS    AlertStatus,
    en.ALERT_CHANNEL                   AlertChannel,
    en.AMOUNT                          Amount,
    en.ID_CUSTOMER                     CustomerId,
    en.ID_GENERAL_ACCOUNT              GeneralAccountId,
    enm.STRING_ADDRESS_TO              DestinationInfo
FROM ICS_EXTERNAL_NOTIFICATION en
         LEFT JOIN (
    SELECT m.ID_EXTERNAL_NOTIFICATION, m.STRING_ADDRESS_TO, m.ID_EXTERNAL_NOTIFICATION_CONFIG
    FROM (
             SELECT m.ID_EXTERNAL_NOTIFICATION, m.STRING_ADDRESS_TO, m.ID_EXTERNAL_NOTIFICATION_CONFIG,
                    ROW_NUMBER() OVER (PARTITION BY m.ID_EXTERNAL_NOTIFICATION ORDER BY m.ID_EXTERNAL_NOTIFICATION_MESSAGE ASC) rn
             FROM ICS_EXTERNAL_NOTIFICATION_MESSAGE m
         ) m
    WHERE m.rn = 1
) enm ON enm.ID_EXTERNAL_NOTIFICATION = en.ID_EXTERNAL_NOTIFICATION
-- WHERE en.ID_ISSUER = :IdIssuer
--   AND en.GENERATION_DATE >= :FilterDate