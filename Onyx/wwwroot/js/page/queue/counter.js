var coCd = $("#CoCd").val();
window["datatable"] = $('#CountersDataTable').DataTable(
    {
        ajax: "/Queue/FetchCounters",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },
            { data: "name" },
            {
                data: function (row) {
                    return row.active ? "Yes" : "No";
                },
            },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showCounterModal('${row.cd}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteCounter('${row.cd}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showCounterModal(cd) {
    var url = `/Queue/GetCounter?cd=${cd}`;
    $('#CounterModal').load(url, function () {
        parseDynamicForm();
        $('#DocList').load(`/Queue/FetchAdFiles?CounterCd=${cd}`);
        $("#CounterModal").modal("show");
    });
}
function deleteCounter(cd) {
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
            deleteAjax(`/Queue/DeleteCounter?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveCounter(btn) {
    var frm = $("#counter-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Queue/SaveCounter", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#CounterModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}