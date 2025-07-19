
if ( document.getElementById( "_dm-boxedBgContent" ) ) {

    // BOXED LAYOUT WITH BACKGROUND IMAGE
    // ----------------------------------------------
    // HINT : Add the background image to the body or override the $boxed-layout-bg-image SCSS Variable.

    const boxedImgThumbs = [... document.querySelectorAll( "._dm-boxbg__thumb" )];

    boxedImgThumbs.map( ( boxedImgThumb ) => {
        boxedImgThumb.addEventListener( "click", (e) => {
            e.preventDefault();
            if (boxedImgThumb.classList.contains( ".active" )) return;


            let oldImg = document.querySelector( "._dm-boxbg__thumb.active " )
            if ( oldImg ) oldImg.classList.remove( "active" );
            boxedImgThumb.classList.add( "active" );


            let targetIMG = boxedImgThumb.querySelector( "img" ).getAttribute( "src" ).replace( "thumbs", "bg" );
            body.style.backgroundImage = `url( ${targetIMG} )`;
        });
    });

}





if ( document.getElementById( "_dm-settingsContainer" ) ) {


    // Cache all radio and checkbox options.
    // ----------------------------------------------
    const conf = {
        boxedLayoutRadio                    : document.getElementById( "_dm-boxedLayoutRadio" ),
        centeredLayoutRadio                 : document.getElementById( "_dm-centeredLayoutRadio" ),
        stickyHeaderCheckbox                : document.getElementById( "_dm-stickyHeaderCheckbox" ),
        stickyNavCheckbox                   : document.getElementById( "_dm-stickyNavCheckbox" ),
        miniNavRadio                        : document.getElementById( "_dm-miniNavRadio" ),
        maxiNavRadio                        : document.getElementById( "_dm-maxiNavRadio" ),
        pushNavRadio                        : document.getElementById( "_dm-pushNavRadio" ),
        slideNavRadio                       : document.getElementById( "_dm-slideNavRadio" ),
        revealNavRadio                      : document.getElementById( "_dm-revealNavRadio" ),
        disableBackdropCheckbox             : document.getElementById( "_dm-disableBackdropCheckbox" ),
        stuckSidebarCheckbox                : document.getElementById( "_dm-stuckSidebarCheckbox" ),
        pinnedSidebarCheckbox               : document.getElementById( "_dm-pinnedSidebarCheckbox" ),
        uniteSidebarCheckbox                : document.getElementById( "_dm-uniteSidebarCheckbox" )
    }


    // Initalize all options.
    // ----------------------------------------------
    conf.boxedLayoutRadio.checked           = body.classList.contains( "boxed-layout" );
    conf.centeredLayoutRadio.checked        = body.classList.contains( "centered-layout" );
    conf.stickyHeaderCheckbox.checked       = root.classList.contains( "hd--sticky" );
    conf.stickyNavCheckbox.checked          = root.classList.contains( "mn--sticky" );
    conf.miniNavRadio.checked               = root.classList.contains( "mn--min" );
    conf.maxiNavRadio.checked               = root.classList.contains( "mn--max" );
    conf.pushNavRadio.checked               = root.classList.contains( "mn--push" );
    conf.slideNavRadio.checked              = root.classList.contains( "mn--slide" );
    conf.revealNavRadio.checked             = root.classList.contains( "mn--reveal" );
    conf.disableBackdropCheckbox.checked    = root.classList.contains( "sb--bd-0" );
    conf.stuckSidebarCheckbox.checked       = root.classList.contains( "sb--stuck" );
    conf.pinnedSidebarCheckbox.checked      = root.classList.contains( "sb--pinned" );
    conf.uniteSidebarCheckbox.checked       = root.classList.contains( "sb--unite" );





    // BOXED LAYOUT
    // ----------------------------------------------
    // HINT : Toggle the .boxed-layout class on BODY

    const boxedBgBtn = document.getElementById( "_dm-boxedBgBtn" );
    const boxedBgOption = document.getElementById( "_dm-boxedBgOption" );

    conf.boxedLayoutRadio.addEventListener( "changed", (e) => {

        if (e.target.checked && !body.classList. contains( "boxed-layout" )) {

            // Set the current layout to Box mode
            body.classList.add( "boxed-layout" );

            // Enable the background images option
            boxedBgOption.classList.remove( "opacity-50" );
            boxedBgBtn.removeAttribute( "disabled" );

        } else {

            // Remove boxed layout
            body.classList.remove( "boxed-layout" );
            body.removeAttribute("style");

            // Disable the background images option
            boxedBgOption.classList.add( "opacity-50" );
            boxedBgBtn.setAttribute( "disabled", true );
        }
    });





    // CENTERED LAYOUT
    // ----------------------------------------------
    // HINT : Toggle the .centered-layout class on BODY

    conf.centeredLayoutRadio.addEventListener( "changed", () => {

        // Set the current layout to Center Mode.
        body.classList.toggle( "centered-layout" );

    });





    // TRANSITION TIMING
    // ----------------------------------------------
    // HINT : Add your favorite transition timing class to the #root.

    document.getElementById( "_dm-transtiionSelect" ).addEventListener( "change", (e) => {
        const _this = e.target;

        // Toggle the selected attribute
        _this.querySelector( "option[selected]" ).removeAttribute( "selected" );
        _this[_this.selectedIndex].setAttribute( "selected", true );


        // Remove existing transition classes and add the currently selected transition class.
        body.classList.remove( "in-quart", "out-quart", "in-back", "out-back", "in-out-back", "steps", "jumping", "rubber" );
        body.classList.add(_this.value);

    });





    // STICKY HEADER
    // ----------------------------------------------
    // HINT : Toggle the .hd--sticky class on #root element.

    conf.stickyHeaderCheckbox.addEventListener( "change", () => {

        // Toggle the sticky header class.
        root.classList.toggle( "hd--sticky" );

    });





    // ADDITIONAL OFFCANVAS
    // ----------------------------------------------
    // HINT : Please visit Bootstrap's documentation for more information and examples.
    // https://getbootstrap.com/docs/5.0/components/offcanvas/

    const offCanvasDemo     = document.getElementById( "_dm-offcanvas" );
    const bsOffcanvas       = new bootstrap.Offcanvas( offCanvasDemo );

    const settingToggler    = document.getElementById( "_dm-settingsToggler" );
    const settingContainer  = document.getElementById( "_dm-settingsContainer" );

    [...document.querySelectorAll( "._dm-offcanvasBtn" )].map( ( _btn ) => {
        _btn.addEventListener( "click", () => {

                // Set the offcanvas position to the user's choice.
                offCanvasDemo.className = `offcanvas ${ _btn.value }`;
                offCanvasDemo.style = "transition-duration: 0s";


                // Hide the settings container and then show the additional offCanvas.
                settingToggler.dispatchEvent( new Event( "click" ) );
                settingContainer.addEventListener( "transitionend", () => {
                    offCanvasDemo.style = "";
                    bsOffcanvas.show();
                }, { once : true } )

        })
    } );





    // STICKY NAVIGATION
    // ----------------------------------------------
    // HINT : Toggle the .mn--sticky class on #root element.

    conf.stickyNavCheckbox.addEventListener( "change", () => {

        // Toggle the sticky navigation class.
        root.classList.toggle( "mn--sticky" );

    });





    // PROILE WIDGET
    // ----------------------------------------------

    const mainNavProfile = document.querySelector( ".mainnav__profile" );

    document.getElementById( "_dm-profileWidgetCheckbox" ).addEventListener( "change", () => {

        // Toggle visibility
        mainNavProfile.classList.toggle( "d-none" );

    });





    // MINI NAVIGATION MODE
    // ----------------------------------------------
    // HINT : Toggle the .mn--min class on #root element.

    conf.miniNavRadio.addEventListener( "changed", () => {

        // Set the navigation to Mini Mode.
        root.classList.toggle( "mn--min" );

    });





    // MAXI NAVIGATION MODE
    // ----------------------------------------------
    // HINT : Toggle the .mn--max class on #root element.

    conf.maxiNavRadio.addEventListener( "changed", () => {

        // Set the navigation to Maxi Mode.
        root.classList.toggle( "mn--max" );

    });





    // REMOVE MIN AND MAX CLASSES
    // ----------------------------------------------
    const removeMinMaxNavigation = (e) => {
        if( !e ) return;
        root.classList.remove( "mn--min", "mn--max" );
        buildNav();
    }





    // PUSH NAVIGATION MODE
    // ----------------------------------------------
    // HINT : Toggle the .mn--push class on #root element.

    conf.pushNavRadio.addEventListener( "changed", (e) => {


        // Make sure your navigation doesn't have any mini-or max classes.
        removeMinMaxNavigation( e.target.checked );


        // Set the navigation to Push Mode.
        root.classList.toggle( "mn--push" );

    });





    // SLIDE NAVIGATION MODE
    // ----------------------------------------------
    // HINT : Toggle the .mn--slide class on #root element.

    conf.slideNavRadio.addEventListener( "changed", (e) => {


        // Make sure your navigation doesn't have any mini-or max classes.
        removeMinMaxNavigation( e.target.checked );


        // Set the navigation to Slide on Top Mode.
        root.classList.toggle( "mn--slide" );

    });





    // REVEAL NAVIGATION MODE
    // ----------------------------------------------
    // HINT : Toggle the .mn--reveal class on #root element.

    conf.revealNavRadio.addEventListener( "changed", (e) => {


        // Make sure your navigation doesn't have any mini-or max classes.
        removeMinMaxNavigation( e.target.checked );


        // Set the navigation to Reveal Mode.
        root.classList.toggle( "mn--reveal" );

    });





    // DISABLE SIDEBAR BACKDROP
    // ----------------------------------------------
    // HINT : Toggle the .sb--bd-0 class on #root element.

    conf.disableBackdropCheckbox.addEventListener( "change", () => {

        // Hide the sidebar backdrop
        root.classList.toggle( "sb--bd-0" );

    });





    // STATIC SIDEBAR
    // ----------------------------------------------
    // HINT : Toggle the .sb--static class on #root element.

    document.getElementById( "_dm-staticSidebarCheckbox" ).addEventListener( "change", () => {

        // The sidebar will follow the page as you scroll down.
        root.classList.toggle( "sb--static" );

    });





    // STUCK SIDEBAR
    // ----------------------------------------------
    // The sidebar will stay in position until you click the close button.
    // ----------------------------------------------
    // HINT : Toggle the .sb--stuck class on #root element.

    conf.stuckSidebarCheckbox.addEventListener( "change", () => {

        // Set the sidebar to Stuck mode.
        root.classList.toggle( "sb--stuck" );

    });





    // UNITE SIDEBAR
    // ----------------------------------------------
    // Transform the sidebar color into a header.
    // ----------------------------------------------
    // HINT : Toggle the .sb--stuck class on #root element.

    conf.uniteSidebarCheckbox.addEventListener( "change", () => {

        // Set the sidebar to Unite mode.
        root.classList.toggle( "sb--unite" );

    });





    // PINNED SIDEBAR
    // ----------------------------------------------
    // The sidebar will look just like the rest of the content.
    // ----------------------------------------------
    // HINT : Toggle the .sb--pinned class on #root element.

    conf.pinnedSidebarCheckbox.addEventListener( "change", () => {

        // Set the sidebar to pinned mode.
        root.classList.toggle( "sb--pinned" );

    });






    // COLOR SCHEMES
    // ----------------------------------------------

    const colorScemesContainer = document.getElementById( "dm_colorSchemesContainer" );
    const themeColorsBtn = [...colorScemesContainer.querySelectorAll( "._dm-themeColors" )];
    const event = new Event( "scheme-changed" );


    // Get the link tag element.
    const getLinkTag = (_type) => {
        let targetLink = null;
        [...document.getElementsByTagName("link")].map( (_link) => ( _link.href.includes( _type ) )? targetLink = _link:null );
        ( _type == "bootstrap" ) ? bootstrapLinkEl = targetLink: niftyLinkEl = targetLink;

        return targetLink;
    }


    const defaultBsUrl      = getLinkTag( "bootstrap." ).getAttribute( "href" );
    const defaultNiftyUrl   = getLinkTag( "nifty." ).getAttribute( "href" );
    const assetsPath        = defaultBsUrl.match( /^.*?assets/g ).toString();
    let stylesLoaded        = 0;
    let totalStyles         = 1;



    // Set active colorschemes
    let currentCSSPath = defaultBsUrl.replace( /^.*color-schemes\/(.*)\/bootstrap.min.css/g, "$1" );
    if ( currentCSSPath != defaultBsUrl ) {
        colorScemesContainer.querySelector( "._dm-themeColors.active" ).classList.remove( "active" );
        let schemeBtn = themeColorsBtn.filter( (btn) => btn.getAttribute( "data-dir" ) === currentCSSPath );
        if (schemeBtn.length) schemeBtn[0].classList.add( "active" );
    }



    const createLinkEl = ( href ) => {
        const newLink = document.createElement( "link" );
        newLink.setAttribute( "rel", "stylesheet" );
        newLink.setAttribute( "href", href );
        newLink.addEventListener( "load", removeLoadingScreen, {
            once: true
        });

        return newLink;
    }



    // Generate a URL for the current scheme selected by the user.
    const makeURL = ( _dir, _file ) => {
        let _uri = "/color-schemes/";
        let newPath = `${ assetsPath }/css${ _uri }${ _dir }/${ _file }.min.css`;
        if ( _dir.length <= 0 ) _file == "bootstrap" ? newPath = defaultBsUrl : newPath = defaultNiftyUrl;

        return newPath;
    }


    // Remove the loading screen.
    const removeLoadingScreen = () => {
        stylesLoaded ++;
        if ( stylesLoaded < totalStyles ) return;

        // Hide the settings panel
        bootstrap.Offcanvas.getInstance( "#_dm-settingsContainer" ).hide();

        // Remove the loading screen
        body.classList.remove( "_dm-load-scheme-css" );
        const ldSc = document.querySelector( "#_dm-loading-screen" );
        if( ldSc ) ldSc.remove();
        document.dispatchEvent(event);
    }

    themeColorsBtn.map( (colorsBtn) => {
        colorsBtn.addEventListener( "click", (e) => {

            if ( colorsBtn.classList.contains( "active" ) ) return;
            e.preventDefault();

            const rootClass        = colorsBtn.getAttribute( "data-hd" );
            const currentActiveBtn = document.querySelector("._dm-themeColors.active");
            let currentBsCSS       = getLinkTag("bootstrap").getAttribute( "href" );
            let newBsCSS           = defaultBsUrl;

            // Reset t0 default value
            stylesLoaded           = 0;
            totalStyles            = 1;


            if ( !colorsBtn.getAttribute( "data-single" ) ) newBsCSS = makeURL( colorsBtn.getAttribute( "data-dir" ), "bootstrap" );

            if ( currentBsCSS !=  newBsCSS ) {

                totalStyles ++;

                if ( !document.getElementById( "_dm-customLoadScreen" ) )
                document.head.insertAdjacentHTML("beforeend", `<style id="_dm-customLoadScreen">._dm-load-scheme-css>._dm-loading-screen{align-items:center;background-color:#fff;color:#2b2c2d;display:flex;flex-direction:column;inset:0;justify-content:center;position:fixed}._dm-load-scheme-css>._dm-loading-screen:before{animation-duration:1s;animation-iteration-count:infinite;animation-name:_dm-spin;animation-timing-function:linear;color:#28292b;content:"\u2686";display:block;font-family:Arial;font-size:5rem;height:2ex;line-height:1;opacity:.1;width:2ex;transform-origin:center center}._dm-load-scheme-css>._dm-loading-screen:after{content:"Please wait while loading . . .";font-family:Poppins,"Open Sans",system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";font-size:1rem;font-weight:700;line-height:1.5;margin-top:2rem}._dm-load-scheme-css>:not(._dm-loading-screen){opacity:0;pointer-events:none;visibility:none}@keyframes _dm-spin{from{transform:rotate(0)}to{transform:rotate(360deg)}}</style>`);

                // Add a loading screen
                const loadingScreen = document.createElement("div");
                loadingScreen.setAttribute("id", "_dm-loading-screen");
                loadingScreen.classList.add("_dm-loading-screen");
                document.body.append(loadingScreen);
                document.body.classList.add("_dm-load-scheme-css");

                // Create a new bootstrap link element
                const newBootstrap = createLinkEl( newBsCSS );
                getLinkTag( "bootstrap." ).parentNode.replaceChild( newBootstrap, getLinkTag( "bootstrap." ));
            }

            const newNifty = createLinkEl( makeURL(colorsBtn.getAttribute("data-dir"), "nifty") );
            getLinkTag( "nifty." ).parentNode.replaceChild( newNifty, getLinkTag( "nifty." ));


            root.classList.remove( "hd--expanded", "hd--fair" );

            if ( rootClass != null ) {
                rootClass.split( "," ).map( ( _class ) => {
                    if ( _class != "border" ) root.classList.add( `hd--${ _class }` );
                });
            }

            // Toggle sctive class for the scheme button.
            if ( currentActiveBtn ) currentActiveBtn.classList.remove( "active" );
            colorsBtn.classList.add( "active" );
        });
    } );





    // SCROLLBARS
    // ----------------------------------------------

    let bodyScrollbar;
    let sidebarScrollbars;


    // Overlayscrollbars Options
    const scrollbarOptions = {
        className: "os-nifty-minimal",
        scrollbars: {
            autoHide: "leave",
            clickScrolling: true
            //touchSupport: false
        },
        overflowBehavior: {
            x: "visible-scroll"
        }
    };



    // Add OverlayScrollbars CSS and JS to the document
    const addOverlayScrollbars = () => {
        return new Promise( ( resolve, reject ) => {
            if ( document.getElementById( `_dm-jsOverlayScrollbars` ) ) {
                resolve( "done" );
            } else {

                let _plugin = document.createElement( "link" );
                _plugin.setAttribute( "id", "_dm-cssOverlayScrollbars" );
                _plugin.setAttribute( "rel", "stylesheet" );
                _plugin.setAttribute( "href", `${ assetsPath }/vendors/overlayscrollbars/overlayscrollbars.min.css` );
                document.querySelector("head").append( _plugin );

                _plugin = document.createElement( "script" );
                _plugin.setAttribute( "id", "_dm-jsOverlayScrollbars" );
                _plugin.setAttribute( "src", `${ assetsPath }/vendors/overlayscrollbars/OverlayScrollbars.min.js` );
                document.body.append( _plugin );

                _plugin.addEventListener( "load", resolve, { once: true } );
                _plugin.onerror = reject;
            }
        });
    }





    // APPLY AND DESTROY THE OVERLAYSCROLLBARS ON THE BODY.
    // ----------------------------------------------
    document.getElementById( "_dm-bodyScrollbarCheckbox" ).addEventListener( "change", async (e) => {
        await addOverlayScrollbars();
        if ( e.target.checked ) bodyScrollbar = OverlayScrollbars( body, scrollbarOptions );
        else bodyScrollbar.destroy();
    });





    // APPLY AND DESTROY THE OVERLAYSCROLLBARS ON ELEMENTS CONTAIN CLASS NAME .SCROLLABLE-CONTENT.
    // ----------------------------------------------
    document.getElementById( "_dm-sidebarsScrollbarCheckbox" ).addEventListener( "change", async (e) => {
        await addOverlayScrollbars();
        if ( e.target.checked ) sidebarScrollbars = OverlayScrollbars( document.querySelectorAll( ".scrollable-content" ), scrollbarOptions );
        else sidebarScrollbars.map( sb => sb.destroy() );
    });

}





// Create custom events for radios to enable fire events when they go unchecked.
// ----------------------------------------------
const radioEvent = new Event( "changed" );

[...document.querySelectorAll( "#_dm-settingsContainer input[type='radio']" )].map(( thisRadio ) => {
    thisRadio.previous = thisRadio.checked;
    thisRadio.addEventListener( "transitionend", (e) => {
        if ( e.propertyName == "background-color" && thisRadio.previous != thisRadio.checked ) {
            thisRadio.previous = thisRadio.checked;
            e.target.dispatchEvent( radioEvent );
        }
    })
});