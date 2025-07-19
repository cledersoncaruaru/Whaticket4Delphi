// Color variables based on css variable.
// ----------------------------------------------
const _body           = getComputedStyle( document.body );
let primaryColor, textColor, secondaryColor;



// Chart and data variable
// ----------------------------------------------
let networkChart;
const areaData = [
    {period: "Oct-12", dl: 94, up:2},
    {period: "Oct-13", dl: 97, up:22},
    {period: "Oct-14", dl: 93, up:7},
    {period: "Oct-15", dl: 92, up:6},
    {period: "Oct-16", dl: 98, up:17},
    {period: "Oct-17", dl: 90, up:15},
    {period: "Oct-18", dl: 80, up:17},
    {period: "Oct-19", dl: 80, up:7},
    {period: "Oct-20", dl: 77, up:18},
    {period: "Oct-21", dl: 96, up: 18},
    {period: "Oct-22", dl: 86, up: 18},
    {period: "Oct-23", dl: 103, up: 29},
    {period: "Oct-24", dl: 100, up: 23},
    {period: "Oct-25", dl: 114, up:10},
    {period: "Oct-26", dl: 110, up:22},
    {period: "Oct-27", dl: 109, up:7},
    {period: "Oct-28", dl: 100, up:6},
    {period: "Oct-29", dl: 105, up:17},
    {period: "Oct-30", dl: 110, up:15},
    {period: "Oct-31", dl: 105, up:17},
    {period: "Nov-01", dl: 107, up:7},
    {period: "Nov-02", dl: 60, up:18},
    {period: "Nov-03", dl: 67, up: 18},
    {period: "Nov-04", dl: 76, up: 18},
    {period: "Nov-05", dl: 73, up: 29},
    {period: "Nov-06", dl: 94, up: 13},
    {period: "Nov-07", dl: 105, up:2},
    {period: "Nov-08", dl: 115, up:22},
    {period: "Nov-09", dl: 110, up:7},
    {period: "Nov-10", dl: 100, up:6},
    {period: "Nov-11", dl: 105, up:17},
    {period: "Nov-12", dl: 109, up:15},
    {period: "Nov-13", dl: 90, up:17},
    {period: "Nov-14", dl: 70, up:7},
    {period: "Nov-15", dl: 67, up:18},
    {period: "Nov-16", dl: 86, up: 18},
    {period: "Nov-17", dl: 86, up: 18},
    {period: "Nov-18", dl: 113, up: 29},
    {period: "Nov-19", dl: 130, up: 23},
    {period: "Nov-20", dl: 125, up:10},
    {period: "Nov-21", dl: 128, up:22},
    {period: "Nov-22", dl: 129, up:7},
    {period: "Nov-23", dl: 122, up:6},
    {period: "Nov-24", dl: 105, up:17},
    {period: "Nov-25", dl: 110, up:15},
    {period: "Nov-26", dl: 102, up:17},
    {period: "Nov-27", dl: 107, up:7},
    {period: "Nov-28", dl: 70, up:18},
    {period: "Nov-29", dl: 77, up: 18},
    {period: "Nov-30", dl: 76, up: 18},
    {period: "Des-01", dl: 73, up: 29},
    {period: "Des-02", dl: 94, up: 13},
    {period: "Des-03", dl: 79, up: 24}
];

const hddData = [
    {period: "Nov-04", hddSpace: 57},
    {period: "Nov-05", hddSpace: 69},
    {period: "Nov-06", hddSpace: 70},
    {period: "Nov-07", hddSpace: 62},
    {period: "Nov-08", hddSpace: 73},
    {period: "Nov-09", hddSpace: 79},
    {period: "Nov-10", hddSpace: 76},
    {period: "Nov-11", hddSpace: 77},
    {period: "Nov-12", hddSpace: 73},
    {period: "Nov-13", hddSpace: 52},
    {period: "Nov-14", hddSpace: 57},
    {period: "Nov-15", hddSpace: 50},
    {period: "Nov-16", hddSpace: 60},
    {period: "Nov-17", hddSpace: 55},
    {period: "Nov-18", hddSpace: 70},
    {period: "Nov-19", hddSpace: 68},
    {period: "Nov-20", hddSpace: 57},
    {period: "Nov-21", hddSpace: 62},
    {period: "Nov-22", hddSpace: 53},
    {period: "Nov-23", hddSpace: 69},
    {period: "Nov-24", hddSpace: 59},
    {period: "Nov-25", hddSpace: 67},
    {period: "Nov-26", hddSpace: 69},
    {period: "Nov-27", hddSpace: 59},
    {period: "Nov-28", hddSpace: 67},
    {period: "Nov-29", hddSpace: 69},
    {period: "Nov-30", hddSpace: 58},
    {period: "Des-01", hddSpace: 50},
    {period: "Des-02", hddSpace: 47},
    {period: "Des-03", hddSpace: 65}
]

