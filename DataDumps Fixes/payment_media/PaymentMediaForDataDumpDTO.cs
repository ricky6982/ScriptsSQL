using FileHelpers;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetPaymentMediaForDataDump;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
	[Serializable]
	public class PaymentMediaForDataDumpDTO
    {
		[CsvOrder(1)]
		public string CardNumber { get; set; }
		[CsvOrder(2)]
		public string Document { get; set; }
		[CsvOrder(3)]
    	public string InternalAccountNumber { get; set; }
		[CsvOrder(4)]
		public string StatusCode { get; set; }
		[CsvOrder(5)]
		public string IssueDate { get; set; }
		[CsvOrder(6)]
		public string InactiveDate { get; set; }
		[CsvOrder(7)]
		public string DueDate { get; set; }
		[CsvOrder(8)]
		public string SecuenceNumber { get; set; }
		[CsvOrder(9)]
		public string DocumentType { get; set; }
		[CsvOrder(10)]
		public string DocTypeDescription { get; set; }
		[CsvOrder(11)]
		public string Category { get; set; }
		[CsvOrder(12)]
		public string ProductCode { get; set; }
		[CsvOrder(13)]
		public string ProductDescription { get; set; }
		[CsvOrder(14)]
		public string ProductGroupCode { get; set; }
		[CsvOrder(15)]
		public string TrackingID { get; set; }
		[CsvOrder(16)]
		public string PaymentMediaStatusType { get; set; }
        [CsvOrder(17)]
        public string EmbossedName { get; set; }
        [CsvOrder(18)]
        public string Scheme { get; set; }
        [CsvOrder(19)]
        public string CardTechnology { get; set; }
        [CsvOrder(20)]
        public string SDP { get; set; }
        [CsvOrder(21)]
        public string BlockStatusCode { get; set; }
        [CsvOrder(22)]
        public string BlockCategoryCode { get; set; }
        [CsvOrder(23)]
        public string Bin { get; set; }
        [CsvOrder(24)]
        public string ICA { get; set; }
        [CsvOrder(25)]
        public string ChipSequence { get; set; }
        [CsvOrder(26)]
        public string EmisionTime { get; set; }
        [CsvOrder(27)]
        public string PreviusDueDate { get; set; }
        [CsvOrder(28)]
        public string ActionTaken { get; set; }

        public PaymentMediaForDataDumpDTO()
        {
            CardNumber = string.Empty;
            Document = string.Empty;
            InternalAccountNumber = string.Empty;
            StatusCode = string.Empty;
            IssueDate = string.Empty;
            InactiveDate = string.Empty;
            DueDate = string.Empty;
            SecuenceNumber = string.Empty;
            DocumentType = string.Empty;
            DocTypeDescription = string.Empty;
            Category = string.Empty;
            ProductCode = string.Empty;
            ProductDescription = string.Empty;
            ProductGroupCode = string.Empty;
            TrackingID = string.Empty;
            PaymentMediaStatusType = string.Empty;
            EmbossedName = string.Empty;
            Scheme = string.Empty;
            CardTechnology = string.Empty;
            SDP = string.Empty;
            BlockStatusCode = string.Empty;
            BlockCategoryCode = string.Empty;
            Bin = string.Empty;
            ICA = string.Empty;
            ChipSequence = string.Empty;
            EmisionTime = string.Empty;
            PreviusDueDate = string.Empty;
            ActionTaken = string.Empty;
        }

		public PaymentMediaForDataDumpDTO(GetPaymentMediaForDataDumpOutputDTO DTO)
		{
			CardNumber = DTO.CardNumber != null ? DTO.CardNumber : string.Empty;
			Document = DTO.Document != null ? DTO.Document : string.Empty;
			InternalAccountNumber = DTO.InternalAccountNumber != null ? DTO.InternalAccountNumber : string.Empty;
			StatusCode = DTO.StatusCode != null ? DTO.StatusCode : string.Empty;
			IssueDate = DTO.IssueDate.HasValue ? DTO.IssueDate.Value.ToString("yyyyMMdd") : string.Empty;
			InactiveDate = DTO.InactiveDate.HasValue ? DTO.InactiveDate.Value.ToString("yyyyMMdd") : string.Empty;
			DueDate = DTO.DueDate.ToString("MMyy");
			SecuenceNumber = DTO.SecuenceNumber.ToString() != null ? DTO.SecuenceNumber.ToString() : string.Empty;
			DocumentType = DTO.DocumentType.ToString();
			DocTypeDescription = DTO.DocTypeDescription != null ? DTO.DocTypeDescription : string.Empty;
			Category = ((short)DTO.Category).ToString();
			ProductCode = DTO.ProductCode != null ? DTO.ProductCode : string.Empty;
			ProductDescription = DTO.ProductDescription != null ? DTO.ProductDescription : string.Empty;
			ProductGroupCode = DTO.ProductGroupCode != null ? DTO.ProductGroupCode : string.Empty;
			TrackingID = DTO.TrackingID != null ? DTO.TrackingID : string.Empty;
			PaymentMediaStatusType = ((short)DTO.PaymentMediaStatusType).ToString();
            EmbossedName = string.Empty; // TODO: Initialize in constructor
            Scheme = string.Empty; // TODO: Initialize in constructor
            CardTechnology = string.Empty; // TODO: Initialize in constructor
            SDP = string.Empty; // TODO: Initialize in constructor
            BlockStatusCode = string.Empty; // TODO: Initialize in constructor
            BlockCategoryCode = string.Empty; // TODO: Initialize in constructor
            Bin = string.Empty; // TODO: Initialize in constructor
            ICA = DTO.ICA ?? string.Empty;
            ChipSequence = string.Empty; // TODO: Initialize in constructor
            EmisionTime = DTO.EmissionTime ?? string.Empty;
            PreviusDueDate = string.Empty; // TODO: Initialize in constructor
            ActionTaken = string.Empty; // TODO: Initialize in constructor
        }
	}
	 
}
