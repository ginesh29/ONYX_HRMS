setTimeout(function () {
    $("#code-type option:eq(1)").prop("selected", true);
    $('.select-picker').selectpicker('refresh');
}, 500)
function showCodeModal(cd) {
    var typeVal = $("#code-type option:selected").val();
    var url = `/Settings/GetCode?cd=${cd}&type=${typeVal}`;
    $('#CodeModal').html("");
    $('#CodeModal').load(url, function () {
        parseDynamicForm();
        var typeVal = $("#code-type option:selected").val();
        var typeText = $("#code-type option:selected").text();
        $("#Type").val(typeVal);
        $("#type-modal-title").text(typeText);
        $("#CodeModal").modal("show");
    });
}
function deleteCode(cd) {
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
            deleteAjax(`/settings/DeleteCode?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveCode(btn) {
    var frm = $("#code-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/settings/SaveCode", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#CodeModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#CodeModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function setType() {
    $('#CodeModal').html("");
    var typeText = $("#code-type option:selected").text();
    var typeVal = $("#code-type option:selected").val();
    $("#code-type-text").text(typeText);
    $('#CodesDataTable').DataTable().destroy();
    window["datatable"] = $('#CodesDataTable').DataTable(
        {
            ajax: `/Settings/FetchCodesByType?type=${typeVal}`,
            ordering: false,
            columns: [
                {
                    data: function (data, type, row, meta) {
                        return meta.row + meta.settings._iDisplayStart + 1;
                    }
                },
                { data: "cd" },
                { data: "typ" },
                { data: "abbr" },
                { data: "sDes" },
                { data: "des" },
                {
                    data: function (row) {
                        return row.active ? "Yes" : "No";
                    }
                },
                {
                    data: function (row) {
                        return `<button class="btn btn-sm btn-info" onclick="showCodeModal('${row.cd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteCode('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                    }, "width": "80px"
                }
            ],
        }
    );
}
setType();