setActiveMenu();
setBrowserInfo();
$("#user-company-dropdown").on('change', function (e) {
    postAjax("/home/UpdateCompany", { CoCd: e.target.value }, function (response) {
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
                    $(this).val("");
                    $(`#${ev.target.id}`).data("daterangepicker").setStartDate(moment());
                    $(`#${ev.target.id}`).data("daterangepicker").setEndDate(moment());
                    $(`#${ev.target.id}Days-txt`).text("");
                    $(`#${ev.target.id}Days`).val("");

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
        postAjax("/Transactions/SaveLeaveApproval", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveApprovalModal").modal("hide");
                reloadDatatable();
                var transNo = $("#TransNo").val();
                if ($("#leave-approvals-notifications").length)
                    $(`#transNo-${transNo}`).remove();
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
    var WpDateRangeDays = $("#WpDateRangeDays").val();
    var WopDateRangeDays = $("#WopDateRangeDays").val();
    var totalLvDays = $("#TotalLvDays").val();
    var calculatedTotalLvDays = Number(WpDateRangeDays) + Number(WopDateRangeDays);
    var WpDateRange = $("#WpDateRange").val();
    var WopDateRange = $("#WopDateRange").val();
    if (checkRangesOverlap(WpDateRange, WopDateRange))
        $("#errorContainer").text("Date Range (WP) & (WOP) is ovelaped");
    else if (Number(totalLvDays) != calculatedTotalLvDays)
        $("#errorContainer").text("Total Leaves not matched with Date Range (WP) & (WOP)");
    else {
        isValid = true;
        $("#errorContainer").text("");
    }
    return isValid;
}