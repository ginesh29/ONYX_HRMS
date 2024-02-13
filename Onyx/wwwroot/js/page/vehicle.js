window["datatable"] = $('#VehiclesDataTable').DataTable(
    {
        ajax: "/Organisation/FetchVehicles",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },            
            { data: "des" },
            { data: "regnNo" },
            { data: "model" },
            { data: "brand" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showVehicleModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteVehicle('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showVehicleModal(cd) {
    var url = `/Organisation/GetVehicle?cd=${cd}`;
    $('#VehicleModal').load(url, function () {
        parseDynamicForm();
        $("#VehicleModal").modal("show");
    });
}
function deleteVehicle(cd) {
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
            deleteAjax(`/Organisation/DeleteVehicle?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveVehicle(btn) {
    var frm = $("#Vehicle-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveVehicle", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#VehicleModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#VehicleModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('Image-Preview');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
    var filename = $("#ImageFile").val().split("\\").pop();
    $("#Image-Preview").removeClass("d-none");
    $("#image-file-label").text(filename);
};