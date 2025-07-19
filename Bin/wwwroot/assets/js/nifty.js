
// Common selectors.
const body                      = document.body;
const root                      = document.getElementById("root");



// BOOTSTRAP COMPONENTS
// ----------------------------------------------

// Boostrap's Cards view mode
// ----------------------------------------------
document.querySelectorAll("[data-view]").forEach((el) => {
    el.addEventListener("click", (e) => {

        // Cache the target element
        if (!el.targetEl) {
            const targetEl = e.target.closest(e.target.getAttribute("data-view-target")) || document.querySelector(e.target.getAttribute("data-view-target"));
            el.targetEl = targetEl;
        }


        if (el.getAttribute("data-view") == "fullscreen") {
            if (el.classList.contains("active")) {
                /* View in fullscreen */
                if (el.targetEl.requestFullscreen) el.targetEl.requestFullscreen();
                else if (el.targetEl.webkitRequestFullscreen) el.targetEl.webkitRequestFullscreen(); /* Safari */
            } else {
                /* Close fullscreen */
                if (document.exitFullscreen) document.exitFullscreen();
                else if (document.webkitExitFullscreen) document.webkitExitFullscreen(); /* Safari */
            }
        } else {
            el.targetEl.classList.toggle("content-full-page");
            body.classList.toggle("body-sc");
        }
    })
});



// Boostrap's Cards Dismissable
// ----------------------------------------------
document.querySelectorAll( ".btn-close-card" ).forEach( el => el.addEventListener( "click", (e) => el.closest( ".card" ).remove()) );







// NIFTY COMPONENTS
// ----------------------------------------------

// Main navigation toggler
// ----------------------------------------------
document.querySelectorAll( ".nav-toggler" ).forEach( ( navToggler ) => {
    navToggler.addEventListener( "click", () => {
        if ( window.innerWidth < 992 || ( !root.classList.contains( "mn--min" ) && !root.classList.contains( "mn--max" ) )) {
            root.classList.toggle( "mn--show" );
        } else {
            root.classList.toggle( "mn--min" );
            root.classList.toggle( "mn--max" );
        }
    });
});



// Sidebar toggler
// ----------------------------------------------
document.querySelectorAll( ".sidebar-toggler" ).forEach( ( sidebarToggler ) => {
    sidebarToggler.addEventListener( "click", () => root.classList.toggle("sb--show") );
});



// Remove the backdrop then hide the navigation and sidebar.
// ----------------------------------------------
document.addEventListener( "click", ( e ) => {
	if ( e.target.classList.contains( "root" ) ) {
		root.classList.remove( "mn--show" );
		if (!root.classList.contains( "sb-stuck" )) root.classList.remove( "sb--show" );
	}
});



// MINIMAL AND MAXIMAL MAIN NAVIGATION PLUGIN
// ----------------------------------------------
// This plugin requires Bootstrap's collapse and PopperJS.
// Remove this plugin if you are not using the mini or max navigation.

const mainNav                   = document.getElementById( "mainnav-container" );

let isMiniNav                   = null;
let miniNavTogglers             = null;
let miniNavContents             = null;
let miniNavContentsCollapse     = null;


// Update navigation variables if #mainnav-container is available.
( function () {
    if (!mainNav) return;

    isMiniNav                   = root.classList.contains( "mn--min" );
    miniNavTogglers             = [...mainNav.querySelectorAll( ".mininav-toggle" )];
    miniNavContents             = [...mainNav.querySelectorAll( ".mininav-content" )];



    // Refresh the navigation when the transition ends.
    mainNav.addEventListener( "transitionend", (e) => {
        if (!e.target.classList.contains( "mainnav" ) || e.propertyName != "max-width" ) return;
        buildNav();
    });



    // Initialize Bootstrap's Collapse
    miniNavContentsCollapse   = miniNavContents.map(( collapseEl ) => {
        const activeToggler = collapseEl.parentElement.querySelector( ".mininav-toggle.active" );
        if ( activeToggler && ( !isMiniNav || window.innerWidth < 992 ) ) {
            const parent = collapseEl.parentElement;
            parent.classList.add( "open" );
            let clp = new bootstrap.Collapse( collapseEl, { toggle: true } );
            collapseEl.addEventListener( "transitionend", () => parent.classList.remove( "open" ), { once : true });
            return clp;
        }
        return new bootstrap.Collapse( collapseEl, { toggle: false });
    });

})();


// Default PopperJS options for the mini-navigation.
const popperOptions = {
    placement   : 'right-start',
    strategy    : 'fixed',
    modifiers   : [{
        name: 'offset',
        options: { offset: [ 0, 2 ] }
    }]
}




