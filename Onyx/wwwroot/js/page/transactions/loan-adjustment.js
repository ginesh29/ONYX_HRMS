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
                            <button class="btn btn-sm btn-warning ml-2" onclick="printLoanAdjust('${row.transNo.trim()}','${row.empCd.trim()}')">
                                <i class="fa fa-print"></i>
                            </button>`;
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
    $('.amt').each(function () {
        if (closed) {
            $("#RecoMode-container").removeClass("d-none");
            var currentMonth = $("#CurrentMonth").val();
            var currentYear = $("#CurrentYear").val();
            var month = $(this).attr("data-month");
            var year = $(this).attr("data-year");
            if (month == currentMonth && year == currentYear) {
                $(this).removeClass("disabled")
                var apprAmt = $("#ApprAmt").val();
                $(this).val(apprAmt);
            }
            else {
                $(this).addClass("disabled");
                $(this).val("0.00");
            }
        }
        else {
            $("#RecoMode-container").addClass("d-none");
            var amt = $(this).attr("data-value");
            $(this).val(amt)
        }
    });
}

function updateEmi(cur) {
    var transNo = $("#TransNo").val();
    var status = $("#LoanStatus").val();
    var amount = $(cur).val();
    loadLoanEmi(transNo, status, amount);
}