/*Copyright (c) 2013 NTS Corp. All Rights Reserved.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
/*Developed by Insook Choe (choe.insook@nhn.com), Inho Jung(inho.jung@nhn.com)*/

var CONST_SVG_URL = 'http://www.w3.org/2000/svg';
var VML_NAME_SPACE = 'urn:schemas-microsoft-com:vml'
var CONST_MAX_RADIUS = 100;
var CONST_DECREMENT = 20;

var Nwagon = {

    chart: function(options){
        var isIE_old = false;
        if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)) { //test for MSIE x.x;
            var ieversion = new Number(RegExp.$1); // capture x.x portion and store as a number
            if (ieversion <= 8){

                isIE_old = true;
                if(!document.namespaces['v']) {
                   document.namespaces.add('v', VML_NAME_SPACE);
                }
            }
        }
        var chartObj = new Object();
        chartObj.chartType = options['chartType'];
        chartObj.dataset = options['dataset'];
        chartObj.legend = options['legend'];
        chartObj.width = options['chartSize']['width'];
        chartObj.height = options['chartSize']['height'];
        chartObj.chart_div = options['chartDiv'];

        //************ values.length should be equal to names.length **************// 
        switch (chartObj.chartType)
        {
            case ('radar') :
                isIE_old ? Nwagon_ie.radar.drawRadarChart(chartObj) : this.radar.drawRadarChart(chartObj);
                break;
            case ('polar') :
            case ('polar_pie') :
                chartObj.core_circle_radius = options['core_circle_radius'];
                chartObj.core_circle_value = options['core_circle_value'];
                chartObj.max = options['maxValue'];
                chartObj.increment = options['increment'];
                isIE_old ? Nwagon_ie.polar.drawPolarChart(chartObj) : this.polar.drawPolarChart(chartObj);
                break;
            case ('donut') : 
            case ('pie') : 
                chartObj.core_circle_radius = 0;
                if(chartObj.chartType == 'donut'){
                    chartObj.core_circle_radius = options['core_circle_radius'];
                }
                chartObj.donut_width = options['donut_width'];
                isIE_old ? Nwagon_ie.donut.drawDonutChart(chartObj) : this.donut.drawDonutChart(chartObj); 
                break;
            case ('line') :
            case ('area') :
            case ('jira') :
                if (options.hasOwnProperty('bottomOffsetValue')) chartObj.bottomOffsetValue = options['bottomOffsetValue']; 
                if (options.hasOwnProperty('leftOffsetValue')) chartObj.leftOffsetValue = options['leftOffsetValue']; 
                if (options['maxValue']) chartObj.highest = options['maxValue'];
                if (options['minValue']) chartObj.lowest = options['minValue'];
                if (options['increment']) chartObj.increment = options['increment'];
                if (options['isGuideLineNeeded']) chartObj.isGuideLineNeeded = options['isGuideLineNeeded'];
                isIE_old ? Nwagon_ie.line.drawLineChart(chartObj) : this.line.drawLineChart(chartObj);
                break;
            case ('column'):
            case ('stacked_column') :
            case ('multi_column') :
                if (options.hasOwnProperty('bottomOffsetValue')) chartObj.bottomOffsetValue = options['bottomOffsetValue']; 
                if (options.hasOwnProperty('leftOffsetValue')) chartObj.leftOffsetValue = options['leftOffsetValue']; 
                if (options.hasOwnProperty('topOffsetValue')) chartObj.topOffsetValue = options['topOffsetValue']; 
                if (options.hasOwnProperty('rightOffsetValue')) chartObj.rightOffsetValue = options['rightOffsetValue']; 
                if (options['maxValue']) chartObj.highest = options['maxValue'];
                if (options['increment']) chartObj.increment = options['increment'];
                
                isIE_old ? Nwagon_ie.column.drawColumnChart(chartObj) : this.column.drawColumnChart(chartObj);
                break;
        }
    },

    createChartArea: function(parentSVG, chartType, viewbox, width, height){

        var chartDiv = document.getElementById(parentSVG);
        var textArea = document.createElement('ul');
        textArea.className = 'accessibility';
        chartDiv.appendChild(textArea);
        var attr = {'version':'1.1', 'width':width, 'height':height, 'viewBox':viewbox, 'class':'Nwagon_' + chartType, 'aria-hidden':'true'};
        var svg = Nwagon.createSvgElem('svg', attr);
        chartDiv.appendChild(svg);

        return svg;
    },

    createSvgElem: function(elem, attr){
        var svgElem = document.createElementNS(CONST_SVG_URL, elem);
        Nwagon.setAttributes(svgElem, attr);
        return svgElem;
    },

    setAttributes: function(svgObj, attributes){
        var keys_arr = Object.keys(attributes);
        var len = keys_arr.length;
        for(var i = 0; i<len; i++){
            svgObj.setAttribute(keys_arr[i], attributes[keys_arr[i]]);
        }
    },

    getMax: function(a){
        var maxValue = 0;
        if(a.length){
            for (var j = 0; j < a.length; j++)
            {
                var a_sub = a[j];
                if(a_sub.length){
                    for(var k = 0; k<a_sub.length; k++){
                        if (typeof(a_sub[k]) == 'number' && a_sub[k] > maxValue) maxValue = a_sub[k];    
                    }
                }
                else{
                    if (typeof(a[j]) == 'number' && a[j] > maxValue) maxValue = a[j];
                }
            }
        }
        return maxValue;
    },

    createTooltip: function(){
        var tooltip = Nwagon.createSvgElem('g', {'class':'tooltip'});
        var tooltipbg = Nwagon.createSvgElem('rect', {});
        tooltip.appendChild(tooltipbg);

        var tooltiptxt = Nwagon.createSvgElem('text', {});
        tooltip.appendChild(tooltiptxt);

        return tooltip;
    },

    showToolTip: function(tooltip, px, py, value, height, ytextOffset, yRectOffset){
        return function(){
            tooltip.style.cssText = "display: block";
            var text_el = tooltip.getElementsByTagName('text')[0];
            text_el.textContent = ' '+value;
            Nwagon.setAttributes(text_el, {'x':px, 'y':py-ytextOffset, 'text-anchor':'middle'});
            var width = text_el.getBBox().width;
            Nwagon.setAttributes(tooltip.getElementsByTagName('rect')[0], {'x':(px-width/2)-5, 'y':py-yRectOffset, 'width':width+10,'height':height});
        }
    },

    hideToolTip: function(tooltip){
        return function(){
            tooltip.style.cssText = "display: none";
        }
    },

    getAngles: function(arr, angles){
                    
        var total = 0;
        for(var i=0; i<arr.length; i++){
            total+=arr[i];
        }
        for(i=0; i<arr.length; i++){
            var degree = 360 * (arr[i]/total);
            angles['angles'].push(degree);
            angles['percent'].push(arr[i]/total);
            angles['values'].push(arr[i]);
        }
        return angles;
    },
    getOpacity: function(opa, r, max_r){
                var len  = opa.length;
                var interval = max_r/len;
                var value = Math.ceil(r/interval);
                return opa[value-1];
    },

    line:{
        points:[],
        guide_line: null, 

        drawLabels: function(x, y, labelText){
            var attributes = {'x':x, 'y':y, 'text-anchor':'end'};
            var text = Nwagon.createSvgElem('text', attributes);
            text.textContent = labelText;
            return text;
        },
        drawLineChart: function(obj){
            var type = obj.chartType;
            var isAreaChart = (type == 'area'), isJira = (type == 'jira');
            var width = obj.width, height = obj.height;
            var values = obj.dataset['values'];
            var LeftOffsetAbsolute =  obj.hasOwnProperty('leftOffsetValue') ? obj.leftOffsetValue : 50;
            var BottomOffsetAbsolute = obj.hasOwnProperty('bottomOffsetValue') ? obj.bottomOffsetValue : 80;
            var TopOffsetAbsolute =  obj.hasOwnProperty('topOffsetValue') ? obj.topOffsetValue : 0;
            var RightOffsetAbsolute = obj.hasOwnProperty('rightOffsetValue') ? obj.rightOffsetValue : 0;
            var names = obj.legend['names'];
            var isGuideNeeded = obj.hasOwnProperty('isGuideLineNeeded') ? obj.isGuideLineNeeded : false;
            
            RightOffsetAbsolute = obj.dataset['fields'] ? (150 + RightOffsetAbsolute) : RightOffsetAbsolute;

            var viewbox = (-LeftOffsetAbsolute) + ' ' + (BottomOffsetAbsolute-height) + ' ' + width + ' ' + height;
            var svg =  Nwagon.createChartArea(obj.chart_div, obj.chartType, viewbox, width, height);
            var max = obj.highest ? obj.highest : Nwagon.getMax(values);
            var min = obj.lowest ? obj.lowest : 0;
            this.drawBackground(svg, names.length, obj.dataset, obj.increment, max, min, width-LeftOffsetAbsolute-RightOffsetAbsolute, height-BottomOffsetAbsolute-TopOffsetAbsolute);
            this.drawLineForeground(obj.chart_div, svg, obj.legend, obj.dataset, obj.increment, max, min, width-LeftOffsetAbsolute-RightOffsetAbsolute, height-BottomOffsetAbsolute-TopOffsetAbsolute, isAreaChart, isJira, isGuideNeeded);

            // after guide line is drawn, add eventlistener to svg
            if(Nwagon.line.guide_line){
                var line = Nwagon.line.guide_line;
                var interval = Math.floor((width-LeftOffsetAbsolute-RightOffsetAbsolute)/names.length);
                var x_coord_max = line.x1.animVal.value;
                var text_add = '', index = 0;
                var fields = obj.dataset['fields'];
                var _h = fields ?  fields.length * 14 : 14;
                var tool = Nwagon.createTooltip();
                var text_el = tool.getElementsByTagName('text')[0];
                if(text_el){
                    for(var i = 0; i<fields.length; i++){
                        var ts = Nwagon.createSvgElem('tspan', {});      
                        text_el.appendChild(ts);
                    }
                }
                svg.appendChild(tool);

                var pt = svg.createSVGPoint();
                function cursorPoint(evt){
                    pt.x = evt.clientX; pt.y = evt.clientY;
                    return pt.matrixTransform(svg.getScreenCTM().inverse());
                }
                svg.addEventListener('mousemove',function(evt){
                    var loc = cursorPoint(evt);
                    var x = loc.x;
                    if(x < 0) x = 0; 
                    if(x > x_coord_max) x = x_coord_max; 
                    if(loc.y < 0){
                        line.setAttribute('x1', x);
                        line.setAttribute('x2', x);
                        index = Math.floor(x/interval);
                        tool.style.cssText = 'display: block';                        
                        if(fields &&  values[index]){
                            var ts_group = text_el.getElementsByTagName('tspan');
                            for(var i = 0; i<fields.length; i++){
                                ts_group[i].setAttribute('x', x);
                                if(i>0) ts_group[i].setAttribute('dy', 15);
                                ts_group[i].textContent = names[index] + '('+ fields[i] + '): ' + values[index][i];
                            }
                        }
                        Nwagon.setAttributes(text_el, {'x':x, 'y':loc.y-40, 'text-anchor':'start'});
                        var _width = text_el.getBBox().width;
                        Nwagon.setAttributes(tool.getElementsByTagName('rect')[0], {'x':x-5, 'y':loc.y-50, 'width':_width+10,'height':_h});
                    }
                },false);
                svg.addEventListener('mouseout',function(evt){
                    tool.style.cssText = 'display:none';
                },false);
            }
        },
        drawJiraForeground:function(parentDiv, _points, colors){
            var getSlopeAndAlpha = function(point_1, point_2){
                var values = {};
                var slope;
                if((point_2[1] == point_1[1])){
                    slope = 0;
                }
                else{
                    slope = (point_2[1]-point_1[1])/(point_2[0]-point_1[0]);
                }
                values['alpha'] = point_1[1] - (slope * point_1[0]);
                values['slope'] = slope;
                return values;
            };
            var drawPolygons = function(arr1, arr2){

                if(arr1 && arr2){
                    var color, first, second, px, py;
                    var points_to_draw = '';

                    var i = 0;
                    while ( i < arr1.length){
                        if(arr1[i][1] > arr2[i][1]){
                            first = arr1;
                            second = arr2;
                            color = colors[0];
                            break;
                        }
                        if(arr1[i][1] < arr2[i][1]){
                            first = arr2;
                            second = arr1;
                            color = colors[1];
                            break;
                        }
                        i++;
                    }
                    var j = 0;
                    while(j<first.length){
                        px = first[j][0];
                        py = first[j][1];
                        if(j === 0){
                            points_to_draw += 'M '+px + ' -' + py;
                        }
                        else{
                            points_to_draw += ' L '+px + ' -' + py;
                        }
                        j++;
                    }
                    var k = second.length-1;
                    while(k >=0){
                        px = second[k][0];
                        py = second[k][1];
                        points_to_draw += ' L '+px + ' -' + py;
                        k--;
                    }

                    points_to_draw +=' Z';
                    var unlayered = Nwagon.createSvgElem('path', {'d':points_to_draw, 'fill': color, 'opacity':'0.7'});
                    polygons.appendChild(unlayered);
                }
            };
            
            var foregrounds = document.getElementById(parentDiv).querySelectorAll('.Nwagon_jira g.foreground');
            var foreground = foregrounds[foregrounds.length-1];
            
            var polygons = Nwagon.createSvgElem('g', {'class':'polygon'});
            foreground.appendChild(polygons);

            var layered_points = [];
            if(_points.length == 2){
                var colorOne = colors[0];
                var colorTwo = colors[1];
                var one = _points[0];
                var two = _points[1];
                var temp_one = [], temp_two = [];

                if(one.length === two.length){
                    var length = one.length;


                    for(var i = 0; i < length; i++){
                        temp_one.push(one[i]);
                        temp_two.push(two[i]);

                        if((one[i][1] > two[i][1])) layered_points.push(two[i]);
                        else layered_points.push(one[i]);

                        if(i !== length-1){
                            if( !((one[i][1] > two[i][1]) && (one[i+1][1] > two[i+1][1])) &&
                                !((one[i][1] < two[i][1]) && (one[i+1][1] < two[i+1][1])) &&
                                !((one[i][1] == two[i][1]) || (one[i+1][1] == two[i+1][1])) )
                            {
                                var points_to_push = [];
                                var equation1 = getSlopeAndAlpha(one[i], one[i+1]);
                                var equation2 = getSlopeAndAlpha(two[i], two[i+1]);
                                var slope1 = equation1['slope'];
                                var slope2 = equation2['slope'];
                                var alpha1 = equation1['alpha'];
                                var alpha2 = equation2['alpha'];

                                var px = (alpha2 - alpha1)/(slope1-slope2);
                                var py = (px * slope1) + alpha1;
                                points_to_push.push(px);
                                points_to_push.push(py);
                                layered_points.push(points_to_push);
                                temp_one.push(points_to_push); // for making splicing easier push the cross _points twice
                                temp_one.push(points_to_push);
                                temp_two.push(points_to_push);
                                temp_two.push(points_to_push);
                            }
                        }
                    }
                }
            }
            // Draw polygon where two areas are stacked up
            if(layered_points.length){

                var points_to_draw = '';
                for (var i = 0; i<layered_points.length; i++){
                    var px = layered_points[i][0];
                    var py = layered_points[i][1];
                    if(i === 0){
                        points_to_draw += 'M '+px + ' -' + py;
                    }
                    else{
                        points_to_draw += ' L '+px + ' -' + py;
                    }
                }
                points_to_draw += ' L '+layered_points[layered_points.length-1][0] + ' -' + 0 + ' L 0 0 Z';
                var layered_line = Nwagon.createSvgElem('path', {'d':points_to_draw, 'class':'layered'});
                polygons.appendChild(layered_line);
            }
            // Draw polygons for non-layered portions
            if(temp_one.length === temp_two.length){
                var i = 0;
                while(i<temp_one.length){
                    if((temp_one[i][1] == temp_two[i][1] ) && (i !=0) || (i == temp_one.length-1)) {
                        var splice_one = temp_one.splice(i+1);
                        var splice_two = temp_two.splice(i+1);
                        drawPolygons(temp_one, temp_two);

                        temp_one = splice_one;
                        temp_two = splice_two;
                        i = 0;
                    }
                    i++;
                }
            }
        },
        draw_vertex_and_tooltip:function(parentSVG, data, guide_needed){
            var circles = Nwagon.createSvgElem('g', {'class':'circles'});
            parentSVG.appendChild(circles);
            if(!guide_needed){
                var tooltip = Nwagon.createTooltip();
                parentSVG.appendChild(tooltip);
            }
            for (var i = 0; i<data.length; i++){
                var vertex = Nwagon.createSvgElem('circle', data[i]['attributes']);
                circles.appendChild(vertex);
                if(!guide_needed){
                    vertex.onmouseover = Nwagon.showToolTip(tooltip, data[i]['tooltip_x'], data[i]['tooltip_y'], data[i]['text'], 14, 7, 18);
                    vertex.onmouseout = Nwagon.hideToolTip(tooltip);
                }
            }
        },
        drawLineForeground: function(parentDiv, parentSVG, legend, dataset, increment, max, min, width, height, isAreaChart, isJira, guide_line_needed){
            var numOfCols = legend['names'].length;
            var colWidth = (width/numOfCols).toFixed(3);
            var yLimit = (Math.ceil((max-min)/increment)+1) * increment;
            var px = '', cw = '', ch = '';
            var names = legend['names'];
            var data = dataset['values'];
            var colors = dataset['colorset'];
            var fields = dataset['fields'];
            var circle_and_tooltips = [];
            var jira_points = [];

            var foreground = Nwagon.createSvgElem('g', {'class':'foreground'});
            parentSVG.appendChild(foreground);

            var lines = Nwagon.createSvgElem('g', {'class':'lines'});
            foreground.appendChild(lines);

            var labels = Nwagon.createSvgElem('g', {'class':'labels'});
            foreground.appendChild(labels);

            // Draw foreground elements (lines, circles, labels...)
            cw = (3/5*colWidth);
            if(data[0]){
                for (var k = 0; k < data[0].length; k++){
                    var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                    if(ul){
                        var textEl = document.createElement('li');
                        textEl.innerHTML = fields[k];
                        var innerUL = document.createElement('ul');
                        textEl.appendChild(innerUL);
                        ul.appendChild(textEl);
                    }

                    var first_y = 0;
                    var points_to_draw = '';
                    var line_points = [];
                    var start_point = 0;
                    for (var i = 0; i<data.length; i++){
                        var circle_and_tooltip_data = {};
                        var point_pair = [];
                        px =  colWidth*i;
                        
                        var py = ((data[i][k] - min) / yLimit) * height;
                        if(isNaN(py)){
                            start_point++;
                        }
                        else{
                            if(i === start_point){
                                points_to_draw += 'M '+px + ' -' + py;
                                first_y = py;
                            }
                            else{
                                points_to_draw += ' L '+px + ' -' + py;
                            }
                            point_pair.push(px);
                            point_pair.push(py);
                            line_points.push(point_pair);

                            var attributes = {'cx':px, 'cy':'-'+py, 'r':2, 'stroke': colors[k], 'fill':colors[k]};
                            var tooltip_text = names[i] + '('+ fields[k] + '): ' + data[i][k].toString();

                            circle_and_tooltip_data['attributes'] = attributes;
                            circle_and_tooltip_data['text'] = tooltip_text;
                            circle_and_tooltip_data['tooltip_x'] =  px+cw/2;
                            circle_and_tooltip_data['tooltip_y'] =  -py;
                            circle_and_tooltips.push(circle_and_tooltip_data);

                            if(innerUL){
                                var innerLI = document.createElement('li');
                                innerLI.innerHTML =  'Label ' + names[i] + ',  Value '+ data[i][k].toString();
                                innerUL.appendChild(innerLI);
                            }
                        }
                        if(k===0){
                            var text = Nwagon.line.drawLabels(px + cw/2, 15, names[i], false, 0);
                            labels.appendChild(text);
                        }
                    }

                    var line = Nwagon.createSvgElem('path', {'d':points_to_draw, 'fill': 'none', 'stroke':colors[k]});

                    if (isAreaChart){
                        var polygon_to_draw = points_to_draw +' L '+px+ ' ' + 0 + ' L '+0 + ' ' + 0 + ' L '+0 + ' -' + first_y +' Z';
                        var polygon = Nwagon.createSvgElem('path', {'d':polygon_to_draw, 'fill':colors[k], 'opacity': '0.8'});
                        lines.appendChild(polygon);
                    }
                    lines.appendChild(line);
                    jira_points.push(line_points);
                }
            }
            if(isJira){
                Nwagon.line.drawJiraForeground(parentDiv, jira_points, colors);
            }

            if(guide_line_needed){
                Nwagon.line.guide_line = Nwagon.createSvgElem('line',  {'x1':numOfCols*colWidth, 'y1': 4, 'x2':numOfCols*colWidth, 'y2' : -height, 'class':'guide_line'});
                parentSVG.appendChild(Nwagon.line.guide_line);  
            }

            Nwagon.line.draw_vertex_and_tooltip(foreground, circle_and_tooltips, guide_line_needed);

        },

        drawBackground: function(parentSVG, numOfCols, dataset, increment, max, min, width, height){

            var colWidth = (width/numOfCols).toFixed(3);
            var attributes = {};
            var px = '', yRatio = 1;

            var background = Nwagon.createSvgElem('g', {'class':'background'});
            parentSVG.appendChild(background);

            var numOfRows = Math.ceil((max-min)/increment);
            var rowHeight = height/(numOfRows+1);

            //Vertical lines(Fist line)
            attributes = {'x1':'0', 'y1':'0', 'x2':'0', 'y2':-height + (rowHeight/2), 'class':'v'};
            var line = Nwagon.createSvgElem('line', attributes);
            background.appendChild(line); 

            //Vertical lines(x-axis)
            for (var i = 0; i < numOfCols; i++)
            {
                px = i * colWidth;
                attributes = {'x1':px, 'y1': 4, 'x2':px, 'y2':-1 , 'class':'v'};
                line = Nwagon.createSvgElem('line', attributes);
                background.appendChild(line);
            }

            //Horizontal lines  
            var count = 0;
            for (i = 0; i<=numOfRows; i++)
            {
                var class_name = (i === 0) ? 'h' : 'h_dash' ;
                attributes = {'x1':'-3', 'y1':'-'+ i*rowHeight, 'x2':(numOfCols*colWidth).toString(), 'y2':'-'+ i*rowHeight, 'class':class_name};
                line = Nwagon.createSvgElem('line', attributes);
                background.appendChild(line);

                attributes = {'x':'-15', 'y':-((count*rowHeight)-3), 'text-anchor':'end'};
                var text = Nwagon.createSvgElem('text', attributes);
                text.textContent = ((count*increment) + min).toString();

                background.appendChild(text);
                count++;
            }
            //Field Names
            if(dataset['fields'])
            {
                var fields = Nwagon.createSvgElem('g', {'class':'fields'});
                background.appendChild(fields);

                var numOfFields = dataset['fields'].length;
                for (i = 0; i<numOfFields; i++)
                {
                    px = width+20;
                    py = (30*i) - height + rowHeight;

                    attributes = {'x':px, 'y':py, 'width':20, 'height':15, 'fill':dataset['colorset'][i]};
                    var badge = Nwagon.createSvgElem('rect', attributes);
                    fields.appendChild(badge);

                    attributes = {'x':px+30, 'y':py+7, 'alignment-baseline':'central'};
                    var name = Nwagon.createSvgElem('text', attributes);
                    name.textContent = dataset['fields'][i];
                    fields.appendChild(name);
                }
            }
        }
    },

    column:{

        drawColumnChart: function(obj){

            var width = obj.width, height = obj.height;
            var values = obj.dataset['values'];
            var LeftOffsetAbsolute =  obj.hasOwnProperty('leftOffsetValue') ? obj.leftOffsetValue : 50;
            var BottomOffsetAbsolute = obj.hasOwnProperty('bottomOffsetValue') ? obj.bottomOffsetValue : 80;
            var TopOffsetAbsolute =  obj.hasOwnProperty('topOffsetValue') ? obj.topOffsetValue : 0;
            var RightOffsetAbsolute = obj.hasOwnProperty('rightOffsetValue') ? obj.rightOffsetValue : 0;
            
            RightOffsetAbsolute = obj.dataset['fields'] ? (150 + RightOffsetAbsolute) : RightOffsetAbsolute;

            var viewbox = (-LeftOffsetAbsolute) + ' ' + (BottomOffsetAbsolute -height) + ' ' + width + ' ' + height;
            var svg =  Nwagon.createChartArea(obj.chart_div, obj.chartType, viewbox, width, height);
            var max = obj.highest ? obj.highest : Nwagon.getMax(values);

            this.drawBackground(svg, obj.legend['names'].length, obj.dataset, obj.increment, max, width-LeftOffsetAbsolute-RightOffsetAbsolute, height-BottomOffsetAbsolute-TopOffsetAbsolute);
            this.drawColumnForeground(obj.chart_div, svg, obj.legend, obj.dataset, obj.increment, max, width-LeftOffsetAbsolute-RightOffsetAbsolute, height-BottomOffsetAbsolute-TopOffsetAbsolute, obj.chartType);

        },

        drawColumn: function(parentGroup, width, height){

            var column = Nwagon.createSvgElem('rect', {'x':'0', 'y':-height, 'width':width, 'height':height});
            parentGroup.appendChild(column);

            return column;
        },

        drawLabels: function(x, y, labelText){

            var attributes = {'x':x, 'y':y, 'text-anchor':'end', 'transform':'rotate(315,'+ x +','+ y + ')'};
            var text = Nwagon.createSvgElem('text', attributes);
            text.textContent = labelText;

            return text;
        },

        getColorSetforSingleColumnChart: function(max, values, colorset){
            var numOfColors = colorset.length;
            var interval = max/numOfColors;
            var colors = [];
            
            for(var index = 0; index < values.length; index++){
                var colorIndex = Math.floor(values[index]/interval);
                if (colorIndex == numOfColors) colorIndex--;
                colors.push(colorset[colorIndex]);
            }
            return colors;
        },

        drawColumnForeground: function(parentDiv, parentSVG, legend, dataset, increment, max, width, height, chartType){

            var names = legend['names'];
            var numOfCols = names.length;
            var colWidth = (width/numOfCols).toFixed(3);
            var yLimit = (Math.ceil(max/increment)+1) * increment;
            var px = '', cw = '', ch = '';
            var data = dataset['values'];
            var chart_title = dataset['title'];
            var fields = dataset['fields'];

            var foreground = Nwagon.createSvgElem('g', {'class':'foreground'});
            parentSVG.appendChild(foreground);

            var columns = Nwagon.createSvgElem('g', {'class':'columns'});
            foreground.appendChild(columns);

            var labels = Nwagon.createSvgElem('g', {'class':'labels'});
            foreground.appendChild(labels);

            var tooltip = Nwagon.createTooltip();
            foreground.appendChild(tooltip);

            var drawColGroups = function(columns, ch, px, color, tooltipText, isStackedColumn, yValue){
                var colgroup  =  Nwagon.createSvgElem('g', {});
                columns.appendChild(colgroup);

                var column = Nwagon.column.drawColumn(colgroup, cw, ch);

                Nwagon.setAttributes(column, {'x':px, 'style':'fill:'+color});
                if(isStackedColumn)
                {
                    var py =  yValue - column.getBBox().y;
                    if ( py > 0 ) Nwagon.setAttributes(column, {'y':-py});
                    ch = py;
                }

                column.onmouseover = Nwagon.showToolTip(tooltip, px+cw/2, -ch, tooltipText, 14, 7, 18);
                column.onmouseout = Nwagon.hideToolTip(tooltip);

                column = null;  //prevent memory leak (in IE) 
            };

            var create_data_list = function(obj){
                var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                if (ul){
                    for (var key in obj){
                        if(obj.hasOwnProperty(key)){
                            var li = document.createElement('li');
                            li.innerHTML = key;
                            var innerUL = document.createElement('ul');
                            li.appendChild(innerUL);
                            ul.appendChild(li);
                            var innerList = obj[key];
                            for (var k = 0; k< innerList.length; k++){
                                var innerLI = document.createElement('li');
                                innerLI.innerHTML = innerList[k];
                                innerUL.appendChild(innerLI);
                            }
                        }
                    }
                }
            };

            if(chartType == 'column')
            {
                var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                if(ul){
                    ul.innerHTML = chart_title;
                }
                cw = (3/5*colWidth);
                var colors = Nwagon.column.getColorSetforSingleColumnChart(max, data, dataset['colorset']);

                for(var index = 0; index < data.length; index++){
                    px = (colWidth*(index+0.2));// + cw;
                    ch = data[index]/yLimit*height;
                    drawColGroups(columns, ch, px, colors[index], data[index]);

                    var text = Nwagon.column.drawLabels(px + cw/2, 15, names[index], false, 0);
                    labels.appendChild(text);

                    var innerLI = document.createElement('li');
                    innerLI.innerHTML = 'Label ' + names[index] + ', Value  '+ data[index];
                    if(ul){
                        ul.appendChild(innerLI);
                    }
                }
            }
            else if(chartType == 'multi_column')
            {
                var colors = dataset['colorset'];
                cw = (3/5*colWidth)/colors.length;
                var chart_data = {};
                for ( var k = 0; k<fields.length; k++){
                    chart_data[fields[k]] = [];
                }

                for(var i = 0; i < data.length; i++){
                    var one_data = data[i];
                    px = (colWidth*(i+0.2));

                    for(var index = 0; index < one_data.length; index++){
                        var pxx = px+ (index*(cw));
                        ch = one_data[index]/yLimit*height;
                        drawColGroups(columns, ch, pxx, colors[index], one_data[index], false, 0);
                        chart_data[fields[index]].push('Label ' + names[i] + ', Value  '+ one_data[index]);
                    }

                    var text = Nwagon.column.drawLabels(px + cw/2, 15, names[i]);
                    labels.appendChild(text);
                }
                create_data_list(chart_data);
            }
            else if(chartType == 'stacked_column')
            {
                cw = (3/5*colWidth);
                var colors = dataset['colorset'];
                var chart_data = {};
                for ( var k = 0; k<fields.length; k++){
                    chart_data[fields[k]] = [];
                }
                for(var i = 0; i < data.length; i++){
                    var one_data = data[i];
                    var yValue = 0;

                    for(var index = 0; index < one_data.length; index++){
                        px = (colWidth*(i+0.2));// + cw;
                        ch = one_data[index]/yLimit*height;

                        drawColGroups(columns, ch, px, colors[index], one_data[index], true, yValue);
                        chart_data[fields[index]].push('Label ' + names[i] + ', Value  '+ one_data[index]);
                        yValue +=ch;
                    }


                    var text = Nwagon.column.drawLabels(px + cw/2, 15, names[i]);
                    labels.appendChild(text);
                }
                create_data_list(chart_data);
            }
        },

        drawBackground: function(parentSVG, numOfCols, dataset, increment, max, width, height){

            var colWidth =(width/numOfCols).toFixed(3);
            var attributes = {};
            var px = '', yRatio = 1;

            var background = Nwagon.createSvgElem('g', {'class':'background'});
            parentSVG.appendChild(background);

            var numOfRows = Math.ceil(max/increment);
            rowHeight = height/(numOfRows+1);

            //Vertical lines
            for (var i = 0; i<=numOfCols; i++)
            {
                px = (i * colWidth).toString();
                attributes = {'x1':px, 'y1':'0', 'x2':px, 'y2':rowHeight-height, 'class':'v'};
                var line = Nwagon.createSvgElem('line', attributes);
                background.appendChild(line);
            }
            //Horizontal lines (draw 1 more extra line to accomodate the max value)
            var count = 0;
            for (var i = 0; i<=numOfRows; i++)
            {
                attributes = {'x1':'0', 'y1':'-'+ i*rowHeight, 'x2':(numOfCols*colWidth).toString(), 'y2':'-'+ i*rowHeight, 'class':'h'};
                var line = Nwagon.createSvgElem('line', attributes);
                background.appendChild(line);

                attributes = {'x':'-15', 'y':-((count*rowHeight)-3), 'text-anchor':'end'};
                var text = Nwagon.createSvgElem('text', attributes);
                text.textContent = (count*increment).toString();

                background.appendChild(text);
                count++;
            }
            //Field Names
            if(dataset['fields'])
            {
                var fields = Nwagon.createSvgElem('g', {'class':'fields'});
                background.appendChild(fields);

                var numOfFields = dataset['fields'].length;
                for (var i = 0; i<numOfFields; i++)
                {
                    px = width+20;
                    py = (30*i) - height + rowHeight;

                    attributes = {'x':px, 'y':py, 'width':20, 'height':15, 'fill':dataset['colorset'][i]};
                    var badge = Nwagon.createSvgElem('rect', attributes);
                    fields.appendChild(badge);

                    attributes = {'x':px+25, 'y':py+7, 'alignment-baseline':'central'};
                    var name = Nwagon.createSvgElem('text', attributes);
                    name.textContent = dataset['fields'][i];
                    fields.appendChild(name);
                }
            }
        }
    },

    donut: {
        
        drawDonutChart: function(obj){
            var width = obj.width, height = obj.height;
            var viewbox = '-' + width/3 + ' -' + height/2 + ' ' + width + ' ' + height;
            var svg =  Nwagon.createChartArea(obj.chart_div, obj.chartType, viewbox, width, height);
            var angles = {'angles':[], 'percent':[], 'values':[]};
            var degree_values = obj.dataset['values'];
            if(degree_values){
                angles = Nwagon.getAngles(degree_values, angles);
            }
            this.drawDonut(obj.chart_div, angles, obj.chartType, svg, obj.dataset, obj.core_circle_radius, obj.donut_width);
            if(obj.core_circle_radius == 0){
                this.drawField(obj.dataset['fields'], obj.dataset['colorset'], svg, obj.donut_width/2);
            }
            else{
                this.drawField(obj.dataset['fields'], obj.dataset['colorset'], svg, obj.donut_width);
            }

        },
        drawDonut: function(parentDiv, angles, chart_type, parentSVG, data, core_radius, donut_width){
            // var core_circle_radius = core_radius;
            var radius = donut_width + core_radius;
            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            var create_data_li = function(text_to_add){
                if(ul){
                    var li = document.createElement('li');
                    li.innerHTML = text_to_add;
                    ul.appendChild(li);
                }
            };

            var foreground = Nwagon.createSvgElem('g', {'class':'foreground'});
            parentSVG.appendChild(foreground);
            var donuts = Nwagon.createSvgElem('g', {'class':'donuts'});
            foreground.appendChild(donuts);
            var tooltip = Nwagon.createTooltip();
            foreground.appendChild(tooltip);

            var colors = data['colorset'];
           
            var length = angles['angles'].length;
            var arch_end_x = 0, arch_end_y = 0;
            var points_to_draw = '', text_to_add = '';
            var names = data['fields'];
            var angle_to_rotate = 0;
            var sub_angle = angle_in_int = angle_in_int_accumulate = 0; 
            
            for(var j=0; j<length; j++)
            {
                var path;
                if(angles['percent'][j] < 1){
                    sub_angle = (Math.PI*2) * angles['percent'][j];
                    angle_in_int = angles['angles'][j];
                    if(j > 0){
                        angle_in_int_accumulate+=angles['angles'][j-1];
                    }

                    if(core_radius > 0) {
                        
                        if(sub_angle){
                            
                            arch_end_x = (radius)*Math.sin(sub_angle);
                            arch_end_y = sub_angle ? -(radius*Math.sin(sub_angle)/Math.tan(sub_angle)) : 0;

                            var end_x = core_radius*Math.sin(sub_angle);
                            var end_y = sub_angle ? -(core_radius*Math.sin(sub_angle)/Math.tan(sub_angle)) : 0;
                            
                            if(sub_angle > Math.PI){
                                points_to_draw = 'M0 '+ -core_radius+ ' L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 1 1 ' + arch_end_x +' '+ arch_end_y +' L '+ end_x +' '+ end_y;    
                                points_to_draw+= ' A ' + core_radius + ' ' + core_radius + ' 0 1 0 0 '+ -core_radius + ' Z';
                            }
                            else 
                            {
                                points_to_draw = 'M0 '+ -core_radius+ ' L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 0 1 ' + arch_end_x +' '+ arch_end_y +' L '+ end_x +' '+ end_y;
                                points_to_draw+= ' A ' + core_radius + ' ' + core_radius + ' 0 0 0 0 '+ -core_radius + ' Z';
                            }
                        }
                        else{
                            points_to_draw = 'M0 0 L 0 0 Z';
                        }
                        
                    }
                    else{
                        if(sub_angle){
                            arch_end_x = radius*Math.sin(sub_angle);
                            arch_end_y = sub_angle ? -(radius*Math.sin(sub_angle)/Math.tan(sub_angle)) : 0;
                            if(sub_angle > Math.PI){
                                points_to_draw = 'M0 0 L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 1 1 ' + arch_end_x +' '+ arch_end_y +' L0 0 Z';
                            }
                            else{
                                points_to_draw = 'M0 0 L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 0 1 ' + arch_end_x +' '+ arch_end_y +' L0 0 Z';   
                            }
                        }
                        else{
                            points_to_draw = 'M0 0 L 0 0 Z';
                        }
                    }
                    path = Nwagon.createSvgElem('path', {'class':'sector','d':points_to_draw, 'fill':colors[j]});
                    donuts.appendChild(path);
                }
                else{
                    
                    var attributes = {'cx':0, 'cy':0, 'r':radius, 'stroke':'transparent', 'fill': colors[j]};
                    path = Nwagon.createSvgElem('circle', attributes);
                    donuts.appendChild(path);
                    if(core_radius > 0){
                        var inner_attributes = {'cx':0, 'cy':0, 'r':core_radius, 'stroke':'transparent', 'fill-opacity': 1, 'fill': 'white'};
                        var inner_circle = Nwagon.createSvgElem('circle', inner_attributes);
                        donuts.appendChild(inner_circle); 
                    }
                }

                if(angles['angles'].length){
                    angle_to_rotate = angle_in_int_accumulate;
                }
                else{
                    angle_to_rotate = (angle_in_int*j);
                }

				var sectors = document.querySelectorAll('#' + parentDiv +  ' .Nwagon_'+chart_type+' .foreground .sector');
				if(sectors.length > 0){
					var sector = sectors[sectors.length-1];
					sector.setAttribute('transform','rotate('+ angle_to_rotate +')');
				}

                var tooltip_angle = (Math.PI * (angle_to_rotate-90))/180; 
                var tooltip_y = radius * Math.sin(tooltip_angle); 
                var tooltip_x = radius * Math.cos(tooltip_angle);// * Math.cos(angle_to_rotate);

                var degree_value = angles['values'][j].toFixed(0);
                text_to_add = names[j] ? (names[j]+ '(' +(angles['percent'][j]*100).toFixed(1) +'%) ' + degree_value) : 'undefiend';
            
                path.onmouseover = Nwagon.showToolTip(tooltip, tooltip_x, tooltip_y, text_to_add, 14, 7, 18);
                path.onmouseout = Nwagon.hideToolTip(tooltip);
                
                create_data_li(text_to_add);
            }
        },
        drawField: function(fields_names, colorset, parentSVG, width){
			if(fields_names.length)
			{
				var fields = Nwagon.createSvgElem('g', {'class':'fields'});
				parentSVG.appendChild(fields);
				var attributes = {};
				var height = 15;
				var numOfFields = fields_names.length;
				for (var i = 0; i<numOfFields; i++)
				{
					var px = width * 4;
					var py = (30*i) - (numOfFields * height); //70 ;

					attributes = {'x':px, 'y':py, 'width':20, 'height':height, 'fill':colorset[i]};
					var badge = Nwagon.createSvgElem('rect', attributes);
					fields.appendChild(badge);

					attributes = {'x':px+25, 'y':py+10, 'alignment-baseline':'central'};
					var name = Nwagon.createSvgElem('text', attributes);
					name.textContent = fields_names[i];
					fields.appendChild(name);
				}
			}
        }
    },        

    polar: {
        drawPolarChart: function(obj){

            var BottomOffsetAbsolute = 80;
            var RightOffsetAbsolute = obj.dataset['fields'] ? 150 : 0;

            var width = obj.width, height = obj.height;
            var viewbox = '-' + width/2 + ' -' + height/2 + ' ' + width + ' ' + height;
            var svg =  Nwagon.createChartArea(obj.chart_div, obj.chartType, viewbox, width, height);
            var angles = {'angles':[], 'percent':[], 'values':[]};
            if(obj.chartType == 'polar_pie'){
                var degree_values = obj.dataset['degree_values'];
                if(degree_values){
                    angles = Nwagon.getAngles(degree_values, angles);
                }
            }

            if(svg && obj.legend['names'] &&  obj.dataset){
                this.drawBackground(svg, angles['angles'], obj.chartType, obj.legend['names'], obj.dataset, obj.increment, obj.max, obj.core_circle_radius, (width/2)-RightOffsetAbsolute, (height/2)-BottomOffsetAbsolute);
                this.drawLabels(svg, angles, obj.legend, CONST_MAX_RADIUS, obj.core_circle_radius);
                if(obj.core_circle_radius > 0 && obj.core_circle_value){
                    this.drawCoreCircleValue(svg, obj.core_circle_value, obj.core_circle_radius);
                }
                this.drawForeground(obj.chart_div, angles, obj.chartType, svg, obj.legend, obj.dataset, obj.core_circle_radius, obj.max);
            }
            this.drawCoordinates(svg, obj.increment, obj.max, obj.core_circle_radius);
        },


        drawCoordinates: function(parentSVG, decrement, maxRadius, core_circle_radius){

            var g = Nwagon.createSvgElem('g', {'class':'xAxis'});
            var i = maxRadius, y=0.0, point=0.0;

            while (i > 0)
            {
                point = y+',' + -(i+core_circle_radius);

                var attributes = {'points': point, 'x':y, 'y':-(i+core_circle_radius), 'text-anchor':'middle'};
                var text = Nwagon.createSvgElem('text', attributes);
                text.textContent = i.toString();
                g.appendChild(text);
                i-=decrement;
            }
            parentSVG.appendChild(g);
        },

        drawCoreCircleValue: function(parentSVG, value, core_circle_radius){

            var core = Nwagon.createSvgElem('g', {'class':'core'});
            parentSVG.appendChild(core);
            var attributes = {'x':'0', 'y':core_circle_radius/4, 'text-anchor':'middle', 'class':'core_text'};
            var core_text = Nwagon.createSvgElem('text', attributes);
            core_text.textContent = value;
            core.appendChild(core_text);
        },

        drawLabels: function(parentSVG, angles, legend, maxRadius, core_circle_radius){

            var labels = Nwagon.createSvgElem('g', {'class':'labels'});
            parentSVG.appendChild(labels);
            var names = legend.names;
            var length = names.length;
            var angle = angle_accumulate = 0;

            for(var i = 0; i<length; i++){
                if(angles['percent'].length){
                    angle = (Math.PI*2) * angles['percent'][i];
                    if(i>0){
                        angle_accumulate += (Math.PI*2) * angles['percent'][i-1];
                    }
                }
                else{
                    angle = (Math.PI*2)/length;
                    angle_accumulate = angle*i;
                }
                var sub_names = names[i];
                if(sub_names){
                    var sub_len = sub_names.length;
                    for(var k = 0; k<sub_len; k++){
                        var sub_angle = angle/sub_len;
                        var total_angle = angle_accumulate + (sub_angle * k) + sub_angle/2;
                        var y = -(maxRadius+core_circle_radius+12) * Math.cos(total_angle);
                        var x = (maxRadius+core_circle_radius+12) * Math.sin(total_angle);

                        var align = (x < 0) ? 'end' : 'start';
                        if(x < 1 && x > -1) align = 'middle';

                        var attributes = {'x':x, 'y':y, 'text-anchor':align, 'class':'chart_label'};
                        var text = Nwagon.createSvgElem('text', attributes);
                        text.textContent = sub_names[k];
                        labels.appendChild(text);
                    }
                }
            }
        },

        drawForeground: function(parentDiv, angles, chart_type, parentSVG, legend, data, core_circle_radius, max){

            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            var create_data_li = function(text_to_add){
                if(ul){
                    var li = document.createElement('li');
                    li.innerHTML = text_to_add;
                    ul.appendChild(li);
                }
            };
            var foreground = Nwagon.createSvgElem('g', {'class':'foreground'});
            parentSVG.appendChild(foreground);
            var pies = Nwagon.createSvgElem('g', {'class':'pies'});
            foreground.appendChild(pies);
            var tooltip = Nwagon.createTooltip();
            foreground.appendChild(tooltip);

            var colors = data['colorset'];
            var dataGroup = data['values'];
            var opacities = data ['opacity'];
            var length = dataGroup.length;
            var arch_end_x = 0, arch_end_y = 0;
            var points_to_draw = '', text_to_add = '';
            var names = legend.names;
            var angle_to_rotate = 0;
            var angle = angle_in_int = angle_in_int_accumulate = 0; 
            if(length){
                for(var j=0; j<length; j++)
                {
                    if(angles['angles'].length){
                        angle = (Math.PI*2) * angles['percent'][j];
                        angle_in_int = angles['angles'][j];
                        if(j > 0){
                            angle_in_int_accumulate+=angles['angles'][j-1];
                        }
                    }
                    else{
                        angle = (Math.PI*2)/length;
                        angle_in_int = 360/length;
                    }

                    var sub_data = dataGroup[j];
                    var sub_len = sub_data.length;

                    for (var k = 0; k<sub_len; k++){
                        var radius = sub_data[k];
                        var opacity = 0.8;
                        if(opacities.length){
                            opacity = Nwagon.getOpacity(opacities, radius, max);
                        }

                        var sub_angle = angle/sub_len;
                        var sub_angle_in_int = angle_in_int/sub_len;

                        if(core_circle_radius > 0) {
                            radius = radius+core_circle_radius;
                            arch_end_x = (radius)*Math.sin(sub_angle);
                            arch_end_y = -(radius*Math.sin(sub_angle)/Math.tan(sub_angle));

                            var end_x = core_circle_radius*Math.sin(sub_angle);
                            var end_y = -(core_circle_radius*Math.sin(sub_angle)/Math.tan(sub_angle));
                            if(sub_angle > Math.PI){
                                points_to_draw = 'M0 '+ -core_circle_radius+ ' L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 1 1 ' + arch_end_x +' '+ arch_end_y +' L '+ end_x +' '+ end_y;    
                                points_to_draw+= ' A ' + core_circle_radius + ' ' + core_circle_radius + ' 0 1 0 0 '+ -core_circle_radius + ' Z';
                            }
                            else
                            {
                                points_to_draw = 'M0 '+ -core_circle_radius+ ' L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 0 1 ' + arch_end_x +' '+ arch_end_y +' L '+ end_x +' '+ end_y;
                                points_to_draw+= ' A ' + core_circle_radius + ' ' + core_circle_radius + ' 0 0 0 0 '+ -core_circle_radius + ' Z';
                            }
                            
                        }
                        else{
                            arch_end_x = radius*Math.sin(sub_angle);
                            arch_end_y = -(radius*Math.sin(sub_angle)/Math.tan(sub_angle));
                            points_to_draw = 'M0 0 L0 ' +'-'+radius +' A ' + radius + ' ' + radius + ' 0 0 1 ' + arch_end_x +' '+ arch_end_y +' L0 0 Z';
                        }

                        var path = Nwagon.createSvgElem('path', {'class':'sector','d':points_to_draw, 'fill':colors[j], 'opacity': opacity});
                        pies.appendChild(path);
                        if(angles['angles'].length){
                            angle_to_rotate = angle_in_int_accumulate + (sub_angle_in_int*k);
                        }
                        else{
                            angle_to_rotate = (angle_in_int*j)+(sub_angle_in_int*k);
                        }

						var sectors = document.querySelectorAll('#' + parentDiv +  ' .Nwagon_'+chart_type+' .foreground .sector');
						if(sectors.length > 0){
							var sector = sectors[sectors.length-1];
							sector.setAttribute('transform','rotate('+ angle_to_rotate +')');
						}
                        
                        
                        var tooltip_angle = (Math.PI * (angle_to_rotate-90))/180; 
                        var tooltip_y = (core_circle_radius+max) * Math.sin(tooltip_angle); 
                        var tooltip_x = (core_circle_radius+max) * Math.cos(tooltip_angle);// * Math.cos(angle_to_rotate);
                        
                        if(angles['values'].length){
                            var degree_value = angles['values'][j].toFixed(0);
                            text_to_add = names[j][k] ? (names[j][k] +' (' + degree_value + '), Value: '+ (radius-core_circle_radius).toFixed(1)) : 'undefiend';
                        }
                        else{
                            text_to_add = names[j][k] ? (names[j][k] + ', Value: '+ (radius-core_circle_radius).toFixed(1)) : 'undefiend';
                        }
                        
                        path.onmouseover = Nwagon.showToolTip(tooltip, tooltip_x, tooltip_y, text_to_add, 14, 7, 18);
                        path.onmouseout = Nwagon.hideToolTip(tooltip);
                        
                        create_data_li(text_to_add);
                    }
                }
            }
        },

        drawBackground: function(parentSVG, angles, chart_type, obj_names, obj_values, decrement, max_radius, core_circle_radius, width, height){
            var background = Nwagon.createSvgElem('g', {'class':'background'});
            parentSVG.appendChild(background);

            var data = obj_values['values'];
            if(data.length)
            {
                var angle = 360/data.length;

                //Draw arch
                var draw_bg_circles = function(radius){
                    var points_to_draw = 'M0 ' + radius + 'A ' + radius + ' ' + radius + ' 0 0 0 0' + ' -'+radius;
                    var path = Nwagon.createSvgElem('path', {'d':points_to_draw});
                    background.appendChild(path);

                    points_to_draw = 'M0 ' + radius + 'A ' + radius + ' ' + radius + ' 0 0 1 0' + ' -'+radius;
                    path = Nwagon.createSvgElem('path', {'d':points_to_draw});
                    background.appendChild(path);
                };

                if(core_circle_radius > 0){
                    draw_bg_circles(core_circle_radius);
                }
                var radius = max_radius + core_circle_radius;
                while (radius > core_circle_radius){
                    draw_bg_circles(radius);
                    radius-= decrement;
                }
                //Draw lines
                var rotate_angle = 0;
                for(var j=0; j<data.length; j++)
                {
                    if(angles.length){
                        rotate_angle+= angles[j];
                    }
                    else{
                        rotate_angle = angle * j;
                    }
                    var attributes = {'x1':'0', 'y1':-core_circle_radius, 'x2':'0', 'y2':-(max_radius+core_circle_radius), 'class':'v'};
                    var bgStraightLine = Nwagon.createSvgElem('line', attributes);
                    background.appendChild(bgStraightLine);
                    
                    bgStraightLine.setAttribute('transform', 'rotate('+ rotate_angle +')');

                    var sub_data = data[j];
                    if(sub_data){
                        var sub_len = sub_data.length;
                        for (var k = 1; k < sub_len; k++)
                        {
                            var inner_rotate_angle = rotate_angle + (angle/sub_len*k);
                            bgStraightLine = Nwagon.createSvgElem('line', attributes);
                            background.appendChild(bgStraightLine);
                            
                            bgStraightLine.setAttribute('transform', 'rotate('+ inner_rotate_angle +')');
                        }
                    }
                }
            }

            var fields_names = obj_values['fields'];
            var colorset = obj_values['colorset'];
            if(fields_names.length)
            {
                var fields = Nwagon.createSvgElem('g', {'class':'fields'});
                background.appendChild(fields);

                var numOfFields = fields_names.length;
                for (var i = 0; i<numOfFields; i++)
                {
                    px = width+20;
                    py = (30*i) - height ;

                    attributes = {'x':px, 'y':py, 'width':20, 'height':15, 'fill':colorset[i]};
                    var badge = Nwagon.createSvgElem('rect', attributes);
                    fields.appendChild(badge);

                    attributes = {'x':px+25, 'y':py+10, 'alignment-baseline':'central'};
                    var name = Nwagon.createSvgElem('text', attributes);
                    name.textContent = fields_names[i];
                    fields.appendChild(name);
                }
            }
        }
    },

    radar: {

        drawRadarChart: function(obj){

            var width = obj.width, height = obj.height;
            var viewbox = '-' + width/2 + ' -' + height/2 + ' ' + width + ' ' + height;
            var svg =  Nwagon.createChartArea(obj.chart_div, obj.chartType, viewbox, width, height);

            this.drawBackground(svg, obj.legend['names'].length, obj.dataset['bgColor'], CONST_DECREMENT, CONST_MAX_RADIUS);
            this.drawLabels(svg, obj.legend, CONST_MAX_RADIUS);
            this.drawCoordinates(svg, CONST_DECREMENT, CONST_MAX_RADIUS);
            this.drawPolygonForeground(obj.chart_div, svg, obj.legend, obj.dataset);
        },

        drawCoordinates: function(parentSVG, decrement, maxRadius){

            var g = Nwagon.createSvgElem('g', {'class':'xAxis'});
            var i = maxRadius, y=0.0, point=0.0;

            while (i > 0)
            {
                point = i+',' + y;

                var attributes = {'points': point, 'x':i, 'y':y, 'text-anchor':'middle'};
                var text = Nwagon.createSvgElem('text', attributes);
                text.textContent = i.toString();
                g.appendChild(text);
                i-=decrement;
            }
            parentSVG.appendChild(g);
        },

        drawLabels: function(parentSVG, legend, maxRadius){

            var labels = Nwagon.createSvgElem('g', {'class':'labels'});
            var hrefs = legend['hrefs'], names = legend['names'];
            var numOfRadars = names.length;
            var attributes = {};

            for(var index = 0; index < names.length; index++){
                var angle = (Math.PI*2)/numOfRadars; // (2*PI)/numOfRadars
                var x = 0 + (maxRadius+12) * Math.cos(((Math.PI*2)/numOfRadars) * (index));
                var y = 0 + (maxRadius+12) * Math.sin(((Math.PI*2)/numOfRadars) * (index));
                var align = (x < 0) ? 'end' : 'start';
                if(x < 1 && x > -1) align = 'middle';

                if(hrefs){
                    attributes = {'onclick':'location.href="' + hrefs[index] + '"', 'x':x, 'y':y, 'text-anchor':align, 'class':'chart_label'};
                }else{
                    attributes = {'x':x, 'y':y, 'text-anchor':align, 'class':'chart_label'};
                }
                var text = Nwagon.createSvgElem('text', attributes);
                text.textContent = names[index];

                labels.appendChild(text);
            }
            parentSVG.appendChild(labels);
        },

        drawPie: function(parentGroup, numOfRadars, maxRadius, decrement, bg_color){
            /* Draw outer solid line and then inner dotted lines  */

            var angle = (Math.PI*2)/numOfRadars;
            var p0='', p1='', p2='';
            var attributes = {}, points ='';
            var radius = maxRadius;

            var pie = Nwagon.createSvgElem('g', {'class':'pie'});

            while (radius > 0)
            {
                p0 = radius+',0'; //'100,0';
                p1 = '0,0';
                p2 = (radius*Math.sin(angle)/Math.tan(angle)) + ',' + (-radius*Math.sin(angle));

                if (radius == maxRadius)
                {
                    points = p0 + ' ' + p1 + ' ' + p2;
                    var lr = Nwagon.createSvgElem('polyline', {'points':points, 'fill': bg_color});
                    pie.appendChild(lr);
                }

                points = p0 + ' ' + p2;
                attributes =  {'points':points, 'stroke-dasharray':'2px,2px', 'fill': bg_color};
                var la = Nwagon.createSvgElem('polyline', attributes);

                pie.appendChild(la);
                radius-=decrement;
            }

            parentGroup.appendChild(pie);
            return pie;

        },

        drawBackground: function(parentSVG, numOfRadars, bg_color, decrement, maxRadius){
            var bg = bg_color ?  bg_color : '#F9F9F9';
            var angle = 360/numOfRadars;

            var background = Nwagon.createSvgElem('g', {'class':'background'});
            parentSVG.appendChild(background);

            for(var j=1; j<=numOfRadars; j++)
            {
                var current_pie = this.drawPie(background, numOfRadars, maxRadius, decrement, bg);
                current_pie.setAttribute('transform','rotate('+angle * (j-1)+')');
            }
        },

        dimmedPie: function(parentGroup, index, length)
        {
            var angle = (360/length) * index;
            var last_pie = this.drawPie(parentGroup, length, CONST_MAX_RADIUS, CONST_DECREMENT);
            last_pie.setAttribute('transform','rotate('+angle +')');
            var polylines = last_pie.querySelectorAll('polyline');
            for(var i = 0; i<polylines.length; i++){
                polylines[i].setAttribute('class','dim');
            }

            if (((index+1)%length)== 0)
            {
                this.drawPie(parentGroup, length, CONST_MAX_RADIUS, CONST_DECREMENT);
            }
            else
            {
                angle = (360/length) * (index+1);
                last_pie = this.drawPie(parentGroup, length, CONST_MAX_RADIUS, CONST_DECREMENT);
                last_pie.setAttribute('transform','rotate('+angle +')');
            }
            
            var polylines = last_pie.querySelectorAll('polyline');
            for(var i = 0; i<polylines.length; i++){
                polylines[i].setAttribute('class','dim');
            }
        },

        drawPolygonForeground: function(parentDiv, parentSVG, legend, data){

            var dataGroup = data['values'];
            var title = data['title'];
            var fg_color = data['fgColor'] ? data['fgColor'] : '#30A1CE';
            var istooltipNeeded = (dataGroup.length == 1) ? true : false;
            var names = legend['names'];

            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            if(ul){
                ul.innerHTML = title;
            }

            for(var i=0; i<dataGroup.length; i++){
                if(ul)
                {
                    var textEl = document.createElement('li');
                    textEl.innerHTML = 'Data set number ' + (i+1).toString();
                    var innerUL = document.createElement('ul');
                    textEl.appendChild(innerUL);
                    ul.appendChild(textEl);
                }
                var dataset = dataGroup[i];
                var length = dataset.length;
                var coordinate = [];
                var angle = (Math.PI/180)*(360/length);
                var pointValue = 0.0, px=0.0; py=0, attributes = {};
                var vertexes = [], tooltips =[];

                var foreground = Nwagon.createSvgElem('g', {'class':'foreground'});
                parentSVG.appendChild(foreground);

                var polygon = Nwagon.createSvgElem('polyline', {'class':'polygon'});
                foreground.appendChild(polygon);

                var tooltip = {};
                if (istooltipNeeded)
                {
                    tooltip = Nwagon.createTooltip();
                }

                for(var index =0; index < dataset.length; index++){
                    if(innerUL){
                        var innerLI = document.createElement('li');
                        innerLI.innerHTML = names[index] + ': ' + dataset[index];
                        innerUL.appendChild(innerLI);
                    }
                    pointValue = dataset[index];
                    pointDisplay = dataset[index];
                    if (typeof(dataset[index]) != 'number')
                    {
                        Nwagon.radar.dimmedPie(foreground, index, length);
                        pointValue = 0;
                        pointDisplay = dataset[index];
                    }

                    px = (index == 0) ? pointValue : pointValue*Math.sin(angle*index)/Math.tan(angle*index);
                    py = (index == 0) ? 0 : pointValue*Math.sin(angle*index);
                    coordinate.push(px + ',' + py);

                    attributes = {'cx':px, 'cy':py, 'r':3, 'stroke-width':8, 'stroke':'transparent', 'fill': fg_color};
                    var vertex = Nwagon.createSvgElem('circle', attributes);

                    if (istooltipNeeded)
                    {
                        vertex.onmouseover = Nwagon.showToolTip(tooltip, px, py, names[index] + ' : ' +  pointDisplay, 20, 15, 28);
                        vertex.onmouseout = Nwagon.hideToolTip(tooltip);
                    }
                    foreground.appendChild(vertex);
                    vertex = null;
                }

                var coordinates = coordinate.join(' ');
                var attributes = {'points':coordinates, 'class':'polygon', 'fill': fg_color, 'stroke':fg_color};
                Nwagon.setAttributes(polygon, attributes);

                if (istooltipNeeded) foreground.appendChild(tooltip);
            }
        }
    }
};

