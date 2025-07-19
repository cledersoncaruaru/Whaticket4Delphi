// Color variables based on css variable.
// ----------------------------------------------
const _body           = getComputedStyle( document.body );
let primaryColor, headingsColor, mutedColorRGB, indigoColor, infoColor, warningColor, successColor, lineChart, gridColor;



// Get all variable colors
// ----------------------------------------------
let updateColorVars = () => {

    // Check current schemes is dark or light
    let a = window.getComputedStyle( document.querySelector("#content > .content__header")).backgroundColor;
    a = a.replace(/^.*\((.*\w)\)/g, "$1").split(",");
    let yiq = ((a[0]*299)+(a[1]*587)+(a[2]*114))/1000;
    let isLight = (yiq >= 220 || a[3] == 0 ) ? true : false;



    // Update all variable colors
    primaryColor    = ( isLight ) ? _body.getPropertyValue( "--bs-comp-active-bg" ) : 'white';
    headingsColor    = ( isLight ) ? _body.getPropertyValue( "--bs-headings-color" ) : 'white';
    mutedColorRGB   = ( isLight ) ? "rgba( 0, 0, 0, .5 )" : "rgba( 255, 255, 255, .5 )";
    indigoColor     = _body.getPropertyValue("--bs-indigo");
    infoColor       = _body.getPropertyValue("--bs-info");
    warningColor    = _body.getPropertyValue("--bs-warning");
    successColor    = _body.getPropertyValue("--bs-success");
    gridColor       = mutedColorRGB.replace(/^(.*,)(.*)\)/g, "$1 .075)");
    return;
}



document.addEventListener( "DOMContentLoaded", () => {

    // Update color variables based on css variable.
    // ----------------------------------------------
    updateColorVars();



    // Line Chart
    // ----------------------------------------------
    const lineData = [
        {'elapsed': 'Jan 1', 'value': 18}, {'elapsed': 'Jan 2', 'value': 24}, {'elapsed': 'Jan 3', 'value': 9}, {'elapsed': 'Jan 4', 'value': 12}, {'elapsed': 'Jan 5', 'value': 13}, {'elapsed': 'Jan 6', 'value': 22}, {'elapsed': 'Jan 7', 'value': 11}, {'elapsed': 'Jan 8', 'value': 26}, {'elapsed': 'Jan 9', 'value': 12}, {'elapsed': 'Jan 10', 'value': 19},
        {'elapsed': 'Jan 11', 'value': 18}, {'elapsed': 'Jan 12', 'value': 24}, {'elapsed': 'Jan 13', 'value': 9}, {'elapsed': 'Jan 14', 'value': 12}, {'elapsed': 'Jan 15', 'value': 13}, {'elapsed': 'Jan 16', 'value': 22}, {'elapsed': 'Jan 17', 'value': 11}, {'elapsed': 'Jan 18', 'value': 26}, {'elapsed': 'Jan 19', 'value': 12}, {'elapsed': 'Jan 20', 'value': 19}
    ];

    lineChart = new Chart(
        document.getElementById('_dm-lineChart'), {
            type: 'line',
            data: {
                datasets: [
                    {
                        label: 'Recent Sales',
                        data: lineData,
                        borderWidth: 1.75,
                        borderColor: primaryColor,
                        backgroundColor: primaryColor,
                        parsing: {
                            xAxisKey: 'elapsed',
                            yAxisKey: 'value'
                        }
                    }
                ]
            },
            options : {
                plugins : {
                    title: {
                        display: true,
                        color: headingsColor,
                        text: 'Recent Sales Chart'
                    },
                    legend: {
                        display: true,
                        labels: {
                            color: headingsColor,
                            boxWidth: 10,
                        }
                    }
                },
                // Tooltip mode
                interaction: {
                    intersect: false,
                },

                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    y: {
                        grid: {
                            borderWidth: 0,
                            color: gridColor
                        },
                        suggestedMax: 30,
                        ticks: {
                            font : { size: 11  },
                            color : mutedColorRGB,
                            beginAtZero: false,
                            stepSize: 5
                        }
                    },
                    x: {
                        grid: {
                            borderWidth: 0,
                            drawOnChartArea: false
                        },
                        ticks: {
                            font : { size: 11  },
                            color : mutedColorRGB,
                            autoSkip: true,
                            maxRotation: 0,
                            minRotation: 0,
                            maxTicksLimit: 7
                        }
                    }
                },

                elements: {
                    // Dot width
                    point : {
                        radius: 3,
                        hoverRadius: 5
                    },
                    // Smooth lines
                    line: {
                        tension: 0.4
                    }
                }
            }
        }
    );


    // Doughnut Chart
    // ----------------------------------------------
    const circleData =[25,35,98,49];
    const doughnutChart = new Chart(
        document.getElementById( "_dm-doughnutChart" ), {
            type: "doughnut",
            data: {
                labels: [ "Resource usage", "Completed Projects", "Completed Tasks", "Earning" ],
                datasets: [{
                    data: circleData,
                    borderColor: "transparent",
                    backgroundColor: [ infoColor, warningColor, indigoColor, successColor ],
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins :{
                    legend: {
                        display: false
                    },
                }
            }
        }
    );

});



// Update the chart"s colors when the color scheme changes.
// ----------------------------------------------
document.addEventListener( "scheme-changed", async() => {

    // Update all color variables
    updateColorVars();

    // Update sales chart
    lineChart.data.datasets[0].borderColor = primaryColor;
    lineChart.data.datasets[0].backgroundColor = primaryColor;
    lineChart.options.plugins.title.color = headingsColor;
    lineChart.options.plugins.legend.labels.color = headingsColor;
    lineChart.options.scales.y.grid.color = gridColor;
    lineChart.options.scales.y.ticks.color = mutedColorRGB;
    lineChart.options.scales.x.ticks.color = mutedColorRGB;

    lineChart.update();

});