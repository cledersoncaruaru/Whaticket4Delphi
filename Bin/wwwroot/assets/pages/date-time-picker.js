
/* -- MCDATEPICKER PLUGIN --*/
/* ---------------------------------------------- */


// MCDatepicker default
// ----------------------------------------------
const datePickerModal = MCDatepicker.create({
    el: "#_dm-mcDatepicker-modal",
    dateFormat: "dddd, dd-mmmm-yyyy"
});



// MCDatepicker with inline bodyType
// ----------------------------------------------
const datePickerInline = MCDatepicker.create({
    el: "#_dm-mcDatepicker-inline",
    bodyType: "inline",
    dateFormat: "mmmm dd, yyyy"
});



// Open the MCDatepicker while the button is being clicked
// ----------------------------------------------
const datePickerMethod = MCDatepicker.create({
    el: "#_dm-mcDatepicker-method",
    bodyType: "modal",
    dateFormat: "mm/dd/yyyy"
});

document.querySelector( "#_dm-mcDatepicker-btn" ).addEventListener( "click", () => {
    datePickerMethod.open();
});

/* ---------------------------------------------- */
/* -- END : MCDATEPICKER PLUGIN --*/





/* -- LITEPICKER PLUGIN --*/
/* ---------------------------------------------- */


// Single date picker
new Litepicker({
    element: document.getElementById( "_dm-litePicker-single" ),
    singleMode: true
})


// Date range with tooltip
new Litepicker({
    element: document.getElementById( "_dm-litePicker-dateRange" ),
    singleMode: false,
    numberOfMonths: 2,
    numberOfColumns: 2,
    tooltipText: {
        one: "day",
        other: "days"
    },
    tooltipNumber: (totalDays) => {
        return totalDays - 1;
    }
})


const currentTime = new Date();
const currentMonth = (currentTime.getMonth() + 1).toString().padStart(2, "0");
const currentYear = currentTime.getFullYear();
const allowedDates = [
    `${ currentYear }-${ currentMonth }-01`, `${ currentYear }-${ currentMonth }-04`, `${ currentYear }-${ currentMonth }-07`,
    `${ currentYear }-${ currentMonth }-12`, `${ currentYear }-${ currentMonth }-15`, `${ currentYear }-${ currentMonth }-19`,
    `${ currentYear }-${ currentMonth }-24`, `${ currentYear }-${ currentMonth }-28`,
];


new Litepicker({
    element: document.getElementById( "_dm-litePicker-allowedDates" ),
    singleMode: false,
    numberOfMonths: 2,
    numberOfColumns: 2,
    startDate: allowedDates[0],
    lockDaysFilter: (date1, date2, pickedDates) => {
        return !allowedDates.includes(date1.format("YYYY-MM-DD"));
    }
})

/* ---------------------------------------------- */
/* -- END : LITEPICKER PLUGIN --*/



/* -- MD DATE TIME PICKER -- */
/* ---------------------------------------------- */

// Date format options
const dateFormatOption = { weekday: "long", year: "numeric", month: "long", day: "numeric" };


// LANDSCAPE VERSION
// ----------------------------------------------

// Date picker
// ----------------------------------------------

// Initialize the date dialog
const mdPicker_Date = new mdDateTimePicker.default({ type: "date" });
const mdPicker_DateInput = document.querySelector( "#_dm-mdDateTimePicker-showDate" );


// Dispatch input event
mdPicker_Date.trigger = mdPicker_DateInput;


// Text input events
mdPicker_DateInput.addEventListener( "focus", () => mdPicker_Date.toggle() );
mdPicker_DateInput.addEventListener( "onOk", () => mdPicker_DateInput.value = new Date(mdPicker_Date.time.toString()).toLocaleDateString( [], dateFormatOption ) );

// ----------------------------------------------
// END : Date picker




// Time picker
// ----------------------------------------------

// Initialize the time dialog
const mdPicker_Time = new mdDateTimePicker.default({ type: "time" });
const mdPicker_TimeInput = document.querySelector( "#_dm-mdDateTimePicker-showTime" );


// Dispatch input event
mdPicker_Time.trigger = mdPicker_TimeInput;


