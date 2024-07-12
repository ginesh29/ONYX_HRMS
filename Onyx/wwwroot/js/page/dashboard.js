let grid = GridStack.init({
    cellHeight: 'auto',
    verticalMargin: 0
});
var width = $(window).width();
if (width <= 768) {
    grid.disable();
}
grid.on('added removed change', function (e, items) {
    if (e.type == "removed")
        deleteAjax(`/home/deletedashboardconfig?widegetId=${items[0].id}`);
    else {
        var data = grid.save();
        postAjax('/home/updatedashboardconfig', { widgets: data });
    }
});

var defaultChartsJsonData = [];
var chartsJsonData = [];
$.ajax({
    url: "/Home/FetchWidgetMaster",
    type: 'get',
    async: false,
    success: function (response) {
        defaultChartsJsonData = response.data.filter(m => m.active);
    }
});
var empOrUser = $("#EmpOrUser").val();
var userLinkedTo = $("#UserLinkedTo").val();
if (empOrUser == "E")
    chartsJsonData = defaultChartsJsonData.filter(m => m.type == "E");

if (userLinkedTo != "Emp") {
    var analysisHeader = `<div class="d-flex justify-content-between"><label class="mb-0">Type</label>
                            <div class="">
                                <select id="Chart-Type" class="form-control dashboard-select-picker" onchange="bindWidget   ('emp_analysis_chart','EmpAnalysisChart')">
                                    <option value="Dept">Department</option>
                                    <option value="Branch">Branch</option>
                                    <option value="Nationality">Nationality</option>
                                    <option value="Location">Location</option>
                                    <option value="Status">Status</option>
                                </select>
                        </div></div>`;
    var days = ["30", "60", "90", "120", "150"];
    var drpDaysHtml = "";
    $.each(days, function (index, item) {
        drpDaysHtml += `<option value="${item}">${item} days</option>`;
    });
    var radioTypeHtml = `<div class="mr-auto">
        <label class="radio-inline mb-0">
            <label class="custom-control custom-radio">
                <input type="radio" name="DocExpiredType" class="custom-control-input custom-control-input-primary custom-control-input-outline" id="type_EMP" value="EMP" onchange="bindWidget('doc_expiry_waiting','DocExpired')" checked>
                <label for="type_EMP" class="custom-control-label font-weight-normal">Employee</label>
            </label>
        </label>
        <label class="radio-inline mb-0">
            <label class="custom-control custom-radio">
                <input type="radio" name="DocExpiredType" class="custom-control-input custom-control-input-primary custom-control-input-outline" id="type_COM" value="COM" onchange="bindWidget('doc_expiry_waiting','DocExpired')">
                <label for="type_COM" class="custom-control-label font-weight-normal">Company</label>
            </label>
        </label>
        <label class="radio-inline mb-0">
            <label class="custom-control custom-radio">
                <input type="radio" name="DocExpiredType" class="custom-control-input custom-control-input-primary custom-control-input-outline" id="type_VEH" value="VEH" onchange="bindWidget('doc_expiry_waiting','DocExpired')">
                <label for="type_VEH" class="custom-control-label font-weight-normal">Vehicle</label>
            </label>
        </label>

</div>`;
    var leavesHeader = ``;
    var userChartsJsonData = defaultChartsJsonData.filter(m => m.type == "U");
    userChartsJsonData.forEach((n, i) => {
        n.header = n.header = n.des.includes("analysis") ? analysisHeader :
            n.des.includes("_list") ? `<div class="d-flex justify-content-between align-items-center"><label class="mb-0">No. Of Days</label>
                                       <div>
                                          <select id="EmpLeaveNoOfDays" class="form-control dashboard-select-picker" onchange="bindWidget                         ('${n.des}','${n.url}')">
                                              ${drpDaysHtml}
                                          </select>
                                       </div></div>`:
                n.des.includes("birthday") ? `<div class="d-flex justify-content-between align-items-center"><label class="mb-0">Date Range</label>
                                           <div class="">
                                               <input id="DateRange" type="text" class="form-control">
                                           </div></div>`:
                    n.des.includes("waiting") ? `
                        ${radioTypeHtml}
                        <div class="d-flex justify-content-between align-items-center">
                        <label class="mb-0">No of Days Before</label>
                        <div class="">
                            <select id="ExpiredDocNoOfDays" class="form-control dashboard-select-picker" onchange="bindWidget('${n.des}','${n.url}')">
                            ${drpDaysHtml}
                            </select>
                        </div></div>` : ""
    })
    chartsJsonData = $.merge(chartsJsonData, userChartsJsonData);
    function showEmployees(curr, type) {
        var typeText = $(curr).text();
        loadingPage();
        $('#EmployeesModal').load(`/Home/FetchEmployees?Type=${type}`, function () {
            $('#EmployeesModal #EmployeesDataTable').DataTable(dataTableDefaultOptions);
            $("#type-header").text(typeText);
            unloadingPage();
            $("#EmployeesModal").modal("show");
        });
    }
}

