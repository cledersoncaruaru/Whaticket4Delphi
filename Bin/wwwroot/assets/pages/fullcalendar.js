document.addEventListener( "DOMContentLoaded", () => {



    // Demo purpose - Set the event based on the current year and month.
    // ----------------------------------------------
    const today         = new Date();
    const currentYear   = today.getFullYear();
    const currentMonth  = (today.getMonth() + 1).toString().padStart(2, "0");



    // Initialize the FullCalendar
    // ----------------------------------------------
    const calendar = new FullCalendar.Calendar( document.getElementById( "_dm-calendar" ), {
        timeZone: "UTC",
        editable: true,
        droppable: true, // this allows things to be dropped onto the calendar
        dayMaxEvents: true, // allow "more" link when too many events
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listMonth"
        },

        themeSystem: "bootstrap",

        bootstrapFontAwesome: {
            close: " demo-psi-cross",
            prev: " demo-psi-arrow-left",
            next: " demo-psi-arrow-right",
            prevYear: " demo-psi-arrow-left-2",
            nextYear: " demo-psi-arrow-right-2"
        },

        events: [
            {
                title       : "Happy Hour",
                start       : `${ currentYear }-${ currentMonth }-05`,
                end         : `${ currentYear }-${ currentMonth }-07`,
                className   : "bg-purple"
            },
            {
                title       : "Birthday Party",
                start       : `${ currentYear }-${ currentMonth }-15`,
                end         : `${ currentYear }-${ currentMonth }-19`,
                className   : "bg-secondary"
            },
            {
                title: "All Day Event",
                start: `${ currentYear }-${ currentMonth }-15`,
                className: "bg-warning"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth }-20T10:30:00`,
                end: `${ currentYear }-${ currentMonth }-20T12:30:00`,
                className: "bg-danger text-white"
            },
            {
                title: "All Day Event",
                start: `${ currentYear }-${ currentMonth + 1 }-01`,
                className: "bg-warning"
            },
            {
                title: "Long Event",
                start: `${ currentYear }-${ currentMonth + 1 }-07`,
                end: `${ currentYear }-${ currentMonth + 1 }-10`,
                className: "bg-purple"
            },
            {
                id: 999,
                title: "Repeating Event",
                start: `${ currentYear }-${ currentMonth + 1 }-09T16:00:00`
            },
            {
                id: 999,
                title: "Repeating Event",
                start: `${ currentYear }-${ currentMonth + 1 }-16T16:00:00`,
                className: "bg-success text-white"
            },
            {
                title: "Conference",
                start: `${ currentYear }-${ currentMonth + 1 }-11`,
                end: `${ currentYear }-${ currentMonth + 1 }-13`,
                className: "bg-dark"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth + 1 }-12T10:30:00`,
                end: `${ currentYear }-${ currentMonth + 1 }-12T12:30:00`
            },
            {
                title: "Lunch",
                start: `${ currentYear }-${ currentMonth + 1 }-12T12:00:00`,
                className: "bg-pink"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth + 1 }-12T14:30:00`
            },
            {
                title: "Happy Hour",
                start: `${ currentYear }-${ currentMonth + 1 }-12T17:30:00`
            },
            {
                title: "Dinner",
                start: `${ currentYear }-${ currentMonth + 1 }-12T20:00:00`
            },
            {
                title: "Birthday Party",
                start: `${ currentYear }-${ currentMonth + 1 }-13T07:00:00`
            }
        ]
    });
        const events= [
            {
                title       : "Happy Hour",
                start       : `${ currentYear }-${ currentMonth }-05`,
                end         : `${ currentYear }-${ currentMonth }-07`,
                className   : "bg-purple"
            },
            {
                title       : "Birthday Party",
                start       : `${ currentYear }-${ currentMonth }-15`,
                end         : `${ currentYear }-${ currentMonth }-19`,
                className   : "bg-secondary"
            },
            {
                title: "All Day Event",
                start: `${ currentYear }-${ currentMonth }-15`,
                className: "bg-warning"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth }-20T10:30:00`,
                end: `${ currentYear }-${ currentMonth }-20T12:30:00`,
                className: "bg-danger text-white"
            },
            {
                title: "All Day Event",
                start: `${ currentYear }-${ currentMonth + 1 }-01`,
                className: "bg-warning"
            },
            {
                title: "Long Event",
                start: `${ currentYear }-${ currentMonth + 1 }-07`,
                end: `${ currentYear }-${ currentMonth + 1 }-10`,
                className: "bg-purple"
            },
            {
                id: 999,
                title: "Repeating Event",
                start: `${ currentYear }-${ currentMonth + 1 }-09T16:00:00`
            },
            {
                id: 999,
                title: "Repeating Event",
                start: `${ currentYear }-${ currentMonth + 1 }-16T16:00:00`,
                className: "bg-success text-white"
            },
            {
                title: "Conference",
                start: `${ currentYear }-${ currentMonth + 1 }-11`,
                end: `${ currentYear }-${ currentMonth + 1 }-13`,
                className: "bg-dark"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth + 1 }-12T10:30:00`,
                end: `${ currentYear }-${ currentMonth + 1 }-12T12:30:00`
            },
            {
                title: "Lunch",
                start: `${ currentYear }-${ currentMonth + 1 }-12T12:00:00`,
                className: "bg-pink"
            },
            {
                title: "Meeting",
                start: `${ currentYear }-${ currentMonth + 1 }-12T14:30:00`
            },
            {
                title: "Happy Hour",
                start: `${ currentYear }-${ currentMonth + 1 }-12T17:30:00`
            },
            {
                title: "Dinner",
                start: `${ currentYear }-${ currentMonth + 1 }-12T20:00:00`
            },
            {
                title: "Birthday Party",
                start: `${ currentYear }-${ currentMonth + 1 }-13T07:00:00`
            }
        ]
console.log(events);
    calendar.render();

});