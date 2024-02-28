using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;
using X.PagedList;

namespace Onyx.Controllers
{
    public class EmployeeController : Controller
    {
        private readonly AuthService _authService;
        private readonly EmployeeService _employeeService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly OrganisationService _organisationService;
        private readonly LoggedInUserModel _loggedInUser;
        private readonly FileHelper _fileHelper;
        public EmployeeController(AuthService authService, EmployeeService employeeService, CommonService commonService, SettingService settingService, OrganisationService organisationService)
        {
            _employeeService = employeeService;
            _authService = authService;
            _commonService = commonService;
            _settingService = settingService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _fileHelper = new FileHelper();
        }
        public IActionResult Profiles()
        {
            return View();
        }
        public IActionResult FetchEmployeeItems(string departments, string designations, string branches, string locations, string term)
        {
            var employees = _employeeService.GetEmployees(_loggedInUser.CompanyCd, departments, designations, branches, locations);
            if (!string.IsNullOrEmpty(term))
                employees = employees.Where(m => m.Name.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Department.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Desg.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Branch.Trim().Contains(term, StringComparison.OrdinalIgnoreCase) || m.Location.Trim().Contains(term, StringComparison.OrdinalIgnoreCase));
            return Json(employees);
        }
        public IActionResult FetchEmployees(int? page)
        {
            int pageNumber = page ?? 1;
            int pageSize = 9;
            var employees = _employeeService.GetEmployees(_loggedInUser.CompanyCd);
            var pagedEmployees = employees.ToPagedList(pageNumber, pageSize);
            return PartialView("_EmployeesList", pagedEmployees);
        }
        public IActionResult Profile(string Cd)
        {
            var employee = _employeeService.FindEmployee(Cd, _loggedInUser.CompanyCd);
            if (employee != null)
            {
                employee.Code = employee.Cd?.Trim();
                employee.Cd = employee.Cd?.Trim();
                employee.Salute = employee.Salute?.Trim();
                employee.Marital = employee.Marital?.Trim();
                employee.Nat = employee.Nat?.Trim();
                employee.Relg = employee.Relg?.Trim();
                employee.Sponsor = employee.Sponsor?.Trim();
                employee.Desg = employee.Desg?.Trim();
                employee.Dept = employee.Dept?.Trim();
                employee.LocCd = employee.LocCd?.Trim();
                employee.RepTo = employee.RepTo?.Trim();
                employee.UserCd = employee.UserCd?.Trim();
                employee.Pwd = employee.Pwd?.Trim().Decrypt();
                employee.ConfirmPassword = employee.Pwd;
                employee.PayFreq = employee.PayFreq?.Trim();
                employee.PayMode = employee.PayMode?.Trim();
                employee.BankCd = employee.BankCd?.Trim();
                employee.CurrCd = employee.CurrCd?.Trim();
                employee.BasicCurr = employee.BasicCurr?.Trim();
                employee.TravSect = employee.TravSect?.Trim();
                employee.TravClass = employee.TravClass?.Trim();
                employee.FareEligibleValue = employee.FareEligible == "Y";
                employee.EmpTyp = employee.EmpTyp?.Trim();
                employee.Status = employee.Status?.Trim();
                employee.GTValue = employee.GT == "Y";
                employee.LSValue = employee.LS == "Y";
                employee.LTValue = employee.LT == "Y";
                employee.ActiveValue = employee.Active == "Y";
                var avatarFileExist = employee?.Imagefile.FileExist("emp-photo", _loggedInUser.CompanyCd);
                var avatarImage = avatarFileExist == true && !string.IsNullOrEmpty(employee?.Imagefile) ? $"/uploads/{_loggedInUser.CompanyCd}/emp-photo/{employee.Imagefile}" : "/images/avatar.png";
                var signatureFileExist = employee?.ImageSign.FileExist("emp-sign", _loggedInUser.CompanyCd);
                var signatureImage = signatureFileExist == true && !string.IsNullOrEmpty(employee?.ImageSign) ? $"/uploads/{_loggedInUser.CompanyCd}/emp-sign/{employee.ImageSign}" : $"/uploads/{_loggedInUser.CompanyCd}/emp-sign/{employee.ImageSign}";
                ViewBag.AvatarFileExist = avatarFileExist;
                ViewBag.SignatureFileExist = signatureFileExist;
                ViewBag.AvatarPath = avatarImage;
                ViewBag.SignaturePath = signatureImage;
                ViewBag.Addrsses = _commonService.GetCodesGroups("HADD");
            }

            ViewBag.SalutationItems = _commonService.GetCodesGroups(CodeGroup.Salutation).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.MaritalStatusItems = _commonService.GetCodesGroups(CodeGroup.MaritalStatus).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.NationalityItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDesc
            });
            ViewBag.ReligionItems = _commonService.GetCodesGroups(CodeGroup.Religion).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.SponsorItems = _commonService.GetCodesGroups(CodeGroup.Sponsor).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
            });
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.BranchItems = _settingService.GetBranches(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.LocationItems = _commonService.GetCodesGroups(CodeGroup.EmpDeployLoc).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.ShortDes}({m.Code.Trim()})"
            });
            ViewBag.ReportingToItems = _employeeService.GetEmployees(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.Name}({m.Cd.Trim()})"
            });
            ViewBag.UserItems = _settingService.GetUsers().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Username}({m.Code.Trim()})"
            });

            ViewBag.PayModeItems = _commonService.GetSysCodes("HPMOD").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayFrequencyItems = _commonService.GetSysCodes("HPFRQ").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayBankItems = _commonService.GetCodesGroups("BANK").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.BasicCurrencyItems = _settingService.GetCurrencies(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Des
            });
            ViewBag.CurrencyItems = _settingService.GetCurrencies(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.Des
            });
            ViewBag.TravelSectorItems = _commonService.GetCodesGroups(CodeGroup.Sector).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.TravelClassItems = _commonService.GetCodesGroups(CodeGroup.Class).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.StatusItems = _commonService.GetStatusTypes();
            ViewBag.EmpTypeItems = _commonService.GetCodesGroups("J_ET").Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.CalulationBasisTypeItems = _commonService.GetCalulationBasisTypes();
            return View("ProfileUpsert", employee ?? new Employee_Find_Result());
        }
        [HttpPost]
        public async Task<IActionResult> SavePersonalDetail(Employee_Find_Result model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            model.ConfirmPassword = model.ConfirmPassword.Encrypt();
            if (model.AvatarFile != null)
            {
                var filePath = await _fileHelper.UploadFile(model.AvatarFile, "emp-photo", _loggedInUser.CompanyCd);
                model.Imagefile = filePath;
            }
            if (model.SignatureFile != null)
            {
                var filePath = await _fileHelper.UploadFile(model.SignatureFile, "emp-sign", _loggedInUser.CompanyCd);
                model.ImageSign = filePath;
            }
            var result = _employeeService.SaveEmployee(model, _loggedInUser.CompanyCd);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult RemoveAvatar(string Cd)
        {
            _employeeService.RemoveAvatar(Cd);
            var result = new CommonResponse
            {
                Success = true,
                Message = "Avatar removed successfully"
            };
            return Json(result);
        }
        #region Education
        public IActionResult Educations()
        {
            return View();
        }
        public IActionResult FetchEducations(string empCd)
        {
            var educations = _employeeService.GetEmpQualifications(empCd, _loggedInUser.CompanyCd);
            CommonResponse result = new()
            {
                Data = educations,
            };
            return Json(result);
        }
        public IActionResult GetEducation(string empCd, int srNo)
        {
            var education = _employeeService.GetEmpQualifications(empCd, _loggedInUser.CompanyCd).FirstOrDefault(m => m.SrNo == srNo);
            var model = new EmpQualificationModel();
            if (education != null)
                model = new EmpQualificationModel
                {
                    Country = education.Country?.Trim(),
                    CountryCd = education.CountryCd?.Trim(),
                    MarksGrade = education.MarksGrade,
                    PassingYear = education.PassingYear?.Trim(),
                    Qualification = education.Qualification?.Trim(),
                    QualCd = education.QualCd?.Trim(),
                    SrNo = srNo,
                    University = education.University,
                };
            else
                model.SrNo = _employeeService.GetEmpQualification_SrNo(empCd);
            ViewBag.QualificationItems = _settingService.GetCodeGroupItems("HQUAL").Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.PassingYearItems = _commonService.GetYears(1900);
            ViewBag.CountryItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Text = m.ShortDesc,
                Value = m.Code.Trim(),
            });
            return PartialView("_EducationModal", model);
        }
        [HttpPost]
        public IActionResult SaveEducation(EmpQualificationModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _employeeService.SaveEmpQualification(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteEducation(string empCd, int srNo)
        {
            _employeeService.DeleteEmpQualification(empCd, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Experience
        public IActionResult Experiences()
        {
            return View();
        }
        public IActionResult FetchExperiences(string empCd)
        {
            var experiences = _employeeService.GetEmpExperiences(empCd);
            CommonResponse result = new()
            {
                Data = experiences,
            };
            return Json(result);
        }
        public IActionResult GetExperience(string empCd, int srNo)
        {
            var experience = _employeeService.GetEmpExperiences(empCd).FirstOrDefault(m => m.Srno == srNo);
            var model = new EmpExperienceModel();
            if (experience != null)
                model = new EmpExperienceModel
                {
                    Country = experience.Country?.Trim(),
                    CountryCd = experience.CountryCd?.Trim(),
                    Designation = experience.Designation?.Trim(),
                    Desg = experience.Desg?.Trim(),
                    CompanyReference = experience.CompanyReference,
                    CompanyName = experience.CompanyName,
                    EndingDate = experience.EndingDate,
                    DateRange = $"{Convert.ToDateTime(experience.StartingDate).ToString(CommonSetting.DateFormat)} - {Convert.ToDateTime(experience.EndingDate).ToString(CommonSetting.DateFormat)}",
                    Narration = experience.Narration,
                    StartingDate = experience.StartingDate,
                    Srno = experience.Srno,
                };
            else
                model.Srno = _employeeService.GetEmpExperience_SrNo(empCd);
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Text = m.SDes,
                Value = m.Cd.Trim(),
            });
            ViewBag.CountryItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Text = m.ShortDesc,
                Value = m.Code.Trim(),
            });
            return PartialView("_ExperienceModal", model);
        }
        [HttpPost]
        public IActionResult SaveExperience(EmpExperienceModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _employeeService.SaveEmpExperience(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteExperience(string empCd, int srNo)
        {
            _employeeService.DeleteEmpExperience(empCd, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Document
        public IActionResult Documents()
        {
            return View("DocumentContainer");
        }
        public IActionResult FetchDocuments(string empCd = "")
        {
            var documents = _employeeService.GetDocuments(empCd);
            CommonResponse result = new()
            {
                Data = documents,
            };
            return Json(result);
        }
        public IActionResult GetDocument(string empCd, string docTypeCd, int srNo)
        {
            var document = _employeeService.GetDocuments(empCd).FirstOrDefault(m => m.DocTypCd.Trim() == docTypeCd && m.SrNo == srNo);
            var model = new EmpDocumentModel();
            if (document != null)
                model = new EmpDocumentModel
                {
                    DocNo = document.DocNo,
                    DocTypSDes = document.DocTypSDes,
                    DocTypCd = document.DocTypCd.Trim(),
                    ExpDt = document.ExpDt,
                    IssueDt = document.IssueDt,
                    SrNo = document.SrNo,
                    IssuePlace = document.IssuePlace,
                    DocsPaths = _employeeService.GetDocumentFiles(empCd, document.DocTypCd)
                };
            else
                model.SrNo = _commonService.GetNext_SrNo("EmpDocuments", "srNo");
            model.EmpCd = empCd;
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems("HDTYP").Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_DocumentModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveDocument(EmpDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _employeeService.SaveDocument(model);
            if (result.Success)
            {
                if (model.DocFiles?.Count() > 0)
                {
                    var totalFiles = _employeeService.GetDocumentFiles(model.EmpCd, model.DocTypCd).Count();
                    string uploadedFilePath = string.Empty;
                    foreach (var item in model.DocFiles.Select((value, i) => new { i, value }))
                    {
                        if (item != null)
                        {
                            var filePath = await _fileHelper.UploadFile(item.value, "emp-doc", _loggedInUser.CompanyCd);
                            uploadedFilePath = filePath;
                            _employeeService.SaveDocumentFile(new EmpDocImageModel
                            {
                                EmployeeCode = model.EmpCd,
                                EntryBy = _loggedInUser.UserAbbr,
                                DocumentTypeCd = model.DocTypCd,
                                ImageFile = uploadedFilePath,
                                SlNo = item.i + 1 + totalFiles,
                            });
                        }
                    }
                }
            }
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteDocument(string empCd, string docTypeCd, int srNo)
        {
            _employeeService.DeleteDocument(empCd, docTypeCd, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        public IActionResult FetchDocumentFiles(string empCd, string docTypeCd)
        {
            var files = _employeeService.GetDocumentFiles(empCd, docTypeCd);
            return PartialView("_DocFilesList", files);
        }
        [HttpDelete]
        public IActionResult DeleteDocumentFile(string empCd, string docTypCd, int slNo)
        {
            var documentFile = _employeeService.GetDocumentFiles(empCd, docTypCd).FirstOrDefault(m => m.SlNo == slNo);
            _fileHelper.RemoveFile(documentFile.ImageFile, "emp-doc");
            var result = _employeeService.DeleteDocumentFile(empCd, docTypCd, slNo);
            return Json(result);
        }
        [HttpPost]
        public async Task<IActionResult> UpdateDocumentFile(string empCd, string docTypCd, int SrNo, IFormFile file)
        {
            var uploadedFilePath = await _fileHelper.UploadFile(file, "emp-doc", _loggedInUser.CompanyCd);
            _employeeService.SaveDocumentFile(new EmpDocImageModel
            {
                EntryBy = _loggedInUser.UserAbbr,
                DocumentTypeCd = docTypCd,
                ImageFile = uploadedFilePath,
                SlNo = SrNo,
                EmployeeCode = empCd,
            });
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.UPDATED
            };
            return Json(result);
        }
        #endregion

        #region Component
        public IActionResult Components()
        {
            return View("ComponentsContainer");
        }
        public IActionResult FetchComponents(string empCd = "")
        {
            var components = _employeeService.GetComponents(empCd);
            CommonResponse result = new()
            {
                Data = components,
            };
            return Json(result);
        }
        public IActionResult GetComponent(string empCd, string edCd, string edTyp, int srNo)
        {
            var component = _employeeService.GetComponents(empCd).FirstOrDefault(m => m.EdCd.Trim() == edCd && m.EdTyp.Trim() == edTyp && m.SrNo == srNo);
            var model = new EmpEarnDedModel();
            if (component != null)
                model = new EmpEarnDedModel
                {
                    Amt = component.Amt,
                    Basic = component.Basic,
                    CurrCd = component.CurrCd,
                    Currency = component.Currency,
                    Description = component.Description.Trim(),
                    EdCd = component.EdCd.Trim(),
                    EdTyp = component.EdTyp.Trim(),
                    EffDt = component.EffDt,
                    Emp = component.Emp,
                    EndDt = component.EndDt,
                    PercAmt = component.PercAmt,
                    PercVal = component.PercVal,
                    SrNo = component.SrNo,
                    Type = component.Type
                };
            model.EmpCd = empCd;
            ViewBag.ComponentClassTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.ComponentClassItems = _employeeService.GetComponentClasses(model.EdTyp?.Trim()).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PercentageAmtItems = _commonService.GetPercentageAmtTypes();
            return PartialView("_ComponentModal", model);
        }
        public IActionResult FetchComponentClassItems(string type)
        {
            var payCodeItems = _employeeService.GetComponentClasses(type).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return Json(payCodeItems);
        }
        [HttpPost]
        public IActionResult SaveComponent(EmpEarnDedModel model)
        {
            model.EntryBy = _loggedInUser.UserAbbr;
            var result = _employeeService.SaveComponent(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteComponent(string empCd, string edCd, string edTyp, int srNo)
        {
            _employeeService.DeleteComponent(empCd, edCd, edTyp, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Address
        //public IActionResult Addresses()
        //{
        //    return View();
        //}

        #endregion

        #region Bank Account

        #endregion
    }
}
