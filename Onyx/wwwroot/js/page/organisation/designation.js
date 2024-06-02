window["datatable"] = $('#DesignationsDataTable').DataTable(
    {
        ajax: "/Organisation/FetchDesignations",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },            
            { data: "sDes" },
            { data: "des" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showDesignationModal('${row.cd}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteDesignation('${row.cd}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showDesignationModal(cd) {
    var url = `/Organisation/GetDesignation?cd=${cd}`;
    $('#DesignationModal').load(url, function () {
        parseDynamicForm();
        $("#DesignationModal").modal("show");
    });
}
function deleteDesignation(cd) {
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
            deleteAjax(`/Organisation/DeleteDesignation?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDesignation(btn) {
    var frm = $("#designation-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveDesignation", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DesignationModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DesignationModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}