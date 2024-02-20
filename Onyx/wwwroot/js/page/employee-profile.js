var stepper = new Stepper(document.querySelector('#stepper'), {
    linear: false,
    animation: true
});
$('.step-trigger:not(.disabled)').click(function () {
    var stepIndex = $(this).closest('.step').index();
    stepper.to(stepIndex);
    // $('.step-trigger').addClass("disabled");
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
function GoToNextPrev(back) {
    if (!back) {
        var frm = $("#emp-profile-frm");
        if (frm.valid())
            stepper.next()
    }
    else
        stepper.previous()
}
function GotoStep(no) {
    stepper.to(no);
}