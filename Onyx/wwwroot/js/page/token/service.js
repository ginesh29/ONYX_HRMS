var coCd = $("#CoCd").val();
window["datatable"] = $('#ServicesDataTable').DataTable(
    {
        ajax: "/Token/FetchServices",
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
                    return `<button class="btn btn-sm btn-info" onclick="showServiceModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteService('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showServiceModal(cd) {
    var url = `/Token/GetService?cd=${cd}`;
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
            deleteAjax(`/Token/DeleteService?cd=${cd}`, function (response) {
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
        filePostAjax("/Token/SaveService", frm[0], function (response) {
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
function previewImage(event) {
    var reader = new FileReader();
    var ext = event.target.files[0].name.split('.').pop().toLowerCase();
    if (imageExtensions.includes(ext)) {
        reader.onload = function () {
            var output = document.getElementById('Image-Preview');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
        var filename = $("#ImageFile").val().split("\\").pop();
        $("#Image-Preview").removeClass("d-none");
        $("#image-file-label").text(filename);
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
};