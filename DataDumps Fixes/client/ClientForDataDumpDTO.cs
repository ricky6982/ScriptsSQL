using PS.IssuerTransaction.Interface.Datatypes.DataDumpQueries.GetClientForDataDump;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PS.IssuerTransaction.Interface.Enumerations;
using PS.IssuerBusinessConfiguration.Interface.Datatypes.DTO;
using PS.IssuerBusinessConfiguration.Interface.Enumerations;
using PS.CommonCredit.Domain.Util.Attribute;

namespace PS.IssuerTransaction.Interface.Datatypes.DataDump
{
    [Serializable]
    public class ClientForDataDumpDTO
    {
		[CsvOrder(1)]
		public string Document { get; set; }
		[CsvOrder(2)]
		public string Name { get; set; }
		[CsvOrder(3)]
		public string Lastname { get; set; }
		[CsvOrder(4)]
		public string Birthday { get; set; }
		[CsvOrder(5)]
		public string MaritalStatus { get; set; }
		[CsvOrder(6)]
		public string Street { get; set; }
		[CsvOrder(7)]
		public string DoorNumber { get; set; }
		[CsvOrder(8)]
		public string AptoNumber { get; set; }
		[CsvOrder(9)]
		public string Complement { get; set; }
		[CsvOrder(10)]
		public string NeightbourhoodName { get; set; }
		[CsvOrder(11)]
		public string NeightbourhoodCode { get; set; }
		[CsvOrder(12)]
		public string CityName { get; set; }
		[CsvOrder(13)]
		public string CityCode { get; set; }
		[CsvOrder(14)]
		public string StateName { get; set; }
		[CsvOrder(15)]
		public string StateCode { get; set; }
		[CsvOrder(16)]
		public string PostalCode { get; set; }
		[CsvOrder(17)]
		public string CellularPhone { get; set; }
		[CsvOrder(18)]
		public string Phone { get; set; }
		[CsvOrder(19)]
		public string Email { get; set; }
		[CsvOrder(20)]
		public string StreetType { get; set; }
		[CsvOrder(21)]
		public string IsBis { get; set; }
		[CsvOrder(22)]
		public string Floor { get; set; }
		[CsvOrder(23)]
		public string Apartment { get; set; }
		[CsvOrder(24)]
		public string AdditionalInfo { get; set; }
		[CsvOrder(25)]
		public string DocumentType { get; set; }
		[CsvOrder(26)]
		public string DocumentTypeName { get; set; }
		[CsvOrder(27)]
		public string EmisionDate { get; set; }
		[CsvOrder(28)]
		public string DueDate { get; set; }
		[CsvOrder(29)]
		public string SecondaryDocumentType { get; set; }
		[CsvOrder(30)]
		public string SecondaryDocumentTypeName { get; set; }
		[CsvOrder(31)]
		public string SecondaryDocument { get; set; }
		[CsvOrder(32)]
		public string EmbossingName { get; set; }
		[CsvOrder(33)]
		public string FirstLasName { get; set; }
		[CsvOrder(34)]
		public string secondSurName { get; set; }
		[CsvOrder(35)]
		public string FirstName { get; set; }
		[CsvOrder(36)]
		public string SecondName { get; set; }
		[CsvOrder(37)]
		public string Ege { get; set; }
		[CsvOrder(38)]
		public string BirthPlace { get; set; }
		[CsvOrder(39)]
		public string Nationality { get; set; }
		[CsvOrder(40)]
		public string Sex { get; set; }
		[CsvOrder(41)]
		public string NumberChildren { get; set; }

