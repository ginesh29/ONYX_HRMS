window["datatable"] = $('#CountriesDataTable').DataTable(
    {
        ajax: "/Settings/FetchCountries",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "code" },
            { data: "shortDesc" },
            { data: "description" },
            { data: "nationality" },
            { data: "region" },
            { data: "provisions" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showCountryModal('${row.code}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteCountry('${row.code}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showCountryModal(cd) {
    var url = `/Settings/GetCountry?cd=${cd}`;
    $('#CountryModal').load(url, function () {
        parseDynamicForm();
        $("#CountryModal").modal("show");
    });
}
function deleteCountry(cd) {
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
            deleteAjax(`/settings/DeleteCountry?cd=${cd}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    reloadDatatable();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function saveCountry(btn) {
    var frm = $("#country-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveCountry", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#CountryModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#CountryModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}