window["datatable"] = $('#EmployeeLeavesSalaryApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLeaveSalaryApprovalData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "transNo" },
            {
                data: function (row) {
                    return `${row.emp}(${row.empCd.trim()})`
                }
            },
            {
                data: function (row) {
                    return !row.lvSalary ? row.lvSalary : formatDecimal(row.lvSalary)
                },
            },
            {
                data: function (row) {
                    return !row.lvTicket ? row.lvTicket : formatDecimal(row.lvTicket)
                },
            },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-warning" onclick="showLeaveDetailModal('${row.empCd.trim()}','${row.transDt}')">
                                <i class="fas fa-search"></i>
                            </button>
                            <button class="btn btn-sm btn-info ml-2" onclick="showLeaveSalaryApprovalModal('${row.transNo.trim()}')" ${editEnable}>
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveSalaryApprovalModal('${row.transNo.trim()}',true)" ${editEnable}>
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "120px"
            }
        ],
    }
);