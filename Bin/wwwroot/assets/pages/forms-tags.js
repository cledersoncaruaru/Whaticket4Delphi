// Wait for the document to fully load.
window.addEventListener( "DOMContentLoaded", async () => {


    // Import and initialize the Bootstrap 5 Tags.
    try {
        const { default: Tags } = await import( "https://cdn.jsdelivr.net/gh/lekoala/bootstrap5-tags@master/tags.min.js" );
        Tags.init();
    } catch (error) {
        console.error( "Couln't import Bootstrap 5 Tags Plugins" );
    }


    // Initialize the Tagin plugin
    for ( const el of document.querySelectorAll( ".tagin" ) ) {
        tagin(el)
    }
})