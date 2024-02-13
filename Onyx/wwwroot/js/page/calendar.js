var Calendar = FullCalendar.Calendar;
var calendarEl = document.getElementById('calendar');
var date = new Date()
var d = date.getDate(),
    m = date.getMonth(),
    y = date.getFullYear()
var calendar = new Calendar(calendarEl, {
    headerToolbar: {
        left: 'today',
        center: 'title',
        right: 'prev,next'
    },
    themeSystem: 'bootstrap',
    events: '/Organisation/FetchCalendarEvents',
    eventDidMount: function (info) {
        var eventElement = info.el;
        var event = info.event;
        var extendedProps = event.extendedProps;
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
        var dt = moment(info.dateStr).format("MM/DD/YYYY");
        setTimeout(function () {
            $("#Date").val(dt);
        }, 100)
    }
});
calendar.render();

function showCalendarEventModal(cd) {
    var url = `/organisation/GetCalendarEvent?cd=${cd}`;
    $('#CalendarEventModal').load(url, function () {
        parseDynamicForm();
        $('.date-input').attr("placeholder", "mm/dd/yyyy");
        $('.date-input').datetimepicker({
            format: 'L'
        });
        $(".select-picker").selectpicker();
        $("#Date").prop("readonly", true);
        $("#CalendarEventModal").modal("show");
    });
}
function deleteCalendarEvent(cd) {
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
            deleteAjax(`/organisation/DeleteCalendarEvent?cd=${cd}`, function (response) {
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
        filePostAjax("/organisation/SaveCalendarEvent", frm[0], function (response) {
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