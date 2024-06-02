window["datatable"] = $('#DepartmentsDataTable').DataTable(
    {
        ajax: "/Settings/FetchDepartments",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "code" },
            { data: "department" },
            { data: "description" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showDepartmentModal('${row.code}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteDepartment('${row.code}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showDepartmentModal(cd) {
    var url = `/Settings/GetDepartment?cd=${cd}`;
    $('#DepartmentModal').load(url, function () {
        parseDynamicForm();
        $("#DepartmentModal").modal("show");
    });
}
function deleteDepartment(cd) {
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
            deleteAjax(`/settings/DeleteDepartment?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDepartment(btn) {
    var frm = $("#dept-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveDepartment", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DepartmentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DepartmentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}