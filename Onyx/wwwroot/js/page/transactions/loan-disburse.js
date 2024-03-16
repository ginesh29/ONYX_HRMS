window["datatable"] = $('#EmployeeLoanDisburseDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanDisburseData",
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
                    return `${row.employeeName}(${row.employeeCode.trim()})`
                }
            },
            { data: "div" },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "loanType" },
            { data: "amt" },
            { data: "purpose" },
            { data: "narr" },
            { data: "narr" },
            { data: "approverName" },
            { data: "apprAmt" },
            //{
            //    data: function (row) {
            //        return `<button data-toggle="tooltip" data-original-title="Approve" class="btn btn-sm btn-info" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
            //                                                            <i class="fas fa-check"></i>
            //                                                        </button>
            //                                                        <button data-toggle="tooltip" data-original-title="Reject" class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
            //                                                            <i class="fa fa-times"></i>
            //                                                        </button>`;
            //    }, "width": "80px"
            //}
        ],
    }
);