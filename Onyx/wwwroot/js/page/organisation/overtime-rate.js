﻿window["datatable"] = $('#OvertimeRatesDataTable').DataTable(
    {
        ajax: "/Organisation/FetchOvertimeRates",
        ordering: false,
        columns: [
            { data: "srNo" },
            { data: "type" },
            { data: "hrsApply" },
            { data: "rate" },
            { data: "sdes" },
            { data: "narr" },
            { data: "holTyp" },
            { data: "payCd" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showOvertimeRateModal('${row.srNo}','${row.typCd}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteOvertimeRate('${row.srNo}','${row.typCd}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showOvertimeRateModal(cd, type) {
    var url = `/Organisation/GetOvertimeRate?cd=${cd}&type=${type}`;
    $('#OvertimeRateModal').load(url, function () {
        parseDynamicForm();
        $("#OvertimeRateModal").modal("show");
    });
}
function deleteOvertimeRate(cd, type) {
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
            deleteAjax(`/Organisation/DeleteOvertimeRate?cd=${cd}&type=${type}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveOvertimeRate(btn) {
    var frm = $("#overtime-rate-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveOvertimeRate", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#OvertimeRateModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#OvertimeRateModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}