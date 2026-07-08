---
name: sync-csv-order
description: Synchronizes CsvOrder attributes in a DTO using the field order defined in a length.txt file.
---

# Objective

Synchronize the `[CsvOrder]` attributes of a DTO based on the field order defined in a `length.txt` file.

The purpose of this skill is to keep the DTO synchronized with the CSV specification without modifying the specification itself.

# Inputs

The skill expects:

- A `length.txt` file containing the CSV field definitions.
- A DTO class to update.

# Source of Truth

The `length.txt` file is the **only source of truth** for the CSV field order.

The skill **must never modify** this file.

It is used exclusively to determine the correct `CsvOrder` value for each DTO property.

Only the DTO may be modified.

# length.txt Format

Each line of the file represents a CSV column.

Structure:

```text
<FieldName> <Length>
```

Example:

```text
RecordType 2
IssuerId 6
TransactionId 20
Currency 3
Amount 15
```

Rules:

- The first column is the DTO property name.
- The second column is the field length.
- The field length is informational only.
- The order of the lines defines the CSV export order.

# Synchronization Rules

For every property in the DTO:

1. Search for a field with the same name in `length.txt`.
2. If a match exists:
    - Add `[CsvOrder(n)]` if it does not exist.
    - Update the existing `CsvOrder` if the value is incorrect.
3. Preserve:
    - Existing attributes.
    - XML documentation.
    - Property formatting.
    - Property order.

# Unmatched Properties

If a DTO property cannot be matched with a field in `length.txt`:

- Do **not** assign a `CsvOrder`.
- Do **not** guess the order.
- Add an inline TODO comment explaining the issue.

Example:

```csharp
public string MerchantCountry { get; set; } // TODO: CsvOrder not assigned. Field not found in length.txt
```

# Missing Fields

If a field exists in `length.txt` but no matching DTO property exists:

- Do not create the property.
- Report it in the validation summary.

# Existing CsvOrder

If a property already contains a `[CsvOrder]` attribute:

- Keep it if it is correct.
- Replace it if the value is incorrect.
- Never duplicate the attribute.

# Validation Summary

At the end of the execution, always generate a summary with the following sections.

## Updated Properties

Properties whose `CsvOrder` was added or updated.

## Missing in DTO

Fields found in `length.txt` but not found in the DTO.

## Missing in length.txt

DTO properties without a matching field in `length.txt`.

## Manual Review Required

List every property that requires manual verification together with the reason.

Example:

```text
Manual Review

- MerchantCountry
  Reason: Field not found in length.txt

- InstallmentType
  Reason: Multiple possible matches

- TerminalDescription
  Reason: Unable to determine matching field
```

# Constraints

The skill must:

- Never modify `length.txt`.
- Never reorder DTO properties.
- Never rename DTO properties.
- Never create new properties.
- Never remove existing attributes except replacing an incorrect `CsvOrder`.
- Preserve formatting and XML documentation.
- Modify only the DTO.
- Update a property only when the match with `length.txt` is unambiguous.
- When a match is ambiguous or missing:
    - Leave the property unchanged.
    - Add a TODO comment.
    - Include the property in the validation summary.

# Expected Output

The skill must produce:

1. The updated DTO.
2. A validation summary including:
    - Updated Properties.
    - Missing in DTO.
    - Missing in length.txt.
    - Manual Review Required.