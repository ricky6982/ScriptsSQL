using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetServicesForDataDump;
using System;
using PS.CommonCredit.Domain.Util.Attribute;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class ServicesForDataDumpDTO
    {
        [CsvOrder(1)]
        public string IdOperation { get; set; }
        [CsvOrder(2)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(3)]
        public string OperationDate { get; set; }
        [CsvOrder(4)]
        public string ServiceType { get; set; }
        [CsvOrder(5)]
        public string ServiceName { get; set; }
        [CsvOrder(6)]
        public string Currency { get; set; }
        [CsvOrder(7)]
        public string Sign { get; set; }
        [CsvOrder(8)]
        public string Amount { get; set; }
        [CsvOrder(9)]
        public string IVA { get; set; }
        [CsvOrder(10)]
        public string SourceCode { get; set; }
        [CsvOrder(11)]
        public string ProductCode { get; set; }
        [CsvOrder(12)]
        public string ServiceAmount { get; set; }
        [CsvOrder(13)]
        public string SubscriptionDate { get; set; }
        [CsvOrder(14)]
        public string SubscriptionDate2 { get; set; }
        [CsvOrder(15)]
        public string PolicyStatus { get; set; }
        [CsvOrder(16)]
        public string TransCode { get; set; }

        public ServicesForDataDumpDTO(GetServicesForDataDumpOutputDTO item)
        {
            IdOperation = item.IdOperation.ToString();
            InternalAccountNumber = item.InternalAccountNumber ?? string.Empty;
            OperationDate = item.OperationDate != null ? item.OperationDate.ToString("yyyyMMdd") : string.Empty;
            ServiceType = ((short)item.ServiceType).ToString();
            ServiceName = item.ServiceName ?? string.Empty;
            Currency = item.OperationCurrency.ToString();
            Sign = item.OperationSign.ToString();
            Amount = item.OperationAmount.ToString();
            IVA = item.IVA ?? String.Empty;
            SourceCode = item.SourceCode.ToString();
            ProductCode = item.ProductCode.HasValue ? item.ProductCode.Value.ToString() : string.Empty;
            ServiceAmount = item.ServiceAmount.HasValue ? item.ServiceAmount.Value.ToString() : string.Empty;
            SubscriptionDate = item.SubscriptionDate.HasValue ? item.SubscriptionDate.Value.ToString("yyyyMMdd") : string.Empty;
            SubscriptionDate2 = item.SubscriptionDate2.HasValue ? item.SubscriptionDate2.Value.ToString("yyyyMMdd") : string.Empty;
            PolicyStatus = item.PolicyStatus ?? string.Empty;
            TransCode = item.TransCode ?? string.Empty;
        }

    }
}
