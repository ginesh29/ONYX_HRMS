﻿var Calendar = FullCalendar.Calendar;
var calendarEl = document.getElementById('calendar');
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
        }, 100)
    }
});
calendar.render();

function showCalendarEventModal(cd) {
    var url = `/organisation/GetCalendarEvent?cd=${cd}`;
    $('#CalendarEventModal').load(url, function () {
        parseDynamicForm();
        $("#Dept_Filter,#Designation_Filter,#Branch_Filter,#Location_Filter").on('change', function () {
            var departments = $("#Dept_Filter").val();
            var designations = $("#Designation_Filter").val();
            var branches = $("#Branch_Filter").val();
            var locations = $("#Location_Filter").val();
            bindEmployeeDropdown(departments, designations, branches, locations);
        })
        showHideInvite();
        $("#Invite").change(function () {
            showHideInvite();
        })
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
                if (response.success) {
                    showSuccessToastr(response.message);
                    calendar.refetchEvents();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function saveCalendarEvent(btn) {
    var frm = $("#calendar-event-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/organisation/SaveCalendarEvent", frm.serialize(), function (response) {
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
function bindEmployeeDropdown(departments, designations, branches, locations, callback) {
    $("#Attendees").empty();
    getAjax(`/Employee/FetchEmployeeItems?departments=${departments}&designations=${designations}&branches=${branches}&locations=${locations}`, function (response) {
        var html = '';
        $.each(response, function (i, item) {
            html += `<option value='${item.cd.trim()}'>${item.name}(${item.cd.trim()})</option>`
        })
        $("#Attendees").html(html);
        $('.select-picker').selectpicker('refresh');
        if (callback) callback();
    });
}

function showHideInvite() {
    $("#invite-div").addClass("d-none");
    var invite = $("#Invite").is(":checked");
    if (invite)
        $("#invite-div").removeClass("d-none");
    else {
        var el = $("#invite-div");
        el.find("textarea").val("");
        el.find("input").val("");
        el.find(".select-picker").selectpicker('val', '');
    }
}