// Text input events
mdPicker_TimeInput.addEventListener( "focus", () => mdPicker_Time.toggle() );
mdPicker_TimeInput.addEventListener( "onOk", () => mdPicker_TimeInput.value = new Date(mdPicker_Time.time.toString()).toLocaleTimeString( [], { hour: "2-digit", minute: "2-digit" }  ) );

// ----------------------------------------------
// END : Time picker



// Show the picker when button is clicked
// ----------------------------------------------

// Initialize the date dialog
const mdPicker_DatePicker = new mdDateTimePicker.default({ type: "date" });
const mdPicker_DatePickerInput = document.querySelector( "#_dm-mdDateTimePicker-input" );
const mdPicker_DatePickerBtn = document.querySelector( "#_dm-mdDateTimePicker-btn" );


// Dispatch input event
mdPicker_DatePicker.trigger = mdPicker_DatePickerInput;


// Text input events
mdPicker_DatePickerBtn.addEventListener( "click", () => mdPicker_DatePicker.toggle() );
mdPicker_DatePickerInput.addEventListener( "onOk", () => mdPicker_DatePickerInput.value = new Date(mdPicker_DatePicker.time.toString()).toLocaleDateString( [], dateFormatOption ) );

// ----------------------------------------------
// END : Show the picker when button is clicked

// END : LANDSCAPE VERSION



// PORTRAIT VERSION
// ----------------------------------------------


// Date Picker
// ----------------------------------------------

// Initialize the date dialog
const mdPicker_DatePortrait = new mdDateTimePicker.default({
    type: "date",
    orientation: "PORTRAIT"
});
const mdPicker_DatePortraitInput = document.querySelector( "#_dm-mdDateTimePicker-showDate-portrait" );


// Dispatch input event
mdPicker_DatePortrait.trigger = mdPicker_DatePortraitInput;


// Text input events
mdPicker_DatePortraitInput.addEventListener( "focus", () => mdPicker_DatePortrait.toggle() );
mdPicker_DatePortraitInput.addEventListener( "onOk", () => mdPicker_DatePortraitInput.value = new Date(mdPicker_DatePortrait.time.toString()).toLocaleDateString( [], dateFormatOption ) );

// ----------------------------------------------
// END : Date Picker



// Time Picker
// ----------------------------------------------

// Initialize the time dialog
const mdPicker_TimePortrait = new mdDateTimePicker.default({
    type: "time",
    orientation: "PORTRAIT"
});
const mdPicker_TimePortraitInput = document.querySelector( "#_dm-mdDateTimePicker-showTime-portrait" );


// Dispatch input event
mdPicker_TimePortrait.trigger = mdPicker_TimePortraitInput;


// Text input events
mdPicker_TimePortraitInput.addEventListener( "focus", () => mdPicker_TimePortrait.toggle() );
mdPicker_TimePortraitInput.addEventListener( "onOk", () => mdPicker_TimePortraitInput.value = new Date(mdPicker_TimePortrait.time.toString()).toLocaleTimeString( [], { hour: "2-digit", minute: "2-digit" }  ) );

// ----------------------------------------------
// END : Time Picker



// Show the picker when button is clicked
// ----------------------------------------------

// Initialize the date dialog
const mdPicker_DatePickerPortrait = new mdDateTimePicker.default({
    type: "date",
    orientation: "PORTRAIT"
});
const mdPicker_DatePickerPortraitInput = document.querySelector( "#_dm-mdDateTimePicker-portraitInput" );
const mdPicker_DatePickerPortraitBtn = document.querySelector( "#_dm-mdDateTimePicker-portraitBtn" );


// Dispatch input event
mdPicker_DatePickerPortrait.trigger = mdPicker_DatePickerPortraitInput;


// Text input events
mdPicker_DatePickerPortraitBtn.addEventListener( "click", () => mdPicker_DatePickerPortrait.toggle() );
mdPicker_DatePickerPortraitInput.addEventListener( "onOk", () => mdPicker_DatePickerPortraitInput.value = new Date(mdPicker_DatePickerPortrait.time.toString()).toLocaleDateString( [], dateFormatOption ) );

// ----------------------------------------------
// END : Show the picker when button is clicked

// END : PORTRAIT VERSION