var Nwagon_ie = {

    setStyles: function(obj, styles){
        for (var key in styles) {
            if (styles.hasOwnProperty(key)) {
                obj.style[key] = styles[key];
            }
        }
    },

    setAttributes: function(obj, attributes){
        for (var key in attributes) {
            if (attributes.hasOwnProperty(key)) {
                obj.setAttribute(key, attributes[key]);
            }
        }
    },
    createChartArea: function(id, width, height){

		var chartDiv = document.getElementById(id);
		chartDiv.style.cssText = 'width: '+ width+'px; height:'+ height + 'px';
		var textArea = document.createElement('ul');
		textArea.className = 'accessibility';
		chartDiv.appendChild(textArea);

		var vml = document.createElement("v:group");
		vml.setAttribute('class', id);
		vml.setAttribute("coordsize", width + " " + height);
		vml.setAttribute('aria-hidden', 'true');
		vml.style.cssText = 'width: '+ width+'px; height:'+ height + 'px;position:absolute;';

		var rect = document.createElement('v:rect');
		var style_attr = {'width': width + 'px', 'height': height + 'px'};
		Nwagon_ie.setStyles(rect, style_attr);
		rect.setAttribute('stroked','true');
		vml.appendChild(rect);
		chartDiv.appendChild(vml);
		return vml;
    },  

    createTooltip: function(parentCanvas){
        var tip = document.createElement('div');
        var textNode = document.createTextNode('');
        tip.appendChild(textNode);
        parentCanvas.appendChild(tip);
        return tip;
    },

    showToolTip: function(tooltip, px,  py, value){
        return function(){
            tooltip.style.cssText = 'display: block; padding: 0 5px 0 5px; background-color:#f9f9f9; border: 1px solid #666; position:absolute; z-index:100';
            tooltip.lastChild.nodeValue = value;
            tooltip.style.left = px + 'px'; 
            tooltip.style.top = (py -15) + 'px'; 
            tooltip.style.fontSize = '12px'; 
        }
    },

    hideToolTip: function(tooltip){
        return function(){
            tooltip.style.cssText = "display: none";
        }
    },
    drawWedges: function(cx, cy, r, fillcolor, start_a, end_a, s_attr){
        var wedge = document.createElement("v:shape"); 
        var sa = Math.round(start_a * 65535); 
        var a = -Math.round(end_a * 65536);  
        var path = "M " + cx + " " + cy + " AE " + cx + " " + cy + " " + r + " " + r + " " + sa + " " + a + " X E"; 

        attributes = {'path': path, 'fillcolor': fillcolor, 'strokecolor': '#FFFFFF', 'strokeweight':'0px'};    
        Nwagon_ie.setAttributes(wedge, attributes);
        Nwagon_ie.setStyles(wedge, s_attr);
        return wedge;
    },
    drawVertex: function(x, y, fill){
        var circle = document.createElement('v:oval');
        circle.setAttribute('fillcolor', fill); 
        circle.setAttribute('strokecolor', fill);
        circle.setAttribute('strokeweight', '1px');
        circle.style.cssText = 'z-index:99; width:6px; height:6px';
        circle.style.top = (y-3) + 'px';
        circle.style.left = (x-3) + 'px';

        return circle;
    },
    drawFields_for_circular_type_chart: function(fields, colors, canvas, h){
        var style_attr = {};
        if(fields.length){
            var lx = 5, ly=10;
            var field_div = document.createElement('div');
            
            style_attr = {'width':Math.round(h/2) + 'px', 'height': Math.round(h*(2/3)) + 'px', 'left': h + 'px', 'top': '70px', 'position':'absolute'};
            Nwagon_ie.setStyles(field_div, style_attr);
            field_div.className = 'fields_area';
            canvas.appendChild(field_div);
            var attributes = {};

            for(var i = 0; i<fields.length; i++){
                var badge = document.createElement("v:rect"); 
                style_attr = {'width':'20px', 'height': '15px', 'left':'5px', 'top': (ly+i*30) + 'px'};
                Nwagon_ie.setStyles(badge, style_attr);    
                attributes = {'fillcolor':colors[i], 'strokecolor': '#FFFFFF', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(badge, attributes);
                field_div.appendChild(badge); 

                var name = document.createElement('div'); 
                name.appendChild(document.createTextNode(fields[i])); 
                style_attr = {'position':'absolute', 'left': (lx + 30) + 'px', 'top': (ly + 30*i) + 'px', 'fontSize': '12px'};
                Nwagon_ie.setStyles(name, style_attr);    
                field_div.appendChild(name); 
            }
        }
    },
    column:{

        drawColumnChart: function(obj){
            
            var width = obj.width, height = obj.height;
            var canvas = Nwagon_ie.createChartArea(obj.chart_div, width, height); 
            
            var values = obj.dataset['values'];
            var left =  obj.hasOwnProperty('leftOffsetValue') ? obj.leftOffsetValue : 50;
            var bottom = obj.hasOwnProperty('bottomOffsetValue') ? obj.bottomOffsetValue : 80;
            
            var max = obj.highest ? obj.highest : Nwagon.getMax(values);
            var fields = obj.dataset['fields'];
            var fieldsExist = ((fields && (obj.chartType !='column')) || (obj.chartType =='column' && obj.dataset['colorset'].length == 1)) ;
            this.drawBackground(canvas, obj.legend['names'], obj.dataset, obj.increment, max, width, height, left, bottom, fieldsExist);
            this.drawColumnForeground(obj.chart_div, canvas, obj.legend, obj.dataset, obj.increment, max, width, height, left, bottom, obj.chartType, fieldsExist);

        },

        drawColumnForeground: function(parentDiv, canvas, legend, dataset, increment, max, width, height, left, bottom, chart_type, isFields){
            var names = legend['names'];
            var numOfCols = names.length;
            var data = dataset['values'];
            var chart_title = dataset['title'];
            var fields = dataset['fields'];
            var right = isFields ?  150 : 0;
            var colWidth = Math.floor((width-left-right)/numOfCols);
            var x1 = 0, x2 = 0, y1 = 0, y2 = 0, cw = 0;
            var yLimit = (Math.ceil(max/increment)+1) * increment;  //let's check if it's used in here
            var numOfRows = max/increment;
            var rowHeight = Math.round((height-bottom)/(numOfRows+1));
            var yRatio = rowHeight/increment;
            var colors = [];
            var attributes = {}, style_attr={};
            var tooltip  = Nwagon_ie.createTooltip(canvas);
            var text_to_add = ''; 
            
            var drawColumn = function(attr, w, h, x, y, text, tip){
                var column = document.createElement('v:shape');
                Nwagon_ie.setAttributes(column, attr);
                style_attr = {'position':'absolute', 'width': w, 'height': h, 'filter':'alpha(opacity=80)'};
                Nwagon_ie.setStyles(column, style_attr);
                column.onmouseover = Nwagon_ie.showToolTip(tip, x, y, text);
                column.onmouseout = Nwagon_ie.hideToolTip(tip);
                return column;
            };
            var create_data_list = function(obj){
                var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                if (ul){
                    for (var key in obj){
                        if(obj.hasOwnProperty(key)){
                            var li = document.createElement('li');
                            li.innerHTML = key;
                            var innerUL = document.createElement('ul');
                            li.appendChild(innerUL);
                            ul.appendChild(li);
                            var innerList = obj[key];
                            for (var k = 0; k< innerList.length; k++){
                                var innerLI = document.createElement('li');
                                innerLI.innerHTML = innerList[k];
                                // console.log('innerList['+k+'] : '+  innerList[k]);
                                innerUL.appendChild(innerLI);
                            }
                        }
                    }
                }
            };
            if(chart_type == 'column'){
                var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                if(ul){
                    ul.innerHTML = chart_title;
                }
                cw = colWidth * 1/5;
                colors = Nwagon.column.getColorSetforSingleColumnChart(max, data, dataset['colorset']);
                for(var i = 0; i<data.length; i++){
                    x1 = left + Math.round(colWidth * (i+0.2)); 
                    x2 = Math.round(left + (colWidth * (i+1)) - cw);
                    y1 = height - bottom;
                    y2 = height - bottom - Math.round(yRatio * data[i]);

                    var path = 'M ' + x1 + ' ' + y1 + ' L ' + x1 + ' ' + y2 + ' L ' + x2 + ' ' + y2 + ' L ' + x2 + ' ' + y1 +' X E';
                    attributes = {'path': path, 'strokecolor': colors[i], 'strokeweight':'1px', 'fillcolor': colors[i]};    
                    text_to_add =  data[i].toString();
                    var c = drawColumn(attributes, canvas.style.width, canvas.style.height, x1+5, y2+rowHeight, text_to_add, tooltip);
                    canvas.appendChild(c);

                    var innerLI = document.createElement('li');
                    innerLI.innerHTML = 'Label ' + names[i] + ', Value  '+ data[i];
                    if(ul){
                        ul.appendChild(innerLI);
                    }
                }                   
            }
            if(chart_type == 'multi_column'){
                colors = dataset['colorset'];
                cw = (3/5*colWidth)/colors.length; 
                var chart_data = {};
                for ( var k = 0; k<fields.length; k++){
                    chart_data[fields[k]] = [];
                }
                
                for(var i = 0; i < data.length; i++){
                    var one_data = data[i];
                    var px = left + Math.round(colWidth * (i+0.2)); 

                    for(var k = 0; k < one_data.length; k++){
                        x1 = px + Math.round((k*(cw)));
                        x2 = px + Math.round((k+1)*cw); 
                        y1 = height - bottom;
                        y2 = height - bottom - Math.round(yRatio * one_data[k]);

                        var path = 'M ' + x1 + ' ' + y1 + ' L ' + x1 + ' ' + y2 + ' L ' + x2 + ' ' + y2 + ' L ' + x2 + ' ' + y1 +' X E';
                        attributes = {'path': path, 'strokecolor': colors[k], 'strokeweight':'1px', 'fillcolor': colors[k]};    
                        text_to_add =  one_data[k].toString();
                        var c = drawColumn(attributes, canvas.style.width, canvas.style.height, x1+5, y2+rowHeight, text_to_add, tooltip);
                        canvas.appendChild(c);
                        chart_data[fields[k]].push('Label ' + names[i] + ', Value  '+ one_data[k]);
                    }
                }
                create_data_list(chart_data);
            }
            if(chart_type == 'stacked_column'){
                colors = dataset['colorset'];
                cw = colWidth * 1/5;
                var chart_data = {};
                for ( var k = 0; k<fields.length; k++){
                    chart_data[fields[k]] = [];
                }
                for(var i = 0; i < data.length; i++){
                    var one_data = data[i];
                    var yValue = height-bottom;
                    var px = left + Math.round(colWidth * (i+0.2)); 

                    for(var k = 0; k < one_data.length; k++){
                        
                        x1 = left + Math.round(colWidth * (i+0.2)); 
                        x2 = Math.round(left + (colWidth * (i+1)) - cw);
                        y1 = yValue;
                        y2 = yValue - Math.round(yRatio * one_data[k]);

                        var path = 'M ' + x1 + ' ' + y1 + ' L ' + x1 + ' ' + y2 + ' L ' + x2 + ' ' + y2 + ' L ' + x2 + ' ' + y1 +' X E';
                        attributes = {'path': path, 'strokecolor': colors[k], 'strokeweight':'1px', 'fillcolor': colors[k]};    
                        text_to_add =  one_data[k].toString();
                        var c = drawColumn(attributes, canvas.style.width, canvas.style.height, x1+5, y2+rowHeight, text_to_add, tooltip);
                        canvas.appendChild(c);

                        chart_data[fields[k]].push('Label ' + names[i] + ', Value  '+ one_data[k]);
                        yValue -=Math.round(yRatio * one_data[k]);
                    }
                }
                create_data_list(chart_data);
            }
            if((fields && (chart_type !='column')) || (chart_type =='column' && dataset['colorset'].length == 1)) {
                for(var i = 0; i<fields.length; i++){
                    var lx = width - right +30, ly= 30;
                    var badge = document.createElement("v:rect"); 
                    style_attr = {'position':'absolute', 'width': '20px', 'height':'15px', 'top':(ly+i*30) + 'px', 'left':lx + 'px'};
                    Nwagon_ie.setStyles(badge, style_attr);
                    attributes = {'fillcolor': colors[i], 'strokecolor':'#FFFFFF', 'strokeweight':'1px'};    
                    Nwagon_ie.setAttributes(badge, attributes);
                    canvas.appendChild(badge); 

                    var name = document.createElement('div'); 
                    name.appendChild(document.createTextNode(fields[i])); 
                    style_attr = {'position':'absolute', 'top':(ly + 30*i) + 'px', 'left': (lx + 30) + 'px', 'fontSize':'12px'};
                    Nwagon_ie.setStyles(name, style_attr);
                    canvas.appendChild(name); 
                }
            }
        },

        drawBackground: function(canvas, names, dataset, increment, max, width, height, left, bottom, isFields){
            var numOfCols = names.length;
            var numOfRows = Math.ceil(max/increment);
            var right = 0, line_width=0, colWidth = 0; 
            if(isFields){
                var right = 150;
            }
            if(numOfCols){
                var colWidth = Math.floor((width-left-right)/numOfCols);
            }
            var rowHeight = Math.round((height-bottom)/(numOfRows+1));
            var values = dataset['values'];
            var attributes = {}, style_attr = {};

            for (var i = 0; i<=values.length; i++){
                var v_line = document.createElement('v:shape');
                var v_height_start = height - bottom;
                var v_height_end = height - bottom -(rowHeight*(numOfRows+1));
                var px = left + (colWidth*i);
                var v_path = 'M '+ px + ' '+ v_height_start + 'L ' + px +' ' + v_height_end;
                
                attributes = {'path': v_path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(v_line, attributes);
                style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                Nwagon_ie.setStyles(v_line, style_attr);
                canvas.appendChild(v_line);

                // draw text as well  (x coord) 
                if(i<values.length){
                    var x_label = document.createElement('div'); 
                    x_label.appendChild(document.createTextNode(names[i])); 
                    x_label.setAttribute('class', 'label_ie')
                    style_attr = {'position':'absolute', 'left': (px + (colWidth/4))+ 'px', 'top': (height - bottom + 15)+ 'px', 'fontSize':'13px'};
                    Nwagon_ie.setStyles(x_label, style_attr);
                    canvas.appendChild(x_label); 
                }
                if(i == values.length){
                    line_width = px;
                }
            }

            //Horizontal lines & labels
            var count = 0;
            for (i = 0; i<=numOfRows; i++){
                var line = document.createElement('v:shape'); 
                var line_height = height - bottom - (rowHeight * i);
                var path = 'M '+ left + ' '+ line_height + 'L ' + line_width +' ' + line_height;
                
                attributes = {'path': path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(line, attributes);
                line.style.position = "absolute"; 
                line.style.width = canvas.style.width; 
                line.style.height = canvas.style.height;  
                canvas.appendChild(line);

                // label 
                var label = document.createElement('div'); 
                var label_text = (increment*i).toString();
                label.setAttribute('class', 'label_ie')
                label.appendChild(document.createTextNode(label_text));
                style_attr = {'position':'absolute', 'right':(width - left +15) + 'px', 'top':line_height - 6 + 'px', 'fontSize':'13px' };
                Nwagon_ie.setStyles(label, style_attr);
                canvas.appendChild(label); 
            }
        }
    },
    line: {
        guide_line: null,
        guide_line_max_left: 0,
        drawLineChart: function(obj){
            var type = obj.chartType;
            var isAreaChart = false, isJira = false;
            var width = obj.width, height = obj.height;
            var canvas = Nwagon_ie.createChartArea(obj.chart_div, width, height); 
            var left = obj.leftOffsetValue ? obj.leftOffsetValue : 50;
            var bottom = obj.bottomOffsetValue ? obj.bottomOffsetValue : 80;
            var names = obj.legend['names'];
            var fields = obj.dataset['fields'];
            var values = obj.dataset['values'];
            var max = obj.highest ? obj.highest : Nwagon.getMax(values);   
            var min = obj.lowest ? obj.lowest : 0;   
            isAreaChart = (type == 'area');
            isJira = (type == 'jira');
            var isGuideNeeded = obj.hasOwnProperty('isGuideLineNeeded') ? obj.isGuideLineNeeded : false;

            this.drawBackground(canvas, names, obj.dataset, obj.increment, max, min, width, height, left, bottom);    
            this.drawLineForeground(obj.chart_div, canvas, obj.legend, obj.dataset, obj.increment, max, min, width, height, left, bottom, isAreaChart , isJira, isGuideNeeded);
            if(isGuideNeeded && Nwagon_ie.line.guide_line){
                var right = fields ?  150 : 0;
                var interval = Math.round(width-left-right)/names.length;
                var tool = document.createElement('div');
                canvas.appendChild(tool);

                var g = Nwagon_ie.line.guide_line;
                var d = document.getElementById(obj.chart_div);
                var x_offset = canvas.offsetLeft + canvas.clientLeft;
                var y_offset = canvas.offsetTop + canvas.clientTop;
                function moveGuideLine(e) {
                    var xPosition = e.clientX - x_offset;
                    var yPosition = e.clientY - y_offset;
                    if((xPosition-left) > 0 ){
                        var index = (Math.floor((xPosition-left)/interval));
                        if(xPosition > Nwagon_ie.line.guide_line_max_left){
                            xPosition = Nwagon_ie.line.guide_line_max_left -left;
                        }
                        if(xPosition >= left && (index < names.length)){
                            g.style.left = xPosition+'px';
                            tool.innerHTML = '';
                            tool.style.cssText = 'display: block; float:left; padding: 0 5px 0 5px; background-color:#f9f9f9; border: 1px solid #666; position:absolute; z-index:100';
                            tool.style.fontSize = '12px'; 
                            tool.style.left = xPosition + 'px'; 
                            tool.style.top = ( yPosition-(fields.length*14) +  document.body.scrollTop )+ 'px';
                            for(var i = 0; i<fields.length; i++){
                                var s = names[index] + '('+ fields[i] + '): ' + values[index][i];
                                var textDiv = document.createElement('div');
                                if(textDiv){
                                    textDiv.innerHTML = s;
                                    tool.appendChild(textDiv);
                                }
                            }
                        }
                    }
                }
                function hideTool(e){
                    tool.style.cssText = 'display:none';
                }
                d.attachEvent('onmousemove', moveGuideLine);
                d.attachEvent('onmouseout', hideTool);
            }
        },

        drawJiraForeground:function(points, colors, canvas, left_off, bottom_off){
            var getSlopeAndAlpha = function(point_1, point_2){
                var values = {};
                var slope;
                if((point_2[1] == point_1[1])){
                    slope = 0;
                }
                else{
                    slope = (point_2[1]-point_1[1])/(point_2[0]-point_1[0]);
                }
                values['alpha'] = point_1[1] - (slope * point_1[0]);
                values['slope'] = slope;
                return values;
            };
            var drawPolygons = function(arr1, arr2){

                if(arr1 && arr2){
                    var color, first, second, px, py;
                    var points_to_draw = '';

                    var i = 0;
                    while ( i < arr1.length){
                        if(arr1[i][1]< arr2[i][1]){
                            first = arr1;
                            second = arr2;
                            color = colors[0];
                            break;
                        }
                        if(arr1[i][1]> arr2[i][1]){
                            first = arr2;
                            second = arr1;
                            color = colors[1];
                            break;
                        }
                        i++;
                    }
                    var j = 0;
                    while(j<first.length){
                        px = Math.round(first[j][0]);
                        var y_coord = bottom_off - first[j][1];
                        py = Math.round(bottom_off - y_coord);
                        // py = first[j][1];
                        if(j === 0){
                            points_to_draw += 'M '+px + ' ' + py;
                        }
                        else{
                            points_to_draw += ' L '+px + ' ' + py;
                        }
                        j++;
                    }
                    var k = second.length-1;
                    while(k >= 0){
                        px = Math.round(second[k][0]);
                        var y_coord = bottom_off - second[k][1];
                        py = Math.round(bottom_off - y_coord);
                        points_to_draw += ' L '+px + ' ' + py;
                        k--;
                    }

                    points_to_draw +=' X E';
                    var unlayered = document.createElement('v:shape');
                    var attributes = {'path': points_to_draw, 'strokecolor': '#CCC', 'fillcolor':color};    
                    Nwagon_ie.setAttributes(unlayered, attributes);    
                    var style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height, 'filter':'alpha(opacity=80)'};
                    Nwagon_ie.setStyles(unlayered, style_attr);
                    canvas.appendChild(unlayered);
                }
            };
            
            var layered_points = [];

            if(points.length == 2){
                var colorOne = colors[0];
                var colorTwo = colors[1];
                var one = points[0];
                var two = points[1];
                var temp_one = [], temp_two = [];

                if(one.length === two.length){
                    var length = one.length;


                    for(var i = 0; i < length; i++){
                        temp_one.push(one[i]);
                        temp_two.push(two[i]);

                        if((one[i][1] < two[i][1])) layered_points.push(two[i]);
                        else layered_points.push(one[i]);

                        if(i !== length-1){
                            if( !((one[i][1] > two[i][1]) && (one[i+1][1] > two[i+1][1])) &&
                                !((one[i][1] < two[i][1]) && (one[i+1][1] < two[i+1][1])) &&
                                !((one[i][1] == two[i][1]) || (one[i+1][1] == two[i+1][1])) )
                            {
                                var points_to_push = [];
                                var equation1 = getSlopeAndAlpha(one[i], one[i+1]);
                                var equation2 = getSlopeAndAlpha(two[i], two[i+1]);
                                var slope1 = equation1['slope'];
                                var slope2 = equation2['slope'];
                                var alpha1 = equation1['alpha'];
                                var alpha2 = equation2['alpha'];

                                var px = (alpha2 - alpha1)/(slope1-slope2)
                                var py = (px * slope1) + alpha1;
                                points_to_push.push(px);
                                points_to_push.push(py);
                                layered_points.push(points_to_push);
                                temp_one.push(points_to_push); // for making splicing easier push the cross points twice
                                temp_one.push(points_to_push);
                                temp_two.push(points_to_push);
                                temp_two.push(points_to_push);
                            }
                        }
                    }
                }
            }
            // Draw polygon where two areas are stacked up
            if(layered_points.length){
                var points_to_draw = '';
                for (var i = 0; i<layered_points.length; i++){
                    var px = Math.round(layered_points[i][0]);
                    var y_coord = bottom_off - layered_points[i][1];
                    var py = Math.round(bottom_off - y_coord);
                    if(i === 0){
                        points_to_draw += 'M '+px + ' ' + py;
                    }
                    else{
                        points_to_draw += ' L '+px + ' ' + py;
                    }
                }
                points_to_draw += ' L '+layered_points[layered_points.length-1][0] + ' ' + bottom_off + ' L '+ left_off + ' '+  bottom_off + ' X E';
                var layered_line = document.createElement('v:shape');
                var attributes = {'path': points_to_draw, 'strokecolor': '#CCC', 'fillcolor':'#FFF'};    
                Nwagon_ie.setAttributes(layered_line, attributes);
                var style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height, 'filter':'alpha(opacity=80)'};
                Nwagon_ie.setStyles(layered_line, style_attr);
                canvas.appendChild(layered_line);
            }
            // Draw polygons for non-layered portions
            if(temp_one.length === temp_two.length){
                var i = 0;
                while(i<temp_one.length){

                    if((temp_one[i][1] == temp_two[i][1] ) && (i !=0) || (i == temp_one.length-1)) {
                        var splice_one = temp_one.splice(i+1, temp_one.length-1);
                        var splice_two = temp_two.splice(i+1, temp_two.length-1);

                        drawPolygons(temp_one, temp_two);

                        temp_one = splice_one;
                        temp_two = splice_two;
                        i = 0;
                    }
                    i++;
                }
            }
        },

        drawLineForeground: function(parentDiv, canvas, legend, dataset, increment, max, min, width, height, left, bottom, isArea, isJira, guide_line_needed){
            var names = legend['names'];
            var colors = dataset['colorset'];
            var fields = dataset['fields'];
            var values = dataset['values'];
            var numOfCols = values.length;
            var right = fields ? 150 : 0; 
            var colWidth = Math.round((width-left-right)/numOfCols);
            var px = left, py = height-bottom;
            var numOfRows = ((max-min)/increment);
            var rowHeight = Math.round((height-bottom)/(numOfRows+1));
            var yRatio = rowHeight/increment;
            var paths = [], polygon_paths = [];
            var text_to_add = '';
            var value = values[0]; 
            var tooltip = Nwagon_ie.createTooltip(canvas);
            var style_attr = {};
            var jira_points = [];

            for(var k = 0; k<value.length; k++){
                var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
                if(ul){
                    var textEl = document.createElement('li');
                    textEl.innerHTML = fields[k];
                    var innerUL = document.createElement('ul');
                    textEl.appendChild(innerUL);
                    ul.appendChild(textEl);
                }
                var first_y = 0; 
                var start_point = 0;
                var path = '';
                var polygon_path = '';
                var line_points = [];
                var x = 0, y = 0;
                for(var i = 0; i<values.length; i++){
                    var point_pair = [];
                    x = px + (colWidth * i);
                    y = py - Math.round((values[i][k]-0.5 - min)*yRatio);
                    if(isNaN(y)){
                        start_point++;
                    }
                    else {
                        if(i == start_point){
                            path += 'M '+x + ' ' + y;
                            first_y = y; 
                        }
                        else{
                            path += 'L '+x + ' ' + y;   
                        }
                        point_pair.push(x);
                        point_pair.push(y);
                        line_points.push(point_pair);

                        var vertex = Nwagon_ie.drawVertex(x, y, colors[k]); 
                        text_to_add = fields ? names[i] + '('+ fields[k] + '): ' + values[i][k].toString() : names[i] + ': ' + values[i][k].toString();
                        if(!guide_line_needed){
                            vertex.onmouseover = Nwagon_ie.showToolTip(tooltip, x, y, text_to_add);
                            vertex.onmouseout = Nwagon_ie.hideToolTip(tooltip);
                        }
                        canvas.appendChild(vertex);
                        if(innerUL){
                            var innerLI = document.createElement('li');
                            innerLI.innerHTML =  'Label ' + names[i] + ',  Value '+ values[i][k].toString();
                            innerUL.appendChild(innerLI);
                        }
                    }
                }
                paths.push(path);
                if(isArea){
                    polygon_path  = path + 'L ' + x + ' '+ py +' L '+ px + ' ' + py +' L '+ px + ' ' + y +' X E'; 
                    polygon_paths.push(polygon_path);
                }
                jira_points.push(line_points);
            }

            for(var k = 0; k<value.length; k++){

                var line = document.createElement('v:shape');
                var attributes = {'path': paths[k], 'strokecolor': colors[k], 'strokeweight':'2px'};    
                Nwagon_ie.setAttributes(line, attributes);
                style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                Nwagon_ie.setStyles(line, style_attr);
                var fill = document.createElement('v:fill');
                fill.setAttribute('on', 'false');
                line.appendChild(fill);  
                canvas.appendChild(line);
                
                if(isArea){
                    var polygon = document.createElement('v:shape');
                    attributes = {'path': polygon_paths[k], 'strokecolor': colors[k], 'fillcolor':colors[k]};    
                    Nwagon_ie.setAttributes(polygon, attributes);
                    style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height, 'filter':'alpha(opacity=80)'};
                    Nwagon_ie.setStyles(polygon, style_attr);
                    canvas.appendChild(polygon);
                }
                
                if(fields){
                    var lx = width - right +30, ly= 30;
                    var badge = document.createElement("v:rect"); 
                    style_attr = {'position':'absolute', 'width': '20px', 'height': '15px', 'left':lx + 'px', 'top':(ly+k*30) + 'px'};
                    Nwagon_ie.setStyles(badge, style_attr);

                    attributes = {'fillcolor': colors[k], 'strokecolor':'#FFFFFF', 'strokeweight':'1px'};    
                    Nwagon_ie.setAttributes(badge, attributes);
                    canvas.appendChild(badge); 
 
                    var name = document.createElement('div'); 
                    name.appendChild(document.createTextNode(fields[k])); 
                    style_attr = {'position':'absolute', 'left':(lx + 30) + 'px', 'top':(ly + 30*k) + 'px', 'fontSize':'12px'};
                    Nwagon_ie.setStyles(name, style_attr);
                    
                    canvas.appendChild(name); 
                }
            }
            if(isJira){
                Nwagon_ie.line.drawJiraForeground(jira_points, colors, canvas, left, height-bottom);
            }
            if(guide_line_needed){
                Nwagon_ie.line.guide_line = document.createElement('div');
                var x_max = left + (colWidth*numOfCols);
                Nwagon_ie.line.guide_line_max_left = x_max;
                Nwagon_ie.setStyles(Nwagon_ie.line.guide_line,  {'position':'absolute', 'width': '2px', 'height': (height-bottom+5)+'px', 'left':x_max + 'px', 'background':'#4010ad'});
                canvas.appendChild(Nwagon_ie.line.guide_line);
            } 
        },

        drawBackground: function(canvas, names, dataset, increment, max, min, width, height, left, bottom){
            var numOfCols = dataset['values'].length;
            var numOfRows = Math.ceil((max-min)/increment);
            var right = 0; 
            var fields = dataset['fields'];
            if(fields){
                right = 150;
            }
            if(numOfCols){
                var colWidth = Math.round((width-left-right)/numOfCols);
            }
            var rowHeight = Math.round((height-bottom)/(numOfRows+1));
            var values = dataset['values'];
            var yRatio = (height-bottom)/100;
            var attributes = {}, style_attr = {};
            
            for (var i = 0; i<values.length; i++){
                var v_line = document.createElement('v:shape');
                var v_height_start = height - bottom + 5;
                var v_height_end = (i == 0) ? height - bottom -(rowHeight*(numOfRows+1)) : height - bottom -5;
                var px = left + (colWidth*i);
                var v_path = 'M '+ px + ' '+ v_height_start + 'L ' + px +' ' + v_height_end;
                
                attributes = {'path': v_path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(v_line, attributes);
                style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                Nwagon_ie.setStyles(v_line, style_attr);
                canvas.appendChild(v_line);

                // draw text as well  (x coord) 
                var x_label = document.createElement('div'); 
                x_label.appendChild(document.createTextNode(names[i])); 
                style_attr = {'position':'absolute', 'left': px+ 'px', 'top': (height - bottom + 15)+ 'px', 'fontSize': '13px'};
                Nwagon_ie.setStyles(x_label, style_attr);
                canvas.appendChild(x_label); 
            }

            //Horizontal lines & labels
            var count = 0;
            var line_width = width-right+3;
            for (i = 0; i<=numOfRows; i++){
                var line = document.createElement('v:shape'); 
                var line_height = height - bottom - (rowHeight * i);
                var path = 'M '+ (left-3) + ' '+ line_height + 'L ' + line_width +' ' + line_height;
                
                attributes = {'path': path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(line, attributes);
                style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                Nwagon_ie.setStyles(line, style_attr);
                var stroke = document.createElement('v:stroke'); 
                stroke.setAttribute('dashstyle', 'dash');
                line.appendChild(stroke);
                canvas.appendChild(line);

                // label 
                var label = document.createElement('div'); 
                var label_text = ((increment*i) + min).toString();
                label.appendChild(document.createTextNode(label_text));
                
                style_attr = {'position':'absolute', 'right': (width - left +15) + 'px', 'top': line_height - 3 + 'px', 'fontSize': '13px'};
                Nwagon_ie.setStyles(label, style_attr);
                canvas.appendChild(label); 
            }
        }
    },

    polar: {
        drawPolarChart: function(obj){
            var width = obj.width, height = obj.height;
            var values = obj.dataset['values'];
            var canvas = Nwagon_ie.createChartArea(obj.chart_div, width, height);         
            var angles = {'angles':[], 'percent':[], 'values':[]};
            if(obj.chartType == 'polar_pie'){
                var degree_values = obj.dataset['degree_values'];
                if(degree_values){
                    angles = Nwagon.getAngles(degree_values, angles);
                }
            }  
            if(canvas && obj.legend['names'] && obj.dataset){
                this.drawBackground(canvas, angles['angles'], obj.chartType, obj.legend['names'], obj.dataset, obj.increment, obj.max, obj.core_circle_radius, height);
                this.drawForeground(canvas, obj.chart_div, angles, obj.chartType, obj.legend, obj.dataset, obj.core_circle_radius, obj.core_circle_value, obj.max, height);
                if(obj.dataset['fields']){
                    Nwagon_ie.drawFields_for_circular_type_chart(obj.dataset['fields'], obj.dataset['colorset'], canvas, height);
                }
            }
        },
        drawForeground: function(canvas, parentDiv, angles, chart_type, legend, dataset, core_circle_radius, core_value, max, h){
            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            var create_data_li = function(text_to_add){
                if(ul){
                    var li = document.createElement('li');
                    li.innerHTML = text_to_add;
                    ul.appendChild(li);
                }
            };
            var cx = Math.round(h/2), cy=Math.round(h/2);
            var names = legend['names']; //names' dimension should match dataset['values']'s dimension
            var data = dataset['values'];
            var colors = dataset['colorset'];
            var opacities = dataset['opacity'];
            var len = data.length;
            var start_angle = 90;
            var style_attr = {};
            var opacity = 80;
            var angle_accumulate = Math.PI/2; 
            if(len){
                var angle = Math.round(360/len);
                var angle_in_pie = (Math.PI*2/len);
                var _text_to_add = '';
                for(var j=0; j<len; j++){
                    if(angles['angles'].length){ //polar area chart 
                        angle = angles['angles'][j];
                        angle_in_pie = (angles['angles'][j] * Math.PI)/180;
                    }
                    var sub_data = data[j];
                    var sub_len = sub_data.length;
                    var sub_angle = angle/sub_len;
                    var sub_angle_in_pie = angle_in_pie/sub_len;  
                    for(var k = 0; k < sub_len; k++){
                        if(opacities.length){
                            opacity = Nwagon.getOpacity(opacities, sub_data[k], max) * 100;
                        }
                        style_attr = {'cssText':'position:absolute', 'width': canvas.style.width, 'height': canvas.style.height, 'filter': 'alpha(opacity='+ opacity +')' };
                        var wedge = Nwagon_ie.drawWedges(cx, cy, sub_data[k]+core_circle_radius, colors[j], start_angle, sub_angle, style_attr);
                        canvas.appendChild(wedge);  
                        start_angle-=sub_angle;

                        // draw labels
                        var label_angle = angle_accumulate + (sub_angle_in_pie/2);
                        var line_width = max + core_circle_radius + 20;
                        var x_cord = (cx - 5 - Math.round(line_width * Math.cos(label_angle)));
                        var y_cord = (h - 5 - cy - Math.round((line_width) * Math.sin(label_angle)));
                        var label = document.createElement('div'); 
                        label.appendChild(document.createTextNode(names[j][k]));
                        style_attr = {'position':'absolute', 'left': x_cord + 'px', 'top': y_cord + 'px', 'fontSize': '13px'};
                        Nwagon_ie.setStyles(label, style_attr);
                        canvas.appendChild(label);
                        _text_to_add = names[j][k] + '('+ sub_data[k] +')';
                        angle_accumulate+=sub_angle_in_pie;
                        create_data_li(_text_to_add);
                    }
                    
                }
                if(core_circle_radius > 0){ //draw core circle and value
                    style_attr = {'cssText':'position:absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                    var inner_circle = Nwagon_ie.drawWedges(cx, cy, core_circle_radius, '#FFFFFF', 0, 360, style_attr);
                    canvas.appendChild(inner_circle);
                    //TODO: core text 
                    var label = document.createElement('div'); 
                    label.appendChild(document.createTextNode(core_value));
                    style_attr = {'cssText':'position:absolute; z-index:100', 'left': cx-(core_circle_radius/2) + 'px', 'top': cy-5 + 'px', 'fontSize': '12px'};
                    Nwagon_ie.setStyles(label, style_attr);
                    canvas.appendChild(label);
                }
            }
        },
        drawBackground: function(canvas, angles, chart_type, obj_names, dataset, increment, max_radius, core_circle_radius, h){
            var cx = Math.round(h/2), cy=Math.round(h/2);
            var data = dataset['values'];
            var len = data.length;
            
            var draw_bg_circles = function(radius){
                var sa = Math.round(90 * 65535); 
                var a = -Math.round((360)* 65536); 
                var circle = document.createElement("v:shape"); 
                var path = 'AE ' + cx + ' ' + cy + ' ' + radius + ' ' + radius +  ' ' + sa + ' ' + a + ' X E';     
                var attributes = {'path': path, 'fillcolor': '#FFFFFF', 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(circle, attributes);
                var style_attr = {'cssText':'position:absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                Nwagon_ie.setStyles(circle, style_attr);
                canvas.appendChild(circle);  
            };
            
            //draw bg circles and y labels
            var r = max_radius + core_circle_radius;
            while(r > core_circle_radius){
                draw_bg_circles(r);
                var label = document.createElement('div'); 
                label.appendChild(document.createTextNode((r-core_circle_radius).toString()));
                style_attr = {'cssText':'position:absolute; z-index:100', 'left': cx + 'px', 'top': (h-cy-r-10) + 'px', 'fontSize': '12px'};
                Nwagon_ie.setStyles(label, style_attr);
                canvas.appendChild(label);
                r-=increment;
            }

            //straight lines
            var rotate_angle = 0, tweak_angle = Math.PI/2; //start at 90 degree
            if(len){
                var angle = (2*Math.PI)/len;
                for(var j=0; j<len; j++)
                {
                    if(angles.length){  // for(polar_pie)
                        rotate_angle += (angles[j] * Math.PI)/180;
                    } 
                    else{
                        rotate_angle = angle * j;
                    }
                    var line_width = max_radius + core_circle_radius;
                    var line = document.createElement('v:shape'); 
                    var path = 'M '+ cx + ' '+ cy + 'L ' + (cx- Math.round(line_width * Math.cos(rotate_angle + tweak_angle))) +' ' + (h - cy - Math.round((line_width) * Math.sin(rotate_angle+tweak_angle)));
                    var attributes = {'path': path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                    Nwagon_ie.setAttributes(line, attributes);
                    style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                    Nwagon_ie.setStyles(line, style_attr);
                    canvas.appendChild(line);
                    
                    var sub_data = data[j];
                    if(sub_data){
                        var sub_len = sub_data.length;
                        for (var k = 1; k < sub_len; k++)
                        {
                            var inner_rotate_angle = rotate_angle + (angle/sub_len*k) +tweak_angle;
                            
                            var inner_line = document.createElement('v:shape'); 
                            var path = 'M '+ cx + ' '+ cy + 'L ' + (cx- Math.round(line_width * Math.cos(inner_rotate_angle))) +' ' + (h - cy - Math.round((line_width) * Math.sin(inner_rotate_angle)));
                            var attributes = {'path': path, 'strokecolor': '#CCC', 'strokeweight':'1px'};    
                            Nwagon_ie.setAttributes(inner_line, attributes);
                            style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
                            Nwagon_ie.setStyles(inner_line, style_attr);
                            canvas.appendChild(inner_line);
                        }
                    }
                }
            }
        }
    },

    donut:{

        drawDonutChart: function(obj){

            var width = obj.width, height = obj.height;
            var canvas = Nwagon_ie.createChartArea(obj.chart_div, width, height);
            var angles = {'angles':[], 'percent':[], 'values':[]};
            var degree_values = obj.dataset['values'];
            if(degree_values){
                angles = Nwagon.getAngles(degree_values, angles);
            }
            this.drawDonut(obj.chart_div, angles, obj.chartType, canvas, obj.dataset, obj.core_circle_radius, obj.donut_width, height);
            Nwagon_ie.drawFields_for_circular_type_chart(obj.dataset['fields'], obj.dataset['colorset'], canvas, height);
        }, 

        drawDonut: function(parentDiv, angles, chartType, canvas, data, core_radius, donut_width, h){
            var radius = donut_width + core_radius;
            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            var create_data_li = function(text_to_add){
                if(ul){
                    var li = document.createElement('li');
                    li.innerHTML = text_to_add;
                    ul.appendChild(li);
                }
            };

            var tooltip = Nwagon_ie.createTooltip(canvas);
            var values = data['values'];
            var colors = data['colorset'];
            var fields = data['fields'];
            var angle_int = angles['angles'];
            var attributes = {}, style_attr = {};;
            var start_angle = 90; // Tweak the angles so that our pie goes clockwise from 12 o'clock. 
            var text_to_add = '';
            var cx = Math.round(h/2), cy = Math.round(h/2); 
            
            for(var i = 0; i < angle_int.length; i++) { 
                
                style_attr = {'cssText':'position:absolute', 'width': canvas.style.width, 'height': canvas.style.height /*,'filter': 'alpha(opacity=80)' */};
                var wedge = Nwagon_ie.drawWedges(cx, cy, radius, colors[i], start_angle, angle_int[i], style_attr);
                
                canvas.appendChild(wedge);  

                var tooltip_angle = (Math.PI * start_angle)/180; 
                var tooltip_x = cx + radius * Math.cos(tooltip_angle);
                var tooltip_y = cy + radius * Math.sin(tooltip_angle); 
                var degree_value = angles['values'][i].toFixed(0);
                text_to_add = fields[i] ? (fields[i]+ '(' +(angles['percent'][i]*100).toFixed(1) +'%) ' + degree_value) : 'undefiend';
                wedge.onmouseover = Nwagon_ie.showToolTip(tooltip, tooltip_x, tooltip_y, text_to_add);
                wedge.onmouseout = Nwagon_ie.hideToolTip(tooltip);

                if(chartType == 'donut'){
                    style_attr = {'cssText':'position:absolute; z-index:50', 'width': canvas.style.width, 'height': canvas.style.height};
                    var wedge2 = Nwagon_ie.drawWedges(cx, cy, core_radius, '#FFFFFF', start_angle, angle_int[i], style_attr);
                    canvas.appendChild(wedge2);  
                }
                start_angle -= angle_int[i];  
                create_data_li(text_to_add);
            }
        }
    }, 

    radar: {

        drawRadarChart: function(obj){

            var width = obj.width, height = obj.height;
            var canvas =  Nwagon_ie.createChartArea(obj.chart_div, width, height);

            this.drawBackground(canvas, obj.legend['names'], obj.dataset['bgColor'], CONST_DECREMENT, CONST_MAX_RADIUS, height, width);
            // this.drawLabels(svg, obj.legend, CONST_MAX_RADIUS);
            this.drawPolygonForeground(obj.chart_div, canvas, obj.legend, obj.dataset, height, width);
        },

        drawBackground: function(canvas, names, bg_color, decrement, maxRadius, h, w){
            var numOfRadars = names.length;
            var bg = bg_color ?  bg_color : '#F9F9F9';
            var cx = Math.round(w/2), cy = Math.round(h/2); 
            var sector_angle  = (Math.PI*2)/numOfRadars, tweak_angle = Math.PI;  //start on 180 degree
            var rotate_angle = 0, prev_angle = 0;
            var p0= cx + ' '+ cy , p1='', p2='';
            var style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height};
            var style_label = {};

            var drawline = function(start, end, style, isdashed){
                var line = document.createElement('v:shape'); 
                var path = 'M '+start+ 'L ' + end;
                var attributes = {'path': path, 'strokecolor':'#666', 'strokeweight':'1px'};    
                Nwagon_ie.setAttributes(line, attributes);
                Nwagon_ie.setStyles(line, style);
                if(isdashed){
                    var stroke = document.createElement('v:stroke'); 
                    stroke.setAttribute('dashstyle', 'dash');
                    line.appendChild(stroke);
                }
                return line;
            };
            var draw_x_coord = function(text_to_add, x, y){
                var label = document.createElement('div'); 
                label.appendChild(document.createTextNode(text_to_add));
                Nwagon_ie.setStyles(label, {'cssText':'position:absolute; z-index:100', 'left': x + 'px', 'top':  (y-5)+ 'px', 'fontSize': '10px'});
                return label;
            };

            for(var j= 1 ; j<=numOfRadars; j++){
                var label_location_off = 0;
                var radius = maxRadius;
                prev_angle = (sector_angle * (j-1)) + tweak_angle;
                rotate_angle = (sector_angle * j) + tweak_angle;
                var x_off = Math.round((maxRadius+20) * Math.cos(rotate_angle));
                var y_off = Math.round((maxRadius+20) * Math.sin(rotate_angle));
                p1 = (cx- Math.round(maxRadius * Math.cos(rotate_angle))) +' ' + (h - cy -  Math.round((maxRadius) * Math.sin(rotate_angle)));
                var straight_line = drawline(p0, p1, style_attr, false);
                canvas.appendChild(straight_line);
                
                // add labels 
                var label = document.createElement('div'); 
                if(j == numOfRadars) label.appendChild(document.createTextNode(names[0]));
                else label.appendChild(document.createTextNode(names[j]));
                style_label = {'cssText':'position:absolute; z-index:100', 'fontSize': '12px'};
                Nwagon_ie.setStyles(label, style_label);
                canvas.appendChild(label);
                if(x_off > 0) {
                    label_location_off = label.clientWidth;
                }
                if (x_off == 0) {
                    label_location_off = Math.round(label.clientWidth/2);
                } 
                label.style.left = (cx- x_off - label_location_off) + 'px';
                label.style.top = (h - cy - (y_off+5)) + 'px';

                while(radius>0){
                    if(j == 1){
                        //draw coordinate labels
                        var x_coord = draw_x_coord(radius.toString(), (cx + radius), (h-cy));
                        canvas.appendChild(x_coord);
                    }
                    //draw dotted bg lines && 
                    p1 = (cx- Math.round(radius * Math.cos(rotate_angle))) +' ' + (h - cy - Math.round((radius) * Math.sin(rotate_angle)));
                    p2 = (cx- Math.round(radius * Math.cos(prev_angle))) +' ' + (h - cy - Math.round((radius) * Math.sin(prev_angle)));
                    
                    var dashed_line = drawline(p1, p2, style_attr, true);
                    canvas.appendChild(dashed_line);
                    radius-=decrement;
                }
            }
        },
        dimmedPie: function(index, len, height, c_x, c_y, a, tweak_a){
            var before = 0, after = 0;            
            var dimmed_pie = document.createElement('v:shape'); 
            before = (index == 0) ? len-1 : index-1;
            after = (index==len) ? 0 : index + 1;
            var gray_pie_path = 'M '+ c_x + ' ' + c_y + 
                                ' L ' + (c_x- Math.round(CONST_MAX_RADIUS * Math.cos((a * before) + tweak_a))) + ' ' + (height - c_y - Math.round((CONST_MAX_RADIUS) * Math.sin((a * before) + tweak_a))) + 
                                ' L ' + (c_x- Math.round(CONST_MAX_RADIUS * Math.cos((a * index) + tweak_a))) + ' ' + (height - c_y - Math.round((CONST_MAX_RADIUS) * Math.sin((a * index) + tweak_a))) + 
                                ' L ' + (c_x- Math.round(CONST_MAX_RADIUS * Math.cos((a * after) + tweak_a))) + ' ' + (height - c_y - Math.round((CONST_MAX_RADIUS) * Math.sin((a * after) + tweak_a))) + 
                                ' X E';
                        
            var attributes = {'path': gray_pie_path, 'strokecolor':'#000000', 'strokeweight':'1px', 'fillcolor':'#000000'};    
            Nwagon_ie.setAttributes(dimmed_pie, attributes);
            return dimmed_pie;
        },
        drawPolygonForeground: function(parentDiv, canvas, legend, data, h, w){
            var style_attr = {'position':'absolute', 'width': canvas.style.width, 'height': canvas.style.height, 'filter': ''};
            var cx = Math.round(w/2), cy = Math.round(h/2); 
            var dataGroup = data['values'];
            var title = data['title'];
            var fg_color = data['fgColor'] ? data['fgColor'] : '#30A1CE';
            var istooltipNeeded = (dataGroup.length == 1);
            var names = legend['names'];
            
            var radius = 0;
            var path = '';
            var ul = document.getElementById(parentDiv).getElementsByTagName('ul')[0];
            if(ul){
                ul.innerHTML = title; 
            }
            if(istooltipNeeded){
                var tooltip = Nwagon_ie.createTooltip(canvas);
            }
            for(var i = 0; i<dataGroup.length; i++){
                if(ul)
                {
                    var textEl = document.createElement('li');
                    textEl.innerHTML = 'Data set number ' + (i+1).toString();
                    var innerUL = document.createElement('ul');
                    textEl.appendChild(innerUL);
                    ul.appendChild(textEl);
                }
                var dataset = dataGroup[i];
                var length = dataset.length;
                var coordinate = [];
                var angle = (Math.PI*2)/length;
                var tweak_angle = Math.PI, point_angle=0;
                var p='';

                for (var k = 0; k<dataset.length; k++){
                    if(typeof(dataset[k]) != 'number'){
                        radius = 0;
                        var gray_pie = Nwagon_ie.radar.dimmedPie(k, dataset.length, h, cx, cy, angle, tweak_angle);
                        style_attr.filter = 'alpha(opacity=10)';
                        Nwagon_ie.setStyles(gray_pie, style_attr);
                        canvas.appendChild(gray_pie);
                    }
                    else{
                        radius = dataset[k];   
                    } 
                    if(innerUL){
                        var innerLI = document.createElement('li');
                        innerLI.innerHTML = names[k] + ': ' + dataset[k];
                        innerUL.appendChild(innerLI);
                    }
                    point_angle = (angle * k) + tweak_angle;
                    if(k==0){
                        p +='M ' + (cx- Math.round(radius * Math.cos(point_angle))) +' ' + (h - cy - Math.round((radius) * Math.sin(point_angle)));
                    }
                    else{
                        p +=' L ' + (cx- Math.round(radius * Math.cos(point_angle))) +' ' + (h - cy - Math.round((radius) * Math.sin(point_angle)));   
                    }
                    //draw vertex
                    var vertex = Nwagon_ie.drawVertex(cx- Math.round(radius * Math.cos(point_angle)), (h - cy - Math.round((radius) * Math.sin(point_angle))), fg_color) ; 
                    text_to_add = names[k] + ': ' + dataset[k];
                    if(istooltipNeeded){
                        vertex.onmouseover = Nwagon_ie.showToolTip(tooltip, cx- Math.round(radius * Math.cos(point_angle)), (h - cy - Math.round((radius) * Math.sin(point_angle))), text_to_add);
                        vertex.onmouseout = Nwagon_ie.hideToolTip(tooltip);
                    }
                    canvas.appendChild(vertex);
                }
                p+=' X E';

                var line = document.createElement('v:shape'); 
                var attributes = {'path': p, 'strokecolor':fg_color, 'strokeweight':'1px', 'fillcolor':fg_color};    
                Nwagon_ie.setAttributes(line, attributes);
                style_attr.filter = 'alpha(opacity=80)';
                Nwagon_ie.setStyles(line, style_attr);
                canvas.appendChild(line);
            }
        }
    }
};

