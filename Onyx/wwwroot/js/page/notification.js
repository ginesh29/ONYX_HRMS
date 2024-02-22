window["datatable"] = $('#NotificationsDataTable').DataTable(
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
                    return `<button class="btn btn-sm btn-info" onclick="showNotificationModal('${row.srNo}','${row.docTyp.trim()}','${row.processId}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteNotification('${row.srNo}','${row.processId}')">
                                <i class="fa fa-trash"></i>
                            </button>`
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
            bindEmployeeDropdown(departments, designations, branches, locations);
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
function bindEmployeeDropdown(departments, designations, branches, locations, callback) {
    $("#Attendees").empty();
    getAjax(`/Employee/FetchEmployeeItems?departments=${departments}&designations=${designations}&branches=${branches}&locations=${locations}`, function (response) {
        var html = ''
        $.each(response, function (i, item) {
            html += `<option value='${item.cd.trim()}' data-subtext='${item.department}_${item.designation}_${item.branch}_${item.location}'>${item.name}(${item.cd.trim()})</option>`
        })
        $("#Attendees").append(html);
        $('.select-picker').selectpicker('refresh');
        callback();
    });
}