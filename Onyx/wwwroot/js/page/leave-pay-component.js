window["datatable"] = $('#LeavePayComponentsDataTable').DataTable(
    {
        ajax: "/Organisation/FetchLeavePayComponents",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "leave" },
            { data: "payType" },
            { data: "paycode" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLeavePayComponentModal('${row.lvCd.trim()}','${row.payTypCd.trim()}','${row.payCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteLeavePayComponent('${row.lvCd.trim()}','${row.payTypCd.trim()}','${row.payCd.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showLeavePayComponentModal(lvCd, payTypCd, payCd) {
    var url = `/Organisation/GetLeavePayComponent?lvCd=${lvCd}&payTypCd=${payTypCd}&payCd=${payCd}`;
    $('#LeavePayComponentModal').load(url, function () {
        parseDynamicForm();
        $(".select-picker").selectpicker();
        $("#LeavePayComponentModal").modal("show");
    });
}
function deleteLeavePayComponent(lvCd, payTypCd, payCd) {
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
            deleteAjax(`/Organisation/DeleteLeavePayComponent?lvCd=${lvCd}&payTypCd=${payTypCd}&payCd=${payCd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveLeavePayComponent(btn) {
    var frm = $("#leave-pay-component-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Organisation/SaveLeavePayComponent", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#LeavePayComponentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#LeavePayComponentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function onChangePayType(e) {
    $("#PayCd").empty();
    getAjax(`/Organisation/FetchPayCodeItems?payTypCd=${e.value}`, function (response) {
        var html = '<option value="">-- Select --</option>'
        $.each(response, function (i, item) {
            html += `<option value='${item.value}'>${item.text}</option>`
        })
        $("#PayCd").append(html);        
        $('.select-picker').selectpicker('refresh');
    });
}