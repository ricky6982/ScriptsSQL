select ica.ID_CUSTOMER, * from TGD_ADDRESS a
         inner join dbo.ICS_CUSTOMER_ADDRESS ICA on a.ID_ADDRESS = ICA.ID_ADDRESS
order by a.ID_ADDRESS desc

select * from ICS_CUSTOMER_ADDRESS ca
inner join TGD_ADDRESS a on ca.ID_ADDRESS = a.ID_ADDRESS
         where ca.ID_CUSTOMER = 387
order by ca.ID_CUSTOMER_ADDRESS desc

select * from TVM_MENU_ITEM
WHERE ID_USE_CASE = 'ICSUC075_InternationalAccountMaintenance'


-- Preview duplicates first
SELECT *, ROW_NUMBER() OVER (
    PARTITION BY ID_USE_CASE  -- Add other columns that define "duplicate" here
    ORDER BY (SELECT NULL)
    ) AS rn
FROM TVM_MENU_ITEM
WHERE ID_USE_CASE = 'ICSUC075_InternationalAccountMaintenance';

-- Delete duplicates, keeping one row
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY ID_USE_CASE  -- Add other columns that define "duplicate" here
        ORDER BY (SELECT NULL)
        ) AS rn
    FROM TVM_MENU_ITEM
    WHERE ID_USE_CASE = 'ICSUC075_InternationalAccountMaintenance'
)
DELETE FROM CTE WHERE rn > 1;