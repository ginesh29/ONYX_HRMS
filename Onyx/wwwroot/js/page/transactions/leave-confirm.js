
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
                    var formattedFromDate = moment(row.fromDt).format('DD/MM/YYYY');
                    var formattedToDate = moment(row.toDt).format('DD/MM/YYYY');
                    var lvDays = moment(row.toDt).diff(moment(row.fromDt), 'days');
                    return `${formattedFromDate} - ${formattedToDate}<br/>(${lvDays} days)`;
                }, width: '200px'
            },
            { data: "lvTyp" },
            {
                data: function (row) {
                    return row.toDt && moment(row.toDt).format('DD/MM/YYYY');
                },
            },
            { data: "designation" },
            { data: "branch" },
            { data: "apprBy" },
            {
                data: function (row) {
                    return row.appDt && moment(row.appDt).format('DD/MM/YYYY');
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
    var url = `/Transactions/GetEmpLeaveConfirm?transNo=${transNo}`;
    $('#EmployeeLeaveConfirmModal').load(url, function () {
        parseDynamicForm();
        $("#EmployeeLeaveConfirmModal").modal("show");
    });
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
    if (frm.valid()) {
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
}