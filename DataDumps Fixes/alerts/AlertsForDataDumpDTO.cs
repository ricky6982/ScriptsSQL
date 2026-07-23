using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetAlertsForDataDump;
using System;
using System.ComponentModel.DataAnnotations;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class AlertsForDataDumpDTO
    {
        [CsvOrder(1)]
        public string ReferenceNumber  { get; set; }

        [CsvOrder(2)]
        public string Account          { get; set; }

        [CsvOrder(3)]
        public string GeneratedDate    { get; set; }

        [CsvOrder(4)]
        public string AlertStatus      { get; set; }

        [CsvOrder(5)]
        public string AlertChannel     { get; set; }

        [CsvOrder(6)]
        public string Amount           { get; set; }

        [CsvOrder(7)]
        public string CustomerId       { get; set; }

        [CsvOrder(8)]
        public string GeneralAccountId { get; set; }

        [CsvOrder(9)]
        public string DestinationInfo  { get; set; }

        public AlertsForDataDumpDTO()
        {
            ReferenceNumber  = string.Empty;
            Account          = string.Empty;
            GeneratedDate    = string.Empty;
            AlertStatus      = string.Empty;
            AlertChannel     = string.Empty;
            Amount           = string.Empty;
            CustomerId       = string.Empty;
            GeneralAccountId = string.Empty;
            DestinationInfo  = string.Empty;
        }

        public AlertsForDataDumpDTO(GetAlertsForDataDumpOutputDTO dto)
        {
            ReferenceNumber  = dto.ReferenceNumber.ToString();
            Account          = dto.Account          ?? string.Empty;
            GeneratedDate    = dto.GeneratedDate.ToString("yyyyMMdd");
            AlertStatus      = dto.AlertStatus.ToString();
            AlertChannel     = dto.AlertChannel.HasValue
                                   ? dto.AlertChannel.Value.ToString()
                                   : string.Empty;
            Amount           = dto.Amount.HasValue
                                   ? dto.Amount.Value.ToString("0.00").Replace(",", ".")
                                   : string.Empty;
            CustomerId       = dto.CustomerId.HasValue
                                   ? dto.CustomerId.Value.ToString()
                                   : string.Empty;
            GeneralAccountId = dto.GeneralAccountId.HasValue
                                   ? dto.GeneralAccountId.Value.ToString()
                                   : string.Empty;
            DestinationInfo  = dto.DestinationInfo  ?? string.Empty;
        }
    }
}
