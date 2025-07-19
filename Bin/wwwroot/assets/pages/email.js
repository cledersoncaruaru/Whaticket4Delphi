document.addEventListener( "DOMContentLoaded", () => {

    // Classic editor
    // ----------------------------------------------
    KothingEditor.create("_dm-classicEditor", {
        display: "block",
        width: "100%",
        height: "350",
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


})