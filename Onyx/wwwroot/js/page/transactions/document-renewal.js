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
showHideTypeDropdown();

function filesPreview(input) {
    $("#Files-Preview").html("");
    if (input.files) {
        var filesCount = input.files.length;
        for (i = 0; i < filesCount; i++) {
            var ext = input.files[i].name.split('.').pop().toLowerCase();
            if (imageExtensions.includes(ext) || pdfExtensions.includes(ext)) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    var src = event.target.result.includes("image") ? event.target.result : "/images/pdf-icon.png";
                    var html = `<div class="btn-file-edit-container"><img style="height:100px;max-width:100%" src='${src}' class="img-thumbnail mb-3"></div>`;
                    $("#Files-Preview").append(html);
                }
                reader.readAsDataURL(input.files[i]);
                $("#doc-file-label").text(`${filesCount} files Chosen`);
            }
            else
                showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
        }
    }
};