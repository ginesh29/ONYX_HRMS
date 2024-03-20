﻿setActiveMenu();
setBrowserInfo();
const decimalMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    digits: 2,
    digitsOptional: false,
    placeholder: '0',
}
const percentageMaskOptions = {
    alias: "percentage",
    suffix: ' %',
    autoGroup: true,
    autoUnmask: true,
    digits: 2,
}
const amountMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    allowMinus: false,
    digits: 2,
    digitsOptional: false,
    groupSeparator: ',',
}
const intMaskOptions = {
    alias: 'numeric',
    radixPoint: '.',
    autoGroup: true,
    digits: 0,
    digitsOptional: false,
    placeholder: '0',
}
const dataTableDefaultOptions = {
    "pagingType": "simple",
    "ordering": false
}
const imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
const pdfExtensions = ['pdf'];
const LeaveConfirmTypesEnum = {
    Confirm: 0,
    Revise: 1,
    Cancel: 2
}

const CommonSetting = {
    DisplayDateFormat: $("#LocalDateFormat").val(),
    InputDateFormat: "YYYY-MM-DD"
}
const dateRangePickerDefaultOptions = {
    locale: {
        format: CommonSetting.DisplayDateFormat
    },
    autoUpdateInput: false,
    autoApply: true
}
function loadingButton(btn) {
    var $this = $(btn);
    if (!$this.find(".fa-spinner").length) {
        var spinnerHtml = "<i class='fas fa-spinner fa-spin ml-2'></i>";
        $this.append(spinnerHtml);
    }
    else
        $this.find(".fa-spinner").removeClass("d-none");
    $("#page-loader").removeClass("d-none");
    $this.prop("disabled", true);
}
function unloadingButton(btn) {
    var $this = $(btn);
    setTimeout(function () {
        $this.prop("disabled", false);
        $($this).find("i").removeClass("d-none");
        $this.find(".fa-spinner").addClass("d-none");
        $("#page-loader").addClass("d-none");
    }, 1000);
}
function showSuccessToastr(msg) {
    toastr.clear()
    toastr.success(msg);
}
function showWarningToastr(msg) {
    toastr.clear()
    toastr.warning(msg);
}
function showErrorToastr(msg) {
    toastr.clear()
    toastr.error(msg);
}

function logOut(btn) {
    loadingButton(btn);
    setTimeout(function () {
        window.location.href = "/account/logout";
    }, 1000);
}
function getAjax(url, callback) {
    $.get(url, callback);
}
function postAjax(url, formdata, callback) {
    var processId = $("#ProcessId").val();
    url = `${url}?processId=${processId}`;
    $.post(url, formdata, callback);
}
function filePostAjax(url, formData, callback) {
    $.ajax({
        url: url,
        type: 'POST',
        data: new FormData(formData),
        processData: false,
        contentType: false,
        success: function (response) {
            callback(response);
        },
    });
}
var deleteAjax = function (url, callback) {
    $.ajax({
        url: url,
        type: 'DELETE',
        success: callback,
    })
}
function setActiveMenu() {
    var activeUrl = `${window.location.pathname}${window.location.search}`;
    var el = $('a[href="' + activeUrl + '"]');
    el.addClass('active');
    var el2 = el.closest('.nav-treeview').closest('.nav-item').addClass('menu-open').find('> .nav-link').addClass('active');
    el2.closest('.nav-treeview').closest('.nav-item').addClass('menu-open').find('> .nav-link').addClass('active');
}
function reloadPageAfterSometime() {
    setTimeout(function () {
        location.reload();
    }, 1000);
}
function reloadDatatable() {
    window["datatable"].ajax.reload();
    window["datatable"].search('').draw();
    if (window["datatable-2"]) {
        window["datatable-2"].ajax.reload();
        window["datatable-2"].search('').draw();
    }
}
function parseDynamicForm() {
    $("form").removeData("validator");
    $("form").removeData("unobtrusiveValidation");
    $.validator.unobtrusive.parse("form");
}
function removeBackdrop() {
    $('body').removeClass('modal-open');
    $('.modal-backdrop').remove();
}
function exportExcel(table, filePrefix) {
    var header = [table.columns().header().map(d => d.textContent).toArray()];
    var data = table.data().toArray();
    var dataWithHeader = header.concat(data);
    var wb = XLSX.utils.book_new();
    var ws = XLSX.utils.aoa_to_sheet(dataWithHeader);
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
    var filename = `${filePrefix}.xlsx`;
    XLSX.writeFile(wb, filename);
}
function setBrowserInfo() {
    const userAgent = navigator.userAgent;
    let browserName = "Unknown";
    let browserVersion = "Unknown";

    if (userAgent.includes("Chrome")) {
        browserName = "Chrome";
        const match = userAgent.match(/Chrome\/(\d+\.\d+\.\d+\.\d+)/);
        if (match) {
            browserVersion = match[1];
        }
    } else if (userAgent.includes("Firefox")) {
        browserName = "Firefox";
        const match = userAgent.match(/Firefox\/(\d+\.\d+\.\d+)/);
        if (match) {
            browserVersion = match[1];
        }
    } else if (userAgent.includes("Edge")) {
        browserName = "Edge";
        const match = userAgent.match(/Edg\/(\d+\.\d+\.\d+\.\d+)/);
        if (match) {
            browserVersion = match[1];
        }
    } else if (userAgent.includes("Safari")) {
        browserName = "Safari";
        const match = userAgent.match(/Version\/(\d+\.\d+\.\d+)/);
        if (match) {
            browserVersion = match[1];
        }
    }
    $("#Browser").val(`${browserName} ${browserVersion}`);
}

