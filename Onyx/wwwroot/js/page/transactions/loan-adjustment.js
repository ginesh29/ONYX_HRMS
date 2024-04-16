window["datatable"] = $('#EmployeeLoanAdjustmentDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanAdjustmentData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "empCd", visible: false },
            { data: "transNo" },            
            {
                data: function (row) {
                    return `${row.empName}(${row.empCd.trim()})`
                }
            },
            { data: "loanTyp" },
            { data: "amt" },
            { data: "apprAmt" },
            { data: "noInst" },
            { data: "purpose" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLoanAdjustModal('${row.transNo.trim()}')">
                                <i class="fas fa-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-success ml-2" onclick="showLoanAdjustModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>
                            <button class="btn btn-sm btn-warning ml-2" onclick="printLoanAdjust('${row.transNo.trim()}')">
                                <i class="fa fa-print"></i>
                            </button>`;
                }, "width": "120px"
            }
        ],
    }
);
bindEmployeeDropdown();
function showLoanAdjustModal(transNo, close) {
    var status = !close ? "D" : "C";
    var url = `/Transactions/GetEmpLoanAdjustment?transNo=${transNo}&status=${status}`;
    $('#EmployeeLoanAdjustModal').load(url, function () {
        parseDynamicForm();
        $("#LoanStatus").val(status);
        $("#EmployeeLoanAdjustModal").modal("show");
    });
}

function saveLoanAdjust(btn, transNo, empCd) {
    var frm = $("#loan-adj-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var status = $("#LoanStatus").val();
        postAjax(`/Transactions/SaveEmpLoanAdj`, `transNo=${transNo.trim()}&type=${status.trim()}&empCd=${empCd.trim()}&${frm.serialize()}`, function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeLoanAdjustModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }

}

$('#EmpCd').on('change', function (e) {
    var dataTable = window["datatable"];
    var value = $(this).val();
    var columnIndex = $(this).attr("data-index");
    if (dataTable.column(columnIndex).search() !== value)
        dataTable.column(columnIndex).search(value).draw();
});