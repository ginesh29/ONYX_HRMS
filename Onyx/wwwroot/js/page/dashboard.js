﻿let grid = GridStack.init();
grid.on('added removed change', function (e, items) {
    var data = grid.save();
    //console.log(data);
    //$.post('adviser/dashboard/updatedashboardconfig', { config: data }, function () {
    //});
});
var defaultChartsJsonData = [];
$.ajax({
    url: "/Home/FetchWidgetMaster",
    type: 'get',
    async: false,
    success: function (response) {
        defaultChartsJsonData = response.data.filter(m => m.active);
    }
});
var chartsJsonData = defaultChartsJsonData;
var empOrUser = $("#EmpOrUser").val();
if (empOrUser == "E")
    chartsJsonData = chartsJsonData.filter(m => m.type == "E");
var userLinkedTo = $("#UserLinkedTo").val();
if (userLinkedTo != "Emp") {
    var analysisHeader = `<label class="mb-0">Type</label>
                            <div class="col-md-3">
                                <select id="Chart-Type" class="form-control dashboard-select-picker" onchange="bindWidget   ('emp_analysis_chart','EmpAnalysisChart')">
                                    <option value="Dept">Department</option>
                                    <option value="Branch">Branch</option>
                                    <option value="Nationality">Nationality</option>
                                    <option value="Location">Location</option>
                                    <option value="Status">Status</option>
                                </select>
                        </div>`;
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
            n.des.includes("_list") ? `<label class="mb-0">No. Of Days</label>
                                       <div class="col-md-3">
                                          <select id="EmpLeaveNoOfDays" class="form-control dashboard-select-picker" onchange="bindWidget                         ('${n.des}','${n.url}')">
                                              ${drpDaysHtml}
                                          </select>
                                       </div>`:
                n.des.includes("birthday") ? `<label class="mb-0">Date Range</label>
                                           <div class="col-md-4">
                                               <input id="DateRange" type="text" class="form-control">
                                           </div>` : "";
        n.subheader = n.subheader = n.des.includes("waiting") ? `<div class="d-flex align-items-center">
                        ${radioTypeHtml}
                        <label class="mb-0">No of Days Before</label>
                        <div class="col-md-3">
                            <select id="ExpiredDocNoOfDays" class="form-control dashboard-select-picker" onchange="bindWidget('${n.des}','${n.url}')">
                            ${drpDaysHtml}
                            </select>
                        </div>
                    </div>` : ""
    })
    chartsJsonData = $.merge(chartsJsonData, userChartsJsonData);
}
chartsJsonData.forEach((n, i) =>
    n.content = `<div class="card dashboard-card">
                    <div class="card-header" id="${n.des}-header">
                        <div class="d-flex align-items-center">
                            <h5 class="card-label text-primary mr-auto">
                                 ${n.title}
                            </h5>
                            ${n.header ? n.header : ""}
                            <div class="card-toolbar d-flex">
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Reload Card" data-chart-container="${n.des}" data-variable="${n.des}_data" data-modal-title="${n.title}" onclick="bindWidget('${n.des}','${n.url}')">
                                   <i class="fas fa-sync-alt icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-primary ml-2" data-toggle="tooltip" data-original-title="Preview" data-chart-container="${n.des}_preview" data-modal-title="${n.title}" onclick="showChartPreview(this)" data-action-url="${n.url}">
                                   <i class="fas fa-expand icon-md text-primary"></i>
                               </button>
                               <button class="btn btn-icon btn-sm btn-hover-light-danger ml-2" data-toggle="tooltip" data-original-title="Remove Card" data-chart-container="${n.des}" onClick="removeWidget    (this.parentElement.parentElement.parentElement.parentElement.parentElement,this)">
                                   <i class="fas fa-times icon-md text-danger"></i>
                               </button>
                            </div>                            
                        </div>
                        ${n.subheader ? n.subheader : ""}
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
        $("#drp-widgets").append(`<a id='${item.des}_drp_item' class="dropdown-item ${disabled}" href="javascript:" onclick="addWidget('${item.des}')">${item.title}</a>`);
    });
}
function bindDashboard() {
    $.get('/home/FetchDashboardConfig', function (response) {
        if (response.data)
            console.log(response.data)
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
                    var startDate = moment().subtract(1, "day").format(dateFormat);
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
function addWidget(id) {
    $(`#${id}_drp_item`).addClass("disabled");
    var widgetData = chartsJsonData.filter(m => m.des == id && !m.enabled)[0];
    var wigetHtml = `<div class="grid-stack-item" gs-id="${widgetData.des}" gs-x="${widgetData.x}" gs-y="${widgetData.y}" gs-w="${widgetData.w}" gs-h="${widgetData.h}">
                        <div class="grid-stack-item-content">${widgetData.content}</div>
                     </div>`;
    grid.addWidget(wigetHtml, 0, 0, widgetData.w, widgetData.h);
    bindWidget(`${widgetData.des}`, `${widgetData.url}`)
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