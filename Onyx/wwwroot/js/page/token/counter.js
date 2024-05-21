var coCd = $("#CoCd").val();
window["datatable"] = $('#CountersDataTable').DataTable(
    {
        ajax: "/Token/FetchCounters",
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
                    return `<button class="btn btn-sm btn-info" onclick="showCounterModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteCounter('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showCounterModal(cd) {
    var url = `/Token/GetCounter?cd=${cd}`;
    $('#CounterModal').load(url, function () {
        parseDynamicForm();
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
            deleteAjax(`/Token/DeleteCounter?cd=${cd}`, function (response) {
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
        filePostAjax("/Token/SaveCounter", frm[0], function (response) {
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