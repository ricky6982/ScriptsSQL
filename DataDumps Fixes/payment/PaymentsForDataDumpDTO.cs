using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetPaymentsForDataDump;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class PaymentsForDataDumpDTO
    {
        public string IdOperation { get; set; }
        public string InternalAccountNumber { get; set; }
        public string OperationDate { get; set; }
        public string OperationType { get; set; }
        public string Currency { get; set; }
        public string OperationAmount { get; set; }
        public string Sign { get; set; }
        public string Description { get; set; }
        public string IsReversed { get; set; }
        public string SourceCode { get; set; }
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