chartsJsonData.forEach((n, i) =>
    n.content = `<div class="card dashboard-card">
                    <div class="card-header" id="${n.des}-header">
                        <div class="d-flex justify-content-between">
                            <h5 class="card-label text-primary">
                                 ${n.title}
                            </h5>
                            <div class="card-toolbar d-flex">
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Reload Card" data-chart-container="${n.des}" data-variable="${n.des}_data" data-modal-title="${n.title}" onclick="bindWidget('${n.des}','${n.url}')">
                                   <i class="fas fa-sync-alt icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Preview" data-chart-container="${n.des}_preview" data-modal-title="${n.title}" onclick="showChartPreview(this)" data-action-url="${n.url}">
                                   <i class="fas fa-expand icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-danger ml-2" data-toggle="tooltip" data-original-title="Remove Card" data-chart-container="${n.id}" onClick="removeWidget('${n.id}')">
                                   <i class="fas fa-times icon-md text-danger"></i>
                               </button>
                            </div>                            
                        </div>
                            ${n.header ? n.header : ""}
                    </div>
                    <div class="card-body">
                        <div class="overlay-wrapper">
                            <div class="overlay d-none" id="${n.des}-loader"><i class="fas fa-3x fa-sync-alt fa-spin"></i><div class="text-bold pt-2">Loading...</div></div>
                        <div id="${n.des}"></div>
                    </div>                            
                   </div>
                </div>`);
