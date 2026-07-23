using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetInteresForDataDump;
using System;
using PS.CommonCredit.Domain.Util.Attribute;


namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class FinancialInterestForDataDumpDTO
    {
        [CsvOrder(1)]
        public string IdOperation { get; set; }
        [CsvOrder(2)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(3)]
        public string OperationDate { get; set; }
        [CsvOrder(4)]
        public string Currency { get; set; }
        [CsvOrder(5)]
        public string Sign { get; set; }
        [CsvOrder(6)]
        public string Amount { get; set; }
        [CsvOrder(7)]
        public string InterestTaxed { get; set; }
        [CsvOrder(8)]
        public string InterestExcent { get; set; }
        [CsvOrder(9)]
        public string Tax { get; set; } // TODO: CsvOrder assigned but field name mismatch. DTO property is "Tax" but length.txt field is "IVA". Verify this mapping.
        [CsvOrder(10)]
        public string SourceCode { get; set; }
        [CsvOrder(11)]
        public string TransCode { get; set; }
        public FinancialInterestForDataDumpDTO(GetInteresForDataDumpOutputDTO financialInterest)
        {
            this.IdOperation = financialInterest.IdOperation.ToString();
            this.InternalAccountNumber = financialInterest.Account.ToString();
            this.OperationDate = financialInterest.OperationDate.ToString();
            this.Currency = financialInterest.Currency.ToString();
            this.Sign = financialInterest.Sign.ToString();
            this.Amount = financialInterest.OperationAmount.ToString();
            this.InterestTaxed = financialInterest.AffectedInterestTaxed.ToString();
            this.InterestExcent = financialInterest.AffectedInterestExcent.ToString();
            this.Tax = financialInterest.Tax.ToString();
            this.SourceCode = financialInterest.SourceCode;
            this.TransCode = financialInterest.TransCode;
        }
    }
}
