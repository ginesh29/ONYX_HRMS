﻿window["datatable"] = $('#BankAccountsDataTable').DataTable(
    {
        ajax: "/Employee/FetchBankAccounts",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            {
                data: function (row) {
                    return `${row.employeeName}(${row.empCd.trim()})`;
                },
            },
            { data: "employeeAcName" },
            { data: "bank" },
            { data: "branch" },
            { data: "empAc" },
            { data: "routeCd" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showBankAccountModal('${row.empCd.trim()}','${row.bankCd.trim()}','${row.bankBrCd.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteBankAccount('${row.empCd.trim()}','${row.bankCd.trim()}','${row.bankBrCd.trim()}',${row.srNo})">
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showBankAccountModal(empCd, bankCd, bankBrCd, srNo) {
    var url = `/Employee/GetBankAccount?empCd=${encodeURI(empCd)}&bankCd=${bankCd}&bankBrCd=${bankBrCd}&srNo=${srNo}`;
    $('#BankAccountModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        $("#BankAccountModal").modal("show");
    });
}
function deleteBankAccount(empCd, bankCd, bankBrCd, srNo) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Delete?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Employee/DeleteBankAccount?empCd=${encodeURI(empCd)}&bankCd=${bankCd}&bankBrCd=${bankBrCd}&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveBankAccount(btn) {
    var frm = $("#bank-account-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Employee/SaveBankAccount", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#BankAccountModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#BankAccountModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function bindBankBranch(e) {
    $("#BankBrCd").empty();
    getAjax(`/Employee/FetchBankBranchItems?bankCd=${e.value}`, function (response) {
        var html = '';
        $.each(response, function (i, item) {
            html += `<option value='${item.value}'>${item.text}</option>`
        })
        $("#BankBrCd").html(html);
        $("#BankBrCd").attr("title", "-- Select --");
        $('.select-picker').selectpicker('refresh');
    });
}