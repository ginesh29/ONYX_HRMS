window["datatable"] = $('#TokensDataTable').DataTable(
    {
        ajax: "/Queue/FetchTokens",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "tokenNo" },
            { data: "serviceName" },
            { data: "mobileNo" },
            {
                data: function (row) {
                    return row.active ? "Called" : "Waiting";
                },
            },
        ],
    }
);
function showTokenModal(cd) {
    var url = `/Queue/GetToken?cd=${cd}`;
    $('#TokenModal').load(url, function () {
        parseDynamicForm();
        $("#TokenModal").modal("show");
    });
}
function saveToken(btn) {
    var frm = $("#token-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Queue/SaveToken", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}