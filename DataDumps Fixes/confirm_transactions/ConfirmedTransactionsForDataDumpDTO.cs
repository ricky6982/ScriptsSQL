using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetConfirmedTransactionsForDataDump;
using PS.CommonCredit.Domain.Util.Attribute;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class ConfirmedTransactionsForDataDumpDTO
    {
        public string IdTransaction { get; set; }
        [CsvOrder(1)]
        public string RetrievalRefno { get; set; }
        [CsvOrder(2)]
        public string MerchantCategory { get; set; }
        [CsvOrder(3)]
        public string ResponseCode { get; set; }
        [CsvOrder(4)]
        public string TransactionType { get; set; }
        public string LocalDate { get; set; }
        public string TransactionBeginTimeAAS { get; set; }
        [CsvOrder(5)]
        public string PurchaseDate { get; set; }
        [CsvOrder(6)]
        public string SaleAmount { get; set; }
        [CsvOrder(7)]
        public string SaleCurrency { get; set; }
        [CsvOrder(8)]
        public string IssuerAmount { get; set; }
        [CsvOrder(9)]
        public string IssuerCurrency { get; set; }
        [CsvOrder(10)]
        public string PrimaryAcctNum { get; set; }
        [CsvOrder(11)]
        public string AuthIdResponse { get; set; }
        [CsvOrder(12)]
        public string TerminalId { get; set; }
        [CsvOrder(13)]
        public string MerchantId { get; set; }
        [CsvOrder(14)]
        public string CardAcqName { get; set; }
        [CsvOrder(15)]
        public string MerchantCountry { get; set; }
        [CsvOrder(16)]
        public string MerchantState { get; set; }
        [CsvOrder(17)]
        public string MerchantCity { get; set; }
        [CsvOrder(18)]
        public string MerchantAddress { get; set; }
        [CsvOrder(19)]
        public string PosEntryMode { get; set; }
        [CsvOrder(20)]
        public string ResponseDescription { get; set; }
        [CsvOrder(21)]
        public string Arn { get; set; }
        [CsvOrder(22)]
        public string PresentationDate { get; set; }
        [CsvOrder(23)]
        public string Status { get; set; }
        [CsvOrder(24)]
        public string ProcessingCode { get; set; }
        [CsvOrder(25)]
        public string Country { get; set; }
        [CsvOrder(26)]
        public string State { get; set; }
        [CsvOrder(27)]
        public string City { get; set; }
        [CsvOrder(28)]
        public string Zipcode { get; set; }
        [CsvOrder(29)]
        public string IsHonoredTransaction { get; set; }
        [CsvOrder(30)]
        public string HonoredReasonCode { get; set; }
        [CsvOrder(31)]
        public string MonetaryIndicator { get; set; }
        [CsvOrder(32)]
        public string DCCIndicator { get; set; }
        [CsvOrder(33)]
        public string WasTransactionTokenized { get; set; }
        [CsvOrder(34)]
        public string ProductType { get; set; }
        [CsvOrder(35)]
        public string CardClass { get; set; }
        [CsvOrder(36)]
        public string SettlementAmount { get; set; }
        [CsvOrder(37)]
        public string SettlementCurrencyCode { get; set; }
        [CsvOrder(38)]
        public string SettlementDate { get; set; }
        [CsvOrder(39)]
        public string TrmRevenue { get; set; }
        [CsvOrder(40)]
        public string InternalAccountNumber { get; set; }
        public string ComunicationDeviceIndicator { get; set; }
        [CsvOrder(41)]
        public string Eci { get; set; }
        [CsvOrder(42)]
        public string InstallmentQuantity { get; set; }
        [CsvOrder(43)]
        public string SalePlanCode { get; set; }
        [CsvOrder(44)]
        public string SalePlanName { get; set; }
        [CsvOrder(45)]
        public string InterestRate { get; set; }
        [CsvOrder(46)]
        public string TranscodeDescription { get; set; }
        [CsvOrder(47)]
        public string SourceCode { get; set; }
        [CsvOrder(48)]
        public string ProductPlan { get; set; }
        [CsvOrder(49)]
        public string TransCode { get; set; }


        public ConfirmedTransactionsForDataDumpDTO() { }

        public ConfirmedTransactionsForDataDumpDTO(GetConfirmedTransactionsForDataDumpOutputDTO item)
        {
            IdTransaction = item.IdTx.ToString();
            InternalAccountNumber = item.InternalAccountNumber ?? string.Empty;
            RetrievalRefno = string.Empty; // Falta definición
            MerchantCategory = item.MerchantCategory.HasValue ? item.MerchantCategory.Value.ToString() : String.Empty;
            ResponseCode = item.ResponseCode != null ? item.ResponseCode.Trim() : String.Empty;
            TransactionType = ((short)item.TransactionType).ToString();
            LocalDate = item.LocalDate.HasValue ? item.LocalDate.Value.ToString("yyMMdd") : String.Empty;
            TransactionBeginTimeAAS = item.TransactionBeginTimeAAS.HasValue ? item.TransactionBeginTimeAAS.Value.ToString("HHmmss") : String.Empty;
            PurchaseDate =
                item.LocalDate?.ToString("yyyyMMdd HH:mm:ss") ??
                item.TransactionBeginTimeAAS?.ToString("yyyyMMdd HH:mm:ss") ??
                item.PurchaseDate.ToString("yyyyMMdd HH:mm:ss");
            SaleAmount = item.SaleAmount.ToString();
            SaleCurrency = item.SaleCurrency != null ? item.SaleCurrency.ToString().Trim() : String.Empty;
            IssuerAmount = item.IssuerAmount.ToString();
            IssuerCurrency = item.IssuerCurrency.HasValue ? item.IssuerCurrency.Value.ToString().Trim() : String.Empty;
            PrimaryAcctNum = item.CardNumber != null ? item.CardNumber.Trim() : String.Empty;
            AuthIdResponse = item.AuthorizationCode != null ? item.AuthorizationCode.Trim() : String.Empty;
            TerminalId = item.TerminalId != null ? item.TerminalId.Trim() : String.Empty;
            MerchantId = !string.IsNullOrWhiteSpace(item.MerchantId) ? item.MerchantId.Trim() : String.Empty;
            CardAcqName = item.MerchantName != null ? item.MerchantName.Trim() : String.Empty;
            MerchantCountry = item.MerchantCountry != null ? item.MerchantCountry.Trim() : String.Empty;
            MerchantState = item.MerchantState != null ? item.MerchantState.ToString() : String.Empty;
            MerchantCity = item.MerchantCity != null ? item.MerchantCity.Trim() : String.Empty;
            MerchantAddress = item.MerchantAddress != null ? item.MerchantAddress.Trim() : String.Empty;
            PosEntryMode = item.PosEntryMode.HasValue ? ((short)item.PosEntryMode.Value).ToString() : String.Empty;
            ResponseDescription = item.ResponseDescription != null ? item.ResponseDescription.Trim() : String.Empty;
            Arn = item.ARN != null ? item.ARN.Trim() : String.Empty;
            PresentationDate = item.PresentationDate.HasValue ? item.PresentationDate.Value.ToString("yyMMdd") : String.Empty;
            Status = item.Status != null ? item.Status.Trim() : String.Empty;
            ProcessingCode = item.ProcessingCode != null ? item.ProcessingCode.Trim() : String.Empty;
            Country = item.Country.HasValue ? item.Country.Value.ToString().Trim() : String.Empty;
            State = item.State != null ? item.State.Trim() : String.Empty;
            City = item.City != null ? item.City.Trim() : String.Empty;
            Zipcode = item.ZipCode != null ? item.ZipCode.Trim() : String.Empty;
            IsHonoredTransaction = item.IsHonoredTransaction.ToString();
            HonoredReasonCode = item.HonoredReasonCode.HasValue ? item.HonoredReasonCode.Value.ToString() : String.Empty;
            MonetaryIndicator = item.MonetaryIndicator.ToString();
            DCCIndicator = item.ApliedDCC ?? String.Empty;
            WasTransactionTokenized = item.TransactionWasTokenized.ToString();
            ProductType = item.ProductType.HasValue ? item.ProductType.Value.ToString() : String.Empty;
            CardClass = item.CardClass != null ? item.CardClass.Trim() : String.Empty;
            SettlementAmount = item.SettlementAmount.HasValue ? item.SettlementAmount.Value.ToString() : String.Empty;
            SettlementCurrencyCode = item.SettlementCurrencyCode.HasValue ? item.SettlementCurrencyCode.Value.ToString() : String.Empty;
            ComunicationDeviceIndicator = item.ComunicationDeviceIndicator ?? string.Empty;
            Eci = string.Empty; // Falta definición
            InstallmentQuantity = item.InstallmentQuantity.ToString();
            SalePlanCode = item.SalePlanCode ?? string.Empty;
            SalePlanName = item.SalePlanName ?? string.Empty;
            InterestRate = item.InterestRate.HasValue ? item.InterestRate.ToString() : string.Empty;
            SettlementDate = item.SettlementDate.HasValue ? item.SettlementDate.Value.ToString("yyyyMMdd") : String.Empty;
            TrmRevenue = item.TrmRevenue != null ? item.TrmRevenue.Trim() : String.Empty;
            TranscodeDescription = item.TranscodeDescription ?? string.Empty;
            SourceCode = item.SourceCode ?? string.Empty;
            ProductPlan = item.ProductPlan ?? string.Empty;
            TransCode = item.TransCode ?? string.Empty;
        }

    }
}
