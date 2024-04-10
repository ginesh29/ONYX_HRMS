window["datatable"] = $('#EmployeeLoanApprovalDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanApprovalData",
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
                    return `${row.empName}(${row.employeeCode.trim()})`
                }
            },
            { data: "desg" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "loanType" },
            {
                data: function (row) {
                    return !row.apprAmt ? row.amt : row.apprAmt
                },
            },
            {
                data: function (row) {
                    return !row.noInst ? row.noInstReq : row.noInst
                },
            },
            { data: "purpose" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showLoanApprovalModal('${row.transNo.trim()}')">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="btn btn-sm btn-danger ml-2" onclick="showLoanApprovalModal('${row.transNo.trim()}',true)">
                                <i class="fa fa-times"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);