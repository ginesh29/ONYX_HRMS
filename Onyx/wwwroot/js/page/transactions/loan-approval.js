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
                    return `<button class="btn btn-sm btn-info" onclick="showLoanApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLoanApprovalModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);

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