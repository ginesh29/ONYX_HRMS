function BindEmployeeGrid(url) {
    loadingPage();
    $('#EmployeeTableContainer').load(url, function () {
        unloadingPage();
    });
}
bindEmployeeDropdown();
var url = `/Employee/FetchEmployees`;
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
function resetFilter() {
    var frm = $('#employee-filter-frm');
    frm.find("input").val("");
    frm.find(".filter-select-picker").val('').selectpicker('refresh');
    frm.find(".filter-select-picker").selectpicker('deselectAll');
}
$("#EmpCd").change(function (e) {
    var url = `/Employee/FetchEmployees?Name=${encodeURI(e.target.value)}`;
    BindEmployeeGrid(url);
})
function changeShowEntries(curr) {
    var frm = $("#employee-filter-frm").serialize();
    var name = $("#EmpCd").val() ?? "";
    var url = `/Employee/FetchEmployees?Name=${encodeURI(name)}&${frm}&pageSize=${curr.value}`;
    BindEmployeeGrid(url);
}
$('#EmpCd').on('select2:open', function () {
    $('.select2-search__field').on('input', function () {
        var searchText = $(this).val();
        var url = `/Employee/FetchEmployees?Name=${encodeURI(searchText)}`;
        BindEmployeeGrid(url);
    });
});