// Update the navigation content and toggle selectors.
const updateNav = () => {
    miniNavTogglers = [...mainNav.querySelectorAll( ".mininav-toggle" )];
    miniNavContents = [...mainNav.querySelectorAll( ".mininav-content" )];
    buildNav();
}



// Cache component variables to the toggler.
const addVariables = (el) => {
	const miniNavContentTarget = el.parentElement.querySelector( ".mininav-content" );

	el._mainnav = {
		target   : miniNavContentTarget,
		islink   : el.parentElement.classList.contains( "has-sub" ),
		collapse : function () {
			for ( let target of miniNavContentsCollapse ) {
				if ( target._element === miniNavContentTarget ) {
					return target;
					break;
				}
			}
		}()
	};


	el._mainnav.target.toggler = el;
	el._mainnav.target.addEventListener( "show.bs.collapse", bsCollapseShow );
	el._mainnav.target.addEventListener( "shown.bs.collapse", bsCollapseShow );
}



// Hides a collapsible element.
const bsCollapseHide = (e) => {
    if ( !e.target.classList.contains( "mininav-content" )) return;

    if ( !isMiniNav || window.innerWidth < 992 ) e.target.toggler.classList.add( "collapsed" );
    else e.target.removeEventListener( "hide.bs.collapse", bsCollapseHide);
}



// Shows a collapsible element.
const bsCollapseShow = ( e ) => {
    if ( !e.target.classList.contains( "mininav-content" )) return;

    if ( !isMiniNav || window.innerWidth < 992 ) {
        e.target.toggler.classList.remove( "collapsed" );
    } else {
        try {
            e.target.popper.update();
        } catch (err) {}
    }
}



// Hide all the sub-menus.
const hideAllMiniNavContent = (e) => {
	if ( window.innerWidth >= 992 && ( !mainNav.contains( e.target ) || e.target.classList.contains( "mainnav__top-content" )) ) miniNavContentsCollapse.map( ( el ) => el.hide() );
}



// Toggle the submenus
const toggleContent = (e) => {
	if ( e.target._mainnav.target.classList.contains( "nav-label" ) && ( !isMiniNav || window.innerWidth < 992 ) ) return;


    const _this = e.target._mainnav;
	if( _this.islink ) e.preventDefault();


	//  Hide all the sub-menus.
	miniNavContentsCollapse.map( async (sm) => {
		if ( !sm._element.contains( _this.target ) ) sm.hide();
	});


	// Show or Toggle the current sub-menu.
	if ( e.type == "mouseenter" ) _this.collapse.show();
	else _this.collapse.toggle();

    [ "click", "touchend" ].forEach( evt => document.addEventListener( evt, hideAllMiniNavContent, { once: true } ));
};


// Build the navigation
const buildNav = () => {
	isMiniNav = root.classList.contains( "mn--min" );
    let activeSub = null;


    // Toggle the active submenu when navigation is in a max state.
    if ( !isMiniNav ) activeSub = mainNav.querySelector(".has-sub > .mininav-toggle.nav-link.active + .mininav-content.nav");
    if ( activeSub ) activeSub.classList.add("show");


	miniNavTogglers.map( ( miniNavToggler ) => {

		if ( !miniNavToggler._mainnav ) addVariables( miniNavToggler );
		miniNavToggler.classList.add( "collapsed" );


		if ( !isMiniNav || window.innerWidth < 992 ) {

			miniNavToggler.addEventListener( "click", toggleContent );
            [ "mouseenter", "touchend"].forEach( evt => miniNavToggler.removeEventListener( evt, toggleContent ));

			if( miniNavToggler._mainnav.target.popper != null ) {
				miniNavToggler._mainnav.target.popper.setOptions({
					scroll: false,
					resize: false
				});
				miniNavToggler._mainnav.target.popper.destroy();
			}

			miniNavToggler._mainnav.target.addEventListener( "hide.bs.collapse", bsCollapseHide );

		} else {

            // Hide all submenus
	        miniNavContentsCollapse.map( async sm => sm.hide() );


		 	miniNavToggler._mainnav.target.popper = Popper.createPopper( miniNavToggler, miniNavToggler._mainnav.target, popperOptions);
			miniNavToggler.removeEventListener( "click", toggleContent );
            [ "mouseenter", "touchend"].forEach( evt => miniNavToggler.addEventListener( evt, toggleContent ));


			// Hide all submenus when clicked outside of the main menu.
			miniNavToggler._mainnav.target.removeEventListener( "hide.bs.collapse", bsCollapseHide );
		}
	});
};



// Initialize the main navigation
if ( miniNavTogglers ) buildNav();
