window["datatable"] = $('#BanksDataTable').DataTable(
    {
        ajax: "/Organisation/FetchBanks",
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "bank" },
            { data: "branch" },
            { data: "swift" },
            { data: "address1" },
            { data: "address2" },
            { data: "address3" },
            { data: "contact" },
            { data: "phone" },
            { data: "fax" },
            { data: "email" },
            { data: "url" },
            {
                data: function (row) {
                    return `<button class="btn btn-sm btn-info" onclick="showBankModal('${row.bankCd.trim()}','${row.branchCd.trim()}')" ${editEnable}>
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button class="btn btn-sm btn-danger ml-2" onclick="deleteBank('${row.bankCd.trim()}','${row.branchCd.trim()}')" ${deleteEnable}>
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "80px"
            }
        ],
    }
);
function showBankModal(bankCd, branchCd) {
    var url = `/Organisation/GetBank?bankCd=${bankCd}&branchCd=${branchCd}`;
    $('#BankModal').load(url, function () {
        parseDynamicForm();
        $("#BankModal").modal("show");
    });
}
function deleteBank(bankCd, branchCd) {
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
            deleteAjax(`/Organisation/DeleteBank?bankCd=${bankCd}&branchCd=${branchCd}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    reloadDatatable();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function saveBank(btn) {
    var frm = $("#bank-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Organisation/SaveBank", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#BankModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#BankModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('Image-Preview');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
    var filename = $("#ImageFile").val().split("\\").pop();
    $("#Image-Preview").removeClass("d-none");
    $("#image-file-label").text(filename);
};