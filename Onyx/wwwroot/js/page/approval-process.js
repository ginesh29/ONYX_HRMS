window["datatable"] = $('#ApprovalProcessesDataTable').DataTable(
    {
        ajax: "/Organisation/FetchApprovalProcesses",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "coCd" },
            { data: "processId" },
            { data: "applTyp" },            
            { data: "branch" },
            { data: "dept" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showBranchModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteBranch('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showBranchModal(cd) {
    var url = `/Organisation/GetBranch?cd=${cd}`;
    $('#BranchModal').load(url, function () {
        parseDynamicForm();
        $("#BranchModal").modal("show");
    });
}
function deleteBranch(cd) {
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
            deleteAjax(`/Organisation/DeleteBranch?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveBranch(btn) {
    var frm = $("#branch-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveBranch", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#BranchModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#BranchModal").modal("hide");
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