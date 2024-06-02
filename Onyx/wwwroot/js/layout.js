setActiveMenu();
var hasEditPermission = $("#HasEditPermission").val();
var hasDeletePermission = $("#HasDeletePermission").val();
var editEnable = !hasEditPermission ? "disabled" : "";
var deleteEnable = !hasDeletePermission ? "disabled" : "";
function managePermissionView() {
    var hasViewPermission = $("#HasViewPermission").val();
    var hasAddPermission = $("#HasAddPermission").val();
    if (!hasAddPermission)
        $(`#btn-add`).remove();
    if (!hasViewPermission) {
        $(".card-header").remove();
        showCardMessage("warning", "You don't have permission to view this module. Please contact Administrator.");
        $(".card-footer").remove();
    }
    if (!hasEditPermission) {
        $(".card form").addClass("disabled-container");
        $("#btn-submit").prop("disabled", true);
    }
}
managePermissionView();
$("#language-dropdown .dropdown-item").on('click', function (e) {
    e.preventDefault();
    var lang = $(this).attr("data-value");
    $("#culture").val(lang);
    $("#selectLanguage").submit();
})
$("#user-company-dropdown").on('change', function (e) {
    postAjax("/home/UpdateClaim", { claimType: 'CompanyCd', claimValue: e.target.value }, function (response) {
        showSuccessToastr(response.message);
        window.location.reload();
    });
})
function showChangePasswordModal() {
    var url = `/Account/ChangePassword`;
    $('#ChangePasswordModal').load(url, function () {
        parseDynamicForm();
        $("#ChangePasswordModal").modal("show");
    });
}
function showLeaveApprovalModal(transNo, reject) {
    var url = `/Transactions/GetEmpLeaveApproval?transNo=${transNo}`;
    $('#EmployeeLeaveApprovalModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            $('#WpDateRange').rules("add", {
                eitherOrRequired: ['#WopDateRange', '#WpDateRange'],
                messages: {
                    eitherOrRequired: "Please enter Date Range(WP)"
                }
            });
            $('#WopDateRange').rules("add", {
                eitherOrRequired: ['#WpDateRange', '#WopDateRange'],
                messages: {
                    eitherOrRequired: "Please enter Date Range(WOP)"
                }
            });
            var start = $("#LvFrom").val();
            var end = $("#LvTo").val();
            var dateRangePickerOptions = dateRangePickerDefaultOptions;
            dateRangePickerOptions.minDate = start;
            dateRangePickerOptions.maxDate = end;
            $('#WpDateRange,#WopDateRange').daterangepicker(dateRangePickerOptions)
                .on('apply.daterangepicker', function (ev, picker) {
                    var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
                    var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
                    var days = getDaysBetweenDateRange(picker.startDate, picker.endDate);
                    $(`#${ev.target.id}Days-txt`).text(`(${days} days)`);
                    $(`#${ev.target.id}Days`).val(days);
                    $(this).val(`${startDate} - ${endDate}`);
                    UpdateTotalLeavesDays();
                }).on('change.daterangepicker', function (ev, picker) {
                    if ($(this).val()) {
                        var picker = $(this).data('daterangepicker');
                        var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
                        var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
                        var days = getDaysBetweenDateRange(picker.startDate, picker.endDate);
                        $(`#${ev.target.id}Days-txt`).text(`(${days} days)`);
                        $(`#${ev.target.id}Days`).val(days);
                        $(this).val(`${startDate} - ${endDate}`);
                    }
                    else {
                        $(this).val("");
                        $(`#${ev.target.id}`).data("daterangepicker").setStartDate(moment());
                        $(`#${ev.target.id}`).data("daterangepicker").setEndDate(moment());
                        $(`#${ev.target.id}Days-txt`).text("");
                        $(`#${ev.target.id}Days`).val("");
                    }
                    UpdateTotalLeavesDays();
                });
            $("#Status").val("Y");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#Status").val("R");
        }
        $("#EmployeeLeaveApprovalModal").modal("show");
    });
}
function showLeaveDetailModal(empCd, fromDt, toDt) {
    var url = `/Transactions/GetEmpLeaveDetail?empCd=${empCd}&fromDt=${fromDt}&toDt=${toDt}`;
    $('#EmployeeLeaveDetailModal').load(url, function () {
        $("#EmployeeLeaveDetailModal").modal("show");
    });
}
function saveLeaveApproval(btn) {
    var frm = $("#leave-approval-frm");
    if (frm.valid() && ValidateLeaveApprovalDateRange()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveApproval?processId=HRPT11", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveApprovalModal").modal("hide");
                reloadDatatable();
                if ($("#leave-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
    else {
        var WpDateRange = $("#WpDateRange").val();
        var WopDateRange = $("#WopDateRange").val();
        if (!WpDateRange && !WopDateRange)
            $("#errorContainer").text("Please enter Date Range(either WP or WOP) otherwise both");
    }
}
function ValidateLeaveApprovalDateRange() {
    var isValid = false;
    var WpDateRange = $("#WpDateRange").val();
    var WopDateRange = $("#WopDateRange").val();
    if (checkRangesOverlap(WpDateRange, WopDateRange))
        $("#errorContainer").text("Date Range (WP) & (WOP) is ovelaped");
    else {
        isValid = true;
        $("#errorContainer").text("");
    }
    return isValid;
}
function UpdateTotalLeavesDays() {
    var lvDays = $("#WpDateRangeDays").val();
    var WoplvDays = $("#WopDateRangeDays").val();
    var totalLvDays = Number(lvDays) + Number(WoplvDays);
    $("#totalLvDays").text(totalLvDays);
}
function showLeaveSalaryApprovalModal(transNo, reject) {
    var url = `/Transactions/GetEmpLeaveSalaryApproval?transNo=${transNo}`;
    $('#EmployeeLeaveSalaryApprovalModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            var LvSalary = $('#LvSalary').attr("data-max");
            var LvTicket = $('#LvTicket').attr("data-max");
            setTimeout(function () {
                $('#LvSalary').rules("add", {
                    max: Number(LvSalary),
                    messages: {
                        max: `Please enter a number less than or equal to ${LvSalary}`
                    }
                });
                $('#LvTicket').rules("add", {
                    max: Number(LvTicket),
                    messages: {
                        max: `Please enter a number less than or equal to ${LvTicket}`
                    }
                });
            }, 500)
            $("#Status").val("Y");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#Status").val("R");
        }
        $("#EmployeeLeaveSalaryApprovalModal").modal("show");
    });
}
function saveLeaveSalaryApproval(btn) {
    var frm = $("#leave-salary-approval-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveSalaryApproval?processId=HRPT101", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveSalaryApprovalModal").modal("hide");
                reloadDatatable();
                if ($("#leave-sal-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}
function showLoanApprovalModal(transNo, reject) {
    var url = `/Transactions/GetEmpLoanApproval?transNo=${transNo}`;
    $('#EmployeeLoanApprovalModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            var amt = $('#ApprAmt').attr("data-max");
            var NoInstReq = $('#NoInst').attr("data-max");
            setTimeout(function () {
                $('#ApprAmt').rules("add", {
                    max: Number(amt),
                    messages: {
                        max: `Please enter a number less than or equal to ${amt}`
                    }
                });
                $('#NoInst').rules("add", {
                    max: Number(NoInstReq),
                    messages: {
                        max: `Please enter a number less than or equal to ${NoInstReq}`
                    }
                });
            }, 500)
            $("#LoanStatus").val("A");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#LoanStatus").val("R");
        }
        $("#EmployeeLoanApprovalModal").modal("show");
    });
}
function saveLoanApproval(btn) {
    var frm = $("#loan-approval-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLoanApproval?processId=HRPT21", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLoanApprovalModal").modal("hide");
                reloadDatatable();
                if ($("#loan-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }

}
function showFundApprovalModal(transNo, reject) {
    var url = `/Transactions/GetEmpFundApproval?transNo=${transNo}`;
    $('#EmpFundApprovalModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            var amt = $('#Amount').attr("data-max");
            setTimeout(function () {
                $('#Amount').rules("add", {
                    max: Number(amt),
                    messages: {
                        max: `Please enter a number less than or equal to ${amt}`
                    }
                });
            }, 500)
            $("#Status").val("Y");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#Status").val("R");
        }
        $("#EmpFundApprovalModal").modal("show");
    });
}
function saveFundApproval(btn) {
    var frm = $("#fund-approval-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveEmpFundApproval?processId=HREFA", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmpFundApprovalModal").modal("hide");
                reloadDatatable();
                if ($("#fund-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}
function showEmpProgressionModal(transNo) {
    var url = `/Transactions/GetEmployeeProgression?transNo=${transNo}`;
    $('#EmpProgressionModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        showHideComponent();
        $("#DesigFromCd").addClass("disabled");
        $("#DesigToCd").addClass("disabled");
        $("#RevisedAmt").addClass("disabled");
        $("#EmpProgressionModal").modal("show");
    });
}
function deleteEmpProgression(transNo) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Delete?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Transactions/DeleteEmployeeProgression?transNo=${transNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
                if ($("#progression-approvals-notifications").length)
                    reloadPageAfterSometime();
            });
        }
    });
}
function saveEmpPrgression(btn, approval) {
    var frm = $("#emp-prograssion-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var url = !approval ? "/Transactions/SaveEmployeeProgression" : "/Transactions/ApproveEmployeeProgression?processId=HRPT6";
        postAjax(url, frm.serialize(), function (response) {
            showSuccessToastr(response.message);
            $("#EmpProgressionModal").modal("hide");
            reloadDatatable();
            if ($("#progression-approvals-notifications").length)
                reloadPageAfterSometime();
            unloadingButton(btn);
        });
    }
}

function showEmpProvisionAdjModal(transNo) {
    var url = `/Transactions/GetProvisionAdj?transNo=${transNo}`;
    $('#EmpProvisionAdjModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        $("#EmpProvisionAdjModal").modal("show");
    });
}
function deleteEmpProvisionAdj(transNo) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Delete?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Transactions/DeleteEmpProvisionAdj?transNo=${transNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
                if ($("#provision-adj-approvals-notifications").length)
                    reloadPageAfterSometime();
            });
        }
    });
}
function saveEmpProvisionAdj(btn, approval) {
    var frm = $("#emp-provision-adj-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var url = !approval ? "/Transactions/SaveEmpProvisionAdj" : "/Transactions/ApproveEmpProvisionAdj";
        postAjax(url, frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmpProvisionAdjModal").modal("hide");
                reloadDatatable();
                if ($("#provision-adj-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
                $("#EmpProvisionAdjModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function showDocumentApprovalModal(empCd, docTypeCd, srNo) {
    var url = `/Transactions/GetRenewalDocumentApproval?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function saveDocumentRenewalApproval(btn, reject) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var status = !reject ? "A" : "R";
        $("#Status").val(status);
        filePostAjax("/Transactions/SaveRenewalDocumentApproval", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                reloadDatatable();
                if ($("#doc-renewal-approvals-notifications").length)
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function showHideTypeDropdown() {
    $('#RenewalDocumentsSearchDataTable').DataTable().destroy();
    $("#RenewalDocumentsSearchDataTable").addClass("d-none");
    var type = $("input[name='Type']:checked").val();
    $("#EmpCd,#Company,#Vehicle").closest('.form-group').addClass("d-none");
    if (type == "EMP")
        $("#EmpCd").closest('.form-group').removeClass("d-none");
    else if (type == "COM")
        $("#Company").closest('.form-group').removeClass("d-none");
    else
        $("#Vehicle").closest('.form-group').removeClass("d-none");
}
function showHideComponent() {
    var type = $("#EP_TypeCd").val();
    $("#component-container").addClass("d-none");
    if (type == "HREP02" || type == "HREP04" || type == "HREP05")
        $("#component-container").removeClass("d-none");
}
$('.filter-select-picker,.filter-select2').on('change', function (e) {
    var dataTable = window["datatable"];
    var value = $(this).val();
    var columnIndex = $(this).attr("data-index");
    if (columnIndex)
        if (dataTable.column(columnIndex).search() !== value)
            dataTable.column(columnIndex).search(value).draw();
});

function showEmpDocumentModal(empCd, docTypeCd, srNo) {
    var url = `/Transactions/GetRenewalEmpDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function showComDocumentModal(docTypeCd, divCd) {
    var url = `/Transactions/GetRenewalComDocument?docTypeCd=${encodeURI(docTypeCd.trim())}&divCd=${divCd.trim()}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function showVehDocumentModal(vehCd, docType) {
    var url = `/Transactions/GetRenewalVehicleDocument?vehCd=${vehCd}&docType=${docType}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function saveEmpDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalEmpDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                if (window.location.search)
                    window.location.href = '/Transactions/DocumentRenewal?processId=HRPT8'
                else
                    reloadPageAfterSometime();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function saveComDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalComDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                window.location.href = '/Transactions/DocumentRenewal?processId=HRPT8'
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function saveVehDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalVehDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                window.location.href = '/Transactions/DocumentRenewal?processId=HRPT8'
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}