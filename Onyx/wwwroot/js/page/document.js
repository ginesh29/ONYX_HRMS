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
        docTypeCd = docTypeCd.split(" _")[0];
        $('#DocList').load(`/Organisation/FetchDocumentFiles?docTypeCd=${docTypeCd}&divCd=${divCd}`, function () {
            $(".texarea-input").on("input", function (e) {
                autoResizeTextarea(e.target)
            });
            $('[data-toggle="tooltip"]').tooltip();
            $("#DocumentModal").modal("show");
        });
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
function filesPreview(input) {
    $("#Files-Preview").html("");
    if (input.files) {
        var filesCount = input.files.length;
        for (i = 0; i < filesCount; i++) {
            var ext = input.files[i].name.split('.').pop().toLowerCase();
            if (imageExtensions.includes(ext) || pdfExtensions.includes(ext)) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    var src = event.target.result.includes("image") ? event.target.result : "/images/pdf-icon.png";
                    var html = `<div class="btn-file-edit-container"><img style="height:100px;max-width:100%" src='${src}' class="img-thumbnail mb-3"></div>`;
                    $("#Files-Preview").append(html);
                }
                reader.readAsDataURL(input.files[i]);
                $("#doc-file-label").text(`${filesCount} files Chosen`);
            }
            else
                showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
        }
    }
};
function deleteDocumentFile(curr, divCd, docType, srNo) {
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
            deleteAjax(`/organisation/DeleteDocumentFile?divCd=${divCd}&docTypCd=${docType}&slNo=${srNo}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    $(curr).closest(".btn-file-edit-container").remove();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function editDoc(curr) {
    var srno = $(curr).attr("data-srno");
    $(`#doc-file-${srno}`).click();
}
function filesEditPreview(input, id) {
    var ext = input.target.files[0].name.split('.').pop().toLowerCase();
    if (imageExtensions.includes(ext) || pdfExtensions.includes(ext)) {
        var reader = new FileReader();
        reader.onload = function () {
            var src = reader.result.includes("image") ? reader.result : "/images/pdf-icon.png";
            $(`#file-${id}`).attr("src", src)
        };
        reader.readAsDataURL(input.target.files[0]);
        $(`#btn-file-delete-${id},#btn-upload-file-${id}`).addClass("d-none");
        $(`#btn-upload-${id}`).removeClass("d-none");
        $("#File_SrNo").val(id);
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
};
function saveEditFile() {
    var docTypCd = $("#DocTypCd").val();
    var divCd = $("#DivCd").val();
    var srNo = $("#File_SrNo").val();
    var file = $(`#doc-file-${srNo}`)[0].files[0];
    var formData = new FormData();
    formData.append('docTypCd', docTypCd);
    formData.append('divCd', divCd);
    formData.append('srNo', srNo);
    formData.append('file', file);
    $.ajax({
        url: "/organisation/UpdateDocumentFile",
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
            if (response.success) {
                $(`#btn-file-delete-${srNo},#btn-upload-file-${srNo}`).removeClass("d-none");
                $(`#btn-upload-${srNo}`).addClass("d-none");
                showSuccessToastr(response.message);
            }
        },
    });
}