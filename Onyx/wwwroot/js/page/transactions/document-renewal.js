function bindDocumentRenewalSerachTable(empCode) {
    if ($.fn.DataTable.isDataTable('#RenewalDocumentsSearchDataTable'))
        $('#RenewalDocumentsSearchDataTable').DataTable().destroy();
    window["datatable"] = $('#RenewalDocumentsSearchDataTable').DataTable(
        {
            ajax: `/Employee/FetchDocuments?empCd=${encodeURI(empCode)}`,
            ordering: false,
            columns: [
                {
                    data: function (data, type, row, meta) {
                        return meta.row + meta.settings._iDisplayStart + 1;
                    }
                },
                { data: "docTypSDes" },
                { data: "docNo", width: "100px" },
                {
                    data: function (row) {
                        return row.issueDt && moment(row.issueDt).format(CommonSetting.DisplayDateFormat);
                    },
                },
                { data: "issuePlace" },
                {
                    data: function (row) {
                        return row.expDt && moment(row.expDt).format(CommonSetting.DisplayDateFormat);
                    }, width: "100px"
                },
                {
                    data: function (row) {
                        return `<button type="button" class="btn btn-sm btn-info" onclick="showDocumentModal('${row.empCd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                                </button>`
                    }, "width": "80px"
                }
            ],
        }
    );
}
function showDocumentRenewalModal() {
    var url = `/Transactions/DocumentRenew`;
    window.location.href = url;
}
function showDocumentModal(empCd, docTypeCd, srNo) {
    var url = `/Transactions/GetRenewalDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function saveDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                window.location.href = '/Transactions/DocumentRenewal?processId=HRPT8'
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}

$("#EmpCd").change(function (e) {
    var empCd = e.target.value ? e.target.value : '0';
    bindDocumentRenewalSerachTable(empCd);
})
window["datatable"] = $('#RenewalDocumentsApprovalDataTable').DataTable(
    {
        ajax: `/Transactions/FetchEmpDocRenewalData`,
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            {
                data: function (row) {
                    return `${row.empName}(${row.employeeCode.trim()})`;
                },
            },
            { data: "docTypeDes" },
            { data: "docNo", width: "100px" },
            {
                data: function (row) {
                    return row.trnDt && moment(row.trnDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "documentStatus" },
            { data: "narr" },
            {
                data: function (row) {
                    return `<button type="button" class="btn btn-sm btn-info" onclick="showDocumentApprovalModal('${row.employeeCode.trim()}','${row.docType.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                                </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showDocumentApprovalModal(empCd, docTypeCd, srNo) {
    var url = `/Transactions/GetRenewalDocumentApproval?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function saveDocumentRenewalApproval(btn, reject) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var status = !reject ? "A" : "R";
        $("#Status").val(status);
        filePostAjax("/Transactions/SaveRenewalDocumentApproval", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentRenewModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}