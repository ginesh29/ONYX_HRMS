function bindDocumentRenewalSerachTable(cd, type) {
    if ($.fn.DataTable.isDataTable('#RenewalDocumentsSearchDataTable'))
        $('#RenewalDocumentsSearchDataTable').DataTable().destroy();
    var url = type == "EMP" ? `/Employee/FetchDocuments?empCd=${encodeURI(cd)}` : type == "COM" ? `/Organisation/FetchDocuments?CompanyCd=${cd}` : `/Organisation/FetchVehicleDocuments?vehCd=${cd}`;
    window["datatable"] = $('#RenewalDocumentsSearchDataTable').DataTable(
        {
            ajax: url,
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
                        return type == "EMP" ? `<button type="button" class="btn btn-sm btn-info" onclick="showEmpDocumentModal('${row.empCd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                                </button>` : type == "COM" ? `<button class="btn btn-sm btn-info" onclick="showComDocumentModal('${row.docTypCd.trim()}','${row.divCd.trim()}')">
                                <i class="fas fa-pen"></i>
                            </button>` : `<button type="button" class="btn btn-sm btn-info" onclick="showVehDocumentModal('${row.vehCd.trim()}','${row.docTypCd.trim()}','${row.srNo}')">
                                <i class="fas fa-pen"></i>
                                </button>`
                    }, "width": "80px"
                }
            ],
        }
    );
    $("#RenewalDocumentsSearchDataTable").removeClass("d-none")
}
function showDocumentRenewalModal() {
    var url = `/Transactions/DocumentRenew`;
    window.location.href = url;
}
function showEmpDocumentModal(empCd, docTypeCd, srNo) {
    var url = `/Transactions/GetRenewalEmpDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function showComDocumentModal(docTypeCd, divCd) {
    var url = `/Transactions/GetRenewalComDocument?docTypeCd=${encodeURI(docTypeCd.trim())}&divCd=${divCd.trim()}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function showVehDocumentModal(vehCd, docType) {
    var url = `/Transactions/GetRenewalVehicleDocument?vehCd=${vehCd}&docType=${docType}`;
    $('#DocumentRenewModal').load(url, function () {
        parseDynamicForm();
        $("#DocumentRenewModal").modal("show");
    });
}
function saveEmpDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalEmpDocument", frm[0], function (response) {
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
function saveComDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalComDocument", frm[0], function (response) {
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
function saveVehDocumentRenewal(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Transactions/SaveRenewalVehDocument", frm[0], function (response) {
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
    bindDocumentRenewalSerachTable(empCd, "EMP");
})
$("#Company").change(function (e) {
    var cd = e.target.value ? e.target.value : '0';
    bindDocumentRenewalSerachTable(cd, "COM");
})
$("#Vehicle").change(function (e) {
    var cd = e.target.value ? e.target.value : '0';
    bindDocumentRenewalSerachTable(cd, "VEH");
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
function showHideTypeDropdown() {
    $('#RenewalDocumentsSearchDataTable').DataTable().destroy();
    $("#RenewalDocumentsSearchDataTable").addClass("d-none");
    var type = $("input[name='Type']:checked").val();
    $("#EmpCd,#Company,#Vehicle").closest('.form-group').addClass("d-none");
    if (type == "EMP")
        $("#EmpCd").closest('.form-group').removeClass("d-none");
    else if (type == "COM")
        $("#Company").closest('.form-group').removeClass("d-none");
    else
        $("#Vehicle").closest('.form-group').removeClass("d-none");
}
showHideTypeDropdown();