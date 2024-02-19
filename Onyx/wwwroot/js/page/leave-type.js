window["datatable"] = $('#LeaveTypesDataTable').DataTable(
    {
        ajax: "/Organisation/FetchLeaveTypes",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },            
            { data: "des" },
            { data: "apprLvl" },
            { data: "lvMax" },
            { data: "accrued" },
            { data: "enCash" },
            { data: "enCashMinLmt" },
            { data: "payFact" },
            { data: "accrLmt" },
            { data: "servicePrd" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLeaveTypeModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteLeaveType('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showLeaveTypeModal(cd) {
    var url = `/Organisation/GetLeaveType?cd=${cd}`;
    $('#LeaveTypeModal').load(url, function () {
        parseDynamicForm();
        $("#LeaveTypeModal").modal("show");
    });
}
function deleteLeaveType(cd) {
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
            deleteAjax(`/Organisation/DeleteLeaveType?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveLeaveType(btn) {
    var frm = $("#leave-type-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveLeaveType", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#LeaveTypeModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#LeaveTypeModal").modal("hide");
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