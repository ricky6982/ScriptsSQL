using PS.IssuerBusinessConfiguration.Interface.Datatypes.DTO;
using PS.IssuerBusinessConfiguration.Interface.Enumerations;
using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetAccountClientForDataDump;
using System;
using System.Collections.Generic;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class AccountClientForDataDumpDTO
    {
        public string InternalAccountNumber { get; set; }
        public string DocumentType { get; set; }
        public string DocumentTypeName { get; set; }
        public string Document { get; set; }
        public string FinancialRelation { get; set; }
        public string ExternalAccountNumber { get; set; }
        public string AccountHolderRelationship { get; set; }
        public string IsCodebtor { get; set; }
        public string CorresponAddresSomePhysical { get; set; }
        public string IdStreetType { get; set; }
        public string Street { get; set; }
        public string DoorNumber { get; set; }
        public string NeighbourhoodName { get; set; }
        public string NeighbourhoodCode { get; set; }
        public string CityName { get; set; }
        public string CityExternalCode { get; set; }
        public string CityCode { get; set; }
        public string GeographicName { get; set; }
        public string GeographicExternalCode { get; set; }
        public string GeographicCode { get; set; }
        public string PostalCode { get; set; }
        public string IsBis { get; set; }
        public string Floor { get; set; }
        public string Apartment { get; set; }
        public string AdditionalInfo { get; set; }
        public string CeeLNumber { get; set; }
        public string PhoneNumber { get; set; }
        public string WarrantyType { get; set; }
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
