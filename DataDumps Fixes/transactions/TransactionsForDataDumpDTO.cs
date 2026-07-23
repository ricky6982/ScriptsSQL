using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetTransactionsForDataDump;
using PS.CommonCredit.Domain.Util.Attribute;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class TransactionsForDataDumpDTO
    {
        [CsvOrder(1)]
        public string RetrievalRefno { get; set; }
        [CsvOrder(2)]
        public string MCC { get; set; }
        [CsvOrder(3)]
        public string ResponseCode { get; set; }
        [CsvOrder(4)]
        public long? TransactionType { get; set; }
        [CsvOrder(5)]
        public string DateLocal { get; set; }
        [CsvOrder(6)]
        public string TimeLocal { get; set; }
        [CsvOrder(7)]
        public string SaleAmount { get; set; }
        [CsvOrder(8)]
        public string SaleCurrency { get; set; }
        [CsvOrder(9)]
        public string CardNumber { get; set; }
        [CsvOrder(10)]
        public string CardBillingAmount { get; set; }
        [CsvOrder(11)]
        public string CardBillingCurrency { get; set; }
        [CsvOrder(12)]
        public String Convertion { get; set; }
        [CsvOrder(13)]
        public string AuthCode { get; set; }
        [CsvOrder(14)]
        public String TerminalID { get; set; }
        [CsvOrder(15)]
        public String MerchantID { get; set; }
        [CsvOrder(16)]
        public String MerchantName { get; set; }
        [CsvOrder(17)]
        public string EntryMode { get; set; }
        [CsvOrder(18)]
        public String ResponseDescription { get; set; }
        [CsvOrder(19)]
        public String isFinancial { get; set; }
        [CsvOrder(20)]
        public String ApliedDCC { get; set; }
        [CsvOrder(21)]
        public String ApliedTokenization { get; set; }
        [CsvOrder(22)]
        public string ProductType { get; set; }
        [CsvOrder(23)]
        public string ProductName { get; set; }
        [CsvOrder(24)]
        public string MTI { get; set; }
        [CsvOrder(25)]
        public string MerchantCountry { get; set; }
        [CsvOrder(26)]
        public string MerchantState { get; set; }
        [CsvOrder(27)]
        public string MerchantCity { get; set; }
        [CsvOrder(28)]
        public string MerchanAndress { get; set; }
        [CsvOrder(29)]
        public string ARN { get; set; }
        [CsvOrder(30)]
        public string TransactionDate { get; set; }
        [CsvOrder(31)]
        public string TransactionSatus { get; set; }
        [CsvOrder(32)]
        public string ProcessingCode { get; set; }
        [CsvOrder(33)]
        public string CountryOrigin { get; set; }
        [CsvOrder(34)]
        public string GeoState { get; set; }
        [CsvOrder(35)]
        public string CityOrigin { get; set; }
        [CsvOrder(36)]
        public string ZipCode { get; set; }
        [CsvOrder(37)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(38)]
        public string Eci { get; set; }
        [CsvOrder(39)]
        public string InstallmentQuantity { get; set; }
        [CsvOrder(40)]
        public string SalePlanCode { get; set; }
        [CsvOrder(41)]
        public string SalePlanName { get; set; }
        [CsvOrder(42)]
        public string InterestRate { get; set; }
        [CsvOrder(43)]
        public string Exception { get; set; }
        [CsvOrder(44)]
        public string TranscodeDescription { get; set; }
        [CsvOrder(45)]
        public string SourceCode { get; set; }
        [CsvOrder(46)]
        public string ProductPlan { get; set; }
        [CsvOrder(47)]
        public string TransCode { get; set; }

        public TransactionsForDataDumpDTO() { }
        public TransactionsForDataDumpDTO(GetTransactionsForDataDumpOutputDTO DTO)
        {
            RetrievalRefno = DTO.IdTransaction.ToString();
            InternalAccountNumber = DTO.InternalAccountNumber ?? string.Empty;
            MCC = DTO.MCC != null ? DTO.MCC.ToString() : string.Empty;
            ResponseCode = !string.IsNullOrWhiteSpace(DTO.ResponseCode) ? DTO.ResponseCode.Trim() : string.Empty;
            TransactionType = DTO.TransactionType;
            DateLocal = DTO.DateLocal.HasValue ? DTO.DateLocal.Value.ToString("yyMMdd") : string.Empty;
            TimeLocal = DTO.TimeLocal.HasValue ? DTO.TimeLocal.Value.ToString("HHmmss") : string.Empty;
            SaleAmount = DTO.SaleAmount != null ? DTO.SaleAmount.ToString() : string.Empty;
            SaleCurrency = DTO.SaleCurrency != null ? DTO.SaleCurrency.ToString() : string.Empty;
            CardNumber = !string.IsNullOrWhiteSpace(DTO.CardNumber) ? DTO.CardNumber.Trim() : string.Empty;
            CardBillingAmount = DTO.CardBillingAmount != null ? DTO.CardBillingAmount.ToString() : string.Empty;
            CardBillingCurrency = DTO.CardBillingCurrency != null ? DTO.CardBillingCurrency.ToString() : string.Empty;
            Convertion = DTO.Convertion != null ? DTO.Convertion.ToString() : string.Empty;
            AuthCode = !string.IsNullOrWhiteSpace(DTO.AuthCode) ? DTO.AuthCode.Trim() : string.Empty;
            TerminalID = !string.IsNullOrWhiteSpace(DTO.TerminalID) ? DTO.TerminalID.Trim() : string.Empty;
            MerchantID = !string.IsNullOrWhiteSpace(DTO.MerchantID) ? DTO.MerchantID.Trim() : string.Empty;
            MerchantName = !string.IsNullOrWhiteSpace(DTO.MerchantName) ? DTO.MerchantName.Trim() : string.Empty;
            EntryMode = DTO.EntryMode != null ? DTO.EntryMode.ToString() : string.Empty;
            Eci = DTO.ComunicationDeviceIndicator != null ? DTO.ComunicationDeviceIndicator.ToString() : string.Empty;
            ResponseDescription = !string.IsNullOrWhiteSpace(DTO.ResponseDescription) ? DTO.ResponseDescription.Trim() : string.Empty;
            isFinancial = !string.IsNullOrWhiteSpace(DTO.isFinancial) ? DTO.isFinancial.Trim() : string.Empty;
            ApliedDCC = DTO.ApliedDCC.ToString();
            ApliedTokenization = !string.IsNullOrWhiteSpace(DTO.ApliedTokenization) ? DTO.ApliedTokenization.Trim() : string.Empty;
            ProductType = DTO.ProductType.ToString() ?? string.Empty;
            ProductName = !string.IsNullOrWhiteSpace(DTO.ProductName) ? DTO.ProductName.Trim() : string.Empty;
            MTI = DTO.MTI.HasValue ? DTO.MTI.Value.ToString() : string.Empty;
            MerchantCountry = !string.IsNullOrWhiteSpace(DTO.MerchantCountry) ? DTO.MerchantCountry.Trim() : string.Empty;
            MerchantState = DTO.MerchantState.HasValue ? DTO.MerchantState.Value.ToString() : string.Empty;
            MerchantCity = !string.IsNullOrWhiteSpace(DTO.MerchantCity) ? DTO.MerchantCity.Trim() : string.Empty;
            MerchanAndress = !string.IsNullOrWhiteSpace(DTO.MerchanAndress) ? DTO.MerchanAndress.Trim() : string.Empty;
            ARN = !string.IsNullOrWhiteSpace(DTO.ARN) ? DTO.ARN.Trim() : string.Empty;
            TransactionDate = DTO.TransactionDate != null ? DTO.TransactionDate.ToString() : string.Empty;
            TransactionSatus = !string.IsNullOrWhiteSpace(DTO.TransactionSatus) ? DTO.TransactionSatus.Trim() : string.Empty;
            ProcessingCode = !string.IsNullOrWhiteSpace(DTO.ProcessingCode) ? DTO.ProcessingCode.Trim() : string.Empty;
            CountryOrigin = DTO.CountryOrigin != null ? DTO.CountryOrigin.ToString() : string.Empty;
            GeoState = !string.IsNullOrWhiteSpace(DTO.GeoState) ? DTO.GeoState.Trim() : string.Empty;
            CityOrigin = !string.IsNullOrWhiteSpace(DTO.CityOrigin) ? DTO.CityOrigin.Trim() : string.Empty;
            ZipCode = !string.IsNullOrWhiteSpace(DTO.ZipCode) ? DTO.ZipCode.Trim() : string.Empty;
            InstallmentQuantity = DTO.InstallmentQuantity.HasValue ? DTO.InstallmentQuantity.ToString() : string.Empty;
            SalePlanCode = DTO.SalePlanCode ?? string.Empty;
            SalePlanName = DTO.SalePlanName ?? string.Empty;
            InterestRate = DTO.InterestRate.HasValue ? DTO.InterestRate.ToString() : string.Empty;
            Exception = DTO.Exception ?? string.Empty;
            TranscodeDescription = DTO.TranscodeDescription ?? string.Empty;
            SourceCode = DTO.SourceCode ?? string.Empty;
            ProductPlan = DTO.ProductPlan ?? string.Empty;
            TransCode = DTO.TransCode ?? string.Empty;
        }
    }
}
