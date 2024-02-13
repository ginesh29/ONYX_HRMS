window["datatable"] = $('#DocumentsDataTable').DataTable(
    {
        ajax: "/Organisation/FetchDocuments",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "docTypSDes" },
            { data: "divSDes" },
            { data: "docNo", width: "100px" },
            {
                data: function (row) {
                    var formattedDate = moment(row.issueDt).format('DD/MM/YYYY');
                    return formattedDate;
                },
            },
            { data: "issuePlace" },
            {
                data: function (row) {
                    var formattedDate = moment(row.expDt).format('DD/MM/YYYY');
                    return formattedDate;
                }, width: "100px"
            },
            { data: "refNo" },
            { data: "refDt" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showDocumentModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteDocument('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showDocumentModal(cd) {
    var url = `/Organisation/GetDocument?cd=${cd}`;
    $('#DocumentModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentModal").modal("show");
    });
}
function deleteDocument(cd) {
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
            deleteAjax(`/Organisation/DeleteDocument?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDocument(btn) {
    var frm = $("#Document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentModal").modal("hide");
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