function BindEmployeeGrid(url) {
    $("#page-loader").removeClass("d-none");
    $('#EmployeeTableContainer').load(url, function () {
        $("#page-loader").addClass("d-none");
    });
}
var url = `/Employee/FetchEmployees?page=1`;
BindEmployeeGrid(url);
$(document).on('click', '.pagination a', function (e) {
    e.preventDefault();
    var url = $(this).attr("href");
    BindEmployeeGrid(url)
});