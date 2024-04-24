window["datatable"] = $('#EmployeeLeavesApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveApprovalData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "empCd", visible: false },
            { data: "div", visible: false },
            { data: "deptCd", visible: false },
            {
                data: function (row) {
                    return `${row.emp}(${row.empCd.trim()})`
                }
            },
            {
                data: function (row) {
                    var formattedFromDate = moment(row.lvFrom).format(CommonSetting.DisplayDateFormat);
                    var formattedToDate = moment(row.lvTo).format(CommonSetting.DisplayDateFormat);
                    var lvDays = getDaysBetweenDateRange(moment(row.lvFrom), moment(row.lvTo));
                    return `${formattedFromDate} - ${formattedToDate}<br/>(${lvDays} days)`;
                }, width: '200px'
            },
            { data: "lvTyp" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "desg" },
            { data: "branch" },
            { data: "reason" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.lvFrom}','${row.lvTo}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button class="btn btn-sm btn-info ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "120px"
            }
        ],
    }
);
var isAdmin = $("#IsAdmin").val() == 1;
if (isAdmin)
    window["datatable"].column(8).visible(false);
bindEmployeeDropdown();