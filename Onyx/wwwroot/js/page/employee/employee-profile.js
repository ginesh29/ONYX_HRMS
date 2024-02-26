var stepper = new Stepper(document.querySelector('#stepper'), {
    linear: false,
    animation: true
});
function previewAvatar(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('avatar-preview')
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
    $("#btn-avatar-delete").addClass("d-none");
};
function editAvatar() {
    $(`#AvatarFile`).click();
}
function deleteAvatar(cd) {
    Swal.fire({
        title: "Are you sure?",
        text: "You want to Remove Profile Image?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
    }).then((result) => {
        if (result.isConfirmed) {
            deleteAjax(`/Employee/RemoveAvatar?Cd=${encodeURI(cd)}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    $("#avatar-preview").attr('src', "/images/avatar.png");
                    $("#btn-avatar-delete").addClass("d-none");
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function previewSignature(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('signature-preview')
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
    var filename = $("#SignatureFile").val().split("\\").pop();

    $("#signature-file-label").text(filename);
    $("#signature-preview").removeClass("d-none");
};
function GoToNextPrev(btn, back) {
    if (!back) {
        var frm = $("#emp-profile-frm");
        if (frm.valid()) {
            var activeStepIndex = $('.step.active').index();
            if (activeStepIndex <= 1) {
                saveBasicDetail(btn);
                $("#official-detail-trigger").removeClass("disabled");
            }
            else
                stepper.next();
        }
    }
    else
        stepper.previous()
}
function GotoStep(no) {
    stepper.to(no);
}
function saveBasicDetail(btn) {
    var frm = $("#emp-profile-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Employee/SavePersonalDetail", frm[0], function (response) {
            if (response.success) {
                $("#btn-avatar-delete").removeClass("d-none");
                stepper.next();
                showSuccessToastr(response.message);
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}
var empCd = $("#Cd").val();
window["datatable"] = $('#EducationsDataTable').DataTable(
    {
        ajax: `/Employee/FetchEducations?empCd=${empCd}`,
        ordering: false,
        columns: [
            {
                data: function (data, type, row, meta) {
                    return meta.row + meta.settings._iDisplayStart + 1;
                }
            },
            { data: "qualification" },
            { data: "university" },
            { data: "country" },
            { data: "passingYear" },
            { data: "marksGrade" },
            {
                data: function (row) {
                    return `<button type="button" class="btn btn-sm btn-info" onclick="showEducationModal('${row.srNo}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button type="button" class="btn btn-sm btn-danger ml-2" onclick="deleteEducation('${row.srNo}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                }, "width": "60px"
            }
        ],
    }
);
function showEducationModal(srNo) {
    var url = `/Employee/GetEducation?empCd=${encodeURI(empCd)}&srNo=${srNo}`;
    $('#EducationModal').html("");
    $('#EducationModal').load(url, function () {
        parseDynamicForm();
        $("#EmpCd").val(empCd);
        $("#EducationModal").modal("show");
    });
}
function deleteEducation(srNo) {
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
            deleteAjax(`/Employee/DeleteEducation?empCd=${encodeURI(empCd) }&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveEducation(btn) {
    var frm = $("#education-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Employee/SaveEducation", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#EducationModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#EducationModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}