const earningData = [
    {period: "Nov-04", earning: 945},
    {period: "Nov-05", earning: 754},
    {period: "Nov-06", earning: 805},
    {period: "Nov-07", earning: 855},
    {period: "Nov-08", earning: 678},
    {period: "Nov-09", earning: 987},
    {period: "Nov-10", earning: 1026},
    {period: "Nov-11", earning: 855},
    {period: "Nov-12", earning: 730},
    {period: "Nov-13", earning: 920},
    {period: "Nov-14", earning: 870},
    {period: "Nov-15", earning: 900},
    {period: "Nov-16", earning: 890},
    {period: "Nov-17", earning: 750},
    {period: "Nov-18", earning: 900},
    {period: "Nov-19", earning: 880},
    {period: "Nov-20", earning: 870},
    {period: "Nov-21", earning: 820},
    {period: "Nov-22", earning: 930},
    {period: "Nov-23", earning: 945},
    {period: "Nov-24", earning: 754},
    {period: "Nov-25", earning: 805},
    {period: "Nov-26", earning: 755},
    {period: "Nov-27", earning: 678},
    {period: "Nov-28", earning: 987},
    {period: "Nov-29", earning: 1026},
    {period: "Nov-30", earning: 885},
    {period: "Des-01", earning: 878},
    {period: "Des-02", earning: 922},
    {period: "Des-03", earning: 875},
]



// Initialize the chart when the document is ready
// ----------------------------------------------
document.addEventListener( "DOMContentLoaded", () => {
    updateColorVars();


   // Network Chart - Area Chart
    networkChart = new Chart(
        document.getElementById("_dm-networkChart"), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Upload Speed",
                        data: areaData,
                        borderColor: primaryColor,
                        backgroundColor: primaryColor,
                        fill: "start",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "up"
                        }
                    },
                    {
                        label: "Download Speed",
                        data: areaData,
                        borderColor: secondaryColor,
                        backgroundColor: secondaryColor,
                        fill: "start",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "dl"
                        }
                    },
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                //resizeDelay: 250,
                plugins :{
                    legend: {
                        display: true,
                        align: "start",
                        labels: {
                            boxWidth: 10,
                        }
                    },
                },

                interaction: {
                    mode: "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        display: false,
                        suggestedMax: 200,
                    },
                    x: {
                        grid: {
                            borderWidth: 0,
                            drawOnChartArea: false
                        },
                        ticks: {
                            font : { size: 11  },
                            color : textColor,
                            autoSkip: true,
                            maxRotation: 0,
                            minRotation: 0,
                            maxTicksLimit: 9
                        }
                    }
                },

                // Dot width
                radius: 1,

                // Smooth lines
                elements: {
                    line: {
                        tension: 0.25
                    }
                }
            }
        }
    );



    // HDD  chart - Area chart
    const hddChart = new Chart(
        document.getElementById("_dm-hddChart"), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Usage",
                        data: hddData,
                        borderColor: "white",
                        backgroundColor: "rgba(255,255,255,.4)",
                        fill: "start",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "hddSpace"
                        }
                    }
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                resizeDelay: 250,
                plugins :{
                    legend: {
                        display: false
                    },
                    tooltip: {
                        caretSize: 0,
                        yAlign : "center",
                        callbacks: {
                            label: (context) => {
                                let label = context.dataset.label || "";
                                if (context.parsed.y !== null) label += " : " + context.parsed.y + "%";
                                return label;
                            }
                        }
                    }
                },

                interaction: {
                    mode: "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        display: false
                    },
                    x: {
                        display: false
                    }
                },
                radius: 1,
                elements: {
                    line: {
                        tension: 0.15
                    }
                }
            }
        }
    )


    // Earning chart - Line chart
    const earningChart = new Chart(
        document.getElementById("_dm-earningChart"), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Earning",
                        data: earningData,
                        borderWidth: 2,
                        borderColor: "white",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "earning"
                        }
                    }
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                resizeDelay: 250,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        caretSize: 0,
                        yAlign : "center",
                        callbacks: {
                            label: (context) => {
                                let label = context.dataset.label || "";
                                if (context.parsed.y !== null) label += " : $" + context.parsed.y + ".00";
                                return label;
                            }
                        }
                    }
                },

                interaction: {
                    mode: "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        display: false
                    },
                    x: {
                        display: false
                    }
                },
                radius: .5,
                elements: {
                    line: {
                        tension: 0.5
                    }
                }
            }
        }
    )



    // Sales Chart - Bar chart
    const salesChart = new Chart(
        document.getElementById("_dm-salesChart"), {
            type: "bar",
            data: {
                datasets: [
                    {
                        data: earningData,
                        drawBorder: false,
                        borderRadius: 3,
                        backgroundColor: "rgba(255,255,255, .6)",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "earning"
                        }
                    }
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                resizeDelay: 250,
                layout: {
                    padding: 0
                },
                plugins :{
                    legend: {
                        display: false
                    },
                    tooltip: {
                        caretSize: 0,
                        yAlign : "center",
                        callbacks: {
                            label: (context) => {
                                let label = context.dataset.label || "";
                                if (context.parsed.y !== null) label += ` ${ context.parsed.y } Sales`;
                                return label;
                            }
                        }
                    }
                },

                interaction: {
                    mode: "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        display: false
                    },
                    x: {
                        display: false
                    }
                }
            }
        }
    )



    // Task Chart - Horizontal bar
    const taskChart = new Chart(
        document.getElementById("_dm-taskChart"), {
            type: "bar",
            data: {
                datasets: [
                    {
                        data: [
                            {kind: "Incidential", complete: 45},
                            {kind: "Coordinated", complete: 54},
                            {kind: "Planned", complete: 24},
                            {kind: "Other", complete: 34}
                        ],
                        barThickness: 7,
                        borderRadius: 3,
                        backgroundColor: "rgba(255,255,255, .7)",
                        parsing: {
                            yAxisKey: "kind",
                            xAxisKey: "complete"
                        }
                    }
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                resizeDelay: 250,
                layout: {
                    padding: 0
                },
                indexAxis: 'y',
                plugins :{
                    legend: {
                        display: false
                    },
                    tooltip: {
                        caretSize: 0,
                        yAlign : "center",
                        callbacks: {
                            label: (context) => {
                                let label = context.dataset.label || "";
                                if (context.parsed.x !== null) label += " " + context.parsed.x + " Items Completed";
                                return label;
                            }
                        }
                    }
                },

                interaction: {
                    mode: "index",
                    intersect: true,
                },

                scales: {
                    y: {
                        display: false
                    },
                    x: {
                        display: false
                    }
                }
            }
        }
    )

});



