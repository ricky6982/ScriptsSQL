---
name: sync-datadump-sql
description: Synchronizes a DataDump SQL script with its DTO using the CsvOrder attribute and the column lengths defined in length.txt.
---

# Objective

Synchronize a DataDump SQL script with its corresponding DTO.

The generated script must:

- Remove all existing field definitions for the selected DataDump.
- Recreate every field definition from the DTO.
- Use the field lengths defined in `length.txt`.
- Generate the `INSERT` statements ordered by the `[CsvOrder]` attribute.
- Append a rollback section at the end of the script.

The SQL script must always remain synchronized with the DTO and the CSV definition.

---

# Source of Truth

The information comes from two files.

## DTO

The DTO defines:

- The field names.
- The CSV column order through the `[CsvOrder]` attribute.

Only properties decorated with `[CsvOrder]` must be included.

Properties without `[CsvOrder]` must be ignored.

## length.txt

The `length.txt` file defines the length of every CSV column.

Each line represents one CSV column in the exported CSV.

The position in `length.txt` corresponds to the property's `CsvOrder`.

The numeric length extracted from each line must be used as the SQL `LENGTH` value.

---

# Input

The skill expects:

- A DTO class.
- The corresponding `length.txt`.
- The SQL script to update.

---

# Supported TYPE_NAME values

The SQL script must target one of the following file types:

- DATA_DUMP_RPT_ACCOUNT
- DATA_DUMP_RPT_CLIENT
- DATA_DUMP_RPT_PAYMENT_MEDIA
- DATA_DUMP_RPT_TRANSACTIONS
- DATA_DUMP_RPT_CONFIRMED_TRANSACTIONS
- DATA_DUMP_RPT_PAYMENTS
- DATA_DUMP_RPT_SERVICES
- DATA_DUMP_RPT_FINANCIAL_INTEREST
- DATA_DUMP_RPT_PENALTY_INTEREST
- DATA_DUMP_RPT_PURCHASE_INTEREST
- DATA_DUMP_RPT_OPERATIONS
- DATA_DUMP_RPT_ACCOUNT_CLIENT
- DATA_DUMP_RPT_EMPLOY
- DATA_DUMP_RPT_TAX
- DATA_DUMP_RPT_ALERTS

The existing `TYPE_NAME` found in the SQL script must be preserved.

---

# SQL Template

The generated SQL must follow this structure.

```sql
-- Script for <TYPE_NAME>

-- Elimina las propiedades que ya existen para no tener extras sin uso
DELETE [IBC_ISSUER_FILE_TYPE_FIELDS]
WHERE ID_ISSUER = 999
AND ID_FILE_TYPE = (
    SELECT ID_FILE_TYPE
    FROM TFM_FILE_TYPE
    WHERE TYPE_NAME = '<TYPE_NAME>'
);

-- <Friendly Name> fields

INSERT INTO IBC_ISSUER_FILE_TYPE_FIELDS
(
    ID_FILE_TYPE,
    ID_ISSUER,
    FIELD,
    IS_VISIBLE,
    LENGTH
)
VALUES
(
    (
        SELECT ID_FILE_TYPE
        FROM TFM_FILE_TYPE
        WHERE TYPE_NAME = '<TYPE_NAME>'
    ),
    999,
    '<PropertyName>',
    1,
    <Length>
);
```

Generate one `INSERT` statement for every property decorated with `[CsvOrder]`.

---

# Rollback

At the end of the generated SQL script, always append the following rollback section.

```sql
-- =============================================
-- Rollback
-- =============================================

DELETE [IBC_ISSUER_FILE_TYPE_FIELDS]
WHERE ID_ISSUER = 999
AND ID_FILE_TYPE = (
    SELECT ID_FILE_TYPE
    FROM TFM_FILE_TYPE
    WHERE TYPE_NAME = '<TYPE_NAME>'
);
```

The rollback must always be the last statement in the script.

---

# Generation Rules

1. Read every property decorated with `[CsvOrder]`.
2. Ignore properties without `[CsvOrder]`.
3. Sort all properties by `CsvOrder`.
4. Read `length.txt`.
5. Match each property with its corresponding length using the CSV order.
6. Generate one `INSERT` statement per property.
7. Preserve the existing `TYPE_NAME`.
8. Use the DTO property name as the `FIELD` value.
9. Use the value from `length.txt` as the `LENGTH`.
10. `IS_VISIBLE` is always `1`.
11. `ID_ISSUER` is always `999`.
12. Remove any existing field definitions before generating the new ones.
13. Do not generate fields that are not present in the DTO.
14. Generate the rollback section as the last part of the script.
15. Produce deterministic output: identical inputs must always generate identical SQL.

---

# Validation

Before generating the SQL script, validate that:

- Every `[CsvOrder]` has a corresponding entry in `length.txt`.
- There are no duplicate `CsvOrder` values.
- There are no gaps in the ordering.
- The number of generated `INSERT` statements matches the number of properties decorated with `[CsvOrder]`.

If any validation fails, stop the generation process and report the inconsistency instead of producing a partial script.

---

# Expected Result

The generated SQL script must:

1. Begin with the `DELETE` statement.
2. Contain one `INSERT` statement for every property decorated with `[CsvOrder]`.
3. Use the DTO property names as the `FIELD` values.
4. Use the lengths defined in `length.txt`.
5. End with the rollback section.
6. Be fully synchronized with the DTO and the CSV definition.