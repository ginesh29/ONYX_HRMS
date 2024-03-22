$.validator.addMethod("eitherOrRequired", function (value, element, options) {
    var $group = $(options[0], element.form);
    var isValid = false;
    $group.each(function () {
        if ($(this).val()) {
            isValid = true;
            return false;
        }
    });
    return isValid || value;
}, "Please fill out at least one field.");