var dateFormat = $("#LocalDateFormat").val();
var startDate = moment().subtract(1, "day").format(dateFormat);
var endDate = moment().add(1, "day").format(dateFormat);
var dateRangeOptions = dateRangePickerDefaultOptions;
dateRangeOptions.startDate = startDate;
dateRangeOptions.endDate = endDate;
$('#DateRange').val(`${startDate} - ${endDate}`);
$('#DateRange').daterangepicker(dateRangeOptions)
    .on('apply.daterangepicker', function () {
        setTimeout(function () {
            loadBirthdayEvents();
        }, 500)
    });
let grid = GridStack.init();
grid.on('added removed change', function (e, items) {
    var data = grid.save();
    console.log(data);
    //$.post('adviser/dashboard/updatedashboardconfig', { config: data }, function () {
    //});
});
var chartsJsonData = [];
var empOrUser = $("#EmpOrUser").val();
if (empOrUser == "E")
    chartsJsonData = [
        {
            "x": 0, "y": 0, "w": 6, "h": 4, "id": "emp_basic_details", "title": "Employee Basic Details", "functionName": "bindEmpBasicDetail", "actionUrl": "EmpBasicDetail", header: ``
        },
        {
            "x": 6, "y": 0, "w": 6, "h": 4, "id": "my_documents", "title": "My Documents", "functionName": "bindMyDocuments",
            "actionUrl": "MyDocuments", header: ``
        },
        {
            "x": 0, "y": 4, "w": 6, "h": 4, "id": "my_leaves", "title": "My Leave", "functionName": "bindMyLeaves", "actionUrl": "MyLeaves", header: ``
        },
        {
            "x": 6, "y": 4, "w": 6, "h": 4, "id": "my_loans", "title": "My Loans", "functionName": "bindMyLoans", "actionUrl": "MyLoans", header: ``
        },
        {
            "x": 0, "y": 8, "w": 6, "h": 4, "id": "salary_chart", "title": "Employee Salary Chart", "functionName": "bindEmpSalaryChart", "actionUrl": "EmpSalaryChart", header: ``
        }
    ];
var userLinkedTo = $("#UserLinkedTo").val();
if (userLinkedTo != "Emp") {
    var analysisHeader = `<label class="mb-0">Type</label>
                        <div class="col-md-3">
                            <select id="Chart-Type" class="form-control dashboard-select-picker" onchange="bindWidget('emp_analysis_chart','EmpAnalysisChart')">
                                <option value="Dept">Department</option>
                                <option value="Branch">Branch</option>
                                <option value="Nationality">Nationality</option>
                                <option value="Location">Location</option>
                                <option value="Status">Status</option>
                            </select>
                        </div>`;
    let userChartsJsonData = [
        { x: 6, y: 8, w: 6, h: 4, id: 'user-salary_chart', title: "User Salary Chart", functionName: "bindUserSalaryChart", actionUrl: "UserSalaryChart", header: `` },
        {
            x: 0, y: 12, w: 6, h: 4, id: 'emp_analysis_chart', title: "Employee Analysis", functionName: "bindEmpAnalysis", actionUrl: "EmpAnalysisChart", header: analysisHeader
        },
        { x: 6, y: 12, w: 6, h: 4, id: 'emp_statistics_chart', title: "Employee Statistics", functionName: "bindEmpStatistics", actionUrl: "EmpStatisticsChart", header: `` },
        //{ x: 6, y: 0, w: 6, h: 4, id: 'my_documents', title: "My Documents", functionName: "bindMyDocuments", actionUrl: "MyDocuments" },
        //{ x: 6, y: 4, w: 6, h: 4, id: 'my_leaves', title: "My Leave", functionName: "bindMyLeaves", actionUrl: "MyLeaves" },
        //{ x: 0, y: 5, w: 6, h: 4, id: 'my_loans', title: "My Loans", functionName: "bindMyLoans", actionUrl: "MyLoans" },
    ];
    var chartsJsonData = $.merge(chartsJsonData, userChartsJsonData);
}
chartsJsonData.forEach((n, i) =>
    n.content = `<div class="card dashboard-card" id="">
                    <div class="card-header">
                        <div class="btn-toolbar d-flex align-items-center">
                            <h5 class="card-label text-primary mr-auto">
                                 ${n.title}
                            </h5>
                            ${n.header}
                            <div class="card-toolbar d-flex">
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Reload Card" data-chart-container="${n.id}" data-variable="${n.id}_data" data-modal-title="${n.title}"  onclick="bindWidget('${n.id}','${n.actionUrl}')">
                                   <i class="fas fa-sync-alt icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Preview" data-chart-container="${n.id}_preview" data-modal-title="${n.title}" onclick="showChartPreview(this)" data-action-url="${n.actionUrl}">
                                   <i class="fas fa-expand icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-danger ml-2" data-toggle="tooltip" data-original-title="Remove Card" data-chart-container="${n.id}" onClick="removeWidget    (this.parentElement.parentElement.parentElement.parentElement.parentElement,this)">
                                   <i class="fas fa-times icon-md text-danger"></i>
                               </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="overlay-wrapper">
                            <div class="overlay d-none" id="${n.id}-loader"><i class="fas fa-3x fa-sync-alt fa-spin"></i><div class="text-bold pt-2">Loading...</div></div>
                        <div id="${n.id}"></div>
                    </div>                            
                   </div>
                </div>`);
