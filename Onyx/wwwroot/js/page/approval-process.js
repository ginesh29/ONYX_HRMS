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
            { data: "processId" },
            { data: "applTyp" },
            { data: "branch" },
            { data: "dept" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showApprovalProcessModal('${row.processIdCd.trim()}','${row.applTypCd.trim()}','${row.branchCd.trim()}','${row.deptCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteApprovalProcess('${row.processIdCd.trim()}','${row.applTypCd.trim()}','${row.branchCd.trim()}','${row.deptCd.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showApprovalProcessModal(processIdCd, applTypCd, branchCd, deptCd) {
    var url = `/Organisation/GetApprovalProcess?processIdCd=${processIdCd}&applTypCd=${applTypCd}&branchCd=${branchCd}&deptCd=${deptCd}`;
    $('#ApprovalProcessModal').load(url, function () {
        parseDynamicForm();
        $("#ApprovalProcessModal").modal("show");
    });
}
function deleteApprovalProcess(cd) {
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
            deleteAjax(`/Organisation/DeleteApprovalProcess?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveApprovalProcess(btn) {
    var frm = $("#ApprovalProcess-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveApprovalProcess", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#ApprovalProcessModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#ApprovalProcessModal").modal("hide");
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