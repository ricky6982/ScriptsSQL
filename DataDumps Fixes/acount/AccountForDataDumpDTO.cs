using FileHelpers;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetAccountForDataDump;
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
        public string InternalAccountNumber { get; set; }
        public string Document { get; set; }
        public string ExternalAcoountNumber { get; set; }
        public string StatusCode { get; set; }
        public string StatusDescription { get; set; }
        public string IssueDate { get; set; }
        public string InactiveDate { get; set; }
        public decimal? CreditLimit { get; set; }
        public decimal? BalanceAmount { get; set; }
        public string DocumentType { get; set; }
        public string DocTypeDescription { get; set; }
        public string AccountStatusType { get; set; }
        public string ArePromotionsEnabled { get; set; }
        public string AreCampaignsEnabled { get; set; }
        public string SendAccountStatement { get; set; }
        public string SendStatementByEmail { get; set; }
        public string SendStatementByCell { get; set; }
        public string StatementEmail { get; set; }
        public string StatementCellPhone { get; set; }
        public string BlockStatusCode { get; set; }
        public string BlockCategoryCode { get; set; }
        public string ChargeOffStatus { get; set; }
        public decimal? ChargeOffAmount { get; set; }
        public string Deliquency { get; set; }
        public string FinRev { get; set; }
        public string RiskCode { get; set; }
        public decimal? CurrentBalance { get; set; }
        public string CreditClass { get; set; }
        public string LastAccStatmentDate { get; set; }
        public string AccountDueCode { get; set; }
        public decimal? CurrentDueAmount { get; set; }
        public string ClosingDate { get; set; }
        public decimal? OverLimitAmount { get; set; }
        public decimal? XDaysDueAmount { get; set; }
        public decimal? DueAmount30Days { get; set; }
        public decimal? DueAmount60Days { get; set; }
        public decimal? DueAmount90Days { get; set; }
        public decimal? DueAmount120Days { get; set; }
        public decimal? DueAmount150Days { get; set; }
        public decimal? DueAmount180Days { get; set; }
        public decimal? DueAmount210Days { get; set; }
        public decimal? TotalDaysDueAmount { get; set; }

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
        }
    }
}
