function showExpiredDocuments() {
    var type = $('input[name=DocExpiredType]:checked').val();
    var days = $("#ExpiredDocNoOfDays").val();
    $('#ExpiredDocDataTable').DataTable().destroy();
    $('#ExpiredDocDataTable').DataTable(
        {
            ajax: `/Home/FetchDocExpired?type=${type}&days=${days}`,
            ordering: false,
            columns: [
                {
                    data: function (data, type, row, meta) {
                        return meta.row + meta.settings._iDisplayStart + 1;
                    }, visible: false
                },
                {
                    data: function (row) {
                        return `${row.name}(${row.cd.trim()})`;
                    },
                },
                { data: "docTypSDes" },
                { data: "docNo" },
                {
                    data: function (row) {
                        return row.expDt && moment(row.expDt).format(CommonSetting.DisplayDateFormat);
                    },
                },
                {
                    data: function (row) {
                        return `<label class="badge badge-secondary">${row.noOfDays} day(s)</lable>`;
                    },
                },
                {
                    data: function (row) {
                        return type == "EMP" ? `<button type="button" class="btn btn-sm btn-info" onclick="showEmpDocumentModal('${row.cd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                                </button>` : type == "COM" ? `<button class="btn btn-sm btn-info" onclick="showComDocumentModal('${row.docTypCd.trim()}','${row.divCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>` : `<button type="button" class="btn btn-sm btn-info" onclick="showVehDocumentModal('${row.vehCd.trim()}','${row.docTypCd.trim()}','${row.srNo}')">
                                <i class="fas fa-pen"></i>
                                </button>`
                    }, "width": "40px"
                }
            ],
        }
    );
}
$('#type_EMP').prop('checked', true);
showExpiredDocuments();

function showEmpLeave(type) {
    var days = $(`#EmpLeaveNoOfDays-${type}`).val();
    $(`#EmpLeaveDataTable-${type}`).DataTable().destroy();
    setTimeout(function () {
        $(`#EmpLeaveDataTable-${type}`).DataTable(
            {
                ajax: `/Home/FetchEmpLeaves?type=${type}&days=${days}`,
                ordering: false,
                columns: [
                    {
                        data: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }, visible: false
                    },
                    {
                        data: function (row) {
                            return `${row.employeeName}(${row.employeeCode.trim()})`;
                        },
                    },
                    {
                        data: function (row) {
                            var formattedFromDate = moment(row.lvFrom).format(CommonSetting.DisplayDateFormat);
                            var formattedToDate = moment(row.lvTo).format(CommonSetting.DisplayDateFormat);
                            var lvDays = getDaysBetweenDateRange(moment(row.lvFrom), moment(row.lvTo));
                            return `${formattedFromDate} - ${formattedToDate}<br/>(${lvDays} days)`;
                        }, width: '200px', visible: type == 5
                    },
                    {
                        data: function (row) {
                            row.noOfDays = row.noOfDays ? row.noOfDays : 1;
                            return `<label class="badge badge-info">${row.noOfDays} day(s)</lable>`;
                        },
                    },
                ],
            }
        );
    }, 0);
}
showEmpLeave(3);
showEmpLeave(4);
showEmpLeave(5);
function showBarChart(init) {
    if ($('#myChart').length) {
        if (!init)
            window["myChart"].destroy();
        var type = $("#Chart-Type").val();
        var typeText = $("#Chart-Type option:selected").text();
        getAjax(`/Home/EmployeeWiseForChart?type=${type}`, function (response) {
            var xValues = response.xAxis;
            var yValues = response.yAxis;
            var ctx = $('#myChart');

            window["myChart"] = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: xValues,
                    datasets: [{
                        backgroundColor: "orange",
                        data: yValues
                    }]
                },
                options: {
                    legend: { display: false },
                    title: {
                        display: true,
                        text: typeText
                    }
                }
            });
        })
    }
}
showBarChart(true);

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