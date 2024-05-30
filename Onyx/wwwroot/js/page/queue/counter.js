var coCd = $("#CoCd").val();
window["datatable"] = $('#CountersDataTable').DataTable(
    {
        ajax: "/Queue/FetchCounters",
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
    var url = `/Queue/GetCounter?cd=${cd}`;
    $('#CounterModal').load(url, function () {
        parseDynamicForm();
        $('#DocList').load(`/Queue/FetchAdFiles?CounterCd=${cd}`);
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
            deleteAjax(`/Queue/DeleteCounter?cd=${cd}`, function (response) {
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
        filePostAjax("/Queue/SaveCounter", frm[0], function (response) {
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
function filesPreview(input) {
    if (input.files) {
        var filesCount = input.files.length;
        for (i = 0; i < filesCount; i++) {
            var ext = input.files[i].name.split('.').pop().toLowerCase();
            if (imageExtensions.includes(ext) || videoExtensions.includes(ext)) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    var src = event.target.result.includes("image") ? event.target.result :
                        event.target.result.includes("video") ? "/images/video-icon.png" : "/images/pdf-icon.png";
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

function deleteAdFile(curr, counterCd, cd) {
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
            deleteAjax(`/Queue/DeleteAdFile?CounterCd=${counterCd}&Cd=${cd}`, function (response) {
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
    if (imageExtensions.includes(ext) || videoExtensions.includes(ext)) {
        var reader = new FileReader();
        reader.onload = function () {
            var src = reader.result.includes("image") ? reader.result :
                reader.result.includes("video") ? "/images/video-icon.png" : "/images/pdf-icon.png";
            $(`#file-${id}`).attr("src", src);
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
    var counterCd = $("#Cd").val();
    var srNo = $("#File_SrNo").val();
    var file = $(`#doc-file-${srNo}`)[0].files[0];
    var formData = new FormData();
    formData.append('CounterCd', counterCd);
    formData.append('Cd', srNo);
    formData.append('file', file);
    $.ajax({
        url: "/Queue/UpdateAdFile",
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