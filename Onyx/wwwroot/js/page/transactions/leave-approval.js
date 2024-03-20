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
                    var lvDays = moment(row.lvTo).diff(moment(row.lvFrom), 'days');
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
                    return `<button data-toggle="tooltip" data-original-title="View" class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.lvFrom}','${row.lvTo}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button data-toggle="tooltip" data-original-title="Approve" class="btn btn-sm btn-info ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button data-toggle="tooltip" data-original-title="Reject" class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
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
            var startDate = $("#LvFrom").val();
            var endDate = $("#LvTo").val();
            var dateRangePickerOptions = dateRangePickerDefaultOptions;
            dateRangePickerOptions.minDate = startDate;
            dateRangePickerOptions.maxDate = endDate;
            $('#LvDateRange,#WopDateRange').daterangepicker(dateRangePickerOptions);
            $('#LvDateRange,#WopDateRange').on('apply.daterangepicker', function (ev, picker) {
                var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
                var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
                var days = picker.endDate.diff(picker.startDate, 'days');
                $(`#${ev.target.id}Days-txt`).text(`(${days} days)`);
                $(`#${ev.target.id}Days`).val(days)
                $(this).val(`${startDate} - ${endDate}`);
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

function UpdateTotalLeavesDays() {
    var lvDays = $("#LvDateRangeDays").val();
    var WoplvDays = $("#WopDateRangeDays").val();
    $("#totalLvDays").text(Number(lvDays) + Number(WoplvDays));
}
function saveLeaveApproval(btn) {
    var frm = $("#leave-approval-frm");
    if (frm.valid()) {
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
}