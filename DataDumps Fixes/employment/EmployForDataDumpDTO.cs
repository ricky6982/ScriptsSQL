using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetEmployForDataDump;
using PS.CommonCredit.Domain.Util.Attribute;
using System;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class EmployForDataDumpDTO
    {
        [CsvOrder(1)]
        public string DocumentType { get; set; }
        [CsvOrder(2)]
        public string DocumentTypeName { get; set; }
        [CsvOrder(3)]
        public string Document { get; set; }
        [CsvOrder(4)]
        public string EmploymentInfoType { get; set; }
        [CsvOrder(5)]
        public string ActivityType { get; set; }
        [CsvOrder(6)]
        public string OccupationCode { get; set; }
        [CsvOrder(7)]
        public string Employer { get; set; }
        [CsvOrder(8)]
        public string EmploymentSectorCode { get; set; }
        [CsvOrder(9)]
        public string Position { get; set; }
        [CsvOrder(10)]
        public string EmploymentDocumentType { get; set; }
        [CsvOrder(11)]
        public string EmployDocumentTypeName { get; set; }
        [CsvOrder(12)]
        public string EmploymentDocument { get; set; }
        [CsvOrder(13)]
        public string RegistrationDate { get; set; }
        [CsvOrder(14)]
        public string ByContract { get; set; }
        [CsvOrder(15)]
        public string ContractDueDate { get; set; }
        [CsvOrder(16)]
        public string IdIncomesCurrency { get; set; }
        [CsvOrder(17)]
        public string NetIncomes { get; set; }
        [CsvOrder(18)]
        public string TotalIncomes { get; set; }
        [CsvOrder(19)]
        public string IsPoliticallyExposed { get; set; }
        [CsvOrder(20)]
        public string GeographicName { get; set; }
        [CsvOrder(21)]
        public string GeographicCode { get; set; }
        [CsvOrder(22)]
        public string CityName { get; set; }
        [CsvOrder(23)]
        public string CityCode { get; set; }
        [CsvOrder(24)]
        public string NeighbourhoodName { get; set; }
        [CsvOrder(25)]
        public string NeighbourhoodCode { get; set; }
        [CsvOrder(26)]
        public string PostalCode { get; set; }
        [CsvOrder(27)]
        public string IdStreetType { get; set; }
        [CsvOrder(28)]
        public string Street { get; set; }
        [CsvOrder(29)]
        public string DoorNumber { get; set; }
        [CsvOrder(30)]
        public string IsBis { get; set; }
        [CsvOrder(31)]
        public string Floor { get; set; }
        [CsvOrder(32)]
        public string Apartment { get; set; }
        [CsvOrder(33)]
        public string AdditionalInfo { get; set; }
        [CsvOrder(34)]
        public string CeeLNumber { get; set; }
        [CsvOrder(35)]
        public string PhoneNumber { get; set; }
        [CsvOrder(36)]
        public string EmailLaboral { get; set; }

        public EmployForDataDumpDTO(GetEmployForDataDumpOutputDTO dto)
        {
            DocumentType = dto.DocumentType.ToString();
            DocumentTypeName = string.IsNullOrWhiteSpace(dto.DocumentTypeName) ? string.Empty : dto.DocumentTypeName.Trim();
            Document = string.IsNullOrWhiteSpace(dto.Document) ? string.Empty : dto.Document.Trim();
            EmploymentInfoType = string.IsNullOrWhiteSpace(dto.EmploymentInfoType) ? string.Empty : dto.EmploymentInfoType.Trim();
            ActivityType = string.IsNullOrWhiteSpace(dto.ActivityType) ? string.Empty : dto.ActivityType.Trim();
            OccupationCode = string.IsNullOrWhiteSpace(dto.EmploymentOccupationCode) ? string.Empty : dto.EmploymentOccupationCode.Trim();
            Employer = string.IsNullOrWhiteSpace(dto.Employer) ? string.Empty : dto.Employer.Trim();
            EmploymentSectorCode = string.IsNullOrWhiteSpace(dto.EmploymentSectorCode) ? string.Empty : dto.EmploymentSectorCode.Trim();
            Position = string.IsNullOrWhiteSpace(dto.Position) ? string.Empty : dto.Position.Trim();
            EmploymentDocumentType = string.IsNullOrWhiteSpace(dto.EmploymentDocumentType) ? string.Empty : dto.EmploymentDocumentType.Trim();
            EmployDocumentTypeName = string.IsNullOrWhiteSpace(dto.EmployDocumentTypeName) ? string.Empty : dto.EmployDocumentTypeName.Trim();
            EmploymentDocument = string.IsNullOrWhiteSpace(dto.EmploymentDocument) ? string.Empty : dto.EmploymentDocument.Trim();
            RegistrationDate = dto.RegistrationDate.HasValue ? dto.RegistrationDate.Value.ToString("yyyyMMdd") : string.Empty;
            ByContract = string.IsNullOrWhiteSpace(dto.ByContract) ? "0" : dto.ByContract.Trim();
            ContractDueDate = dto.ContractDueDate.HasValue ? dto.ContractDueDate.Value.ToString("yyyyMMdd") : string.Empty;
            IdIncomesCurrency = string.IsNullOrWhiteSpace(dto.IdIncomesCurrency) ? string.Empty : dto.IdIncomesCurrency.Trim();
            NetIncomes = string.IsNullOrWhiteSpace(dto.NetIncomes) ? string.Empty : dto.NetIncomes.Trim();
            TotalIncomes = string.IsNullOrWhiteSpace(dto.TotalIncomes) ? string.Empty : dto.TotalIncomes.Trim();
            IsPoliticallyExposed = string.IsNullOrWhiteSpace(dto.IsPoliticallyExposed) ? "0" : dto.IsPoliticallyExposed.Trim();
            GeographicCode = string.IsNullOrWhiteSpace(dto.GeographicCode) ? string.Empty : dto.GeographicCode.Trim();
            GeographicName = string.IsNullOrWhiteSpace(dto.GeographicName) ? string.Empty : dto.GeographicName.Trim();
            CityCode = string.IsNullOrWhiteSpace(dto.CityCode) ? string.Empty : dto.CityCode.Trim();
            CityName = string.IsNullOrWhiteSpace(dto.CityName) ? string.Empty : dto.CityName.Trim();
            NeighbourhoodCode = string.IsNullOrWhiteSpace(dto.NeighbourhoodCode) ? string.Empty : dto.NeighbourhoodCode.Trim();
            NeighbourhoodName = string.IsNullOrWhiteSpace(dto.NeighbourhoodName) ? string.Empty : dto.NeighbourhoodName.Trim();
            PostalCode = string.IsNullOrWhiteSpace(dto.PostalCode) ? string.Empty : dto.PostalCode.Trim();
            IdStreetType = string.IsNullOrWhiteSpace(dto.IdStreetType) ? string.Empty : dto.IdStreetType.Trim();
            Street = string.IsNullOrWhiteSpace(dto.Street) ? string.Empty : dto.Street.Trim();
            DoorNumber = string.IsNullOrWhiteSpace(dto.DoorNumber) ? string.Empty : dto.DoorNumber.Trim();
            IsBis = string.IsNullOrWhiteSpace(dto.IsBis) ? "0" : dto.IsBis.Trim();
            Floor = string.IsNullOrWhiteSpace(dto.Floor) ? string.Empty : dto.Floor.Trim();
            Apartment = string.IsNullOrWhiteSpace(dto.Apartment) ? string.Empty : dto.Apartment.Trim();
            AdditionalInfo = string.IsNullOrWhiteSpace(dto.AdditionalInfo) ? string.Empty : dto.AdditionalInfo.Trim();
            PhoneNumber = string.IsNullOrWhiteSpace(dto.PhoneNumber) ? string.Empty : dto.PhoneNumber.Trim();
            CeeLNumber = string.IsNullOrWhiteSpace(dto.CeeLNumber) ? string.Empty : dto.CeeLNumber.Trim();
            EmailLaboral = string.IsNullOrWhiteSpace(dto.EmailLaboral) ? string.Empty : dto.EmailLaboral.Trim();
        }
    }
}
