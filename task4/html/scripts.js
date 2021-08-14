const api_url = 'https://api.covid19api.com/total/country/singapore/status/confirmed?from=2020-03-01T00:00:00Z';
async function getData() {
  const response = await fetch(api_url);
  const data = await response.json();
  let processData = []
  for (let dailyRecord of data) {
    processData.push([new Date(dailyRecord.Date).getTime(), dailyRecord.Cases])
  }
  plotChart('container1', processData, false);
  plotChart('container2', processData, true);
}

function plotChart(container, data, isLog) {
  let ytype = isLog ? 'logarithmic' : 'value';
  let cTitle = isLog ? 'Total Covid-19 Cases (Logarithmic)' : 'Total Covid-19 Cases (Linear)'
  Highcharts.chart(container, {
    chart: {zoomType: 'x'},
    title: {text: cTitle},
    subtitle: {text: document.ontouchstart === undefined ? 'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in' },
    xAxis: { type: 'datetime' },
    yAxis: { type: ytype, title: { ext: 'Total Cases' } },
    legend: { enabled: false },
    plotOptions: {
      area: {
        fillColor: {
          linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
          stops: [
            [0, Highcharts.getOptions().colors[0]],
            [1, Highcharts.color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
          ]
        },
        marker: { radius: 2 },
        lineWidth: 1,
        states: { hover: { lineWidth: 1 } },
        threshold: null
      }
    },
    series: [{type: 'area', name: 'Total Cases', data: data}]
  });
}

getData();