function showChangePasswordModal() {
    var url = `/Account/ChangePassword`;
    $('#ChangePasswordModal').load(url, function () {
        parseDynamicForm();
        $("#ChangePasswordModal").modal("show");
    });
}
function changePassword(btn) {
    var frm = $("#change-password-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax(`/account/changepassword`, frm.serialize(), function (response) {
            if (response.success)
                showSuccessToastr(response.message)
            else
                showErrorToastr(response.message)
        });
        $("#ChangePasswordModal").modal("hide");
        unloadingButton(btn);
    }
}
function getQueryStringParams(queryString) {
    var params = {};
    if (queryString) {
        var queryStringWithoutQuestionMark = queryString.substring(1);
        var pairs = queryStringWithoutQuestionMark.split('&');
        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i].split('=');
            var key = decodeURIComponent(pair.shift());
            var value = pair.length ? pair.join('=') : '';
            value = decodeURIComponent(value);
            params[key] = value;
        }
    }
    return params;
}
function filePreview(path) {
    if (!path.includes("not found")) {
        var url = `/Home/FilePreview?path=${path}`;
        $('#PreviewModal').load(url, function () {
            $("#file-preview").attr("src", path);
            setTimeout(function () {
                adjustIframeHeight();
            }, 200);
            $("#PreviewModal").modal("show");
        });
    }
    else
        showErrorToastr(path);
}
function adjustIframeHeight() {
    var iframe = document.getElementById('file-preview');
    var innerDoc = iframe.contentDocument || iframe.contentWindow.document;
    function resizeIframe() {
        var img = innerDoc.getElementsByTagName('img')[0];
        if (img) {
            iframe.style.height = img.offsetHeight + 'px';
            iframe.style.width = img.offsetWidth + 'px';
        }
        else {
            iframe.style.height = '100vh';
            iframe.style.width = '100%';
        }
    }

    if (innerDoc.readyState == 'complete') {
        resizeIframe();
    } else {
        iframe.onload = resizeIframe;
    }
}
function autoResizeTextarea(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = Math.min(textarea.scrollHeight, parseInt(window.getComputedStyle(textarea).getPropertyValue("max-height"))) + 'px';
}
$("#company-dropdown").on('change', function (e) {
    postAjax("/home/UpdateCompany", { CoCd: e.target.value }, function (response) {
        showSuccessToastr(response.message);
        window.location.reload();
    });
})
function printDiv(divContainer) {
    divContainer = divContainer ? divContainer : "print-container";
    $(`#${divContainer}`).print();
}
function initControls() {
    $(".select-picker,.filter-select-picker").not("#company-dropdown").attr("data-live-search", true)
    $(".select-picker").attr("title", "-- Select --");
    $(".filter-select-picker").attr("title", "-- All --");
    $(".select-picker,.filter-select-picker").selectpicker();
    $(".select-picker,.filter-select-picker").on('show.bs.select', function () {
        $("ul.dropdown-menu.inner.show").css("margin-bottom", "0");
    });
    $('.date-input').attr("placeholder", CommonSetting.DisplayDateFormat && CommonSetting.DisplayDateFormat.toLowerCase());
    $('.date-input').datetimepicker({
        format: CommonSetting.DisplayDateFormat
    });
    $('.decimal-input').attr("placeholder", "0.00");
    $('.decimal-input').inputmask(decimalMaskOptions);

    $('.int-input').attr("placeholder", "0");
    $('.int-input').inputmask(intMaskOptions);

    $('.percentage-input').attr("placeholder", "0 %");
    $('.percentage-input').inputmask(percentageMaskOptions);

    $("textarea.form-control").on("input", function (e) {
        autoResizeTextarea(e.target)
    });
    setTimeout(function () {
        $("textarea.form-control").trigger('input');
    }, 200)
    $('[data-toggle="tooltip"]').tooltip();
    $('#DateRange').on('apply.daterangepicker', function (ev, picker) {
        var startDate = picker.startDate.format(CommonSetting.DisplayDateFormat);
        var endDate = picker.endDate.format(CommonSetting.DisplayDateFormat);
        $(this).val(`${startDate} - ${endDate}`);
        var days = picker.endDate.diff(picker.startDate, 'days');
        $("#Days").text(`(${days} days)`);
    });
}
function downloadFile(foldername, filename) {
    $.ajax({
        url: `/Home/DownloadFile?foldername=${foldername}&filename=${filename}`,
        type: 'GET',
        xhrFields: {
            responseType: 'blob' // important to handle as blob
        },
        success: function (data) {
            var anchor = document.createElement('a');
            var url = window.URL.createObjectURL(data);
            anchor.href = url;
            anchor.download = filename;
            document.body.appendChild(anchor);
            anchor.click();
            window.URL.revokeObjectURL(url); // Release the object URL
            document.body.removeChild(anchor);
        },
        error: function () {
            showErrorToastr('File not found.');
        }
    });
};
$(function () {
    initControls();
});
$(document).ajaxComplete(function () {
    initControls();
});