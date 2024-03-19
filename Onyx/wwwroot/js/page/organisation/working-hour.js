window["datatable"] = $('#WorkingHoursDataTable').DataTable(
    {
        ajax: "/Organisation/FetchWorkingHours",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "code" },
            { data: "narr" },
            {
                data: function (row) {
                    var formattedFromDate = moment(row.fromDt).format(CommonSetting.DisplayDateFormat);
                    var formattedToDate = moment(row.toDt).format(CommonSetting.DisplayDateFormat);
                    return `${formattedFromDate} - ${formattedToDate}`;
                }
            },
            { data: "dutyHrs" },
            { data: "religion" },
            { data: "holTypDesc" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showWorkingHourModal('${row.code}')">
                                <i class="fas fa-pen"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="deleteWorkingHour('${row.code}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showWorkingHourModal(cd) {
    var url = `/Organisation/GetWorkingHour?cd=${cd}`;
    $('#WorkingHourModal').load(url, function () {
        parseDynamicForm();
        $('#DateRange').daterangepicker(dateRangePickerDefaultOptions);        
        $('#DateRange').on('apply.daterangepicker', function (ev, picker) {
            var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
            var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
            $(this).val(`${startDate} - ${endDate}`);
            $("#FromDt").val(startDate);
            $("#ToDt").val(endDate);
        });
        $("#WorkingHourModal").modal("show");
    });
}
function deleteWorkingHour(cd) {
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
            deleteAjax(`/Organisation/DeleteWorkingHour?cd=${cd}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveWorkingHour(btn) {
    var frm = $("#workig-hour-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveWorkingHour", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#WorkingHourModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#WorkingHourModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}