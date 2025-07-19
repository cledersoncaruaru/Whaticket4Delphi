document.addEventListener( "DOMContentLoaded", () => {


    // Sparline global options
    const options = {
        cursorWidth: 1,
        spotRadius: 3,
        onmousemove(e, datapoint) {

            // Get current SVG Element
            const svg = e.target.parentElement;


            // Cache the tooltip selector
            if( !svg.tooltip ) {
                svg.tooltip = svg.parentElement.querySelector(".tooltip");
                svg.tooltipInner = svg.tooltip.querySelector( ".tooltip-inner" );
            }


            // Tooltip positions
            svg.tooltip.classList.add("show");
            svg.tooltipInner.textContent = ( svg.dataset.labelSuffix || "" ) + datapoint.value + ( svg.dataset.labelPrefix || "" );
            svg.tooltip.setAttribute( "style", `left: ${ e.pageX - (svg.tooltip.clientWidth / 2) }px; top: ${ e.pageY - window.scrollY + 25 }px` );
        },
        onmouseout(e) {
            e.target.parentElement.tooltip.classList.remove("show");
        }
    }


    // Sparkline data sample
    const sparklineData = [ 1, 3, 2, 4, 3, 7, 4, 15, 19, 14, 12, 7, 2, 3, 5, 4, 2, 3, 5, 3, 2, 3, 1, 9, 15, 22, 40, 35, 25, 23, 14, 15, 7, 3, 2, 4, 3, 7, 4, 15, 19, 14, 12, ];


    // Initialize sparkline
    // ----------------------------------------------
    document.querySelectorAll( ".sparkline" ).forEach( sprk => {
        if( sprk.classList.contains("with-tooltip") ){

            // Initialize Sparkline with the tooltip option.
            sparkline.sparkline( sprk, sparklineData, options);

        } else {

            // Initialize default sparkline.
            sparkline.sparkline( sprk, sparklineData );

        }
    });

})