function bindWidgetDropdown() {
    $.each(chartsJsonData, function (index, item) {
        var d = chartsJsonData.filter(m => m.des == item.des && m.enabled).length;
        var disabled = d ? "disabled" : "";
        $("#drp-widgets").append(`<a id='${item.id}_drp_item' class="dropdown-item ${disabled}" href="javascript:" onclick="addWidget('${item.des}')">${item.title}</a>`);
    });
}
function bindDashboard() {
    $.get('/home/FetchDashboardConfig', function (response) {
        if (response.data)
            chartsJsonData.forEach((n, i) => {
                var res = response.data.filter(m => m.des == n.des)[0];
                if (res) {
                    n.enabled = true;
                    n.x = res.x;
                    n.y = res.y;
                    n.w = res.w;
                    n.h = res.h;
                }
            });
        bindWidgetDropdown();
        var activeChartsJsonData = chartsJsonData.filter(m => m.enabled);
        grid.load(activeChartsJsonData, true);

        $.each(activeChartsJsonData, function (index, item) {
            if (activeChartsJsonData.filter(m => m.des == item.des).length) {
                bindWidget(`${item.des}`, `${item.url}`)
                if (item.des.includes("birthday_events")) {
                    var dateFormat = $("#LocalDateFormat").val();
                    var startDate = moment().format(dateFormat);
                    var endDate = moment().add(1, "day").format(dateFormat);
                    var dateRangeOptions = dateRangePickerDefaultOptions;
                    dateRangeOptions.startDate = startDate;
                    dateRangeOptions.endDate = endDate;
                    $('#DateRange').val(`${startDate} - ${endDate}`);
                    $('#DateRange').daterangepicker(dateRangeOptions)
                        .on('apply.daterangepicker', function () {
                            setTimeout(function () {
                                bindWidget(item.des, item.url)
                            }, 500)
                        });
                }
            }
        });
    });
}
function addWidget(des) {
    var widgetData = defaultChartsJsonData.filter(m => m.des == des && !m.enabled)[0];
    $(`#${widgetData.id}_drp_item`).addClass("disabled");
    var widgetLength = $(".grid-stack-item").length;
    var x = widgetLength % 2 == 0 ? 0 : 6;
    var maxY = _.maxBy(chartsJsonData, 'y') && _.maxBy(chartsJsonData, 'y').y;
    var wigetHtml = `<div class="grid-stack-item" gs-id="${widgetData.id}" gs-x="${x}" gs-y="${maxY}" gs-w="6" gs-h="4" gs-no-move="true">
                        <div class="grid-stack-item-content">${widgetData.content}</div>
                     </div>`;
    grid.addWidget(wigetHtml, 0, 0, widgetData.w, widgetData.h);
    bindWidget(`${widgetData.des}`, `${widgetData.url}`)
}
function removeWidget(id) {
    $(`#${id}_drp_item`).removeClass("disabled");
    var el = $(`.grid-stack-item[gs-id='${id}']`)[0];
    grid.removeWidget(el, true);
    $('[data-toggle="tooltip"], .tooltip').tooltip("hide");
}
function showChartPreview(el) {
    var container = $(el).attr("data-chart-container");
    var url = $(el).attr("data-action-url");
    var title = $(el).attr("data-modal-title");
    $("#ChartPreviewModal .modal-body").html("");
    $("#ChartPreviewModal .modal-body").append(`<div id='${container}'></div>`);
    bindWidget(container, url)
    $("#ChartPreviewModal .chart-title").text(title);
    $("#ChartPreviewModal").modal({ backdrop: 'static' });
}
bindDashboard();

function bindWidget(el, url) {
    $(`#${el}-loader`).removeClass("d-none");
    $(`#${el}`).empty();
    var url = `/Home/${url}`;
    var query = "";
    if (el.includes("chart"))
        query += `?container=${el}`
    if (el.includes("analysis")) {
        var type = $("#Chart-Type").val();
        var typeText = $("#Chart-Type option:selected").text();
        query += `&type=${type}&typeText=${typeText}`
    }
    if (el.includes("_list")) {
        var el2 = el.replace("_preview", "");
        var days = $(`#${el2}-header #EmpLeaveNoOfDays`).val();
        query += `&container=${el}&days=${days}`;
    }
    if (el.includes("birthday")) {
        var dateRange = $("#DateRange").val();
        query += `?DateRange=${encodeURI(dateRange)}`
    }
    if (el.includes("waiting")) {
        var days = $(`#ExpiredDocNoOfDays`).val();
        var type = $('input[name=DocExpiredType]:checked').val();
        query += `?type=${type}&container=${el}&days=${days}`;
    }
    url = `${url}${query}`;
    $(`#${el}`).load(url, function () {
        setTimeout(function () {
            $(`#${el}-loader`).addClass("d-none");
        }, 500)
    });
}
function showDocumentModal(empCd, docTypeCd, srNo) {
    var url = `/Employee/GetDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentModal').load(url, function () {
        $("#preview-hidden-div").remove();
        $('#DocList').load(`/Employee/FetchDocumentFiles?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}`, function () {
            $(".modal-title").text("Preview Document Files");
            $(".btn-file-edit").remove();
            $(".btn-file-delete").remove();
            $("#btn-submit").remove();
            $("#DocumentModal").modal("show");
        });
    });
}
function loadPayslip() {
    var frm = $("#payslip-filter-frm");
    var url = `/Reports/FetchPaySlips?${frm.serialize()}`;
    $('#PaySlip').load(url, function () {
        $("#btn-pdf").addClass("d-none");
        if ($(".invoice").length > 0)
            $("#btn-pdf").removeClass("d-none");
    });
}
function filterShowReport(report) {
    if (report) {
        var frm = $("#payslip-filter-frm");
        var url = `/Reports/PaySlipsReport?${decodeURIComponent(frm.serialize())}`;
        window.open(url);
    }
}