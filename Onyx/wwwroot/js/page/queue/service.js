var coCd = $("#CoCd").val();
window["datatable"] = $('#ServicesDataTable').DataTable(
    {
        ajax: "/Queue/FetchServices",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },
            { data: "prefix" },
            { data: "name" },
            {
                data: function (row) {
                    return row.active ? "Yes" : "No";
                },
            },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showServiceModal('${row.cd}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteService('${row.cd}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showServiceModal(cd) {
    var url = `/Queue/GetService?cd=${cd}`;
    $('#ServiceModal').load(url, function () {
        parseDynamicForm();
        $("#ServiceModal").modal("show");
    });
}
function deleteService(cd) {
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
            deleteAjax(`/Queue/DeleteService?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveService(btn) {
    var frm = $("#service-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Queue/SaveService", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#ServiceModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}