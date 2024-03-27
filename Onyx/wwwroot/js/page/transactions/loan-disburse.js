window["datatable"] = $('#EmployeeLoanDisburseDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanDisburseData",
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
                    return `${row.employeeName}(${row.employeeCode.trim()})`
                }
            },
            { data: "div" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "loanType" },
            { data: "amt" },
            { data: "purpose" },
            { data: "narr" },
            {
                data: function (row) {
                    return row.loanApprDt && moment(row.loanApprDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "approverName" },
            { data: "apprAmt" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLoanDisburseModal('${row.transNo.trim()}')">
                                <i class="fas fa-pencil"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);
function showLoanDisburseModal(transNo, reject) {
    var url = `/Transactions/GetEmpLoanDisburse?transNo=${transNo}`;
    $('#EmployeeLoanDisburseModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            $("#LoanStatus").val("A");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#LoanStatus").val("R");
        }
        $("#EmployeeLoanDisburseModal").modal("show");
    });
}

function saveLoanDisburse(btn) {
    var frm = $("#loan-disburse-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLoanDisburse", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLoanDisburseModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }

}