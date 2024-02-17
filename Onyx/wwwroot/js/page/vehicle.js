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
var queryParams = getQueryStringParams();
window["datatable-2"] = $('#VehicleDocumentsDataTable').DataTable(
    {
        ajax: `/Organisation/FetchVehicleDocuments?vehCd=${queryParams.cd}`,
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "docTypSDes" },
            { data: "docNo" },
            {
                data: function (row) {
                    return row.issueDt && moment(row.issueDt).format('DD/MM/YYYY');
                },
            },
            { data: "issuePlace" },
            {
                data: function (row) {
                    return row.issueDt && moment(row.expDt).format('DD/MM/YYYY');
                },
            },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showVehicleDocumentModal('${row.vehCd.trim()}','${row.docTypCd.trim()}','${row.srNo}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteVehicleDocument('${row.vehCd.trim()}','${row.docTypCd.trim()}','${row.srNo}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showVehicleModal(cd) {
    var url = `/Organisation/GetVehicle?cd=${cd}`;
    window.location.href = url;
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
                if (response.success) {
                    showSuccessToastr(response.message);
                    reloadDatatable();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function saveVehicle(btn) {
    var frm = $("#vehicle-frm");
    if (frm.valid()) {
        loadingButton(btn);
        frm.submit();
    }
}
function showVehicleDocumentModal(vehCd, docTypCd, srNo) {
    var url = `/Organisation/GetVehicleDocument?vehCd=${vehCd}&docType=${docTypCd}&srNo=${srNo}`;
    $('#VehicleDocumentModal').load(url, function () {
        parseDynamicForm();
        $(".select-picker").selectpicker();
        $('.date-input').attr("placeholder", "mm/dd/yyyy");
        $('.date-input').datetimepicker({
            format: 'L'
        });
        $('#VehicleDocList').load(`/Organisation/FetchVehicleDocumentFiles?vehCd=${vehCd}`);
        $("#VehicleDocumentModal").modal("show");
    });
}
function saveVehicleDocument(btn) {
    var frm = $("#vehicle-document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveVehicleDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#VehicleDocumentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#VehicleDocumentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function deleteVehicleDocument(vehCd, docTypCd, srNo) {
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
            deleteAjax(`/Organisation/DeleteVehicleDocument?vehCd=${vehCd}&docType=${docTypCd}&srNo=${srNo}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    reloadDatatable();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function filesPreview(input) {
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
function deleteVehicleDocumentFile(curr, vehCd, docType, srNo) {
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
            deleteAjax(`/organisation/DeleteVehicleDocumentFile?vehCd=${vehCd}&docType=${docType}&slNo=${srNo}`, function (response) {
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
    var vehCd = $("#Cd").val();
    var srNo = $("#File_SrNo").val();
    var file = $(`#doc-file-${srNo}`)[0].files[0];
    var formData = new FormData();
    formData.append('docTypCd', docTypCd);
    formData.append('vehCd', vehCd);
    formData.append('srNo', srNo);
    formData.append('file', file);
    $.ajax({
        url: "/organisation/UpdateVehicleDocumentFile",
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