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
                        return `<label class="badge badge-info">${row.noOfDays} day(s)</lable>`;
                    },
                },
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
showBarChart(true);

function showLineChart() {
    const xValues = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    new Chart("myLineChart", {
        type: "line",
        data: {
            labels: xValues,
            datasets: [{
                data: [860, 1140, 1060, 1060, 1070, 1110, 1330, 2210, 7830, 2478, 1070, 1110],
                borderColor: "red",
                fill: false
            }, {
                data: [1600, 1700, 1700, 1900, 2000, 2700, 4000, 5000, 6000, 7000, 5070, 7110],
                borderColor: "green",
                fill: false
            }, {
                data: [300, 700, 2000, 5000, 6000, 4000, 2000, 1000, 200, 100, 2000, 1000],
                borderColor: "blue",
                fill: false
            }]
        },
        options: {
            legend: { display: false }
        }
    });
}
showLineChart();