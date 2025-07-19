document.addEventListener( "DOMContentLoaded", () => {

    // Color variables based on css variable.
    // ----------------------------------------------
    const _body           = getComputedStyle( document.body );
    const primaryColor    = _body.getPropertyValue("--bs-comp-active-bg");
    const successColor    = _body.getPropertyValue("--bs-success");
    const infoColor       = _body.getPropertyValue("--bs-info");
    const warningColor    = _body.getPropertyValue("--bs-warning");
    const mutedColorRGB   = _body.getPropertyValue("--bs-muted-color-rgb");
    const grayColor       = "rgba( 180,180,180, .2 )";



    // Area Chart
    // ----------------------------------------------
    const areaData = [{period:"January 16",dl:77,up:25},{period:"February 16",dl:127,up:58},{period:"March 16",dl:115,up:46},{period:"April 16",dl:239,up:57},{period:"May 16",dl:46,up:75},{period:"June 16",dl:97,up:57},{period:"July 16",dl:105,up:70},{period:"August 16",dl:115,up:106},{period:"September 16",dl:239,up:187},{period:"October 16",dl:97,up:57},{period:"November 16",dl:189,up:70},{period:"December 16",dl:65,up:30},{period:"January 17",dl:35,up:90},{period:"February 17",dl:127,up:58},{period:"March 17",dl:115,up:46},{period:"April 17",dl:239,up:57},{period:"May 17",dl:46,up:75},{period:"June 17",dl:97,up:57},{period:"July 17",dl:105,up:70},{period:"August 17",dl:115,up:106},{period:"September 17",dl:239,up:187},{period:"October 17",dl:97,up:57},{period:"November 17",dl:189,up:70},{period:"December 17",dl:65,up:30},{period:"January 18",dl:35,up:90},{period:"February 18",dl:127,up:58},{period:"March 18",dl:115,up:46},{period:"April 18",dl:239,up:57},{period:"May 18",dl:46,up:75},{period:"June 18",dl:97,up:57},{period:"July 18",dl:105,up:70},{period:"August 18",dl:115,up:106}];
    const areaChart = new Chart(
        document.getElementById("_dm-areaChart"), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Upload Speed",
                        data: areaData,
                        borderColor: successColor,
                        backgroundColor: successColor,
                        fill: "start",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "up"
                        }
                    },
                    {
                        label: "Download Speed",
                        data: areaData,
                        borderColor: "transparent",
                        backgroundColor: grayColor,
                        fill: "start",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "dl"
                        }
                    },
                ]
            },
            options : {
                plugins :{
                    legend: {
                        display: true,
                        align: "end",
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                },

                interaction: {
                    mode : "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        grid: {
                            borderWidth: 0,
                            color: `rgba( ${ mutedColorRGB }, .07 )`
                        },
                        suggestedMax: 400,
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
                            beginAtZero: false,
                            stepSize: 100
                        }
                    },
                    x: {
                        grid: {
                            borderWidth: 0,
                            drawOnChartArea: false
                        },
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
                            autoSkip: true,
                            maxRotation: 0,
                            minRotation: 0,
                            maxTicksLimit: 7
                        }
                    }
                },

                // Dot width
                radius: 1,

                // Smooth lines
                elements: {
                    line: {
                        tension: 0.5
                    }
                }
            }
        }
    );





    // Line Chart
    // ----------------------------------------------
    const lineData = [ {"elapsed": "2010", "value": 18}, {"elapsed": "2011", "value": 24}, {"elapsed": "2012", "value": 9}, {"elapsed": "2013", "value": 12}, {"elapsed": "2014", "value": 13}, {"elapsed": "2015", "value": 22}, {"elapsed": "2016", "value": 11}, {"elapsed": "2017", "value": 26}, {"elapsed": "2018", "value": 12}, {"elapsed": "2019", "value": 19} ];
    const lineChart = new Chart(
        document.getElementById("_dm-lineChart"), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Total order",
                        data: lineData,
                        borderWidth: 2,
                        borderColor: primaryColor,
                        backgroundColor: primaryColor,
                        parsing: {
                            xAxisKey: "elapsed",
                            yAxisKey: "value"
                        }
                    }
                ]
            },
            options : {
                plugins :{
                    legend: {
                        display: true,
                        align: "end",
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                },

                // Tooltip mode
                interaction: {
                    intersect: false,
                },

                scales: {
                    y: {
                        grid: {
                            borderWidth: 0,
                            color: `rgba( ${ mutedColorRGB }, .07 )`
                        },
                        suggestedMax: 30,
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
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
                            color : `rgb( ${ mutedColorRGB })`,
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
                        tension: 0.2
                    }
                }
            }
        }
    );





    // Bar Chart
    // ----------------------------------------------
    const barData = [ { y: "1", a: 100, b: 90 }, { y: "2", a: 75,  b: 65 }, { y: "3", a: 20,  b: 15 }, { y: "5", a: 50,  b: 40 }, { y: "6", a: 75,  b: 95 }, { y: "7", a: 15,  b: 65 }, { y: "8", a: 70,  b: 100 }, { y: "9", a: 100, b: 70 }, { y: "10", a: 50, b: 70 }, { y: "11", a: 20, b: 10 }, { y: "12", a: 40, b: 90 } ];
    const barChart = new Chart(
        document.getElementById("_dm-barChart"), {
            type: "bar",
            data: {
                datasets: [
                    {
                        label: "Upload Speed",
                        data: barData,
                        borderWidth: 2,
                        borderColor: primaryColor,
                        backgroundColor: primaryColor,
                        parsing: {
                            xAxisKey: "y",
                            yAxisKey: "a"
                        }
                    },
                    {
                        label: "Download Speed",
                        data: barData,
                        borderColor: infoColor,
                        backgroundColor: infoColor,
                        parsing: {
                            xAxisKey: "y",
                            yAxisKey: "b"
                        }
                    }
                ]
            },

            options : {
                plugins :{
                    legend: {
                        display: true,
                        align: "end",
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                    tooltip : {
                        position : "nearest"
                    }
                },

                interaction: {
                    mode : "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        grid: {
                            borderWidth: 0,
                            color: `rgba( ${ mutedColorRGB }, .07 )`
                        },
                        suggestedMax: 150,
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
                            beginAtZero: false,
                            stepSize: 50
                        }
                    },
                    x: {
                        grid: {
                            borderWidth: 0,
                            drawOnChartArea: false
                        },
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
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
                        tension: 0.2
                    }
                }
            }
        }
    );





    // Stack chart
    // ----------------------------------------------
    const stackChart = new Chart(
        document.getElementById( "_dm-stackChart" ), {
            type: "line",
            data: {
                datasets: [
                    {
                        label: "Upload Speed",
                        data: areaData,
                        borderColor: primaryColor,
                        backgroundColor: primaryColor,
                        stack: "combined",
                        type: "bar",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "up"
                        }
                    },
                    {
                        label: "Download Speed",
                        data: areaData,
                        borderColor: warningColor,
                        backgroundColor: warningColor,
                        stack: "combined",
                        parsing: {
                            xAxisKey: "period",
                            yAxisKey: "dl"
                        }
                    },
                ]
            },
            options : {
                plugins :{
                    legend: {
                        display: true,
                        align: "end",
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                },

                interaction: {
                    mode : "index",
                    intersect: false,
                },

                scales: {
                    y: {
                        suggestedMax: 300,
                        grid: {
                            borderWidth: 0,
                            color: `rgba( ${ mutedColorRGB }, .07 )`
                        },
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
                            beginAtZero: false,
                            stepSize: 100
                        }
                    },
                    x: {
                        grid: {
                            borderWidth: 0,
                            drawOnChartArea: false
                        },
                        ticks: {
                            font : { size: 11  },
                            color : `rgb( ${ mutedColorRGB })`,
                            autoSkip: true,
                            maxRotation: 0,
                            minRotation: 0,
                            maxTicksLimit: 7
                        }
                    }
                },

                // Dot width
                radius: 3,

            }
        }
    );





    // Doughnut Chart
    // ----------------------------------------------
    const circleData =[25,35,98,59,17];
    const doughnutChart = new Chart(
        document.getElementById( "_dm-doughnutChart" ), {
            type: "doughnut",
            data: {
                labels: ["Blue", "Orange", "Navy", "Green", "Gray"],
                datasets: [{
                    data: circleData,
                    borderColor: "transparent",
                    backgroundColor: [ infoColor, warningColor, primaryColor, successColor, grayColor ],
                }]
            },
            options: {
                plugins :{
                    legend: {
                        display: true,
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                }
            }
        }
    );



    // Pie Chart
    // ----------------------------------------------
    const pieChart = new Chart(
        document.getElementById( "_dm-pieChart" ), {
            type: "pie",
            data: {
                labels: ["Blue", "Orange", "Navy", "Green", "Gray"],
                datasets: [{
                    data: circleData,
                    borderColor: "transparent",
                    backgroundColor: [ infoColor, warningColor, primaryColor, successColor, grayColor ],
                }]
            },
            options: {
                plugins :{
                    legend: {
                        display: true,
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                }
            }
        }
    );



    // Polar Area chart
    // ----------------------------------------------
    const polarAreaChart = new Chart(
        document.getElementById( "_dm-polarAreaChart" ), {
            type: "polarArea",
            data: {
                labels: ["Blue", "Orange", "Navy", "Green", "Gray"],
                datasets: [{
                    data: circleData,
                    borderColor: "transparent",
                    backgroundColor: [ infoColor, warningColor, primaryColor, successColor, grayColor ],
                }]
            },
            options: {
                plugins :{
                    legend: {
                        display: true,
                        labels: {
                            color: `rgb( ${ mutedColorRGB })`,
                            boxWidth: 10,
                        }
                    },
                }
            }
        }
    );
});