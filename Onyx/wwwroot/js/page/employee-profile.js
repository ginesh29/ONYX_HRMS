var stepper = new Stepper(document.querySelector('#stepper'), {
    linear: false,
    animation: true
});
$('.step-trigger:not(.disabled)').click(function () {
    var stepIndex = $(this).closest('.step').index();
    //$('.step-trigger').addClass("disabled");
    stepper.to(stepIndex + 1);
    // 
    // $(`.step-trigger:nth-child(${stepIndex + 1})`).removeClass("disabled");
});
//$('.step-trigger').addClass("disabled");
// $('.step-trigger').click(function () {
//     var stepIndex = $(this).closest('.step').index() + 1;
//     stepper.to(stepIndex); // Jump to the clicked step
// });
function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('avatar-preview')
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
    var filename = $("#ImageFile").val().split("\\").pop();
    $("#image-file-label").text(filename);
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
        postAjax("/Employee/SavePesonalDetail", frm.serialize(), function (response) {
            if (response.success) {
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