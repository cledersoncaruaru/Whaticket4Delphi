document.addEventListener( "DOMContentLoaded", () => {


    // Icons variables
    // ----------------------------------------------
    const iconContainer   = document.getElementById("_dm-iconContainer");
    const iconButtons     = [...document.querySelectorAll( "._dm-iconButton" )];
    const currentIconsPack      = (function (){
        let currentIconPack = "default";
        if ( iconContainer.classList.contains("ionicons") ) currentIconPack = "ionicons";
        else if ( iconContainer.classList.contains("flag-icons") ) currentIconPack = "flag-icons";

        return currentIconPack;
    }());



    // Toast variables
    // ----------------------------------------------
    const toastContainer  = document.getElementById( "_dm-toastIcons" );
    const toast           = new bootstrap.Toast( toastContainer );
    const toastTitle      = document.getElementById( "_dm-iconName" );
    const toastInput      = document.getElementById( "_dm-iconTag" );



    // Remove the active class from all Icon buttons.
    // ----------------------------------------------
    const removeActiveClass = () => {
        let a = document.querySelector( "._dm-iconButton.active" );
        if (a) a.classList.remove("active");
    }



    // Detect clicking from outside the container.
    // ----------------------------------------------
    const clickOutsideContainer = (e) => {
        const withinBoundaries = e.composedPath().includes( e.target.closest("._dm-iconWrap") );
        const withinBoundaries2 = e.composedPath().includes( toastContainer );

        if (!withinBoundaries && !withinBoundaries2) {
            removeActiveClass();
            toast.hide();
            document.removeEventListener( "click", clickOutsideContainer );
        }
    }


    // All icon buttons event
    // ----------------------------------------------
    iconButtons.forEach( iconBtn => {
        iconBtn.addEventListener( "click", e => {

            // Toogle active class
            removeActiveClass();
            iconBtn.classList.add("active");


            // Fill in all the icon details on the toast screen.
            let thisIconName = iconBtn.firstChild.getAttribute( "name" );
            if( !thisIconName ) thisIconName = iconBtn.firstChild.getAttribute( "class" );

            let toastName = thisIconName.replace( /^ti-/g, "" );
            toastName = toastName.replace( /^wi wi-wind wi-wind/g, "Wind" );
            toastName = toastName.replace( /^wi wi-wind/g, "Wind" );
            toastName = toastName.replace( /^wi wi-/g, "" );
            toastName = toastName.replace( /^pli-/g, "" );
            toastName = toastName.replace( /^psi-/g, "" );
            toastTitle.innerText = toastName.replace( /\-/g, " " );


            if( currentIconsPack == "ionicons" ) {
                toastInput.value = `<ion-icon name="${ thisIconName }"></ion-icon>`;
            } else if ( currentIconsPack == "flag-icons" ) {
                let cld = iconBtn.querySelector("._dm-countryName");
                toastTitle.innerText = cld.innerText;
                toastInput.value = `<i class="flag-icon flag-icon-${ cld.getAttribute("data-alpha") }"></i>`;
            } else {
                toastInput.value = `<i class="${ thisIconName }"></i>`;
            }


            // Show the toast and detect all clicks outside the container.
            toast.show();
            document.addEventListener( "click", clickOutsideContainer );
        });
    })
});