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
            $(".step-trigger").removeClass("disabled");
            if (activeStepIndex == 0 || activeStepIndex == 1) {
                saveBasicDetail(btn);
                if (activeStepIndex == 1)
                    bindEducationDataTable();
            }
            else if (activeStepIndex == 2)
                bindExperienceDataTable();
            else if (activeStepIndex == 3)
                bindDocumentDataTable();
            else if (activeStepIndex == 4)
                bindComponentDataTable();
            else if (activeStepIndex == 5)
                bindAddresses(empCode);
            if (activeStepIndex != 0 && activeStepIndex != 1)
                stepper.next();
        }
    }
    else
        stepper.previous()
}
function GotoStep(no) {
    stepper.to(no);
}
var empCode = $("#Cd").val();
var visibleEmpName = !empCode ? true : false;
$('.step[data-target="#education-detail-part"] .step-trigger').on('click', function (e) {
    e.preventDefault();
    bindEducationDataTable();
});
$('.step[data-target="#experience-detail-part"] .step-trigger').on('click', function (e) {
    e.preventDefault();
    bindExperienceDataTable();
});
$('.step[data-target="#documents-part"] .step-trigger').on('click', function (e) {
    e.preventDefault();
    bindDocumentDataTable();
});
$('.step[data-target="#components-part"] .step-trigger').on('click', function (e) {
    e.preventDefault();
    bindComponentDataTable();
});
$('.step[data-target="#addresses-part"] .step-trigger').on('click', function (e) {
    e.preventDefault();
    bindAddresses(empCode);
});
function saveBasicDetail(btn) {
    var frm = $("#emp-profile-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Employee/SavePersonalDetail", frm[0], function (response) {
            if (response.success) {
                $("#btn-avatar-delete").removeClass("d-none");
                setTimeout(function () {
                    stepper.next();
                }, 1000)
                showSuccessToastr(response.message);
            }
            else {
                showErrorToastr(response.message);
            }
            unloadingButton(btn);
        });
    }
}
function bindEducationDataTable() {
    if (!$.fn.DataTable.isDataTable('#EducationsDataTable'))
        window["datatable"] = $('#EducationsDataTable').DataTable(
            {
                ajax: `/Employee/FetchEducations?empCd=${empCode}`,
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
                        }, "width": "80px"
                    }
                ],
            }
        );
}
function showEducationModal(srNo) {
    var url = `/Employee/GetEducation?empCd=${encodeURI(empCode)}&srNo=${srNo}`;
    $('#EducationModal').html("");
    $('#EducationModal').load(url, function () {
        parseDynamicForm();
        $("#EmpCd").val(empCode);
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
            deleteAjax(`/Employee/DeleteEducation?empCd=${encodeURI(empCode)}&srNo=${srNo}`, function (response) {
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
function bindExperienceDataTable() {
    if (!$.fn.DataTable.isDataTable('#ExperiencesDataTable'))
        window["datatable"] = $('#ExperiencesDataTable').DataTable(
            {
                ajax: `/Employee/FetchExperiences?empCd=${empCode}`,
                ordering: false,
                columns: [
                    {
                        data: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    { data: "companyName" },
                    { data: "designation" },
                    {
                        data: function (row) {
                            var formattedFromDate = moment(row.startingDate).format('DD/MM/YYYY');
                            var formattedToDate = moment(row.endingDate).format('DD/MM/YYYY');
                            return `${formattedFromDate} - ${formattedToDate}`;
                        }
                    },
                    { data: "country" },
                    {
                        data: function (row) {
                            return `<button type="button" class="btn btn-sm btn-info" onclick="showExperienceModal('${row.srno}')">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button type="button" class="btn btn-sm btn-danger ml-2" onclick="deleteExperience('${row.srno}')">
                                <i class="fa fa-trash"></i>
                            </button>`
                        }, "width": "80px"
                    }
                ],
            }
        );
}
function showExperienceModal(srNo) {
    var url = `/Employee/GetExperience?empCd=${encodeURI(empCode)}&srNo=${srNo}`;
    $('#ExperienceModal').load(url, function () {
        parseDynamicForm();
        $("#EmpCd").val(empCode);
        $('#DateRange').daterangepicker({
            autoUpdateInput: false
        });
        $('#DateRange').on('apply.daterangepicker', function (ev, picker) {
            var startDate = picker.startDate.format('MM/DD/YYYY');
            var endDate = picker.endDate.format('MM/DD/YYYY');
            $(this).val(startDate + ' - ' + endDate);
            $("#StartingDate").val(startDate);
            $("#EndingDate").val(endDate);
        });
        $('#DateRange').on('cancel.daterangepicker', function (ev, picker) {
            $(this).val('');
        });
        $("#ExperienceModal").modal("show");
    });
}
function deleteExperience(srNo) {
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
            deleteAjax(`/Employee/DeleteExperience?empCd=${encodeURI(empCode)}&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveExperience(btn) {
    var frm = $("#experience-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Employee/SaveExperience", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#ExperienceModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#ExperienceModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function bindDocumentDataTable() {
    empCode = empCode ? empCode : "";
    if (!$.fn.DataTable.isDataTable('#DocumentsDataTable'))
        window["datatable"] = $('#DocumentsDataTable').DataTable(
            {
                ajax: `/Employee/FetchDocuments?empCd=${encodeURI(empCode)}`,
                ordering: false,
                "columnDefs": [
                    { "visible": visibleEmpName, "targets": 1 }
                ],
                columns: [
                    {
                        data: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    {
                        data: function (row) {
                            return `${row.empName}(${row.empCd.trim()})`;
                        },
                    },
                    { data: "docTypSDes" },
                    { data: "docNo", width: "100px" },
                    {
                        data: function (row) {
                            return row.issueDt && moment(row.issueDt).format('DD/MM/YYYY');
                        },
                    },
                    { data: "issuePlace" },
                    {
                        data: function (row) {
                            return row.expDt && moment(row.expDt).format('DD/MM/YYYY');
                        }, width: "100px"
                    },
                    {
                        data: function (row) {
                            return `<button type="button" class="btn btn-sm btn-info" onclick="showDocumentModal('${row.empCd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button type="button" class="btn btn-sm btn-danger ml-2" onclick="deleteDocument('${row.empCd.trim()}','${row.docTypCd.trim()}',${row.srNo})">
                                <i class="fa fa-trash"></i>
                            </button>`
                        }, "width": "80px"
                    }
                ],
            }
        );
}
function showDocumentModal(empCd, docTypeCd, srNo) {
    empCd = empCd ? empCd : empCode;
    var url = `/Employee/GetDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`;
    $('#DocumentModal').load(url, function () {
        parseDynamicForm();
        $('#DocList').load(`/Employee/FetchDocumentFiles?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}`);
        if (!visibleEmpName)
            $("#EmpCd").closest(".form-group").addClass("d-none");
        $("#DocumentModal").modal("show");
    });
}
function deleteDocument(empCd, docTypeCd, srNo) {
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
            deleteAjax(`/Employee/DeleteDocument?empCd=${encodeURI(empCd)}&docTypeCd=${docTypeCd}&srNo=${srNo}`, function (response) {
                showSuccessToastr(response.message);
                reloadDatatable();
            });
        }
    });
}
function saveDocument(btn) {
    var frm = $("#document-frm");
    if (frm.valid()) {
        loadingButton(btn);
        filePostAjax("/Employee/SaveDocument", frm[0], function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#DocumentModal").modal("hide");
                reloadDatatable();
            }
            else {
                showErrorToastr(response.message);
                $("#DocumentModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function filesPreview(input) {
    $("#Files-Preview").html("");
    if (input.files) {
        var filesCount = input.files.length;
        for (i = 0; i < filesCount; i++) {
            var ext = input.files[i].name.split('.').pop().toLowerCase();
            if (imageExtensions.includes(ext) || pdfExtensions.includes(ext)) {
                var reader = new FileReader();
                reader.onload = function (event) {
                    var src = event.target.result.includes("image") ? event.target.result : "/images/pdf-icon.png";
                    var html = `<div class="btn-file-edit-container"><img style="height:100px;max-width:100%" src='${src}' class="img-thumbnail mb-3"></div>`;
                    $("#Files-Preview").append(html);
                }
                reader.readAsDataURL(input.files[i]);
                $("#doc-file-label").text(`${filesCount} files Chosen`);
            }
            else
                showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
        }
    }
};
function deleteDocumentFile(curr, divCd, docType, srNo) {
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
            deleteAjax(`/Employee/DeleteDocumentFile?empCd=${encodeURI(empCd)}&docTypCd=${docType}&slNo=${srNo}`, function (response) {
                if (response.success) {
                    showSuccessToastr(response.message);
                    $(curr).closest(".btn-file-edit-container").remove();
                }
                else
                    showErrorToastr(response.message);
            });
        }
    });
}
function editDoc(curr) {
    var srno = $(curr).attr("data-srno");
    $(`#doc-file-${srno}`).click();
}
function filesEditPreview(input, id) {
    var ext = input.target.files[0].name.split('.').pop().toLowerCase();
    if (imageExtensions.includes(ext) || pdfExtensions.includes(ext)) {
        var reader = new FileReader();
        reader.onload = function () {
            var src = reader.result.includes("image") ? reader.result : "/images/pdf-icon.png";
            $(`#file-${id}`).attr("src", src)
        };
        reader.readAsDataURL(input.target.files[0]);
        $(`#btn-file-delete-${id},#btn-upload-file-${id}`).addClass("d-none");
        $(`#btn-upload-${id}`).removeClass("d-none");
        $("#File_SrNo").val(id);
    }
    else
        showErrorToastr(`${ext.toUpperCase()} file type not allowed`);
};
function saveEditFile() {
    var docTypCd = $("#DocTypCd").val();
    var empCd = $("#EmpCd").val();
    var srNo = $("#File_SrNo").val();
    var file = $(`#doc-file-${srNo}`)[0].files[0];
    var formData = new FormData();
    formData.append('docTypCd', docTypCd);
    formData.append('empCd', empCd);
    formData.append('srNo', srNo);
    formData.append('file', file);
    $.ajax({
        url: "/Employee/UpdateDocumentFile",
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
            if (response.success) {
                $(`#btn-file-delete-${srNo},#btn-upload-file-${srNo}`).removeClass("d-none");
                $(`#btn-upload-${srNo}`).addClass("d-none");
                showSuccessToastr(response.message);
            }
        },
    });
}
function bindEmployeeDropdown(callback) {
    $("#EmpCd").empty();
    getAjax(`/Employee/FetchEmployeeItems`, function (response) {
        var html = ''
        $.each(response, function (i, item) {
            html += `<option value='${item.cd.trim()}'>${item.name}(${item.cd.trim()})</option>`
        })
        $("#EmpCd").html(html);
        $('.select-picker').selectpicker('refresh');
        callback();
    });
}
function bindComponentDataTable() {
    empCode = empCode ? empCode : "";
    if (!$.fn.DataTable.isDataTable('#ComponentsDataTable'))
        window["datatable"] = $('#ComponentsDataTable').DataTable(
            {
                ajax: `/Employee/FetchComponents?empCd=${encodeURI(empCode)}`,
                ordering: false,
                "columnDefs": [
                    { "visible": visibleEmpName, "targets": 1 }
                ],
                columns: [
                    {
                        data: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        }
                    },
                    {
                        data: function (row) {
                            return `${row.emp}(${row.empCd.trim()})`;
                        },
                    },
                    { data: "type" },
                    { data: "description" },
                    { data: "currency" },
                    { data: "amt" },
                    { data: "percVal" },
                    {
                        data: function (row) {
                            return row.effDt && moment(row.effDt).format('DD/MM/YYYY');
                        }, width: "100px"
                    },
                    {
                        data: function (row) {
                            return `<button type="button" class="btn btn-sm btn-info" onclick="showComponentModal('${row.empCd.trim()}','${row.edCd.trim()}','${row.edTyp.trim()}',${row.srNo})">
                                <i class="fas fa-pen"></i>
                            </button>                                                                          <button type="button" class="btn btn-sm btn-danger ml-2" onclick="deleteComponent('${row.empCd.trim()}','${row.edCd.trim()}','${row.edTyp.trim()}',${row.srNo})">
                                <i class="fa fa-trash"></i>
                            </button>`
                        }, "width": "80px"
                    }
                ],
            }
        );
}
function showComponentModal(empCd, edCd, edTyp, srNo) {
    empCd = empCd ? empCd : empCode;
    var url = `/Employee/GetComponent?empCd=${encodeURI(empCd)}&edCd=${edCd}&edTyp=${edTyp}&srNo=${srNo}`;
    $('#ComponentModal').load(url, function () {
        parseDynamicForm();
        changePercentageAmt();
        $("#ComponentModal").modal("show");
    });
}
function deleteComponent(empCd, edCd, edTyp, srNo) {
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
            deleteAjax(`/Employee/DeleteComponent?empCd=${empCd}&edCd=${edCd}&edTyp=${edTyp}&srNo=${srNo}`, function (response) {
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
        postAjax("/Employee/SaveComponent", frm.serialize(), function (response) {
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

function bindComponentClass(e) {
    $("#EdCd").empty();
    getAjax(`/Employee/FetchComponentClassItems?type=${e.value}`, function (response) {
        var html = ''
        $.each(response, function (i, item) {
            html += `<option value='${item.value}'>${item.text}</option>`
        })
        $("#EdCd").html(html);
        $("#EdCd").attr("title", "-- Select --");
        $('.select-picker').selectpicker('refresh');
    });
}

function showAddressModal(empCd, type) {
    empCd = empCd ? empCd : empCode;
    var url = `/Employee/GetAddress?empCd=${encodeURI(empCd)}&type=${type}`;
    $('#AddressModal').load(url, function () {
        parseDynamicForm();
        $("#AddressModal").modal("show");
    });
}
function saveAddress(btn) {
    var frm = $("#address-frm");
    if (frm.valid()) {
        loadingButton(btn);
        postAjax("/Employee/SaveAddress", frm.serialize(), function (response) {
            if (response.success) {
                showSuccessToastr(response.message);
                $("#AddressModal").modal("hide");
                bindAddresses(empCode);
            }
            else {
                showErrorToastr(response.message);
                $("#AddressModal").modal("hide");
            }
            unloadingButton(btn);
        });
    }
}
function deleteAddress(empCd, type) {
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
            deleteAjax(`/Employee/DeleteAddress?empCd=${encodeURI(empCd)}&type=${type}`, function (response) {
                showSuccessToastr(response.message);
                bindAddresses(empCode);
            });
        }
    });
}
function bindAddresses(empCd) {
    $('#Addresses').load(`/Employee/FetchAddresses?empCd=${encodeURI(empCd)}`);
}