		public ClientForDataDumpDTO() { }
		public ClientForDataDumpDTO(GetClientForDataDumpOutputDTO DTO, List<IssuerParameterStateDTO> parameterState)
		{
			Document = DTO.Document != null ? DTO.Document : string.Empty;
			Name = DTO.Name != null ? DTO.Name : string.Empty;
			Lastname = DTO.Lastname != null ? DTO.Lastname : string.Empty;
			Birthday = DTO.Birthday.HasValue ? DTO.Birthday.Value.ToString("yyyyMMdd") : string.Empty;
			MaritalStatus = DTO.MaritalStatus != null ? DTO.MaritalStatus.ToString() : string.Empty;
			Street = DTO.Street != null ? DTO.Street : string.Empty;
			DoorNumber = DTO.DoorNumber != null ? DTO.DoorNumber : string.Empty;
			AptoNumber = DTO.AptoNumber != null ? DTO.AptoNumber : string.Empty;
			Complement = DTO.Complement != null ? DTO.Complement : string.Empty;
			NeightbourhoodName = DTO.NeightbourhoodName != null ? DTO.NeightbourhoodName : string.Empty;
			NeightbourhoodCode = DTO.NeightbourhoodCode != null ? DTO.NeightbourhoodCode.ToString() : string.Empty;
			CityName = DTO.CityName != null ? DTO.CityName : string.Empty;
			CityCode = GetCityCode(DTO,parameterState); 
			StateName = DTO.StateName != null ? DTO.StateName : string.Empty;
			StateCode = GetGeoSatateCode(DTO, parameterState);
			PostalCode = DTO.PostalCode != null ? DTO.PostalCode : string.Empty;
			CellularPhone = DTO.CellularPhone != null ? DTO.CellularPhone : string.Empty;
			Phone = DTO.Phone != null ? DTO.Phone : string.Empty;
			Email = DTO.Email != null ? DTO.Email : string.Empty;
			StreetType =  string.IsNullOrWhiteSpace(DTO.Street) ? string.Empty : DTO.StreetType ;
			IsBis = string.IsNullOrWhiteSpace(DTO.IsBis) ? string.Empty : DTO.IsBis ;
			Floor = string.IsNullOrWhiteSpace(DTO.Floor) ? string.Empty : DTO.Floor;
			Apartment = string.IsNullOrWhiteSpace(DTO.AptoNumber) ? string.Empty : DTO.AptoNumber;
			AdditionalInfo = string.IsNullOrWhiteSpace(DTO.Complement) ? string.Empty : DTO.Complement;
			DocumentType = string.IsNullOrWhiteSpace(DTO.DocumentType) ? string.Empty : DTO.DocumentType;
			DocumentTypeName = string.IsNullOrWhiteSpace(DTO.DocumentTypeName) ? string.Empty : DTO.DocumentTypeName;
			EmisionDate = DTO.EmisionDate.HasValue ? DTO.EmisionDate.Value.ToString("yyyyMMdd") : string.Empty;
			DueDate = DTO.DueDate.HasValue ? DTO.DueDate.Value.ToString("yyyyMMdd") : string.Empty;
			SecondaryDocumentType = string.IsNullOrWhiteSpace(DTO.SecondaryDocumentType) ? string.Empty : DTO.SecondaryDocumentType;
			SecondaryDocumentTypeName = string.IsNullOrWhiteSpace(DTO.SecondaryDocumentTypeName) ? string.Empty : DTO.SecondaryDocumentTypeName;
			SecondaryDocument = string.IsNullOrWhiteSpace(DTO.SecondaryDocument) ? string.Empty : DTO.SecondaryDocument;
			EmbossingName = string.IsNullOrWhiteSpace(DTO.EmbossingName) ? string.Empty : DTO.EmbossingName;
			FirstLasName = string.IsNullOrWhiteSpace(DTO.Lastname) ? string.Empty : DTO.Lastname;
			secondSurName = string.IsNullOrWhiteSpace(DTO.secondSurName) ? string.Empty : DTO.secondSurName;
			FirstName = string.IsNullOrWhiteSpace(DTO.Name) ? string.Empty : DTO.Name;
			SecondName = string.IsNullOrWhiteSpace(DTO.SecondName) ? string.Empty : DTO.SecondName;
			Ege = string.IsNullOrWhiteSpace(DTO.Age) ? string.Empty : DTO.Age;
			BirthPlace = string.IsNullOrWhiteSpace(DTO.BirthPlace) ? string.Empty : DTO.BirthPlace;
			Nationality = string.IsNullOrWhiteSpace(DTO.Nationality) ? string.Empty : DTO.Nationality;
			Sex = DTO.Sex.HasValue ? DTO.Sex.Value.ToString() : string.Empty ;
			NumberChildren = DTO.NumberChildren.HasValue ? DTO.NumberChildren.ToString() : string.Empty;
		}

        private string GetCityCode(GetClientForDataDumpOutputDTO dTO, List<IssuerParameterStateDTO> parameterState)
        {
			if(parameterState.Exists(x=> x.IsActive && x.Parameter == IssuerParameter.USE_CITY_EXTERNAL_CODE.ToString()))
				return  string.IsNullOrWhiteSpace(dTO.CityCode) ? string.Empty : dTO.CityCode.ToString();
			else
				return  string.IsNullOrWhiteSpace(dTO.CityExternalCode) ? string.Empty : dTO.CityExternalCode.ToString();
		}

		private string GetGeoSatateCode(GetClientForDataDumpOutputDTO dTO, List<IssuerParameterStateDTO> parameterState)
		{
			if (parameterState.Exists(x => x.IsActive && x.Parameter == IssuerParameter.USE_GEO_STATE_EXTERNAL_CODE.ToString()))
				return string.IsNullOrWhiteSpace(dTO.StateCode ) ? string.Empty : dTO.StateCode.ToString();
			else
				return string.IsNullOrWhiteSpace(dTO.StateExternalCode) ? string.Empty : dTO.StateExternalCode.ToString();
		}
	}
}
