// Example starter JavaScript for disabling form submissions if there are invalid fields
// Fetch all the forms we want to apply custom Bootstrap validation styles to
const forms = document.querySelectorAll( ".needs-validation" );

// Loop over them and prevent submission
forms.forEach( form => {
    form.addEventListener( "submit", e => {
        if ( !form.checkValidity() ) {
            e.preventDefault()
            e.stopPropagation()
        }

        form.classList.add( "was-validated" )
    }, false)
})