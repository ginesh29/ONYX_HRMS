window["datatable"] = $('#CurrenciesDataTable').DataTable(
    {
        ajax: "/Settings/FetchCurrencies",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "code" },
            { data: "des" },
            { data: "mainCurr" },
            { data: "subCurr" },
            { data: "rate" },
            { data: "noDecs" },
            { data: "symbol" },
            { data: "abbr" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showCurrencyModal('${row.code}')">
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteCurrency('${row.code}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showCurrencyModal(cd) {
    var url = `/Settings/GetCurrency?cd=${cd}`;
    $('#CurrencyModal').load(url, function () {
        parseDynamicForm();
        $("#CurrencyModal").modal("show");
    });
}
function deleteCurrency(cd) {
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
            deleteAjax(`/settings/DeleteCurrency?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveCurrency(btn) {
    var frm = $("#currency-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveCurrency", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#CurrencyModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#CurrencyModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}