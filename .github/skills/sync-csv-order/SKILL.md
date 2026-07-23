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

The skill **must never modify** this file directly during synchronization.

It is used exclusively to determine the correct `CsvOrder` value for each DTO property.

Only the DTO may be modified during the synchronization process.

However, after synchronization, a **generated mapping report** is produced based on the DTO properties that have been successfully matched and assigned `CsvOrder` attributes. This report can be used for manual verification and to update the `length.txt` file if needed to ensure consistency.

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

# Constructor Property Initialization

After updating the DTO properties with `CsvOrder` attributes, verify that all properties are properly initialized in the DTO constructor.

## Initialization Check Rules

For each public property in the DTO:

1. Check if it is initialized in the constructor.
2. If the property **is initialized**:
   - No action is required.
3. If the property **is NOT initialized**:
   - Add an inline TODO comment on the property indicating that it needs initialization in the constructor.
   - Example: `public string TransactionId { get; set; } // TODO: Initialize in constructor`

## Constructor Initialization Example

```csharp
public class TransactionDTO
{
    [CsvOrder(1)]
    public string RecordType { get; set; }

    [CsvOrder(2)]
    public string IssuerId { get; set; } // TODO: Initialize in constructor

    [CsvOrder(3)]
    public string TransactionId { get; set; }

    public TransactionDTO()
    {
        RecordType = string.Empty;
        TransactionId = string.Empty;
        // IssuerId is missing initialization
    }
}
```

## Expected Behavior

- Properties that are not initialized in the constructor should be flagged with a TODO comment.
- This check ensures that all properties have explicit initialization values, preventing null reference issues.
- Include these uninitialized properties in the "Manual Review Required" section of the validation summary.

# Generated Mapping Report

After synchronizing the DTO with `CsvOrder` attributes, a **mapping report** must be generated that shows the current mapping of all properties.

## Purpose

The mapping report serves as a verification tool to ensure that:

1. All properties are correctly mapped.
2. The CSV field order is accurate.
3. Manual updates to `length.txt` can be made confidently.

## Mapping Report Format

The report should display the mapping in the same format as `length.txt`:

```text
<FieldName> <Length>
```

Or with additional information for manual verification:

```text
[dtoProperty] <FieldName> <Length> [CsvOrder(<order>)]
```

Example:

```text
RecordType 2 [CsvOrder(1)]
IssuerId 6 [CsvOrder(2)]
TransactionId 20 [CsvOrder(3)]
Currency 3 [CsvOrder(4)]
Amount 15 [CsvOrder(5)]
```

## How to Use

1. **Generate the mapping report** after running the skill.
2. **Review the report** to verify that all fields are correctly ordered.
3. **Compare with the current `length.txt`** to identify any differences.
4. **Manually update `length.txt`** if needed to match the generated mapping, ensuring consistency.

## Rules for Mapping Report

- Include only properties that have been assigned a `CsvOrder` attribute.
- Sort the report by the `CsvOrder` value in ascending order.
- Include fields from the original `length.txt` that were used for mapping.
- Preserve the original field lengths from `length.txt` when available.

# Validation Summary

At the end of the execution, always generate a summary with the following sections.

## Updated Properties

Properties whose `CsvOrder` was added or updated.

## Missing in DTO

Fields found in `length.txt` but not found in the DTO. Add a comment to manually verify the field.

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

- IssuerId
  Reason: Property not initialized in constructor
```

# Constraints

The skill must:

- Generate a mapping report for manual verification and updating `length.txt`.
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
- Verify that all public properties are initialized in the constructor.
- Add TODO comments for properties that are not initialized in the constructor.

## Manual Update of length.txt

The generated mapping report is provided as a reference:

- The report should be reviewed manually.
- The user **may** update `length.txt` based on the generated mapping report.
- The skill does not automatically update `length.txt` to preserve data integrity.
- Any updates to `length.txt` should be done consciously by the user after reviewing the mapping report.

# Expected Output

The skill must produce:

1. The updated DTO with:
   - Correct `CsvOrder` attributes.
   - TODO comments for uninitialized properties in the constructor.

2. A **generated mapping report** showing the CSV field mapping with order information, which can be used to manually update `length.txt` for verification purposes.

3. A validation summary including:
    - Updated Properties.
    - Missing in DTO.
    - Missing in length.txt.
    - Manual Review Required (including properties not initialized in the constructor).

## Manual Verification Step

After obtaining the generated mapping report:

1. Review the mapping report carefully.
2. Compare it with the current `length.txt` to ensure correctness.
3. Manually update the `length.txt` file if discrepancies are found.
4. Re-run the skill if significant changes were made to `length.txt`.

This ensures that the CSV specification remains consistent with the DTO implementation.

