﻿window["datatable"] = $('#NotificationsDataTable').DataTable(
    {
        ajax: "/Organisation/FetchNotifications",
        ordering: false,
        columns: [
            { data: "srNo" },
            { data: "notificationType" },
            { data: "docTypDes" },
            {
                data: function (row) {
                    return `${row.beforeOrAfter} ${row.noOfDays} Days`
                }
            },
            { data: "messageBody" },
            {
                data: function (row) {
                    return `<div class="d-flex"><button class="btn btn-sm btn-info" onclick="showNotificationModal('${row.srNo}','${row.docTyp.trim()}','${row.processId}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                              <button class="btn btn-sm btn-danger ml-2" onclick="deleteNotification('${row.srNo}','${row.processId}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button></div>`
                }, "width": "80px"
            }
        ],
    }
);
function showNotificationModal(cd, docType, processId) {
    var url = `/Organisation/GetNotification?cd=${cd}&docType=${docType}&processId=${processId}`;
    $('#NotificationModal').load(url, function () {
        parseDynamicForm();
        $("#Dept_Filter,#Designation_Filter,#Branch_Filter,#Location_Filter").on('change', function () {
            var departments = $("#Dept_Filter").val();
            var designations = $("#Designation_Filter").val();
            var branches = $("#Branch_Filter").val();
            var locations = $("#Location_Filter").val();
            bindEmployeeMultipleDropdown(departments, designations, branches, locations);
        })
        $("#NotificationModal").modal("show");
    });
}
function deleteNotification(cd, processId) {
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
            deleteAjax(`/Organisation/DeleteNotification?cd=${cd}&processId=${processId}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveNotification(btn) {
    var frm = $("#overtime-rate-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveNotification", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#NotificationModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#NotificationModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}