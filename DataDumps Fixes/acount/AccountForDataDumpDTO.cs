using FileHelpers;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetAccountForDataDump;
using PS.CommonCredit.Domain.Util.Attribute;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class AccountForDataDumpDTO
    {
        [CsvOrder(1)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(2)]
        public string Document { get; set; }
        [CsvOrder(3)]
        public string ExternalAcoountNumber { get; set; }
        [CsvOrder(4)]
        public string StatusCode { get; set; }
        public string StatusDescription { get; set; } // TODO: CsvOrder not assigned. Field not found in length.txt
        [CsvOrder(5)]
        public string IssueDate { get; set; }
        [CsvOrder(6)]
        public string InactiveDate { get; set; }
        [CsvOrder(7)]
        public decimal? CreditLimit { get; set; }
        [CsvOrder(8)]
        public decimal? BalanceAmount { get; set; }
        [CsvOrder(9)]
        public string DocumentType { get; set; }
        [CsvOrder(10)]
        public string DocTypeDescription { get; set; }
        [CsvOrder(11)]
        public string AccountStatusType { get; set; }
        [CsvOrder(12)]
        public string ArePromotionsEnabled { get; set; }
        [CsvOrder(13)]
        public string AreCampaignsEnabled { get; set; }
        [CsvOrder(14)]
        public string SendAccountStatement { get; set; }
        [CsvOrder(15)]
        public string SendStatementByEmail { get; set; }
        [CsvOrder(16)]
        public string SendStatementByCell { get; set; }
        [CsvOrder(17)]
        public string StatementEmail { get; set; }
        [CsvOrder(18)]
        public string StatementCellPhone { get; set; }
        [CsvOrder(19)]
        public string BranchCode { get; set; }
        [CsvOrder(20)]
        public string CashWithdrawalEnabled { get; set; }
        [CsvOrder(21)]
        public string AdvancedPaymentMode { get; set; }
        [CsvOrder(22)]
        public string BlockStatusCode { get; set; }
        [CsvOrder(23)]
        public string BlockCategoryCode { get; set; }
        [CsvOrder(24)]
        public string ChargeOffStatus { get; set; }
        [CsvOrder(25)]
        public decimal? ChargeOffAmount { get; set; }
        [CsvOrder(26)]
        public string Deliquency { get; set; }
        [CsvOrder(27)]
        public string FinRev { get; set; }
        [CsvOrder(28)]
        public string RiskCode { get; set; }
        [CsvOrder(29)]
        public decimal? CurrentBalance { get; set; }
        [CsvOrder(30)]
        public string CreditClass { get; set; }
        [CsvOrder(31)]
        public string LastAccStatmentDate { get; set; }
        [CsvOrder(32)]
        public string AccountDueCode { get; set; }
        [CsvOrder(33)]
        public decimal? CurrentDueAmount { get; set; }
        [CsvOrder(34)]
        public decimal? XDaysDueAmount { get; set; }
        [CsvOrder(35)]
        public decimal? DueAmount30Days { get; set; }
        [CsvOrder(36)]
        public decimal? DueAmount60Days { get; set; }
        [CsvOrder(37)]
        public decimal? DueAmount90Days { get; set; }
        [CsvOrder(38)]
        public decimal? DueAmount120Days { get; set; }
        [CsvOrder(39)]
        public decimal? DueAmount150Days { get; set; }
        [CsvOrder(40)]
        public decimal? DueAmount180Days { get; set; }
        [CsvOrder(41)]
        public decimal? DueAmount210Days { get; set; }
        [CsvOrder(42)]
        public decimal? TotalDaysDueAmount { get; set; }
        [CsvOrder(43)]
        public string ClosingDate { get; set; }
        [CsvOrder(44)]
        public decimal? OverLimitAmount { get; set; }
        [CsvOrder(45)]
        public string CreditAmountDate { get; set; }

        public AccountForDataDumpDTO() { }
        public AccountForDataDumpDTO(GetAccountForDataDumpOutputDTO DTO)
        {
            InternalAccountNumber = DTO.InternalAccountNumber != null ? DTO.InternalAccountNumber : string.Empty;
            Document = DTO.Document != null ? DTO.Document : string.Empty;
            ExternalAcoountNumber = DTO.ExternalAcoountNumber != null ? DTO.ExternalAcoountNumber : string.Empty;
            StatusCode = DTO.StatusCode != null ? DTO.StatusCode : string.Empty;
            StatusDescription = DTO.StatusDescription != null ? DTO.StatusDescription : string.Empty;
            IssueDate = DTO.IssueDate.HasValue ? DTO.IssueDate.Value.ToString("yyyyMMdd") : string.Empty;
            InactiveDate = DTO.InactiveDate.HasValue ? DTO.InactiveDate.Value.ToString("yyyyMMdd") : string.Empty;
			CreditLimit = DTO.CreditLimit??0;
			BalanceAmount = DTO.BalanceAmount??0;
            DocumentType = DTO.DocumentType.ToString();
            DocTypeDescription = DTO.DocTypeDescription != null ? DTO.DocTypeDescription : string.Empty;
            AccountStatusType = ((short)DTO.AccountStatusType).ToString();
            AreCampaignsEnabled = DTO.AreCampaignsEnabled.HasValue ? (DTO.AreCampaignsEnabled.Value ? "1" : "0") : "0";
            ArePromotionsEnabled = DTO.ArePromotionsEnabled.HasValue ? (DTO.ArePromotionsEnabled.Value ? "1" : "0") : "0";
            SendAccountStatement = DTO.SendAccountStatement.HasValue ? DTO.SendAccountStatement.Value.ToString() : "0";
            SendStatementByEmail = DTO.SendStatementByEmail.HasValue ? DTO.SendStatementByEmail.Value.ToString() : "0";
            SendStatementByCell = DTO.SendStatementByCell.HasValue ? DTO.SendStatementByCell.Value.ToString() : "0";
            StatementEmail = DTO.StatementEmail != null ? DTO.StatementEmail : string.Empty;
            StatementCellPhone = DTO.StatementCellPhone != null ? DTO.StatementCellPhone : string.Empty;
            BranchCode = DTO.BranchCode != null ? DTO.BranchCode : string.Empty;
            CashWithdrawalEnabled = DTO.CashWithdrawalEnabled != null ? DTO.CashWithdrawalEnabled : string.Empty;
            AdvancedPaymentMode = DTO.AdvancedPaymentMode != null ? DTO.AdvancedPaymentMode : string.Empty;
            BlockStatusCode = DTO.BlockStatusCode.HasValue ? DTO.BlockStatusCode.Value.ToString() : string.Empty;
            BlockCategoryCode = DTO.BlockCategoryCode ?? string.Empty;
            ChargeOffStatus = ((short)DTO.ChargeOffStatus).ToString();
            ChargeOffAmount = DTO.ChargeOffAmount ?? 0;
            Deliquency = DTO.Deliquency.HasValue ? DTO.Deliquency.Value.ToString() : string.Empty;
            FinRev = DTO.FinRev ?? string.Empty;
            RiskCode = DTO.RiskCode ?? string.Empty;
            CurrentBalance = DTO.CurrentBalance ?? 0;
            CreditClass = DTO.CreditClass ?? string.Empty;
            LastAccStatmentDate = DTO.LastAccStatmentDate.HasValue ? DTO.LastAccStatmentDate.Value.ToString("yyyyMMdd") : string.Empty;
            AccountDueCode = DTO.AccountDueCode ?? string.Empty;
            CurrentDueAmount = DTO.CurrentDueAmount ?? 0;
            ClosingDate = DTO.ClosingDate.HasValue ? DTO.ClosingDate.Value.ToString("yyyyMMdd") : string.Empty;
            OverLimitAmount = DTO.OverLimitAmount ?? 0;
            XDaysDueAmount = DTO.XDaysDueAmount ?? 0;
            DueAmount30Days = DTO.DUE_AMOUNT_30_DAYS ?? 0;
            DueAmount60Days = DTO.DUE_AMOUNT_60_DAYS ?? 0;
            DueAmount90Days = DTO.DUE_AMOUNT_90_DAYS ?? 0;
            DueAmount120Days = DTO.DUE_AMOUNT_120_DAYS ?? 0;
            DueAmount150Days = DTO.DUE_AMOUNT_150_DAYS ?? 0;
            DueAmount180Days = DTO.DUE_AMOUNT_180_DAYS ?? 0;
            DueAmount210Days = DTO.DUE_AMOUNT_210_DAYS ?? 0;
            TotalDaysDueAmount = DTO.TotalDaysDueAmount ?? 0;
            CreditAmountDate = DTO.CreditAmountDate ?? string.Empty;
        }
    }
}
