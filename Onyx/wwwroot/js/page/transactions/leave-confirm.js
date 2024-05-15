var type = $("#Type").val();
type = type ? type : '';
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
            { data: "empCd", visible: false },
            { data: "div", visible: false },
            { data: "dept", visible: false },
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
                    return `<button class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.fromDt}','${row.toDt}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button class="btn btn-sm btn-info ml-2" onclick="showLeaveConfirmModal('${row.transNo.trim()}')">
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
        $('#DateRange,#WpDateRange,#WopDateRange,#GraduityDateRange,#LvSalaryDateRange,#LvTicketDateRange').daterangepicker(dateRangePickerDefaultOptions)
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
                UpdateTotalLeavesDays();
            });;
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
bindEmployeeDropdown();

function changeType(e) {
    $(".confirm-div").addClass("d-none");
    $(".revise-div").addClass("d-none");
    $("#single-payroll-container").addClass("d-none");
    $(".single-payroll-div").addClass("d-none");
    if (e.value == LeaveConfirmTypesEnum.Confirm) {
        $(".confirm-div").removeClass("d-none");
        $(".revise-div:not(.confirm-div) input").val("");
    }
    else if (e.value == LeaveConfirmTypesEnum.Revise) {
        $(".revise-div").removeClass("d-none");
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
            else
                showErrorToastr(response.message);
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
            else 
                showErrorToastr(response.message);
            unloadingButton(btn);
        });
    }
}

function changeSinglePayroll() {
    $("#single-payroll-container").addClass("d-none");
    $(".single-payroll-div").addClass("d-none");
    var checked = $("#SinglePayroll").is(":checked");
    if (checked) {
        $("#single-payroll-container").removeClass("d-none");
        $(".single-payroll-div").removeClass("d-none");
    }
}
function LvPaidUpdate(cur, i) {
    var unpaid = cur.value;
    var totalDays = $(`#Salary_SinglePayrollAttendanceData_${i}__NoOfDays`).val();
    var paidDays = $(`#Salary_SinglePayrollAttendanceData_${i}__P_HDays`).val();
    var payable = totalDays - paidDays - unpaid;
    if (payable >= 0) {
        $(`#Salary_SinglePayrollAttendanceData_${i}__Payable`).val(payable);
        var payabletotal = getTotalPayable();
        updateComponentAmount(payabletotal);
    }
    else
        $(`#Salary_SinglePayrollAttendanceData_${i}__Payable`).val(payable - totalDays);
}

function getTotalPayable() {
    var total = 0;
    $("[id$=__Payable").each(function () {
        var val = $(this).val();
        total += Number(val);
    })
    return total;
}

function updateComponentAmount(totalPayable) {
    $("[id$=__UpdatedAmt").each(function () {
        var itemAmt = parseFloat($(this).attr("data-val"));
        var totalWDays = parseInt($('#TotalWDays').val());
        var totalPayableDays = parseFloat(totalPayable);
        var updatedAmt = (itemAmt / totalWDays) * totalPayableDays;
        $(this).val(updatedAmt)
    })
}