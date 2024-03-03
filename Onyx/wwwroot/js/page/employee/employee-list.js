function BindEmployeeGrid(url) {
    $("#page-loader").removeClass("d-none");
    $('#EmployeeTableContainer').load(url, function () {
        $("#page-loader").addClass("d-none");
    });
}
var url = `/Employee/FetchEmployees?init=true`;
BindEmployeeGrid(url);
$(document).on('click', '.pagination a', function (e) {
    e.preventDefault();
    var url = $(this).attr("href");
    BindEmployeeGrid(url);
});
function filterEmployee(btn) {
    loadingButton(btn);
    var frm = $("#employee-filter-frm").serialize();
    var url = `/Employee/FetchEmployees?${frm}`;
    BindEmployeeGrid(url);
    unloadingButton(btn);
    $("#EmployeeFilterModal").modal("hide");
}