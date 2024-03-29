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
            { data: "amt" },
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

function showEmpProvisionAdjModal(transNo) {
    var url = `/Transactions/GetProvisionAdj?transNo=${transNo}`;
    $('#EmpProvisionAdjModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        $("#EmpProvisionAdjModal").modal("show");
    });
}
function deleteEmpProvisionAdj(transNo) {
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
            deleteAjax(`/Transactions/DeleteEmpProvisionAdj?transNo=${transNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveEmpProvisionAdj(btn) {
    var frm = $("#emp-provision-adj-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Transactions/SaveEmpProvisionAdj", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EmpProvisionAdjModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#EmpProvisionAdjModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}