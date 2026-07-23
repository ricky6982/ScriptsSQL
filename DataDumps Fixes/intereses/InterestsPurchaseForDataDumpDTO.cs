using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetDailyInterestsPurchaseForDataDump;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetInterestsPurchaseForDataDump;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PS.CommonCredit.Domain.Util.Attribute;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class InterestsPurchaseForDataDumpDTO
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
        public string Tax { get; set; }
        [CsvOrder(10)]
        public string IsOrder { get; set; }
        [CsvOrder(11)]
        public string SourceCode { get; set; }
        [CsvOrder(12)]
        public string TransCode { get; set; }

        public InterestsPurchaseForDataDumpDTO(GetInterestsPurchaseForDataDumpOutputDTO dto)
        {
            this.IdOperation = dto.IdOperation.ToString();
            this.InternalAccountNumber = dto.Account.ToString();
            this.OperationDate = dto.OperationDate.ToString();
            this.Currency = dto.Currency.ToString();
            this.Sign = dto.Sign.ToString();
            this.Amount = dto.OperationAmount.ToString();
            this.InterestTaxed = dto.AffectedInterestTaxed.ToString();
            this.InterestExcent = dto.AffectedInterestExcent.ToString();
            this.Tax = dto.Tax.ToString();
            this.IsOrder = dto.IsOrder.ToString();
            this.SourceCode = dto.SourceCode;
            this.TransCode = dto.TransCode;
        }

        public InterestsPurchaseForDataDumpDTO(GetDailyInterestsPurchaseForDataDumpOutputDTO dto)
        {
            this.IdOperation = dto.IdOperation.ToString();
            this.InternalAccountNumber = dto.Account.ToString();
            this.OperationDate = dto.OperationDate.ToString();
            this.Currency = dto.Currency.ToString();
            this.Sign = dto.Sign.ToString();
            this.Amount = dto.OperationAmount.ToString();
            this.InterestTaxed = dto.AffectedInterestTaxed.ToString();
            this.InterestExcent = dto.AffectedInterestExcent.ToString();
            this.Tax = dto.Tax.ToString();
            this.IsOrder = dto.IsOrder.ToString();
            this.SourceCode = dto.SourceCode;
            this.TransCode = dto.TransCode;
        }
    }
}
