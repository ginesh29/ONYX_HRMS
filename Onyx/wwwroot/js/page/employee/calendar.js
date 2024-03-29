var Calendar = FullCalendar.Calendar;
var calendarEl = document.getElementById('calendar');
var calendar = new Calendar(calendarEl, {
    headerToolbar: {
        left: 'today',
        center: 'title',
        right: 'prev,next'
    },
    themeSystem: 'bootstrap',
    events: '/Employee/FetchCalendarEvents',
    eventDidMount: function (info) {
        var eventElement = info.el;
        var event = info.event;
        console.log(event.id)
        var color = event.allDay ? "white" : "dark";
        $(eventElement).find(".fc-event-title").append(`<span class='fc-event-icons float-right'><button class='btn btn-icon btn-sm p-0 mr-1 edit-event'><i class='fas fa-pencil-alt text-${color}'></i></button><button class='btn btn-icon btn-sm p-0 delete-event mr-2'><i class='fa fa-trash text-${color}'></i></button></span>`);
        $(eventElement).find(".edit-event").click(function () {
            showCalendarEventModal(event.id);
        });
        $(eventElement).find(".delete-event").click(function () {
            deleteCalendarEvent(event.id);
        });
    },
    dateClick: function (info) {
        showCalendarEventModal('');
        var dt = moment(info.dateStr).format(CommonSetting.DisplayDateFormat);
        setTimeout(function () {
            $("#Date").val(dt);
        }, 500)
    }
});
calendar.render();

function showCalendarEventModal(srNo) {
    var url = `/Employee/GetCalendarEvent?srNo=${srNo}`;
    $('#CalendarEventModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        $("#CalendarEventModal").modal("show");
    });
}
function deleteCalendarEvent(srNo) {
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
            deleteAjax(`/Employee/DeleteCalendarEvent?srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                calendar.refetchEvents();
            });
        }
    });
}
function saveCalendarEvent(btn) {
    var frm = $("#calendar-event-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Employee/SaveCalendarEvent", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#CalendarEventModal").modal("hide");
                calendar.refetchEvents();
            }
            else {
                showErrorToastr(response.message);
                $("#CalendarEventModal").modal("hide");
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