$(function () {
    markMenu();
    alertify.set('notifier', 'delay', 3.5);
    alertify.confirm().setting({
        'transition': 'zoom',
    });

    setInterval(function () {
        jQuery.post("/Login/Live", null, function () { });
    }, 60000);

    //khởi tạo tooltip
    $('[data-toggle="tooltip"]').tooltip();
});

function markMenu() {
    $('.menu-left').removeClass('active');
    let url = window.location.pathname;
    $('.menu-left').each(function () {
        let mark = $(this).attr('data-mark');
        if (url.includes(mark)) {
            $(this).closest('li').addClass('active');
            return false;
        }
    });
}

/** Khởi tạo Autonumeric */
$('.autonumeric').autoNumeric('init', { aSep: ',', lZero: 'deny', wEmpty: 'zero', vMin: 0, aPad: false, mRound: 'A' });

/** Khởi tạo Select2 Search */
$('.select2').select2({ width: '100%' });

/** Khởi tạo Select2 UnSearch */
$('.select2-nosearch').select2({ width: '100%', minimumResultsForSearch: -1 });

/** Khởi tạo iCheck */
$('input[type="radio"], input[type="checkbox"]').iCheck({ radioClass: 'iradio_minimal-blue', checkboxClass: 'icheckbox_minimal-blue' });

/** Khởi tạo Datepicker */
$('.datepicker').datepicker({ autoclose: true, format: 'dd/mm/yyyy', ignoreReadonly: true  });

/** Draggable Modal */
$('.modal').on('show.bs.modal', function (e) {
    $(".modal-content", $(this)).draggable({ handle: ".modal-header", containment: "body" });
});

/** Config Alertify*/
alertify.set('notifier', 'delay', 3.5);
alertify.confirm().setting({
    'title': 'Thông báo',
    'labels': { ok: 'Đồng ý', cancel: 'Bỏ qua' }
});

alertify.alert().setting({
    'title': 'Thông báo',
    'label': 'Xác nhận'
});

/** Cấu hình Daterangepicker (VI) */
let optionDaterangepicker = {
    autoUpdateInput: false,
    applyButtonClasses: 'btn-success',
    cancelButtonClasses: 'btn-default',
    ranges: {
        'Hôm nay': [moment(), moment()],
        'Hôm qua': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        '7 ngày qua': [moment().subtract(6, 'days'), moment()],
        '30 ngày qua': [moment().subtract(29, 'days'), moment()],
        'Tháng này': [moment().startOf('month'), moment().endOf('month')],
        'Tháng trước': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
        'Năm này': [moment().startOf('year'), moment().endOf('year')]
    },
    'locale': {
        'format': 'DD/MM/YYYY',
        'separator': ' - ',
        'applyLabel': 'Chọn',
        'cancelLabel': 'Xóa',
        'fromLabel': 'Từ',
        'toLabel': 'Đến',
        'customRangeLabel': 'Tùy chọn',
        'weekLabel': 'W',
        'daysOfWeek': ['C', 'H', 'B', 'T', 'N', 'S', 'B'],
        'monthNames': ['Tháng Giêng', 'Tháng Hai', 'Tháng Ba', 'Tháng Tư', 'Tháng Năm', 'Tháng Sáu', 'Tháng Bảy', 'Tháng Tám', 'Tháng Chín', 'Tháng Mười', 'Tháng Mười Một', 'Tháng Mười Hai'],
        'firstDay': 1
    }
}

function logOut() {
    alertify.confirm('Bạn có chắc chắn muốn thoát khỏi ứng dụng?', function () {
        document.location.href = "/Home/LogOut";
    });
}

(function ($) {
    $.fn.inputFilter = function (inputFilter) {
        return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
            if (inputFilter(this.value)) {
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
            } else if (this.hasOwnProperty("oldValue")) {
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
            }
        });
    };
}(jQuery));