function createNoDataMessage(canvasId) {
    var $cardBody= $("#"+canvasId).closest('.card-body')
    console.log( $cardBody)
    $cardBody.html('<div style="min-height: 250px;" class="no-data w-100 h-100 d-flex justify-content-center align-items-center text-danger">No Data Available For Chart</div>')
}

function createChart(canvasId, chartType, labels, data, backgroundColors, width=400, height=400) {
  const ctx = document.getElementById(canvasId);
  if (!ctx) {
      console.error(`Canvas with ID ${canvasId} not found.`);
      return;
  }
  
  ctx.width = width;
  ctx.height = height;

  const total = data.reduce((acc, value) => acc + value, 0)
  const percentageData = data.map(value => ((value / total) * 100).toFixed(2));

  const chartData = {
      labels: labels.map((label, index) => (canvasId === 'schedule-adherence' ? `${label}-(${data[index]}%) members` : `${label} : ${ isNaN(percentageData[index]) ? '-' : Math.round(percentageData[index])+'%'}`)),
      datasets: [{
          label: 'Dataset ',
          data: data,
          backgroundColor: backgroundColors,
          hoverOffset: 4
      }]
  };
  plugins = canvasId === 'enagagements' ? [] : [htmlLegendPlugin]
  
  new Chart(ctx, {
      type: chartType,
      data: chartData,
      options: {
          plugins: {
              htmlLegend: {
                  containerID: `${canvasId}-legend-container`,
              },
              tooltip: {
                  titleFont: {
                      size: 10,
                      weight: 'bold'
                  }
              },
              legend: {
                  display: false,
                  labels: {
                      usePointStyle: true,
                      pointStyleWidth: 10,
                  }
              },
          }
      },
      plugins: plugins,
  });
  const allDataZero = data.every(value => value === 0);

  if (allDataZero) {
      createNoDataMessage(canvasId);
      return;
  }
}


const htmlLegendPlugin = {
  id: 'htmlLegend',
  afterUpdate(chart, args, options) {
      const ul = getOrCreateLegendList(chart, options.containerID);

      // Remove old legend items
      while (ul.firstChild) {
          ul.firstChild.remove();
      }

      // Reuse the built-in legendItems generator
      const items = chart.options.plugins.legend.labels.generateLabels(chart);
      // console.log('labels>>>>',chart.data.labels)
      items.forEach(item => {
          const li = document.createElement('li');
          li.style.alignItems = 'center';
          li.style.cursor = 'pointer';
          li.style.display = 'flex';
          li.style.flexDirection = 'row';
          li.style.marginLeft = '10px';
          li.style.marginBottom = '10px';

          li.onclick = () => {
              const {
                  type
              } = chart.config;
              if (type === 'pie' || type === 'doughnut') {
                  // Pie and doughnut charts only have a single dataset and visibility is per item
                  chart.toggleDataVisibility(item.index);
              } else {
                  chart.setDatasetVisibility(item.datasetIndex, !chart.isDatasetVisible(item.datasetIndex));
              }
              chart.update();
          };

          // Color box
          const boxSpan = document.createElement('span');
          boxSpan.style.background = item.fillStyle;
          boxSpan.style.borderColor = item.strokeStyle;
          boxSpan.style.borderWidth = item.lineWidth + 'px';
          boxSpan.style.display = 'inline-block';
          boxSpan.style.flexShrink = 0;
          boxSpan.style.height = '20px';
          boxSpan.style.marginRight = '10px';
          boxSpan.style.width = '20px';
          boxSpan.style.borderRadius = '50%';

          // Text
          const textContainer = document.createElement('p');
          textContainer.style.color = item.fontColor;
          textContainer.style.margin = 0;
          textContainer.style.padding = 0;
          textContainer.style.textDecoration = item.hidden ? 'line-through' : '';
          textContainer.style.lineHeight = '20px';
          // console.log(item.text)

          const text = item.text.split(/\(([^)]+)%\)/).map(part => {
              const match = part.split(/\(([^)]+)%\)/)
              // Check if the part is a number
              if (!isNaN(part) && part != '') {
                  // If it's a number, wrap it in a span with the desired color
                  const containsNon = item.text.toLowerCase().includes('non');
                  const containsNot = item.text.toLowerCase().includes('not');
                  const color = (containsNon || containsNot) ? 'crimson' : 'green';
                  // Determine the color based on the number count
                  const span = document.createElement('span');
                  span.style.color = item.numberColor || color; // You can set a default color if needed
                  if (item.text.toLowerCase().includes('non adherence')) {
                      span.appendChild(document.createTextNode(`${part}`))
                  } else {

                      span.appendChild(document.createTextNode(`${part}%`));
                  }
                  return span;
              } else {
                  // Otherwise, return the text as it is
                  return document.createTextNode(part);
              }
          });
          // Append all text parts to the text container
          text.forEach(part => {
              textContainer.appendChild(part);
          });


          li.appendChild(boxSpan);
          li.appendChild(textContainer);
          ul.appendChild(li);
      });

  }
};

const getOrCreateLegendList = (chart, id) => {
  const legendContainer = document.getElementById(id);
  
  if(legendContainer){
    let listContainer = legendContainer.querySelector('ul');
    if (!listContainer) {
      listContainer = document.createElement('ul');
      listContainer.style.display = 'flex';
      listContainer.style.flexDirection = 'row';
      listContainer.style.flexWrap = 'wrap';
      listContainer.style.margin = 0;
      listContainer.style.padding = 0;
  
      legendContainer.appendChild(listContainer);
    }
  
    return listContainer;
  }
  
  
};