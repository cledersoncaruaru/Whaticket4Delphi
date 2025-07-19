document.addEventListener( "DOMContentLoaded", () => {


    // Blank editor
    // ----------------------------------------------
    KothingEditor.create("_dm-blankEditor", {
        display: "block",
        width: "local",
        height: "162",
        popupDisplay: "full",
        buttonList: [
            ["font", "fontSize", "formatBlock"],
            ["bold", "underline", "italic", "strike", "subscript", "superscript"],
        ],
    });



    // Classic editor
    // ----------------------------------------------
    KothingEditor.create("_dm-classicEditor", {
        display: "block",
        width: "100%",
        height: "auto",
        popupDisplay: "full",
        katex: katex,
        toolbarItem: [
            ["undo", "redo"],
            ["fontSize", "formatBlock"],
            [
                "bold",
                "underline",
                "italic",
                "strike",
                "subscript",
                "superscript",
                "fontColor",
                "hiliteColor",
            ],
            ["outdent", "indent", "align", "list", "horizontalRule"],
            ["link", "table", "image", "audio", "video"],
            ["lineHeight", "paragraphStyle", "textStyle"],
            ["showBlocks", "codeView"],
            ["math"],
            ["preview", "print", "fullScreen"],
            ["save", "template"],
            ["removeFormat"],
        ],
        templates: [{
                name: "Template-1",
                html: "<p>HTML source1</p>",
            },
            {
                name: "Template-2",
                html: "<p>HTML source2</p>",
            },
        ],
        charCounter: true,
    });


    // Popup bar
    // ----------------------------------------------
    KothingEditor.create("_dm-balloonEditor", {
        mode: "balloon",
        display: "block",
        width: "100%",
        height: "auto",
        popupDisplay: "full",
        buttonList: [
            ["fontSize", "fontColor", "bold", "align", "horizontalRule", "table"],
        ],
    });


});