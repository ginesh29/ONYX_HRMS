var stepper = new Stepper(document.querySelector('#stepper'), {
    linear: false,
    animation: true
});
$('.step-trigger:not(.disabled)').click(function () {
    var stepIndex = $(this).closest('.step').index();
    stepper.to(stepIndex + 1);
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
        filePostAjax("/Employee/SavePesonalDetail", frm[0], function (response) {
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