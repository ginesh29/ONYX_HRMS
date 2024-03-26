window["datatable"] = $('#EmployeeLoanApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanApprovalData",
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
                    return `${row.empName}(${row.employeeCode.trim()})`
                }
            },
            { data: "desg" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "loanType" },
            {
                data: function (row) {
                    return !row.apprAmt ? row.amt : row.apprAmt
                },
            },
            {
                data: function (row) {
                    return !row.noInst ? row.noInstReq : row.noInst
                },
            },
            { data: "purpose" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLoanApprovalModal('${row.transNo.trim()}','${row.employeeCode.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLoanApprovalModal('${row.transNo.trim()}','${row.employeeCode.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);

function showLoanApprovalModal(transNo, empCd, reject) {
    var url = `/Transactions/GetEmpLoanApproval?transNo=${transNo}&empCd=${empCd}`;
    $('#EmployeeLoanApprovalModal').load(url, function () {
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
        $("#EmployeeLoanApprovalModal").modal("show");
    });
}

function saveLoanApproval(btn) {
    var frm = $("#loan-approval-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLoanApproval", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLoanApprovalModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }

}