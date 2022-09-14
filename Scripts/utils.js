function getLastSegment() {
    var pageURL = window.location.href;
    var lastURLSegment = pageURL.substr(pageURL.lastIndexOf('/') + 1);
    return lastURLSegment;
}

//Kiểm tra email
function isEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

//Get url param
function getParam(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

//Delay
var delay = (function () {
    var timer = 0;
    return function (callback, ms) {
        clearTimeout(timer);
        timer = setTimeout(callback, ms);
    };
})();

function isVNDate(input) {
    var pattern = /^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/;
    return pattern.test(input);
}

function getDateCurrent() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!
    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    } if (mm < 10) {
        mm = '0' + mm;
    }
    today = dd + '/' + mm + '/' + yyyy;
    return today;
};

function clearVN(str) {
    str = str.toLowerCase();
    str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
    str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
    str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
    str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
    str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
    str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
    str = str.replace(/đ/g, "d");
    return str;
}

function clearSpecial(str) {
    return str.replace(/[^a-z0-9\s]/gi, '').replace(/[_\s]/g, '-');
}

function randomText(num) {
    var text = "";
    var possible = "@#ABCDEFGHIJKLMNOPQRSTUVWXYZ@#abcdefghijklmnopqrstuvwxyz@#0123456789@#";
    for (var i = 0; i < num; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    return text;
}

function showWaiting(elementID) {
    if (elementID == undefined) {
        elementID = 'page';
    }
    $('#' + elementID).waitMe({
        effect: 'ios',
        text: '',
        bg: 'rgba(255,255,255,0.0)',
        color: '#3c8dbc',
        maxSize: 39,
        waitTime: -1,
        source: '',
        textPos: '',
        fontSize: '',
        onClose: function (el) { }
    });
}

function closeWaiting(elementID) {
    if (elementID == undefined) {
        elementID = 'page';
    }
    $('#' + elementID).waitMe("hide");
}
//upper case
$('.inputCapital').on('input', function (evt) {
    $(this).val(function (_, val) {
        return val.toUpperCase();
    });
});

//Upper first letter
function capitalFirstLetter(str) {
    str = str.split(" ");
    for (var i = 0, x = str.length; i < x; i++) {
        str[i] = str[i][0].toUpperCase() + str[i].substr(1);
    }
    return str.join(" ");
}

function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}
