

/* Initialize the Bootstrap's Tooltips
/* ---------------------------------------------- */
const tooltipTriggerList = [...document.querySelectorAll( '[data-bs-toggle="tooltip"]' )];
const tooltipList = tooltipTriggerList.map( tooltipTriggerEl => new bootstrap.Tooltip( tooltipTriggerEl ));




/* Initialize the Bootstrap's Popovers
/* ---------------------------------------------- */
const popoverTriggerList = [...document.querySelectorAll( '[data-bs-toggle="popover"]' )];
const popoverList = popoverTriggerList.map( popoverTriggerEl => new bootstrap.Popover( popoverTriggerEl ));