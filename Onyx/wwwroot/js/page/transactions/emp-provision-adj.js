window["datatable"] = $('#EmployeeProvisionAdjDataTable').DataTable(
    {
        ajax: "/Transactions/FetchProvisionAdjData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: 'transNo' },
            {
                data: function (row) {
                    return `${row.name}(${row.empCd.trim()})`
                }
            },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "prov" },
            { data: "days" },
            {
                data: function (row) {
                    return !row.amt ? row.amt : formatDecimal(row.amt)
                },
            },
            { data: "purpose" },
            { data: "narr" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showEmpProvisionAdjModal('${row.transNo.trim()}')">
                                <i class="fas fa-pencil"></i>
                            </button>
                            <button  class="btn btn-sm btn-danger ml-2" onclick="deleteEmpProvisionAdj('${row.transNo.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);