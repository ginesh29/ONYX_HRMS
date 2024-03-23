window["datatable"] = $('#EmployeeLoanAdjustmentDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpLoanAdjustmentData",
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
                    return `${row.empName}(${row.empCd.trim()})`
                }
            },
            { data: "loanTyp" },
            { data: "amt" },
            { data: "apprAmt" },
            { data: "noInst" },
            { data: "purpose" },
            //{
            //    data: function (row) {
            //        return `<button class="btn btn-sm btn-info" onclick="showLeaveApprovalModal('${row.transNo.trim()}')">
            //                                                            <i class="fas fa-check"></i>
            //                                                        </button>
            //                                                        <button class="btn btn-sm btn-danger ml-2" onclick="showLeaveApprovalModal('${row.transNo.trim()}',true)">
            //                                                            <i class="fa fa-times"></i>
            //                                                        </button>`;
            //    }, "width": "80px"
            //}
        ],
    }
);