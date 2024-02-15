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
                    return row.issueDt && moment(row.issueDt).format('DD/MM/YYYY');
                },
            },
            { data: "issuePlace" },
            {
                data: function (row) {
                    return row.expDt && moment(row.expDt).format('DD/MM/YYYY');
                }, width: "100px"
            },
            { data: "refNo" },
            {
                data: function (row) {
                    return row.refDt && moment(row.refDt).format('DD/MM/YYYY');
                },
            },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showDocumentModal('${row.docTypCd.trim()}','${row.divCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteDocument('${row.docTypCd.trim()}','${row.divCd.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showDocumentModal(docTypeCd, divCd) {
    var url = `/Organisation/GetDocument?docTypeCd=${encodeURI(docTypeCd)}&divCd=${divCd}`;
    $('#DocumentModal').load(url, function () {
        parseDynamicForm();
        $(".select-picker").selectpicker();
        $('.date-input').attr("placeholder", "mm/dd/yyyy");
        $('.date-input').datetimepicker({
            format: 'L'
        });
        $("#DocumentModal").modal("show");
    });
}
function deleteDocument(docTypeCd, divCd) {
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
            deleteAjax(`/Organisation/DeleteDocument?docTypeCd=${encodeURI(docTypeCd)}&divCd=${divCd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDocument(btn) {
    var frm = $("#document-frm");
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