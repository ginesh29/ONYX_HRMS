window["datatable"] = $('#LanguageResourceTable').DataTable(
    {
        ajax: "/Settings/FetchLanguageResources",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "en" },
            { data: "ar" },
            { data: "fa" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showLanguageResourceModal('${row.en}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2 btn-delete" onclick="deleteLanguageResource('${row.en}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showLanguageResourceModal(en) {
    var url = `/Settings/GetLangResource?en=${encodeURI(en)}`;
    $('#LanguageResourceModal').load(url, function () {
        parseDynamicForm();
        $("#LanguageResourceModal").modal("show");
    });
}
function deleteLanguageResource(en) {
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
            deleteAjax(`/settings/DeleteLangResource?en=${en}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveLangResource(btn) {
    var frm = $("#lang-resource-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveLangResource", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#LanguageResourceModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}
function uploadFile(event) {
    var ext = event.target.files[0].name.split('.').pop().toLowerCase();
    if (excelExtensions.includes(ext)) {
        var frm = $("#import-frm");
        loadingPage();
        filePostAjax('/Employee/ImportCalendarEvents', frm[0], function (response) {
            if (!response.includes("not supported")) {
                $("#excel-import-data").html(response);
                var tableRowCnt = $("#ExecelData tbody tr").length;
                if (tableRowCnt == 0)
                    $("#excel-import-data").empty();
                calendar.refetchEvents();
            }
            else
                showErrorToastr(response);
            $("#import-file").val("");
            unloadingPage();
        });
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
}