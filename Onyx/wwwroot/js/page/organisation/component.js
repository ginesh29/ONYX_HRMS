window["datatable"] = $('#ComponentsDataTable').DataTable(
    {
        ajax: "/Organisation/FetchComponents",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "cd" },
            { data: "typeDesc" },
            {
                data: function (row) {
                    return row.perc_Amt;
                },
            },
            { data: "perc_Val" },
            { data: "trnTyp" },
            { data: "abbr" },
            { data: "sDes" },
            { data: "des" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showComponentModal('${row.cd}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteComponent('${row.cd}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showComponentModal(cd) {
    var url = `/Organisation/GetComponent?cd=${cd}`;
    $('#ComponentModal').load(url, function () {
        parseDynamicForm();
        changePercentageAmt();
        $("#ComponentModal").modal("show");
    });
}
function deleteComponent(cd, type) {
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
            deleteAjax(`/Organisation/DeleteComponent?cd=${cd}&type=${type}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveComponent(btn) {
    var frm = $("#component-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveComponent", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#ComponentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#ComponentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function changePercentageAmt() {
    var val = $("#PercAmt_Cd").val();
    if (val)
        if (val == "A") {
            $("#Perc_Val").removeClass("percentage-input").addClass("decimal-input");
            $('.decimal-input').attr("placeholder", "0.00");
            $('.decimal-input').inputmask(decimalMaskOptions);
        }
        else {
            $("#Perc_Val").removeClass("decimal-input").addClass("percentage-input");
            $('.percentage-input').attr("placeholder", "0.00 %");
            $('.percentage-input').inputmask(percentageMaskOptions);
        }
}