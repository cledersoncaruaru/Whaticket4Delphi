document.addEventListener( "DOMContentLoaded", () => {


    // DEFINE DATAS
    // ----------------------------------------------
    const simpleData = [
        {id:1, name:"Billy Bob", age:"12", gender:"male", height:1, col:"red", dob:"", cheese:1},
        {id:2, name:"Mary May", age:"1", gender:"female", height:2, col:"blue", dob:"14/05/1982", cheese:true},
        {id:3, name:"Christine Lobowski", age:"42", gender:"female", height:0, col:"green", dob:"22/05/1982", cheese:"true"},
        {id:4, name:"Brendon Philips", age:"125", gender:"male", gender:"male", height:1, col:"orange", dob:"01/08/1980"},
        {id:5, name:"Margret Marmajuke", age:"16", gender:"female", height:5, col:"yellow", dob:"31/01/1999"}
    ]

    let moreData = [
        {id:6, name:"Frank Harbours", age:"12", gender:"male", height:1, col:"red", dob:"", cheese:1},
        {id:7, name:"Gemma Jane", age:"1", gender:"female", height:2, col:"blue", dob:"14/05/1982", cheese:true},
        {id:8, name:"Margret Marmajuke", gender:"female", age:"42", height:0, col:"green", dob:"22/05/1982", cheese:"true"},
        {id:9, name:"James Newman", age:"125", gender:"male", height:1, col:"orange", dob:"01/08/1980"},
        {id:10, name:"Brendon Philips", age:"16", gender:"male", height:5, col:"yellow", dob:"31/01/1999"},
    ]

    // Join two arrays
    moreData = simpleData.concat(moreData);





    // DEFINE TABLES
    // ----------------------------------------------

    // Basic table
    // ----------------------------------------------
    const basicTable = new Tabulator( "#_dm-tabulatorBasic", {
        data: simpleData,
        autoColumns: true,
        layout:"fitColumns"
    })



    // Formatting Headers
    // ----------------------------------------------
    const formattingHeaders = new Tabulator("#_dm-tabulatorFormatHead", {
        data: simpleData,
        layout:"fitColumns",
        columns:[
            {title:"Name", field:"name", sorter:"string", width:200, editor:true},
            {title:"Age", field:"age", sorter:"number", hozAlign:"right", formatter:"progress"},
            {title:"Gender", field:"gender", sorter:"string", cellClick:function(e, cell){console.log("cell click")},},
            {title:"Height", field:"height", formatter:"star", hozAlign:"center", width:100},
            {title:"Favourite Color", field:"col", sorter:"string"},
            {title:"Date Of Birth", field:"dob", sorter:"date", hozAlign:"center"},
            {title:"Cheese Preference", field:"cheese", sorter:"boolean", hozAlign:"center", formatter:"tickCross"},
        ],
    });



    // Formatting Headers
    // ----------------------------------------------
    const stripedRows = new Tabulator("#_dm-tabulatorStriped", {
        data: simpleData,
        layout:"fitColumns",
        columns:[
            {title:"Name", field:"name", sorter:"string" },
            {title:"Age", field:"age", sorter:"number" },
            {title:"Gender", field:"gender", sorter:"string" },
            {title:"Favourite Color", field:"col", sorter:"string" }
        ],
    });



    // Bordered tables
    // ----------------------------------------------
    const borderedTables = new Tabulator("#_dm-tabulatorBorderedTable", {
        data: simpleData,
        layout:"fitColumns",
        columns:[
            {title:"Name", field:"name", sorter:"string" },
            {title:"Age", field:"age", sorter:"number" },
            {title:"Gender", field:"gender", sorter:"string" },
            {title:"Favourite Color", field:"col", sorter:"string" }
        ],
    });



    // Pagination tables
    // ----------------------------------------------
    const paginationTable = new Tabulator("#_dm-tabulatorPagination", {
        data: moreData,
        layout:"fitColumns",
        pagination:"local",
        paginationSize: 5,
        paginationSizeSelector:[ 3, 5, 7, 10],
        columns:[
            {title:"Name", field:"name", sorter:"string" },
            {title:"Age", field:"age", sorter:"number" },
            {title:"Gender", field:"gender", sorter:"string" },
            {title:"Favourite Color", field:"col", sorter:"string" }
        ],
    });



    // Editing data
    // ----------------------------------------------
    const editDataTable = new Tabulator("#_dm-tabulatorEditData", {
        data: moreData,
        layout:"fitColumns",
        pagination:"local",
        paginationSize: 5,
        paginationSizeSelector:[ 3, 5, 7, 10],
        columns:[
            {title:"Name", field:"name", sorter:"string", width: 200, editor:true },
            {title:"Age", field:"age", sorter:"number" },
            {title:"Gender", field:"gender", sorter:"string" },
            {title:"Favourite Color", field:"col", sorter:"string" }
        ],
    });



    // Formatting data
    // ----------------------------------------------
    const questionIcon = () => '<i class="demo-pli-question fs-5"></i>';
    const formattingData = new Tabulator("#_dm-tabulatorFormatData", {
        data: moreData,
        layout:"fitColumns",
        height:"300px",
        columns:[
            {title:"Who", formatter: questionIcon, width:70, hozAlign:"center", cellClick:function(e, cell){alert("Printing row data for: " + cell.getRow().getData().name)}},
            {title:"Name", field:"name", sorter:"string", width:200, editor:true},
            {title:"Age", field:"age", sorter:"number", hozAlign:"left", formatter:"progress"},
            {title:"Gender", field:"gender", sorter:"string", hozAlign:"center" },
            {title:"Height", field:"height", formatter:"star", hozAlign:"center", width:100},
            {title:"Favourite Color", field:"col", hozAlign:"center", sorter:"string", formatter:"color"},
            {title:"Date Of Birth", field:"dob", sorter:"date", hozAlign:"center"},
            {title:"Cheese Preference", field:"cheese", sorter:"boolean", hozAlign:"center", formatter:"tickCross"},
        ],
    });



    // Filter Data
    // ----------------------------------------------
    // Define variables for input elements
    const fieldEl = document.getElementById( "_dm-filterField" );
    const typeEl  = document.getElementById( "_dm-filterType" );
    const valueEl = document.getElementById( "_dm-filterValue" );

    //Custom filter example
    function customFilter( data ) {
        return data.car && data.rating < 3;
    }

    //Trigger setFilter function with correct parameters
    function updateFilter(){
        let filterVal = fieldEl.options[fieldEl.selectedIndex].value;
        let typeVal = typeEl.options[typeEl.selectedIndex].value;

        const filter = filterVal == "function" ? customFilter : filterVal;

        if( filterVal == "function" ){
            typeEl.disabled = true;
            valueEl.disabled = true;
        } else {
            typeEl.disabled = false;
            valueEl.disabled = false;
        }

        if( filterVal ) filteredTable.setFilter(filter,typeVal, valueEl.value);
    }


    //Update filters on value change
    document.getElementById( "_dm-filterField").addEventListener( "change", updateFilter );
    document.getElementById( "_dm-filterType").addEventListener( "change", updateFilter );
    document.getElementById( "_dm-filterValue").addEventListener( "keyup", updateFilter );


    //Clear filters on "Clear Filters" button click
    document.getElementById( "_dm-filterClear").addEventListener( "click", function(){
        fieldEl.value = "none";
        typeEl.value = "like";
        valueEl.value = "";

        filteredTable.clearFilter();
    });


    //Build Tabulator
    const filteredTable = new Tabulator("#_dm-tabulatorFilter", {
        data: [
            {id:1, name:"Oli Bob", progress:12, location:"United Kingdom", gender:"male", rating:1, col:"red", dob:"14/04/1984", car:1, lucky_no:5, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:2, name:"Mary May", progress:1, location:"Germany", gender:"female", rating:2, col:"blue", dob:"14/05/1982", car:true, lucky_no:10, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:3, name:"Christine Lobowski", progress:42, location:"France", gender:"female", rating:0, col:"green", dob:"22/05/1982", car:"true", lucky_no:12, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:4, name:"Brendon Philips", progress:100, location:"USA", gender:"male", rating:1, col:"orange", dob:"01/08/1980", car:false, lucky_no:18, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:5, name:"Margret Marmajuke", progress:16, location:"Canada", gender:"female", rating:5, col:"yellow", dob:"31/01/1999", car:false, lucky_no:33, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:6, name:"Frank Harbours", progress:38, location:"Russia", gender:"male", rating:4, col:"red", dob:"12/05/1966", car:1, lucky_no:2, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:7, name:"Jamie Newhart", progress:23, location:"India", gender:"male", rating:3, col:"green", dob:"14/05/1985", car:true, lucky_no:63, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:8, name:"Gemma Jane", progress:60, location:"China", gender:"female", rating:0, col:"red", dob:"22/05/1982", car:"true", lucky_no:72, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:9, name:"Emily Sykes", progress:42, location:"South Korea", gender:"female", rating:1, col:"maroon", dob:"11/11/1970", car:false, lucky_no:44, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
            {id:10, name:"James Newman", progress:73, location:"Japan", gender:"male", rating:5, col:"red", dob:"22/03/1998", car:false, lucky_no:9, lorem:"Lorem ipsum dolor sit amet, elit consectetur adipisicing "},
        ],
        height:"300px",
        layout:"fitColumns",
        columns:[
            {title:"Name", field:"name", width:200},
            {title:"Progress", field:"progress", formatter:"progress", sorter:"number"},
            {title:"Gender", field:"gender"},
            {title:"Rating", field:"rating", formatter:"star", hozAlign:"center", width:100},
            {title:"Favourite Color", field:"col"},
            {title:"Date Of Birth", field:"dob", hozAlign:"center", sorter:"date"},
            {title:"Driver", field:"car", hozAlign:"center", formatter:"tickCross"},
        ],
    });
})