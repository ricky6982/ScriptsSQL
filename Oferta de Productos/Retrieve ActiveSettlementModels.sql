select *
from IAC_ACCOUNT_SETT_MODEL
where ID_ISSUER = :issuer
    AND VALID_FROM <= :customeDate and :customeDate <= VALID_TO
    AND ID_ISS_SETT_MOD_TYPE = 3;

SELECT * FROM IAC_CREDIT_GENERAL_ACCOUNT;