select * from IBC_PRODUCT_TRANSITION;

select pt.ID_PRODUCT_ORIG, p1.PRODUCT_NAME as ProductOrigen, pt.ID_PRODUCT_DEST, p2.PRODUCT_NAME as ProductDest
from dbo.IBC_PRODUCT_TRANSITION pt
         inner join dbo.IBC_PRODUCT p1 on pt.ID_PRODUCT_ORIG = p1.ID_PRODUCT
         inner join dbo.IBC_PRODUCT p2 on pt.ID_PRODUCT_DEST = p2.ID_PRODUCT;

select * from dbo.IBC_PRODUCT;

SELECT
    ID_SETTLEMENT_MODEL IdSettModel,
    ID_ISSUER IdIssuer,
    ID_PRODUCT IdProduct
FROM
    IBC_SETTLEMENT_MODEL_PRODUCTS

