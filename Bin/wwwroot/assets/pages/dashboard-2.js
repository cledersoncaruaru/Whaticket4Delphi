document.addEventListener( "DOMContentLoaded", () => {

    // Color variables based on css variable.
    // ----------------------------------------------
    const _body           = getComputedStyle( document.body );
    const textColor       = _body.getPropertyValue('--bs-body-color');
    const infoColor       = _body.getPropertyValue('--bs-info');
    const warningColor    = _body.getPropertyValue('--bs-warning');
    const grayColor       = _body.getPropertyValue('--bs-gray-700');



    // Bar Chart
    // ----------------------------------------------
    const barData = [ { y: 'May', a: 520, b: 85, c: 50 }, { y: 'Jun', a: 370,  b: 45, c: 30 }, { y: 'Jul', a: 209,  b: 35, c: 29 }, { y: 'Aug', a: 495,  b: 95, c: 95 }, { y: 'Sept', a: 170,  b: 25, c: 70 }, { y: 'Oct', a: 185,  b: 65, c: 15 }, { y: 'Nov', a: 273,  b: 12, c: 73 } ];
    const barChart = new Chart(
        document.getElementById('_dm-barChart'), {
            type: 'bar',
            data: {
                datasets: [
                    {
                        label: 'Students',
                        data: barData,
                        borderWidth: 2,
                        borderColor: infoColor,
                        backgroundColor: infoColor,
                        parsing: {
                            xAxisKey: 'y',
                            yAxisKey: 'a'
                        }
                    },
                    {
                        label: 'Parents',
                        data: barData,
                        borderColor: warningColor,
                        backgroundColor: warningColor,
                        parsing: {
                            xAxisKey: 'y',
                            yAxisKey: 'b'
                        }
                    },
                    {
                        label: 'Teachers',
                        data: barData,
                        borderColor: grayColor,
                        backgroundColor: grayColor,
                        parsing: {
                            xAxisKey: 'y',
                            yAxisKey: 'c'
                        }
                    }
                ]
            },
            options : {
                responsive: true,
                maintainAspectRatio: false,
                plugins : {
                    legend: {
                        display: true,
                        labels: {
                            boxWidth: 10,
                        }
                    },
                    tooltip : {
                        position : 'nearest'
                    }
                },

                interaction: {
                    mode : 'index',
                    intersect: false,
                },

                scales: {
                    y: {
                        grid: {
                            borderWidth: 0,
                            color: "rgba(0,0,0, .03)"
                        },
                        suggestedMax: 650,
                        ticks: {
                            font : { size: 11  },
                            color : textColor,
                            beginAtZero: false,
                            stepSize: 150
                        }
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
});