﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Onyx.Models.StoredProcedure;
using Onyx.Models.ViewModels;
using Onyx.Services;
using X.PagedList;

namespace Onyx.Controllers
{
    [Authorize]
    public class EmployeeController : Controller
    {
        private readonly AuthService _authService;
        private readonly OrganisationService _organisationService;
        private readonly CommonService _commonService;
        private readonly SettingService _settingService;
        private readonly EmployeeService _employeeService;
        private readonly UserService _userService;
        private readonly EmailService _emailService;
        private readonly LoggedInUserModel _loggedInUser;
        private readonly FileHelper _fileHelper;
        public EmployeeController(AuthService authService, EmployeeService employeeService, OrganisationService organisationService, CommonService commonService, SettingService settingService, UserService userService, EmailService emailService)
        {
            _authService = authService;
            _commonService = commonService;
            _loggedInUser = _authService.GetLoggedInUser();
            _organisationService = organisationService;
            _settingService = settingService;
            _emailService = emailService;
            _employeeService = employeeService;
            _userService = userService;
            _fileHelper = new FileHelper();
        }
        public IActionResult Profiles()
        {
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
            });
            ViewBag.DepartmentItems = _settingService.GetDepartments().Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Department}({m.Code.Trim()})"
            });
            ViewBag.EmpTypeItems = _commonService.GetCodesGroups(CodeGroup.EmpType).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.EmpWorkingStatusItems = _commonService.GetEmpWorkingStatuses();
            ViewBag.EmployeeStatusItems = _commonService.GetSysCodes(SysCode.EmpStatus).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return View();
        }
        public IActionResult FetchEmployeeItems(string departments, string designations, string branches, string locations)
        {
            var empCd = _loggedInUser.UserLinkedTo == "Emp" ? _loggedInUser.UserCd : string.Empty;
            var employees = _employeeService.GetEmployeeItems(_loggedInUser.CompanyCd, empCd, _loggedInUser.UserLinkedTo, branches, departments, locations, designations);
            var items = employees.Select(s => new Select2Item
            {
                Id = s.Cd.Trim(),
                Text = $"{s.Name.Trim()}({s.Cd.Trim()})"
            }).OrderBy(m => m.Text);
            return Json(items);
        }        
        public IActionResult FetchPagedEmployees(int? page, int? pageSize, EmployeeFilterModel filterModel)
        {
            int pageNumber = page ?? 1;
            var size = pageSize ?? 25;
            var name = !string.IsNullOrEmpty(filterModel.Name) ? $"%{filterModel.Name.Trim()}%" : string.Empty;
            var branches = filterModel.Branches != null ? string.Join(",", filterModel.Branches) : null;
            var departments = filterModel.Departments != null ? string.Join(",", filterModel.Departments) : null;
            var sponsors = filterModel.Sponsors != null ? string.Join(",", filterModel.Sponsors) : null;
            var designations = filterModel.Designations != null ? string.Join(",", filterModel.Designations) : null;
            var empTypes = filterModel.EmployeeTypes != null ? string.Join(",", filterModel.EmployeeTypes) : null;
            var employeesData = _employeeService.GetEmployees(_loggedInUser.CompanyCd, name, _loggedInUser.UserLinkedTo, branches, departments, sponsors, designations, filterModel.EmployeeStatus, empTypes, filterModel.LeaveStatus, filterModel.Active, pageNumber, size);
            var pagedEmployees = new StaticPagedList<Employee_GetRow_Result>(employeesData.Employees, pageNumber, size, employeesData.TotalCount);
            return PartialView("_EmployeesList", new { Data = pagedEmployees, FilterModel = filterModel });
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
                employee.Div = employee.Div?.Trim();
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
                ViewBag.Basic = employee?.Basic;
                var components = _employeeService.GetComponents(Cd, _loggedInUser.UserCd);
                var totalIncome = components.Where(m => m.Type != "Deductions").Sum(m => m.Amt);
                var totalDeductions = components.Where(m => m.Type == "Deductions").Sum(m => m.Amt);
                ViewBag.TotalSalary = employee.Basic + totalIncome - totalDeductions;
                ViewBag.Currency = employee.BasicCurr?.Trim();
            }
            else
            {
                employee = new Employee_Find_Result();
                var autoGen = _commonService.GetParameterByType("#", "GEN_EMPCD")?.Val;
                if (autoGen == "Y")
                    employee.Cd = _employeeService.GetAutoGenerateEmployeeCd().Trim();
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
                Text = m.Nationality
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
            ViewBag.BranchItems = _commonService.GetUserBranches(_loggedInUser.UserLinkedTo, _loggedInUser.CompanyCd).Where(m => m.UserDes != null).Select(m => new SelectListItem
            {
                Value = m.Div.Trim(),
                Text = $"{m.Branch}({m.Div.Trim()})"
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
            ViewBag.ReportingToItems = _employeeService.GetEmployeeItems(_loggedInUser.CompanyCd, string.Empty, _loggedInUser.UserLinkedTo).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.Name}({m.Cd.Trim()})"
            });
            ViewBag.UserItems = _userService.GetUsers(string.Empty).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = $"{m.Username}({m.Code.Trim()})"
            });

            ViewBag.PayModeItems = _commonService.GetSysCodes(SysCode.PayMode).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayFrequencyItems = _commonService.GetSysCodes(SysCode.PayFrequency).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PayBankItems = _commonService.GetCodesGroups(CodeGroup.Bank).Select(m => new SelectListItem
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
            ViewBag.StatusItems = _commonService.GetSysCodes(SysCode.EmpStatus).Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });

            ViewBag.EmpTypeItems = _commonService.GetCodesGroups(CodeGroup.EmpType).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            ViewBag.CalulationBasisTypeItems = _commonService.GetCalulationBasisTypes();
            return View("ProfileUpsert", employee);
        }
        public IActionResult GetEmployeeDetail(string empCd)
        {
            var result = _employeeService.FindEmployee(empCd, _loggedInUser.CompanyCd);
            return Json(result);
        }
        public IActionResult GetUserPwd(string empCd)
        {
            var pwd = _userService.GetUsers(empCd).FirstOrDefault().UPwd.Decrypt();
            return Json(pwd);
        }
        [HttpPost]
        public IActionResult SaveBasicSalary(string empCd, int basic)
        {
            _employeeService.SaveBasicSalary(empCd, basic);
            var employee = _employeeService.FindEmployee(empCd, _loggedInUser.CompanyCd);
            var components = _employeeService.GetComponents(empCd, _loggedInUser.UserLinkedTo);
            var totalIncome = components.Where(m => m.Type != "Deductions").Sum(m => m.Amt);
            var totalDeductions = components.Where(m => m.Type == "Deductions").Sum(m => m.Amt);
            var TotalSalary = employee.Basic + totalIncome - totalDeductions;
            var Currency = employee.BasicCurr?.Trim();
            return Json(new CommonResponse
            {
                Data = new { TotalSalary, Currency = Currency ?? string.Empty },
                Message = "Basic updated successfully"
            });
        }
        [HttpPost]
        public async Task<IActionResult> SavePersonalDetail(Employee_Find_Result model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            model.ConfirmPassword = !string.IsNullOrEmpty(model.ConfirmPassword) ? model.ConfirmPassword.Encrypt() : null;
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
            result.Data = new { EmpCd = model.Cd.Trim() };
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
            model.EmpCd = empCd;
            ViewBag.QualificationItems = _settingService.GetCodeGroupItems(CodeGroup.Qualification).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.PassingYearItems = _commonService.GetYears(1900);
            ViewBag.CountryItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Text = m.Description,
                Value = m.Code.Trim(),
            });
            return PartialView("_EducationModal", model);
        }
        [HttpPost]
        public IActionResult SaveEducation(EmpQualificationModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
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
                    DateRange = ExtensionMethod.GetDateRange(experience.StartingDate, experience.EndingDate),
                    Narration = experience.Narration,
                    StartingDate = experience.StartingDate,
                    Srno = experience.Srno,
                };
            else
                model.Srno = _employeeService.GetEmpExperience_SrNo(empCd);
            model.EmpCd = empCd;
            ViewBag.DesignationItems = _organisationService.GetDesignations().Select(m => new SelectListItem
            {
                Text = m.SDes,
                Value = m.Cd.Trim(),
            });
            ViewBag.CountryItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Text = m.Description,
                Value = m.Code.Trim(),
            });
            return PartialView("_ExperienceModal", model);
        }
        [HttpPost]
        public IActionResult SaveExperience(EmpExperienceModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var dateSp = model.DateRange.Split(" - ");
            model.StartingDate = Convert.ToDateTime(dateSp[0]);
            model.EndingDate = Convert.ToDateTime(dateSp[1]);
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
            var documents = _employeeService.GetDocuments(empCd, string.Empty, 0, "A", _loggedInUser.UserLinkedTo);
            CommonResponse result = new()
            {
                Data = documents,
            };
            return Json(result);
        }
        public IActionResult GetDocument(string empCd, string docTypeCd, int srNo)
        {
            var document = _employeeService.GetDocuments(empCd, docTypeCd, srNo, "A", _loggedInUser.UserLinkedTo).FirstOrDefault();
            var model = new EmpDocumentModel();
            if (document != null)
                model = new EmpDocumentModel
                {
                    Cd = document.EmpCd,
                    EmpCd = document.EmpCd,
                    EmpName = document.EmpName,
                    DocNo = document.DocNo,
                    DocTypSDes = document.DocTypSDes,
                    DocTypCd = document.DocTypCd.Trim(),
                    Expiry = document.Expiry,
                    ExpDt = document.ExpDt,
                    IssueDt = document.IssueDt,
                    SrNo = document.SrNo,
                    IssuePlace = document.IssuePlace,
                    DocsPaths = _employeeService.GetDocumentFiles(empCd, document.DocTypCd)
                };
            else
            {
                model.SrNo = _employeeService.GetEmpDocNext_SrNo(empCd);
                model.Expiry = true;
            }
            var employee = _employeeService.GetEmployees(_loggedInUser.CompanyCd, empCd, _loggedInUser.UserLinkedTo).Employees.FirstOrDefault();
            model.EmpCd = empCd;
            model.EmpName = employee.Name;
            ViewBag.DocTypeItems = _settingService.GetCodeGroupItems(CodeGroup.EmpDocType).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            return PartialView("_DocumentModal", model);
        }
        [HttpPost]
        public async Task<IActionResult> SaveDocument(EmpDocumentModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
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
                                EntryBy = _loggedInUser.UserCd,
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
            var result = _employeeService.DeleteDocumentFile(empCd, docTypeCd, 0);
            if (result.Success)
                _employeeService.DeleteDocument(empCd, docTypeCd, srNo);
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
                EntryBy = _loggedInUser.UserCd,
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
            var components = _employeeService.GetComponents(empCd, _loggedInUser.UserLinkedTo);
            CommonResponse result = new()
            {
                Data = components,
            };
            return Json(result);
        }
        public IActionResult GetComponent(string empCd, string edCd, string edTyp, int srNo)
        {
            var component = _employeeService.GetComponents(empCd, _loggedInUser.UserLinkedTo).FirstOrDefault(m => m.EdCd.Trim() == edCd && m.EdTyp.Trim() == edTyp && m.SrNo == srNo);
            var employee = _employeeService.FindEmployee(empCd, _loggedInUser.CompanyCd);
            var model = new EmpEarnDedModel();
            if (component != null)
            {
                model = new EmpEarnDedModel
                {
                    Cd = empCd,
                    Amt = component.Amt,
                    Basic = component.Basic,
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
                    Type = component.Type,
                    CurrCd = employee.CurrCd.Trim()
                };
            }
            model.EmpCd = empCd;
            model.Emp = employee?.Name;
            ViewBag.ComponentClassTypeItems = _commonService.GetSysCodes(SysCode.ComponentClass).Select(m => new
            SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = $"{m.SDes}({m.Cd.Trim()})"
            });
            ViewBag.ComponentClassItems = _employeeService.GetComponentClasses(model.EdTyp?.Trim()).Where(m => m.Cd.Trim() != "001").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            ViewBag.PercentageAmtItems = _commonService.GetPercentageAmtTypes();
            return PartialView("_ComponentModal", model);
        }
        public IActionResult FetchComponentClassItems(string type)
        {
            var payCodeItems = _employeeService.GetComponentClasses(type).Where(m => m.Cd.Trim() != "001").Select(m => new SelectListItem
            {
                Value = m.Cd.Trim(),
                Text = m.SDes
            });
            return Json(payCodeItems);
        }
        [HttpPost]
        public IActionResult SaveComponent(EmpEarnDedModel model)
        {
            var employee = _employeeService.FindEmployee(model.EmpCd, _loggedInUser.CompanyCd);
            model.EntryBy = _loggedInUser.UserCd;
            if (model.Mode == "I")
            {
                model.SrNo = _employeeService.EmpEarnDed_SrNo(model.EmpCd, model.EdCd, model.EdTyp);
                model.CurrCd = employee.CurrCd;
            }
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
        public IActionResult FetchAddresses(string empCd)
        {
            var addresses = _employeeService.GetAddresses(empCd);
            return PartialView("_Addresses", addresses);
        }
        public IActionResult GetAddress(string empCd, string type)
        {
            var address = _employeeService.GetAddresses(empCd).FirstOrDefault(m => m.AddTyp.Trim() == type);
            var model = new EmpAddressModel();
            if (address != null)
                model = new EmpAddressModel
                {
                    Cd = address.EmployeeCode,
                    Contact = address.Contact,
                    City = address.City,
                    Country = address.Country.Trim(),
                    CountryCd = address.CountryCd.Trim(),
                    AddTyp = address.AddTyp.Trim(),
                    AddressLine1 = address.AddressLine1,
                    AddressLine2 = address.AddressLine2,
                    AddressLine3 = address.AddressLine3,
                    Address_Type = address.Address_Type,
                    EmployeeName = address.EmployeeName,
                    Fax = address.Fax,
                    Email = address.Email,
                    Mobile = address.Mobile,
                    Phone = address.Phone,
                };
            model.EmployeeCode = empCd;
            ViewBag.AddressTypeItems = _commonService.GetCodesGroups(CodeGroup.Address).Select(m => new SelectListItem
            {
                Text = m.Description,
                Value = m.Code.Trim(),
            });
            ViewBag.CountryItems = _settingService.GetCountries().Select(m => new SelectListItem
            {
                Text = m.ShortDesc,
                Value = m.Code.Trim(),
            });
            return PartialView("_AddressModal", model);
        }
        [HttpPost]
        public IActionResult SaveAddress(EmpAddressModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _employeeService.SaveAddress(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteAddress(string empCd, string type)
        {
            _employeeService.DeleteAddress(empCd, type);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Bank Account
        public IActionResult BankAccounts()
        {
            return View();
        }
        public IActionResult FetchBankAccounts()
        {
            var bankaccounts = _employeeService.GetBankAccounts(_loggedInUser.UserLinkedTo);
            CommonResponse result = new()
            {
                Data = bankaccounts,
            };
            return Json(result);
        }
        public IActionResult GetBankAccount(string empCd, string bankCd, string bankBrCd, int srNo)
        {
            var bankAccount = _employeeService.GetBankAccounts(_loggedInUser.UserLinkedTo).FirstOrDefault(m => m.EmpCd.Trim() == empCd && m.BankCd.Trim() == bankCd && m.BankBrCd.Trim() == bankBrCd && m.SrNo == srNo);
            var model = new EmpBankAcModel();
            if (bankAccount != null)
                model = new EmpBankAcModel
                {
                    Amt = bankAccount.Amt,
                    Bank = bankAccount.Bank,
                    BankBrCd = bankAccount.BankBrCd.Trim(),
                    BankCd = bankAccount.BankCd.Trim(),
                    BankGrp = bankAccount.BankGrp,
                    BankGrpCd = bankAccount.BankGrpCd.Trim(),
                    Branch = bankAccount.Branch,
                    CurrCd = bankAccount.CurrCd.Trim(),
                    Currency = bankAccount.Currency,
                    EmpAc = bankAccount.EmpAc,
                    EmpCd = bankAccount.EmpCd.Trim(),
                    EmployeeAcName = bankAccount.EmployeeAcName,
                    EmployeeName = bankAccount.EmployeeName,
                    RouteCd = bankAccount.RouteCd,
                    SrNo = bankAccount.SrNo,
                    Typ = bankAccount.Typ
                };
            else
                model.SrNo = _commonService.GetNext_SrNo("EmpBankAc", "SrNo");
            ViewBag.BankItems = _settingService.GetCodeGroupItems(CodeGroup.Bank).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.BankBranchItems = _settingService.GetBankBranches(model.BankCd).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.BankGroupItems = _settingService.GetCodeGroupItems(CodeGroup.BankGroup).Select(m => new SelectListItem
            {
                Text = m.ShortDes,
                Value = m.Code.Trim(),
            });
            ViewBag.CurrencyItems = _settingService.GetCurrencies(_loggedInUser.CompanyCd).Select(m => new SelectListItem
            {
                Text = m.MainCurr,
                Value = m.Code.Trim(),
            });
            return PartialView("_BankAccountModal", model);
        }
        public IActionResult FetchBankBranchItems(string bankCd)
        {
            var payCodeItems = _settingService.GetBankBranches(bankCd).Select(m => new SelectListItem
            {
                Value = m.Code.Trim(),
                Text = m.ShortDes
            });
            return Json(payCodeItems);
        }
        [HttpPost]
        public IActionResult SaveBankAccount(EmpBankAcModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _employeeService.SaveBankAccount(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteBankAccount(string empCd, string bankCd, string bankBrCd, int srNo)
        {
            _employeeService.DeleteBankAccount(empCd, bankCd, bankBrCd, srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        #endregion

        #region Calendar
        public IActionResult Calendar()
        {
            return View();
        }
        public IActionResult FetchCalendarEvents(string empCd = "")
        {
            var events = _employeeService.GetCalendarEvents(empCd, _loggedInUser.UserLinkedTo).Select(m => new CalendarModel
            {
                Id = m.SrNo.ToString(),
                AllDay = true,
                BackgroundColor = "#f56954",
                BorderColor = "#f56954",
                Start = m.Date.ToString("yyyy-MM-ddTHH:mm:ss"),
                Title = m.Title
            });
            return Json(events);
        }
        public IActionResult GetCalendarEvent(int srNo, string empCd = "")
        {
            var calendarEvent = _employeeService.GetCalendarEvents(empCd, _loggedInUser.UserLinkedTo).FirstOrDefault(m => m.SrNo == srNo);
            var model = new EmpCalendarModel();
            if (calendarEvent != null)
                model = new EmpCalendarModel
                {
                    SrNo = calendarEvent.SrNo,
                    Title = calendarEvent.Title,
                    EmpCd = calendarEvent.EmpCd,
                    EmpName = calendarEvent.EmpName,
                    Date = calendarEvent.Date,
                    Holiday = calendarEvent.Holiday,
                    Narr = calendarEvent.Narr,
                };
            else
                model.SrNo = _commonService.GetNext_SrNo("EmpCalendar_N", "SrNo");
            return PartialView("_CalendarEventModal", model);
        }
        [HttpPost]
        public IActionResult SaveCalendarEvent(EmpCalendarModel model)
        {
            model.EntryBy = _loggedInUser.UserCd;
            var result = _employeeService.SaveCalendarEvent(model);
            return Json(result);
        }
        [HttpDelete]
        public IActionResult DeleteCalendarEvent(int srNo)
        {
            _employeeService.DeleteCalendarEvent(srNo);
            var result = new CommonResponse
            {
                Success = true,
                Message = CommonMessage.DELETED
            };
            return Json(result);
        }
        public IActionResult ImportCalendarEvents(IFormFile file)
        {
            try
            {
                var excelData = _employeeService.GetCalendarEventsFromExcel(file, _loggedInUser.CompanyCd);
                var nextSerialNo = _commonService.GetNext_SrNo("EmpCalendar_N", "SrNo");
                var validData = excelData.Where(m => m.IsValid);
                var invalidData = excelData.Where(m => !m.IsValid);
                string Message = !invalidData.Any() && !validData.Any() ? "No record found to import"
                    : invalidData.Any() ? $"{invalidData.Count()} record failed to import" : $"{validData.Count()} records imported succussfully";
                bool validHeader = _employeeService.ValidHeaderCalendarEventExcel(file);
                if (!validHeader)
                {
                    excelData = null;
                    Message = "Headers are not matched. Download again & refill data";
                }
                if (validHeader && validData.Any())
                    _employeeService.ImportExcelData(validData, nextSerialNo, _loggedInUser.UserCd);
                return PartialView("_ExcelData", new { Data = excelData, Message });
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return Json("File not supported. Download again & refill data");
            }
        }
        #endregion
    }
}
