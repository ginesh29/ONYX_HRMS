﻿window["datatable"] = $('#LoanTypesDataTable').DataTable(
    {
        ajax: "/Organisation/FetchLoanTypes",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },
            { data: "payTyp" },
            { data: "payComp" },
            { data: "dedTyp" },
            { data: "dedComp" },
            { data: "abbr" },
            { data: "chgsTyp" },
            { data: "intPerc" },
            { data: "sdes" },
            { data: "des" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLoanTypeModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteLoanType('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showLoanTypeModal(cd) {
    var url = `/Organisation/GetLoanType?cd=${cd}`;
    $('#LoanTypeModal').load(url, function () {
        parseDynamicForm();
        $('.percentage-input').attr("placeholder", "0 %");
        $('.percentage-input').inputmask(percentageMaskOptions);
        $(".select-picker").selectpicker();
        $("#LoanTypeModal").modal("show");
    });
}
function deleteLoanType(cd) {
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
            deleteAjax(`/Organisation/DeleteLoanType?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveLoanType(btn) {
    var frm = $("#loan-type-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveLoanType", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#LoanTypeModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#LoanTypeModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}