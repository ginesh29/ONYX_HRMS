window["datatable"] = $('#EmployeeProgressionDataTable').DataTable(
    {
        ajax: "/Transactions/FetchEmployeeProgressionData",
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
                    return `${row.name}(${row.empCode.trim()})`
                }
            },
            {
                data: function (row) {
                    return row.transDt && moment(row.transDt).format(CommonSetting.DisplayDateFormat);
                },
            },
            { data: "eP_Typ" },
            { data: "desigFrom" },
            { data: "desigTo" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showEmpProgressionModal('${row.transNo.trim()}')">
                                <i class="fas fa-pencil"></i>
                            </button>
                            <button  class="btn btn-sm btn-danger ml-2" onclick="deleteEmpProgression('${row.transNo.trim()}')">
                                <i class="fa fa-trash"></i>
                            </button>`;
                }, "width": "100px"
            }
        ],
    }
);

function showEmpProgressionModal(transNo) {
    var url = `/Transactions/GetEmployeeProgression?transNo=${transNo}`;
    $('#EmpProgressionModal').load(url, function () {
        parseDynamicForm();
        bindEmployeeDropdown();
        showHideComponent();
        $("#EmpProgressionModal").modal("show");
    });
}
function deleteEmpProgression(transNo) {
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
            deleteAjax(`/Transactions/DeleteEmployeeProgression?transNo=${transNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveEmpPrgression(btn, approval) {
    var frm = $("#emp-prograssion-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var url = !approval ? "/Transactions/SaveEmployeeProgression" : "/Transactions/ApproveEmployeeProgression";
        postAjax(url, frm.serialize(), function (response) {
            showSuccessToastr(response.message);
            $("#EmpProgressionModal").modal("hide");
            reloadDatatable();
            //if (!response.success) {
            //    showErrorToastr(response.message);
            //    $("#EmpProgressionModal").modal("hide");
            //}
            unloadingButton(btn);
        });
    }
}

function saveBulkEmpPrgression(btn) {
    var frm = $("#emp-prograssion-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var url = "/Transactions/SaveBulkEmployeeProgression";
        postAjax(url, frm.serialize(), function (response) {
            showSuccessToastr(response.message);
            $("#EmpProgressionModal").modal("hide");
            reloadDatatable();
            unloadingButton(btn);
        });
    }
}
function bindComponentClass(e) {
    $("#PayCodeCd").empty();
    getAjax(`/Employee/FetchComponentClassItems?type=${e.value}`, function (response) {
        var html = '';
        $.each(response, function (i, item) {
            html += `<option value='${item.value}'>${item.text}</option>`
        })
        $("#PayCodeCd").html(html);
        $("#PayCodeCd").attr("title", "-- Select --");
        $('.select-picker').selectpicker('refresh');
    });
}

function getEmpDesignation() {
    var empCd = $("#EmpCd").val();
    getAjax(`/Employee/GetEmployeeDetail?empCd=${encodeURI(empCd)}`, function (response) {
        $("#DesigFromCd").selectpicker('val', response.desg.trim());
        $("#DesigToCd").selectpicker('val', response.desg.trim());
        $("#DesigFromCd").addClass("disabled");
    })
}
function getCurrentAmt() {
    var empCd = $("#EmpCd").val();
    if (empCd) {
        var edTypeDes = $("#PayTypCd").find("option:selected").val();
        var edCdDes = $("#PayCodeCd").find("option:selected").val();
        getAjax(`/Transactions/GetCurrentAmt?empCd=${encodeURI(empCd)}&edTypeDes=${edTypeDes.split("(")[0]}&edCdDes=${edCdDes.split("(")[0]}`, function (response) {
            $("#CurrentAmt").val(response.amount);
            $("#CurrentAmt").addClass("disabled");
            $("#PercAmt").val(response.percAmt);
            $("#PercAmt").addClass("disabled");
        })
    }
}

function showHideComponent() {
    var type = $("#EP_TypeCd").val();
    $("#component-container").addClass("d-none");
    if (type == "HREP02" || type == "HREP04" || type == "HREP05")
        $("#component-container").removeClass("d-none");
}

function uploadFile(event) {
    var ext = event.target.files[0].name.split('.').pop().toLowerCase();
    if (excelExtensions.includes(ext)) {
        var frm = $("#emp-prograssion-frm");
        $("#EmpCd").prop("disabled", true);
        $("#DesigFromCd").prop("disabled", true);
        $("#DesigToCd").prop("disabled", true);
        $("#CurrentAmt").prop("disabled", true);
        $("#RevisedAmt").prop("disabled", true);
        $("#EffDt").prop("disabled", true);
        $(".select-picker").selectpicker('refresh')
        $("#btn-submit").addClass("d-none");
        $("#btn-bulk-submit").removeClass("d-none");
        if (frm.valid()) {
            loadingPage();
            filePostAjax('/Transactions/ImportEmployeeProgression', frm[0], function (response) {
                $("#import-file").val("");
                $("#EmpProgressions-Table").html(response);
                //if (response.success) {
                    
                //}
                //else
                //    showErrorToastr(response);
                unloadingPage();
            });
        }
        $("#import-file").val("");
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
}