function bindWidgetDropdown() {
    $.each(chartsJsonData, function (index, item) {
        var d = chartsJsonData.filter(m => m.id == item.id && m.active).length;
        var disabled = d ? "disabled" : "";
        $("#drp-widgets").append(`<a id='${item.id}_drp_item' class="dropdown-item ${disabled}" href="javascript:" onclick="addWidget('${item.id}')">${item.title}</a>`);
    });
}
function bindDashboard() {
    //$.get('adviser/dashboard/FetchDashboardConfig', function (response) {
    //if (response)
    //chartsJsonData.forEach((n, i) => {
    //    var res = response.filter(m => m.id == n.id)[0];
    //    if (res) {
    //        n.active = true;
    //        n.x = res.x;
    //        n.y = res.y;
    //        n.w = res.w;
    //        n.h = res.h;
    //    }
    //});
    bindWidgetDropdown();
    var activeChartsJsonData = chartsJsonData;//.filter(m => m.active);
    grid.load(activeChartsJsonData, true);

    $.each(activeChartsJsonData, function (index, item) {
        if (activeChartsJsonData.filter(m => m.id == item.id).length) {
            bindWidget(`${item.id}`, `${item.actionUrl}`)
        }
    });
    //});
}
function addWidget(id) {
    $(`#${id}_drp_item`).addClass("disabled");
    var widgetData = chartsJsonData.filter(m => m.id == id && !m.active)[0];
    var wigetHtml = `<div class="grid-stack-item" gs-id="${widgetData.id}" gs-x="${widgetData.x}" gs-y="${widgetData.y}" gs-w="${widgetData.w}" gs-h="${widgetData.h}">
                        <div class="grid-stack-item-content">${widgetData.content}</div>
                     </div>`;
    grid.addWidget(wigetHtml, 0, 0, widgetData.w, widgetData.h);
    bindWidget(`${widgetData.id}`, `${widgetData.actionUrl}`)
}
function removeWidget(el, sel) {
    var id = $(sel).attr("data-chart-container");
    $(`#${id}_drp_item`).removeClass("disabled");
    grid.removeWidget(el, true);
    el.remove();
    $('[data-toggle="tooltip"], .tooltip').tooltip("hide");
}
function showChartPreview(el) {
    var container = $(el).attr("data-chart-container");
    var actionUrl = $(el).attr("data-action-url");
    var title = $(el).attr("data-modal-title");
    $("#ChartPreviewModal .modal-body").html("");
    $("#ChartPreviewModal .modal-body").append(`<div id='${container}'></div>`);
    bindWidget(container, actionUrl)
    $("#ChartPreviewModal .chart-title").text(title);
    $("#ChartPreviewModal").modal({ backdrop: 'static' });
}
bindDashboard();

function bindWidget(el, actionUrl) {
    $(`#${el}-loader`).removeClass("d-none");
    $(`#${el}`).empty();
    var url = `/Home/${actionUrl}`;
    var query = "";
    if (el.includes("chart"))
        query += `container=${el}`
    if (el.includes("analysis")) {
        var type = $("#Chart-Type").val();
        var typeText = $("#Chart-Type option:selected").text();
        query += `&type=${type}&typeText=${typeText}`
    }
    url = `${url}?${query}`;
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