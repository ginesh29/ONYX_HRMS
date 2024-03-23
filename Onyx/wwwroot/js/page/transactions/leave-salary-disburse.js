window["datatable"] = $('#EmployeeLeavesSalaryDisburseDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveSalaryConfirmData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "transNo" },
            {
                data: function (row) {
                    return `${row.emp}(${row.empCd.trim()})`
                }
            },     
            { data: "div" },
            { data: "lvSalary" },
            { data: "lvTicket" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLeaveSalaryDisburseModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveSalaryDisburseModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);

function showLeaveSalaryDisburseModal(transNo, reject) {
    var url = `/Transactions/GetEmpLeaveSalaryDisburse?transNo=${transNo}`;
    $('#EmployeeLeaveSalaryDisburseModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            $("#Status").val("0");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Cancel");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#Status").val("1");
        }
        $("#EmployeeLeaveSalaryDisburseModal").modal("show");
    });
}
function saveLeaveSalaryApproval(btn) {
    var frm = $("#leave-salary-disburse-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveSalaryDisburse", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveSalaryDisburseModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}