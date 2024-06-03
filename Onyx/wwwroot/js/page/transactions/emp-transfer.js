window["datatable"] = $('#EmployeeTransferDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmpTransferData",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            {
                data: function (row) {
                    return `${row.name}(${row.empCd.trim()})`
                }
            },
            {
                data: function (row) {
                    return row.transferDt && moment(row.transferDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "deptFrDes" },
            { data: "deptToDes" },
            { data: "brFrDes" },
            { data: "brToDes" },
            { data: "narration" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showEmpTransferModal('${row.empCd.trim()}',${row.srNo})" ${editEnable}>
                                <i class="fas fa-pencil"></i>
                            </button>
                            <button  class="btn btn-sm btn-danger ml-2" onclick="deleteEmpTransfer('${row.empCd.trim()}',${row.srNo})" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button>`;
                }, "width": "80px"
            }
        ],
    }
);

function showEmpTransferModal(empCd, srNo) {
    var url = `/Transactions/GetEmpTransfer?empCd=${empCd}&srNo=${srNo}`;
    $('#EmployeeTransferModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        $("#EmployeeTransferModal").modal("show");
    });
}
function deleteEmpTransfer(empCd, srNo) {
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
            deleteAjax(`/Transactions/DeleteEmpTransfer?empCd=${empCd}&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveEmpTransfer(btn) {
    var frm = $("#emp-transfer-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveEmpTransfer", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmployeeTransferModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#EmployeeTransferModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}

function getEmpTransferEmployeeDetail() {
    var empCd = $("#EmpCd").val();
    getAjax(`/Transactions/GetEmpTransferDetail?empCd=${empCd}`, function (response) {
        $('#DeptFrom').selectpicker('val', response.dept && response.dept.trim());
        $('#LocFrom').selectpicker('val', response.locCd && response.locCd.trim());
        $('#BrFrom').selectpicker('val', response.div && response.div.trim());
    })
}