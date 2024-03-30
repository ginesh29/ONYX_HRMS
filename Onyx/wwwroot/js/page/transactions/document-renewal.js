function bindDocumentDataTable() {
    if (!$.fn.DataTable.isDataTable('#DocumentsDataTable'))
        window["datatable"] = $('#DocumentsDataTable').DataTable(
            {
                ajax: `/Employee/FetchDocuments?empCd=${encodeURI(empCode)}`,
                ordering: false,
                "columnDefs": [
                    { "visible": visibleEmpName, "targets": 1 }
                ],
                columns: [
                    {
                        data: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    {
                        data: function (row) {
                            return `${row.empName}(${row.empCd.trim()})`;
                        },
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
                            </button>                                                                          <button type="button" class="btn btn-sm btn-danger ml-2" onclick="deleteDocument('${row.empCd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fa fa-trash"></i>
                            </button>`
                        }, "width": "80px"
                    }
                ],
            }
        );
}
function showDocumentModal(empCd, docTypeCd, srNo) {
    empCd = empCd ? empCd : empCode;
    var url = `/Employee/GetDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentModal').load(url, function () {
        bindEmployeeDropdown();
        parseDynamicForm();
        showHideExpiry();
        $('#DocList').load(`/Employee/FetchDocumentFiles?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}`);
        if (!visibleEmpName)
            $("#EmpCd").closest(".form-group").addClass("d-none");
        $("#DocumentModal").modal("show");
    });
}
function deleteDocument(empCd, docTypeCd, srNo) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Delete?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Employee/DeleteDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDocument(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Employee/SaveDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}