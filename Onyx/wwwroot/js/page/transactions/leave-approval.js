
window["datatable"] = $('#EmployeeLeavesApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveApprovalData",
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
                    var formattedFromDate = moment(row.lvFrom).format(CommonSetting.DisplayDateFormat);
                    var formattedToDate = moment(row.lvTo).format(CommonSetting.DisplayDateFormat);
                    var lvDays = getDaysBetweenDateRange(moment(row.lvFrom), moment(row.lvTo));
                    return `${formattedFromDate} - ${formattedToDate}<br/>(${lvDays} days)`;
                }, width: '200px'
            },
            { data: "lvTyp" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "desg" },
            { data: "branch" },
            { data: "reason" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.lvFrom}','${row.lvTo}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button class="btn btn-sm btn-info ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "120px"
            }
        ],
    }
);
var isAdmin = $("#IsAdmin").val() == 1;
if (isAdmin)
    window["datatable"].column(8).visible(false);
function showLeaveDetailModal(empCd, fromDt, toDt) {
    var url = `/Transactions/GetEmpLeaveDetail?empCd=${empCd}&fromDt=${fromDt}&toDt=${toDt}`;
    $('#EmployeeLeaveDetailModal').load(url, function () {
        $("#EmployeeLeaveDetailModal").modal("show");
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

function UpdateTotalLeavesDays() {
    var lvDays = $("#WpDateRangeDays").val();
    var WoplvDays = $("#WopDateRangeDays").val();
    var totalLvDays = Number(lvDays) + Number(WoplvDays);
    $("#totalLvDays").text(totalLvDays);
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
function saveLeaveApproval(btn) {
    var frm = $("#leave-approval-frm");
    if (frm.valid() && ValidateDateRange()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveApproval", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveApprovalModal").modal("hide");
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