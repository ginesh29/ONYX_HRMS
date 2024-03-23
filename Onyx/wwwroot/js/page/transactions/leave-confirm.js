
var type = $("#Type").val();
window["datatable"] = $('#EmployeeLeavesDataTable').DataTable(
    {
        ajax: `/Transactions/FetchEmpLeaveData?type=${type}`,
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            {
                data: function (row) {
                    return `${row.emp}(${row.empCd.trim()})`
                }
            },
            {
                data: function (row) {
                    var formattedFromDate = moment(row.fromDt).format(CommonSetting.DisplayDateFormat);
                    var formattedToDate = moment(row.toDt).format(CommonSetting.DisplayDateFormat);
                    var lvDays = getDaysBetweenDateRange(moment(row.fromDt), moment(row.toDt));
                    return `${formattedFromDate} - ${formattedToDate}<br/>(${lvDays} days)`;
                }, width: '200px'
            },
            { data: "lvTyp" },
            {
                data: function (row) {
                    return row.toDt && moment(row.toDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "designation" },
            { data: "branch" },
            { data: "apprBy" },
            {
                data: function (row) {
                    return row.appDt && moment(row.appDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLeaveConfirmModal('${row.transNo.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showLeaveConfirmModal(transNo) {
    var action = !type ? "GetEmpLeaveConfirm" : "GetDutyResumption";
    var url = `/Transactions/${action}?transNo=${transNo}`;
    $('#EmployeeLeaveConfirmModal').load(url, function () {
        parseDynamicForm();
        var start = $("#FromDt").val();
        var end = $("#ToDt").val();
        var dateRangePickerOptions = dateRangePickerDefaultOptions;
        dateRangePickerOptions.minDate = start;
        dateRangePickerOptions.maxDate = end;
        $('#DateRange,#WpDateRange,#WopDateRange,#GraduityDateRange,#LvSalaryDateRange,#LvTicketDateRange').daterangepicker(dateRangePickerDefaultOptions)
            .on('apply.daterangepicker', function (ev, picker) {
                var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
                var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
                var days = getDaysBetweenDateRange(picker.startDate, picker.endDate);
                $(`#${ev.target.id}Days`).text(`(${days} days)`);
                $(this).val(`${startDate} - ${endDate}`);
            });
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
        $('#DateRange').on('apply.daterangepicker', function (ev, picker) {
            $('#WpDateRange,#WopDateRange').val("");
            $('#WpDateRange,#WopDateRange').data("daterangepicker").setStartDate(moment());
            $('#WpDateRange,#WopDateRange').data("daterangepicker").setEndDate(moment());
            $('#WpDateRange,#WopDateRange').data('daterangepicker').minDate = picker.startDate;
            $('#WpDateRange,#WopDateRange').data('daterangepicker').maxDate = picker.endDate;
        });
        $("#EmployeeLeaveConfirmModal").modal("show");
    });
}
function ValidateDateRange() {
    var isValid = false;
    var WpDateRangeDays = $("#WpDateRangeDays").val();
    var WopDateRangeDays = $("#WopDateRangeDays").val();
    var totalLvDays = $("#TotalLvDays").val();
    var calculatedTotalLvDays = Number(WpDateRangeDays) + Number(WopDateRangeDays);
    var WpDateRange = $("#WpDateRange").val();
    var WopDateRange = $("#WopDateRange").val();
    if (checkRangesOverlap(WpDateRange, WopDateRange))
        $("#errorContainer").text("Date Range (WP) & (WOP) is ovelaped");
    else if (totalLvDays != calculatedTotalLvDays)
        $("#errorContainer").text("Total Leaves not matched with Date Range (WP) & (WOP)");
    else {
        isValid = true;
        $("#errorContainer").text("");
    }
    return isValid;
}

function changeType(e) {
    $(".confirm-div").addClass("d-none");
    $(".revise-div").addClass("d-none");
    if (e.value == LeaveConfirmTypesEnum.Confirm) {
        $(".confirm-div").removeClass("d-none");
        $(".revise-div input").val("");
    }
    else if (e.value == LeaveConfirmTypesEnum.Revise) {
        $(".revise-div").removeClass("d-none");
        $(".confirm-div input").val("");
    }
}
function saveLeaveConfirm(btn) {
    var frm = $("#leave-confirm-frm");
    if (frm.valid() && ValidateDateRange()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveConfirm", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveConfirmModal").modal("hide");
                reloadDatatable();
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
function saveDutyResumption(btn) {
    var frm = $("#leave-duty-resumption-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveDutyResumption", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveConfirmModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}