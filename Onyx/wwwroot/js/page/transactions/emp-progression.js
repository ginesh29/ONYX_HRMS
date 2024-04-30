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

function saveBulkEmpPrgression(btn) {
    var frm = $("#emp-prograssion-frm");
    if (frm.valid()) {
        loadingButton(btn);
        var url = "/Transactions/SaveBulkEmployeeProgression";
        postAjax(url, frm.serialize(), function (response) {
            if (response.success)
                showSuccessToastr(response.message);
            else
                showErrorToastr(response.message)
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
        if (response && response.desg) {
            $("#DesigFromCd").selectpicker('val', response.desg.trim());
            $("#DesigToCd").selectpicker('val', response.desg.trim());
            $("#DesigToCd").removeClass("disabled");
            $("#DesigToCd").parent().removeClass("disabled");
            $("#RevisedAmt").removeClass("disabled");
            $(".select-picker").selectpicker('refresh');
        }
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
function uploadFile(event) {
    var ext = event.target.files[0].name.split('.').pop().toLowerCase();
    if (excelExtensions.includes(ext)) {
        var frm = $("#emp-prograssion-frm");
        $("#EmpCd").prop("disabled", true);
        $("#DesigFromCd").prop("disabled", true);
        $("#DesigToCd").prop("disabled", true);
        $("#CurrentAmt").addClass("disabled");
        $("#RevisedAmt").addClass("disabled");
        $(".select-picker").selectpicker('refresh')
        $("#btn-submit").addClass("d-none");
        $("#btn-bulk-submit").removeClass("d-none");
        $("#DesigFromCd").selectpicker('val', '');
        $("#DesigToCd").selectpicker('val', '');
        $("#EmpCd").val('').change();
        if (frm.valid()) {
            $("#modal-loader").removeClass("d-none");
            $("#btn-bulk-submit").addClass("d-none");
            filePostAjax('/Transactions/ImportEmployeeProgression', frm[0], function (response) {
                $("#import-file").val("");
                $("#EmpProgressions-Table").html(response);
                $("#modal-loader").addClass("d-none");
                $("#btn-bulk-submit").removeClass("d-none");
                if (response.message)
                    showErrorToastr(response.message);
                unloadingPage();
            });
        }
        $("#import-file").val("");
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
}