using PS.IssuerBusinessConfiguration.Interface.Datatypes.DTO;
using PS.IssuerBusinessConfiguration.Interface.Enumerations;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetAccountClientForDataDump;
using PS.CommonCredit.Domain.Util.Attribute;
using System;
using System.Collections.Generic;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class AccountClientForDataDumpDTO
    {
        [CsvOrder(1)]
        public string InternalAccountNumber { get; set; }
        [CsvOrder(2)]
        public string DocumentType { get; set; }
        [CsvOrder(3)]
        public string DocumentTypeName { get; set; }
        [CsvOrder(4)]
        public string Document { get; set; }
        [CsvOrder(5)]
        public string FinancialRelation { get; set; }
        [CsvOrder(6)]
        public string ExternalAccountNumber { get; set; }
        [CsvOrder(7)]
        public string AccountHolderRelationship { get; set; }
        [CsvOrder(8)]
        public string IsCodebtor { get; set; }
        [CsvOrder(9)]
        public string CorresponAddresSomePhysical { get; set; }
        [CsvOrder(10)]
        public string IdStreetType { get; set; }
        [CsvOrder(11)]
        public string Street { get; set; }
        [CsvOrder(12)]
        public string DoorNumber { get; set; }
        [CsvOrder(13)]
        public string NeighbourhoodName { get; set; }
        [CsvOrder(14)]
        public string NeighbourhoodCode { get; set; }
        [CsvOrder(15)]
        public string CityName { get; set; }
        public string CityExternalCode { get; set; }
        [CsvOrder(16)]
        public string CityCode { get; set; }
        [CsvOrder(17)]
        public string GeographicName { get; set; }
        public string GeographicExternalCode { get; set; }
        [CsvOrder(18)]
        public string GeographicCode { get; set; }
        [CsvOrder(19)]
        public string PostalCode { get; set; }
        [CsvOrder(20)]
        public string IsBis { get; set; }
        [CsvOrder(21)]
        public string Floor { get; set; }
        [CsvOrder(22)]
        public string Apartment { get; set; }
        [CsvOrder(23)]
        public string AdditionalInfo { get; set; }
        [CsvOrder(24)]
        public string CeeLNumber { get; set; }
        [CsvOrder(25)]
        public string PhoneNumber { get; set; }
        [CsvOrder(26)]
        public string WarrantyType { get; set; }
        [CsvOrder(27)]
        public string WarrantyDescription { get; set; }

        public AccountClientForDataDumpDTO() { }

        public AccountClientForDataDumpDTO(GetAccountClientForDataDumpOutputDTO dto)
        {
            InternalAccountNumber = string.IsNullOrWhiteSpace(dto.InternalAccountNumber) ? string.Empty : dto.InternalAccountNumber.Trim();
            DocumentType = string.IsNullOrWhiteSpace(dto.DocumentType) ? string.Empty : dto.DocumentType.Trim();
            DocumentTypeName = string.IsNullOrWhiteSpace(dto.DocumentTypeName) ? string.Empty : dto.DocumentTypeName.Trim();
            Document = string.IsNullOrWhiteSpace(dto.Document) ? string.Empty : dto.Document.Trim();
            FinancialRelation = string.IsNullOrWhiteSpace(dto.FinancialRelation) ? string.Empty : dto.FinancialRelation.Trim();
            ExternalAccountNumber = string.IsNullOrWhiteSpace(dto.ExternalAccountNumber) ? string.Empty : dto.ExternalAccountNumber.Trim();
            AccountHolderRelationship = string.IsNullOrWhiteSpace(dto.AccountHolderRelationship) || FinancialRelation == "1" ? string.Empty : dto.AccountHolderRelationship.Trim() ;
            IsCodebtor = string.IsNullOrWhiteSpace(dto.IsCodebtor) ? "0" : dto.IsCodebtor.Trim();
            CorresponAddresSomePhysical = string.IsNullOrWhiteSpace(dto.CorresponAddresSomePhysicalAnddress) ? "0" : dto.CorresponAddresSomePhysicalAnddress.Trim();
            IdStreetType = string.IsNullOrWhiteSpace(dto.IdStreetType) || FinancialRelation != "1"  ? string.Empty : dto.IdStreetType.Trim();
            Street = string.IsNullOrWhiteSpace(dto.Street) || FinancialRelation != "1" ? string.Empty : dto.Street.Trim();
            DoorNumber = string.IsNullOrWhiteSpace(dto.DoorNumber) || FinancialRelation != "1" ? string.Empty : dto.DoorNumber.Trim();
            NeighbourhoodName = string.IsNullOrWhiteSpace(dto.NeighbourhoodName) || FinancialRelation != "1" ? string.Empty : dto.NeighbourhoodName.Trim();
            NeighbourhoodCode = string.IsNullOrWhiteSpace(dto.NeighbourhoodCode) || FinancialRelation != "1" ? string.Empty : dto.NeighbourhoodCode.Trim();
            CityName = string.IsNullOrWhiteSpace(dto.CityName) || FinancialRelation != "1" ? string.Empty : dto.CityName.Trim();
            CityExternalCode = string.IsNullOrWhiteSpace(dto.CityExternalCode) || FinancialRelation != "1" ? string.Empty : dto.CityExternalCode.Trim();
            CityCode = string.IsNullOrWhiteSpace(dto.CityCode) || FinancialRelation != "1" ? string.Empty : dto.CityCode.Trim();
            GeographicName = string.IsNullOrWhiteSpace(dto.GeographicName) || FinancialRelation != "1" ? string.Empty : dto.GeographicName.Trim();
            GeographicExternalCode = string.IsNullOrWhiteSpace(dto.GeographicExternalCode) || FinancialRelation != "1" ? string.Empty : dto.GeographicExternalCode.Trim();
            GeographicCode = string.IsNullOrWhiteSpace(dto.GeographicCode) || FinancialRelation != "1" ? string.Empty : dto.GeographicCode.Trim();
            PostalCode = string.IsNullOrWhiteSpace(dto.PostalCode) || FinancialRelation != "1" ? string.Empty : dto.PostalCode.Trim();
            IsBis = FinancialRelation != "1" ? string.Empty : (string.IsNullOrWhiteSpace(dto.IsBis) ? "0" : dto.IsBis.Trim());
            Floor = string.IsNullOrWhiteSpace(dto.Floor) || FinancialRelation != "1" ? string.Empty : dto.Floor.Trim();
            Apartment = string.IsNullOrWhiteSpace(dto.Apartment) || FinancialRelation != "1" ? string.Empty : dto.Apartment.Trim();
            AdditionalInfo = string.IsNullOrWhiteSpace(dto.AdditionalInfo) || FinancialRelation != "1" ? string.Empty : dto.AdditionalInfo.Trim();
            CeeLNumber = string.IsNullOrWhiteSpace(dto.CeeLNumber) || FinancialRelation != "1" ? string.Empty : dto.CeeLNumber.Trim();
            PhoneNumber = string.IsNullOrWhiteSpace(dto.PhoneNumber) || FinancialRelation != "1" ? string.Empty : dto.PhoneNumber.Trim();
            WarrantyType = string.IsNullOrWhiteSpace(dto.WarrantyType) ? string.Empty : dto.WarrantyType.Trim();
            WarrantyDescription = string.IsNullOrWhiteSpace(dto.WarrantyDescription) ? string.Empty : dto.WarrantyDescription.Trim();
        }       
    }
}
