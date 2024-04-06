window["datatable"] = $('#EmployeeLeavesSalaryApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveSalaryApprovalData",
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
            { data: "lvSalary" },
            { data: "lvTicket" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.transDt}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button class="btn btn-sm btn-info ml-2" onclick="showLeaveSalaryApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveSalaryApprovalModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "120px"
            }
        ],
    }
);

function showLeaveSalaryApprovalModal(transNo, reject) {
    var url = `/Transactions/GetEmpLeaveSalaryApproval?transNo=${transNo}`;
    $('#EmployeeLeaveSalaryApprovalModal').load(url, function () {
        parseDynamicForm();
        if (!reject) {
            var LvSalary = $('#LvSalary').attr("data-max");
            var LvTicket = $('#LvTicket').attr("data-max");
            setTimeout(function () {
                $('#LvSalary').rules("add", {
                    max: Number(LvSalary),
                    messages: {
                        max: `Please enter a number less than or equal to ${LvSalary}`
                    }
                });
                $('#LvTicket').rules("add", {
                    max: Number(LvTicket),
                    messages: {
                        max: `Please enter a number less than or equal to ${LvTicket}`
                    }
                });
            }, 500)
            $("#Status").val("Y");
        }
        else {
            $("#approval-div").addClass("d-none");
            $("#approval-div input").val("");
            $("#btn-submit").text("Reject");
            $("#btn-submit").removeClass("btn-info").addClass("btn-danger");
            $("#Status").val("R");
        }
        $("#EmployeeLeaveSalaryApprovalModal").modal("show");
    });
}
function saveLeaveSalaryApproval(btn) {
    var frm = $("#leave-salary-approval-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveLeaveSalaryApproval", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLeaveSalaryApprovalModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}