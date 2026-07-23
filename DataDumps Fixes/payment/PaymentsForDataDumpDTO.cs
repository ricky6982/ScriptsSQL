using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetPaymentsForDataDump;
using System;
using PS.CommonCredit.Domain.Util.Attribute;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class PaymentsForDataDumpDTO
    {
        [CsvOrder(1)]
        public string IdOperation { get; set; }
        [CsvOrder(2)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(3)]
        public string OperationDate { get; set; }
        [CsvOrder(4)]
        public string OperationType { get; set; }
        [CsvOrder(5)]
        public string Currency { get; set; }
        [CsvOrder(6)]
        public string OperationAmount { get; set; }
        [CsvOrder(7)]
        public string Sign { get; set; }
        [CsvOrder(8)]
        public string Description { get; set; }
        [CsvOrder(9)]
        public string IsReversed { get; set; }
        [CsvOrder(10)]
        public string SourceCode { get; set; }
        [CsvOrder(11)]
        public string TransactionCode { get; set; }

        public PaymentsForDataDumpDTO() { }

        public PaymentsForDataDumpDTO(GetPaymentsForDataDumpOutputDTO item)
        {
			IdOperation = item.IdOperation.ToString();
			InternalAccountNumber = item.InternalAccountNumber ?? string.Empty;
			OperationDate = item.OperationDate != null ? item.OperationDate.ToString("yyyyMMdd") : string.Empty;
			OperationType = ((short)item.OperationType).ToString();
			Currency = item.OperationCurrency.ToString();
            OperationAmount = item.OperationAmount.ToString();
            Sign = item.IsReversedPayment == 1 ? GetOppositeSign(item.OperationSign) : item.OperationSign.ToString();
			Description = item.OperationDescription ?? string.Empty;
			IsReversed = item.IsReversedPayment.ToString();
			TransactionCode = item.TransactionCode ?? string.Empty;
			SourceCode = item.SourceCode.ToString();
        }

        private string GetOppositeSign(short sign)
        {
            if (sign == -1) return "1";
            if (sign == 1) return "-1";            
            return sign.ToString();
        }
    }
}
