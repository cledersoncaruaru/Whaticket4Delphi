document.addEventListener( "DOMContentLoaded", () => {


    // Custom style form wizard
    // ----------------------------------------------
    const customWizStep = document.getElementById( "_dm-customWizardSteps");
    const customWizForm = new Zangdar( "#_dm-customWizardForm", {
        onStepChange() {

            // Remove all active variable
            customWizStep.querySelectorAll( ".active" ).forEach( el => el.classList.remove( "active" ));

            // Set active to step based on current form wizard label
            const currentStep = customWizForm.getCurrentStep().label;
            customWizStep.querySelector( `[data-step="${currentStep}"]` ).classList.add( "active" );
        }
    })



    // Form wizard with step progress
    // ----------------------------------------------
    const progressSteps = document.getElementById( "_dm-progWizardSteps");
    const progressForm = new Zangdar( "#_dm-progWizardForm", {
        onStepChange() {

            // Remove all active variable
            progressSteps.querySelectorAll( ".active" ).forEach( el => el.classList.remove( "active" ));

            // Set active to step based on current form wizard label
            const currentStep = progressForm.getCurrentStep().label;
            progressSteps.querySelector( `[data-step="${currentStep}"]` ).classList.add( "active" );
        }
    })



    // Form wizard with validation
    // ----------------------------------------------
    const validationWizardSteps = document.getElementById( "_dm-validWizardSteps");
    const validationWizardForm = new Zangdar( "#_dm-validWizardForm", {
        onStepChange() {

            // Remove all active variable
            validationWizardSteps.querySelectorAll( ".active" ).forEach( el => el.classList.remove( "active" ));

            // Set active to step based on current form wizard label
            const currentStep = validationWizardForm.getCurrentStep().label;
            validationWizardSteps.querySelector( `[data-step="${currentStep}"]` ).classList.add( "active" );
        },

        onValidation( step ) {
            if ( step.hasErrors() ) {
                step.element.classList.add( "was-validated" );
                return false;
            }
            return true;
        }
    })



    // Disable browser popup validation
    // ----------------------------------------------
    document.addEventListener( "invalid", (function () {
        return function (e) {
            e.preventDefault()
            e.stopPropagation()
        };
    })(), true);
})