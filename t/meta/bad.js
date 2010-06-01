
alert("Failing, bad javascript");

/* This below is bad JS which will fail in IE, due to trailing comma */
$("#foo").dialog({
    autoOpen: false,
    modal: false,
});