// Update the chart"s colors when the color scheme changes.
// ----------------------------------------------
document.addEventListener( "scheme-changed", async() => {

    // Update all color variables
    updateColorVars();

    // Update network chart
    networkChart.data.datasets[0].borderColor = primaryColor;
    networkChart.data.datasets[0].backgroundColor = primaryColor;
    networkChart.data.datasets[1].borderColor = secondaryColor;
    networkChart.data.datasets[1].backgroundColor = secondaryColor;
    networkChart.update();

});



// Get a secondary color based on the selected primary color.
// ----------------------------------------------
let getSecondaryColor = (rgb) => {
    rgb =  rgb.split(",");
    let r = rgb[0] / 255, g = rgb[1] / 255, b = rgb[2] / 255;
    let v=Math.max(r,g,b), c=v-Math.min(r,g,b), f=(1-Math.abs(v+v-c-1));
    let h= c && ((v==r) ? (g-b)/c : ((v==g) ? 2+(b-r)/c : 4+(r-g)/c));
    let l = getBgLightness();

    return hslToHex( Math.round(60*(h<0?h+6:h)), l>70?Math.round(f ? c/f : 0 * 100)+30:15, l>70?.95:.25 );
}



// Convert hsl color to hex
// ----------------------------------------------
function hslToHex(h, s, l) {
    const a = s * Math.min(l, 1 - l) / 100;
    const f = n => {
        const k = (n + h / 30) % 12;
        const color = l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
        return Math.round(255 * color).toString(16).padStart(2, '0');   // convert to Hex and prefix "0" if needed
    };
    return `#${f(0)}${f(8)}${f(4)}`;
}



// Get a lighting value from the background to determine if it is a dark or light scheme.
// ----------------------------------------------
let getBgLightness = () => {
    let clr =  _body.getPropertyValue("--bs-card-bg-rgb").split(",");
    clr[0] /= 255, clr[1] /= 255, clr[2] /= 255;
    let x= Math.max(clr[0],clr[1],clr[2]), n = x-Math.min(clr[0],clr[1],clr[2]);
    return Math.round((x+x-n)/2 * 100);
}



// Update colors
// ----------------------------------------------
let updateColorVars = () => {
    primaryColor      = _body.getPropertyValue("--bs-comp-active-bg");
    textColor         = _body.getPropertyValue("--bs-body-color");
    secondaryColor    = getSecondaryColor( _body.getPropertyValue("--bs-primary-rgb") );
    return;
}