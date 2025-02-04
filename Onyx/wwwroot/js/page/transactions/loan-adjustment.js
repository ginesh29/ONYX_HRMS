﻿window["datatable"] = $('#EmployeeLoanAdjustmentDataTable').DataTable(
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
            {
                data: function (row) {
                    return !row.apprAmt ? row.apprAmt : formatDecimal(row.apprAmt)
                },
            },
            { data: "noInst" },
            { data: "purpose" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showLoanAdjustModal('${row.transNo.trim()}')" ${editEnable}>
                                <i class="fas fa-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-warning ml-2" onclick="printLoanAdjust('${row.transNo.trim()}','${row.empCd.trim()}')">
                                <i class="fa fa-print"></i>
                            </button></div>`;
                }, "width": "80px"
            }
        ],
    }
);
bindEmployeeDropdown();
function showLoanAdjustModal(transNo, close) {
    var status = !close ? "D" : "C";
    var url = `/Transactions/GetEmpLoanAdjustment?transNo=${transNo}`;
    $('#EmployeeLoanAdjustModal').load(url, function () {
        parseDynamicForm();
        loadLoanEmi(transNo, status);
        $("#LoanStatus").val(status);
        $("#EmployeeLoanAdjustModal").modal("show");
    });
}
function loadLoanEmi(transNo, status, amount) {
    $("#EmpLoanEmi-container").load(`/Transactions/GetEmpLoanEmi?transNo=${transNo}&status=${status}&amount=${amount}`)
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
function printLoanAdjust(transNo, empCd) {
    window.open(`/Transactions/LoanAdvanceSlip?transNo=${transNo}&empCd=${empCd}`);
}
$('#EmpCd').on('change', function (e) {
    var dataTable = window["datatable"];
    var value = $(this).val();
    var columnIndex = $(this).attr("data-index");
    if (dataTable.column(columnIndex).search() !== value)
        dataTable.column(columnIndex).search(value).draw();
});

function ClosedLoan() {
    var closed = $("#Closed").is(":checked");
    var remainingLoan = $("#RemainingLoan").val();
    var transNo = $("#TransNo").val();
    var status = $("#LoanStatus").val();
    var amt = closed ? remainingLoan : null;
    loadLoanEmi(transNo, status, amt);
    $("#RecoMode-container").addClass("d-none");
    if (closed)
        $("#RecoMode-container").removeClass("d-none");
}

function updateEmi(cur) {
    var transNo = $("#TransNo").val();
    var status = $("#LoanStatus").val();
    var amount = $(cur).val();
    loadLoanEmi(transNo, status, amount);
    $("#RecoMode-error").removeClass("d-none");
}