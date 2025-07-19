document.addEventListener( "DOMContentLoaded", () => {

    // Default Classname for all tables
    // ----------------------------------------------
    const defaultClassName = {
        table: 'table table-striped',
        search: "form-control",
        header: "d-flex justify-content-end"
    };



    // Basic Example
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        columns: [ "ID", "Name", "Date", "Amount", "Status" ],
        pagination: {
            limit: 5
        },
        server:{
            url: "https://themeon.net/nifty/v3.0.1/assets/data/data-tables.json",
            then: data => data.map(user =>
                [ user.id, user.name, user.date, user.amount, user.status ]
            )
        },
    }).render( document.getElementById( "_dm-gridjsBasic" ));



    // Sorting
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        columns: [ "ID", "Name", "Last Login", "Amount" ],
        sort: true,
        data: [
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ]
        ],
    }).render( document.getElementById( "_dm-gridjsSorting" ));



    // Resizable Columns
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        columns: [ "ID", "Name", "Last Login", "Amount" ],
        resizable: true,
        data: [
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ]
        ],
    }).render( document.getElementById( "_dm-gridjsResizableCol" ));



    // Fixed Header
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        columns: [ "ID", "Name", "Last Login", "Amount" ],
        fixedHeader: true,
        height: "285px",
        data: [
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ],
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ],
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ]
        ],
    }).render( document.getElementById( "_dm-gridjsFixedHeader" ));



    // Hidden Columns
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        columns: [ {
                name: 'ID',
                hidden: true
            }, {
                name: 'Name',
                hidden: true
            },
            "Last Login", "Amount" ],
        resizable: true,
        data: [
            [ 53454, "Charles S Boyle", "Today 01:25 PM", "$132.20" ],
            [ 53453, "Steve N. Horton", "Today 11:03 AM", "$74.00" ],
            [ 53452, "Lucy Doe", "Today 10:56 PM", "$12.00" ],
            [ 53451, "Teresa L. Doe", "Yesterday 05:25 PM", "$532.99" ],
            [ 53450, "Lucy Doe", "Yesterday 03:25 PM", "$45.00" ]
        ],
    }).render( document.getElementById( "_dm-gridjsHiddenCol" ));



    // Cell formatting
    // ----------------------------------------------
    new gridjs.Grid({
        className: defaultClassName,
        search: true,
        pagination: {
            limit: 7
        },
        columns: [
            {
                name: "ID",
                formatter: (cell) => {
                    return gridjs.h( "a", {
                        href: "#",
                        className: "btn-link"
                    }, cell)
                }
            },
            "Name",
            {
                name: "Date",
                formatter: (cell) => gridjs.html(`<i class="demo-pli-clock text-muted align-middle me-2"></i>${cell}`)
            },
            "Amount",
            {
                name: "Status",
                formatter: (cell) => {
                    let bgColor;
                    switch( cell ) {
                    case "Paid":
                        bgColor = "bg-success";
                        break;
                    case "Unpaid":
                        bgColor = "bg-warning";
                        break;
                    case "Shipped":
                        bgColor = "bg-info";
                        break;
                    case "Refunded":
                        bgColor = "bg-danger";
                        break;
                    }
                    return gridjs.html(`<span class="d-block rounded fw-bold text-white text-center ${ bgColor }">${cell}</span>`)
                }
            },
            "Membership",
            "Tracking Number"
            ],

           server:{
            url: "https://themeon.net/nifty/v3.0.1/assets/data/data-tables.json",
            then: data => data.map(user =>
                [ user.id, user.name, user.date, user.amount, user.status, user.user_status, user.track ]
            )
        },
    }).render( document.getElementById( "_dm-gridjsCellformatting" ));

});



