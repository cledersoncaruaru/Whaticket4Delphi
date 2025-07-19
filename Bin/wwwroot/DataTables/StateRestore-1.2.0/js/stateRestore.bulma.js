/*! Bootstrap integration for DataTables' StateRestore
 * © SpryMedia Ltd - datatables.net/license
 */

(function( factory ){
	if ( typeof define === 'function' && define.amd ) {
		// AMD
		define( [''], function ( $ ) {
			return factory( $, window, document );
		} );
	}
	else if ( typeof exports === 'object' ) {
		// CommonJS
		module.exports = function (root, $) {
			if ( ! root ) {
				// CommonJS environments without a window global must pass a
				// root. This will give an error otherwise
				root = window;
			}

			if ( ! $.fn.dataTable ) {
				require('')(root, $);
			}


			return factory( $, root, root.document );
		};
	}
	else {
		// Browser
		factory( jQuery, window, document );
	}
}(function( $, window, document, undefined ) {
'use strict';
var DataTable = $.fn.dataTable;


$.extend(true, DataTable.StateRestoreCollection.classes, {
    checkRow: 'dtsr-check-row checkbox',
    creationButton: 'dtsr-creation-button button',
    creationForm: 'dtsr-creation-form modal-content',
    creationText: 'dtsr-creation-text modal-header',
    creationTitle: 'dtsr-creation-title modal-card-title',
    nameInput: 'dtsr-name-input input'
});
$.extend(true, DataTable.StateRestore.classes, {
    confirmationButton: 'dtsr-confirmation-button button',
    confirmationTitle: 'dtsr-confirmation-title modal-card-title',
    input: 'dtsr-input input'
});


return DataTable;
}));
