using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetOperationsForDataDump;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetPaymentsForDataDump;
using System;
using PS.CommonCredit.Domain.Util.Attribute;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class OperationsForDataDumpDTO
    {
        [CsvOrder(1)]
        public string IdOperation { get; set; }
        [CsvOrder(2)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(3)]
        public DateTime OperationDate { get; set; }
        [CsvOrder(4)]
        public string OperationType { get; set; }
        [CsvOrder(5)]
        public string Currency { get; set; }
        [CsvOrder(6)]
        public string OperationAmount { get; set; }
        [CsvOrder(7)]
        public string OperationSign { get; set; }
        [CsvOrder(8)]
        public string Description { get; set; }
        [CsvOrder(9)]
        public string CategoryCode { get; set; }
        [CsvOrder(10)]
        public string CategoryName { get; set; }
        [CsvOrder(11)]
        public string InstallmentQuantity { get; set; }
        [CsvOrder(12)]
        public string SalePlanCode { get; set; }
        [CsvOrder(13)]
        public string SalePlanName { get; set; }
        [CsvOrder(14)]
        public string InterestRate { get; set; }
        [CsvOrder(15)]
        public string Periodicity { get; set; }
        [CsvOrder(16)]
        public string SourceCode { get; set; }
        [CsvOrder(17)]
        public string TransactionCode { get; set; } // Maps to TransCode in length.txt

        public OperationsForDataDumpDTO() { }

        public OperationsForDataDumpDTO(GetOperationsForDataDumpOutputDTO item)
        {
            IdOperation = item.IdOperation.ToString();
            InternalAccountNumber = item.InternalAccountNumber ?? string.Empty;
            OperationDate = item.OperationDate ;
            OperationType = ((int)item.OperationType).ToString();
            Currency = item.Currency.ToString();
            OperationAmount = item.OperationAmount.ToString();
            OperationSign = item.OperationSign.ToString();
            Description = item.Description.ToString();
            CategoryCode = item.CategoryCode ?? string.Empty;
            CategoryName = item.CategoryName ?? string.Empty;
            InstallmentQuantity = item.InstallmentQuantity.ToString();
            SalePlanCode = item.SalePlanCode ?? string.Empty;
            SalePlanName = item.SalePlanName ?? string.Empty;
            InterestRate = item.InterestRate.HasValue ? item.InterestRate.Value.ToString() : string.Empty; 
            Periodicity = item.Periodicity.HasValue ? item.Periodicity.Value.ToString () : string.Empty;
            TransactionCode = item.TransactionCode ?? string.Empty;
            SourceCode = item.SourceCode.ToString();
        }

    }
}
