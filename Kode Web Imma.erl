<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="initial-scale=1,user-scalable=no,maximum-scale=1,width=device-width">
        <meta name="mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <link rel="stylesheet" href="css/leaflet.css">
        <link rel="stylesheet" href="css/L.Control.Layers.Tree.css">
        <link rel="stylesheet" href="css/qgis2web.css">
        <link rel="stylesheet" href="css/fontawesome-all.min.css">
        <link rel="stylesheet" href="css/filter.css">
<link rel="stylesheet" href="css/nouislider.min.css">
        <link rel="stylesheet" href="css/leaflet.photon.css">
        <link rel="stylesheet" href="css/leaflet-measure.css">
        <style>
        html, body, #map {
            width: 100%;
            height: 100%;
            padding: 0;
            margin: 0;
        }
        </style>
        <title>PETA ADMINISTRASI KECAMATAN</title>
    </head>
    <body>
        <div id="map">
        </div>
        <script src="js/qgis2web_expressions.js"></script>
        <script src="js/leaflet.js"></script>
        <script src="js/L.Control.Layers.Tree.min.js"></script>
        <script src="js/leaflet.rotatedMarker.js"></script>
        <script src="js/leaflet.pattern.js"></script>
        <script src="js/leaflet-hash.js"></script>
        <script src="js/Autolinker.min.js"></script>
        <script src="js/rbush.min.js"></script>
        <script src="js/labelgun.min.js"></script>
        <script src="js/labels.js"></script>
        <script src="js/leaflet.photon.js"></script>
        <script src="js/leaflet-measure.js"></script>
        <script src="js/tailDT.js"></script>
<script src="js/nouislider.min.js"></script>
<script src="js/wNumb.js"></script>
        <script src="data/Clipped_1.js"></script>
        <script>
        var highlightLayer;
        function highlightFeature(e) {
            highlightLayer = e.target;
            highlightLayer.openPopup();
        }
        var map = L.map('map', {
            zoomControl:false, maxZoom:28, minZoom:1
        }).fitBounds([[0.3966515628308117,116.04197937936983],[3.1069269530572825,119.0660761305699]]);
        var hash = new L.Hash(map);
        map.attributionControl.setPrefix('<a href="https://github.com/tomchadwin/qgis2web" target="_blank">qgis2web</a> &middot; <a href="https://leafletjs.com" title="A JS library for interactive maps">Leaflet</a> &middot; <a href="https://qgis.org">QGIS</a>');
        var autolinker = new Autolinker({truncate: {length: 30, location: 'smart'}});
        // remove popup's row if "visible-with-data"
        function removeEmptyRowsFromPopupContent(content, feature) {
         var tempDiv = document.createElement('div');
         tempDiv.innerHTML = content;
         var rows = tempDiv.querySelectorAll('tr');
         for (var i = 0; i < rows.length; i++) {
             var td = rows[i].querySelector('td.visible-with-data');
             var key = td ? td.id : '';
             if (td && td.classList.contains('visible-with-data') && feature.properties[key] == null) {
                 rows[i].parentNode.removeChild(rows[i]);
             }
         }
         return tempDiv.innerHTML;
        }
        // modify popup if contains media
        function addClassToPopupIfMedia(content, popup) {
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = content;
            var imgTd = tempDiv.querySelector('td img');
            if (imgTd) {
                var src = imgTd.getAttribute('src');
                if (/\.(jpg|jpeg|png|gif|bmp|webp|avif)$/i.test(src)) {
                    popup._contentNode.classList.add('media');
                    setTimeout(function() {
                        popup.update();
                    }, 10);
                } else if (/\.(mp3|wav|ogg|aac)$/i.test(src)) {
                    var audio = document.createElement('audio');
                    audio.controls = true;
                    audio.src = src;
                    imgTd.parentNode.replaceChild(audio, imgTd);
                    popup._contentNode.classList.add('media');
                    setTimeout(function() {
                        popup.setContent(tempDiv.innerHTML);
                        popup.update();
                    }, 10);
                } else if (/\.(mp4|webm|ogg|mov)$/i.test(src)) {
                    var video = document.createElement('video');
                    video.controls = true;
                    video.src = src;
                    video.style.width = "400px";
                    video.style.height = "300px";
                    video.style.maxHeight = "60vh";
                    video.style.maxWidth = "60vw";
                    imgTd.parentNode.replaceChild(video, imgTd);
                    popup._contentNode.classList.add('media');
                    // Aggiorna il popup quando il video carica i metadati
                    video.addEventListener('loadedmetadata', function() {
                        popup.update();
                    });
                    setTimeout(function() {
                        popup.setContent(tempDiv.innerHTML);
                        popup.update();
                    }, 10);
                } else {
                    popup._contentNode.classList.remove('media');
                }
            } else {
                popup._contentNode.classList.remove('media');
            }
        }
        var title = new L.Control({'position':'topright'});
        title.onAdd = function (map) {
            this._div = L.DomUtil.create('div', 'info');
            this.update();
            return this._div;
        };
        title.update = function () {
            this._div.innerHTML = '<h2>PETA ADMINISTRASI KECAMATAN</h2>';
        };
        title.addTo(map);
        var abstract = new L.Control({'position':'topright'});
        abstract.onAdd = function (map) {
            this._div = L.DomUtil.create('div',
            'leaflet-control abstract');
            this._div.id = 'abstract'

                abstract.show();
                return this._div;
            };
            abstract.show = function () {
                this._div.classList.remove("abstract");
                this._div.classList.add("abstractUncollapsed");
                this._div.innerHTML = 'DI KECAMATAN KABUPATEN BERAU MERUPAKAN SATUAN WILAYAH ADMINISTRASI YANG BERPERAN DALAM MENDUKUNG PEMERINTAHAN DAN MEMBANGUN DAERAH, INFORMASI SPASIAL BATAS KECAMATAN DIPERLUKAN UNTUK MEDIA PETA SECARA EFEKTIF YANG TERDIRI DARI 13 KECAMATAN';
        };
        abstract.addTo(map);
        var zoomControl = L.control.zoom({
            position: 'topleft'
        }).addTo(map);
        var measureControl = new L.Control.Measure({
            position: 'topleft',
            primaryLengthUnit: 'feet',
            secondaryLengthUnit: 'miles',
            primaryAreaUnit: 'sqfeet',
            secondaryAreaUnit: 'sqmiles'
        });
        measureControl.addTo(map);
        document.getElementsByClassName('leaflet-control-measure-toggle')[0].innerHTML = '';
        document.getElementsByClassName('leaflet-control-measure-toggle')[0].className += ' fas fa-ruler';
        var bounds_group = new L.featureGroup([]);
        function setBounds() {
        }
        map.createPane('pane_OSMStandard_0');
        map.getPane('pane_OSMStandard_0').style.zIndex = 400;
        var layer_OSMStandard_0 = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            pane: 'pane_OSMStandard_0',
            opacity: 1.0,
            attribution: '<a href="https://www.openstreetmap.org/copyright">© OpenStreetMap contributors, CC-BY-SA</a>',
            minZoom: 1,
            maxZoom: 28,
            minNativeZoom: 0,
            maxNativeZoom: 19
        });
        layer_OSMStandard_0;
        map.addLayer(layer_OSMStandard_0);
        function pop_Clipped_1(feature, layer) {
            layer.on({
                mouseout: function(e) {
                    if (typeof layer.closePopup == 'function') {
                        layer.closePopup();
                    } else {
                        layer.eachLayer(function(feature){
                            feature.closePopup()
                        });
                    }
                },
                mouseover: highlightFeature,
            });
            var popupContent = '<table>\
                    <tr>\
                        <th scope="row">OBJECTID</th>\
                        <td>' + (feature.properties['OBJECTID'] !== null ? autolinker.link(String(feature.properties['OBJECTID']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">NAMOBJ</th>\
                        <td>' + (feature.properties['NAMOBJ'] !== null ? autolinker.link(String(feature.properties['NAMOBJ']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">FCODE</th>\
                        <td>' + (feature.properties['FCODE'] !== null ? autolinker.link(String(feature.properties['FCODE']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">METADATA</th>\
                        <td>' + (feature.properties['METADATA'] !== null ? autolinker.link(String(feature.properties['METADATA']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">SRS_ID</th>\
                        <td>' + (feature.properties['SRS_ID'] !== null ? autolinker.link(String(feature.properties['SRS_ID']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">KDCPUM</th>\
                        <td>' + (feature.properties['KDCPUM'] !== null ? autolinker.link(String(feature.properties['KDCPUM']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">TIPADM</th>\
                        <td>' + (feature.properties['TIPADM'] !== null ? autolinker.link(String(feature.properties['TIPADM']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">WADMKC</th>\
                        <td>' + (feature.properties['WADMKC'] !== null ? autolinker.link(String(feature.properties['WADMKC']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                    <tr>\
                        <th scope="row">WADMKK</th>\
                        <td>' + (feature.properties['WADMKK'] !== null ? autolinker.link(String(feature.properties['WADMKK']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">WADMPR</th>\
                        <td>' + (feature.properties['WADMPR'] !== null ? autolinker.link(String(feature.properties['WADMPR']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">WIADKK</th>\
                        <td>' + (feature.properties['WIADKK'] !== null ? autolinker.link(String(feature.properties['WIADKK']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">WIADPR</th>\
                        <td>' + (feature.properties['WIADPR'] !== null ? autolinker.link(String(feature.properties['WIADPR']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">WIADKD</th>\
                        <td>' + (feature.properties['WIADKD'] !== null ? autolinker.link(String(feature.properties['WIADKD']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">luas</th>\
                        <td>' + (feature.properties['luas'] !== null ? autolinker.link(String(feature.properties['luas']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">SHAPE_Leng</th>\
                        <td>' + (feature.properties['SHAPE_Leng'] !== null ? autolinker.link(String(feature.properties['SHAPE_Leng']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                    <tr>\
                        <th scope="row">SHAPE_Area</th>\
                        <td>' + (feature.properties['SHAPE_Area'] !== null ? autolinker.link(String(feature.properties['SHAPE_Area']).replace(/'/g, '\'').toLocaleString()) : '') + '</td>\
                    </tr>\
                </table>';
            var content = removeEmptyRowsFromPopupContent(popupContent, feature);
			layer.on('popupopen', function(e) {
				addClassToPopupIfMedia(content, e.popup);
			});
			layer.bindPopup(content, { maxHeight: 400 });
        }
                    break;
                case 'Biatan':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(178,201,84,1.0)',
                interactive: true,
            }
                    break;
                case 'Biduk-Biduk':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(240,141,48,1.0)',
                interactive: true,
            }
                    break;
                case 'Gunung Tabur':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(94,145,239,1.0)',
                interactive: true,
            }
                    break;
                case 'Karangan':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(238,125,189,1.0)',
                interactive: true,
            }
                    break;
                case 'Kelay':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(203,114,235,1.0)',
                interactive: true,
            }
                    break;
                case 'Maratua':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(207,88,114,1.0)',
                interactive: true,
            }
                    break;
                case 'Muara Wahau':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(223,49,22,1.0)',
                interactive: true,
            }
                    break;
                case 'Pulau Derawan':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(103,207,92,1.0)',
                interactive: true,
            }
                    break;
                case 'Sambaliung':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(214,195,88,1.0)',
                interactive: true,
            }
                    break;
                case 'Sandaran':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(28,22,202,1.0)',
                interactive: true,
            }
                    break;
                case 'Segah':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(14,209,131,1.0)',
                interactive: true,
            }
                    break;
                case 'Tabalar':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(158,209,116,1.0)',
                interactive: true,
            }
                    break;
                case 'Talisayan':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(30,177,240,1.0)',
                interactive: true,
            }
                    break;
                case 'Tanjung Redeb':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(99,218,129,1.0)',
                interactive: true,
            }
                    break;
                case 'Teluk Bayur':
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(235,85,222,1.0)',
                interactive: true,
            }
                    break;
                default:
                    return {
                pane: 'pane_Clipped_1',
                opacity: 1,
                color: 'rgba(35,35,35,1.0)',
                dashArray: '',
                lineCap: 'butt',
                lineJoin: 'miter',
                weight: 1.0, 
                fill: true,
                fillOpacity: 1,
                fillColor: 'rgba(46,222,213,1.0)',
                interactive: true,
            }
                    break;
            }
        }
        map.createPane('pane_Clipped_1');
        map.getPane('pane_Clipped_1').style.zIndex = 401;
        map.getPane('pane_Clipped_1').style['mix-blend-mode'] = 'normal';
        var layer_Clipped_1 = new L.geoJson(json_Clipped_1, {
            attribution: '',
            interactive: true,
            dataVar: 'json_Clipped_1',
            layerName: 'layer_Clipped_1',
            pane: 'pane_Clipped_1',
            onEachFeature: pop_Clipped_1,
            style: style_Clipped_1_0,
        });
        bounds_group.addLayer(layer_Clipped_1);
        map.addLayer(layer_Clipped_1);
        var overlaysTree = [
            {label: 'Clipped<br /><table><tr><td style="text-align: center;"><img src="legend/Clipped_1_BatuPutih0.png" /></td><td>Batu Putih</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Biatan1.png" /></td><td>Biatan</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_BidukBiduk2.png" /></td><td>Biduk-Biduk</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_GunungTabur3.png" /></td><td>Gunung Tabur</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Karangan4.png" /></td><td>Karangan</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Kelay5.png" /></td><td>Kelay</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Maratua6.png" /></td><td>Maratua</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_MuaraWahau7.png" /></td><td>Muara Wahau</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_PulauDerawan8.png" /></td><td>Pulau Derawan</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Sambaliung9.png" /></td><td>Sambaliung</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Sandaran10.png" /></td><td>Sandaran</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Segah11.png" /></td><td>Segah</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Tabalar12.png" /></td><td>Tabalar</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_Talisayan13.png" /></td><td>Talisayan</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_TanjungRedeb14.png" /></td><td>Tanjung Redeb</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_TelukBayur15.png" /></td><td>Teluk Bayur</td></tr><tr><td style="text-align: center;"><img src="legend/Clipped_1_16.png" /></td><td></td></tr></table>', layer: layer_Clipped_1},
            {label: "OSM Standard", layer: layer_OSMStandard_0},]
        var lay = L.control.layers.tree(null, overlaysTree,{
            //namedToggle: true,
            //selectorBack: false,
            //closedSymbol: '&#8862; &#x1f5c0;',
            //openedSymbol: '&#8863; &#x1f5c1;',
            //collapseAll: 'Collapse all',
            //expandAll: 'Expand all',
            collapsed: false, 
        });
        lay.addTo(map);
		document.addEventListener("DOMContentLoaded", function() {
            // set new Layers List height which considers toggle icon
            function newLayersListHeight() {
                var layerScrollbarElement = document.querySelector('.leaflet-control-layers-scrollbar');
                if (layerScrollbarElement) {
                    var layersListElement = document.querySelector('.leaflet-control-layers-list');
                    var originalHeight = layersListElement.style.height 
                        || window.getComputedStyle(layersListElement).height;
                    var newHeight = parseFloat(originalHeight) - 50;
                    layersListElement.style.height = newHeight + 'px';
                }
            }
            var isLayersListExpanded = true;
            var controlLayersElement = document.querySelector('.leaflet-control-layers');
            var toggleLayerControl = document.querySelector('.leaflet-control-layers-toggle');
            // toggle Collapsed/Expanded and apply new Layers List height
            toggleLayerControl.addEventListener('click', function() {
                if (isLayersListExpanded) {
                    controlLayersElement.classList.remove('leaflet-control-layers-expanded');
                } else {
                    controlLayersElement.classList.add('leaflet-control-layers-expanded');
                }
                isLayersListExpanded = !isLayersListExpanded;
                newLayersListHeight()
            });	
			// apply new Layers List height if toggle layerstree
			if (controlLayersElement) {
				controlLayersElement.addEventListener('click', function(event) {
					var toggleLayerHeaderPointer = event.target.closest('.leaflet-layerstree-header-pointer span');
					if (toggleLayerHeaderPointer) {
						newLayersListHeight();
					}
				});
			}
            // Collapsed/Expanded at Start to apply new height
            setTimeout(function() {
                toggleLayerControl.click();
            }, 10);
            setTimeout(function() {
                toggleLayerControl.click();
            }, 10);
            // Collapsed touch/small screen
            var isSmallScreen = window.innerWidth < 650;
            if (isSmallScreen) {
                setTimeout(function() {
                    controlLayersElement.classList.remove('leaflet-control-layers-expanded');
                    isLayersListExpanded = !isLayersListExpanded;
                }, 500);
            }  
        });       
        setBounds();
        var mapDiv = document.getElementById('map');
        var row = document.createElement('div');
        row.className="row";
        row.id="all";
        row.style.height = "100%";
        var col1 = document.createElement('div');
        col1.className="col9";
        col1.id = "mapWindow";
        col1.style.height = "99%";
        col1.style.width = "80%";
        col1.style.display = "inline-block";
        var col2 = document.createElement('div');
        col2.className="col3";
        col2.id = "menu";
        col2.style.display = "inline-block";
        mapDiv.parentNode.insertBefore(row, mapDiv);
        document.getElementById("all").appendChild(col1);
        document.getElementById("all").appendChild(col2);
        col1.appendChild(mapDiv)
        var Filters = {"WADMKC": "str"};
        function filterFunc() {
          map.eachLayer(function(lyr){
          if ("options" in lyr && "dataVar" in lyr["options"]){
            features = this[lyr["options"]["dataVar"]].features.slice(0);
            try{
              for (key in Filters){
                keyS = key.replace(/[^a-zA-Z0-9_]/g, "")
                if (Filters[key] == "str" || Filters[key] == "bool"){
                  var selection = [];
                  var options = document.getElementById("sel_" + keyS).options
                  for (var i=0; i < options.length; i++) {
                    if (options[i].selected) selection.push(options[i].value);
                  }
                    try{
                      if (key in features[0].properties){
                        for (i = features.length - 1;
                          i >= 0; --i){
                          if (selection.indexOf(
                          features[i].properties[key])<0
                          && selection.length>0) {
                          features.splice(i,1);
                          }
                        }
                      }
                    } catch(err){
                  }
                }
                if (Filters[key] == "int"){
                  sliderVals =  document.getElementById(
                    "div_" + keyS).noUiSlider.get();
                  try{
                    if (key in features[0].properties){
                    for (i = features.length - 1; i >= 0; --i){
                      if (parseInt(features[i].properties[key])
                          < sliderVals[0]
                          || parseInt(features[i].properties[key])
                          > sliderVals[1]){
                            features.splice(i,1);
                          }
                        }
                      }
                    } catch(err){
                    }
                  }
                if (Filters[key] == "real"){
                  sliderVals =  document.getElementById(
                    "div_" + keyS).noUiSlider.get();
                  try{
                    if (key in features[0].properties){
                    for (i = features.length - 1; i >= 0; --i){
                      if (features[i].properties[key]
                          < sliderVals[0]
                          || features[i].properties[key]
                          > sliderVals[1]){
                            features.splice(i,1);
                          }
                        }
                      }
                    } catch(err){
                    }
                  }
                if (Filters[key] == "date"
                  || Filters[key] == "datetime"
                  || Filters[key] == "time"){
                  try{
                    if (key in features[0].properties){
                      HTMLkey = key.replace(/[&\/\\#,+()$~%.'":*?<>{} ]/g, '');
                      startdate = document.getElementById("dat_" +
                        HTMLkey + "_date1").value.replace(" ", "T");
                      enddate = document.getElementById("dat_" +
                        HTMLkey + "_date2").value.replace(" ", "T");
                      for (i = features.length - 1; i >= 0; --i){
                        if (features[i].properties[key] < startdate
                          || features[i].properties[key] > enddate){
                          features.splice(i,1);
                        }
                      }
                    }
                  } catch(err){
                  }
                }
              }
            } catch(err){
            }
          this[lyr["options"]["layerName"]].clearLayers();
          this[lyr["options"]["layerName"]].addData(features);
          }
          })
        }
            document.getElementById("menu").appendChild(
                document.createElement("div"));
            var div_WADMKC = document.createElement('div');
            div_WADMKC.id = "div_WADMKC";
            div_WADMKC.className= "filterselect";
            document.getElementById("menu").appendChild(div_WADMKC);
            sel_WADMKC = document.createElement('select');
            sel_WADMKC.multiple = true;
            sel_WADMKC.size = 10;
            sel_WADMKC.id = "sel_WADMKC";
            var WADMKC_options_str = "<option value='' unselected></option>";
            sel_WADMKC.onchange = function(){filterFunc()};
            WADMKC_options_str  += '<option value="Batu Putih">Batu Putih</option>';
            WADMKC_options_str  += '<option value="Biatan">Biatan</option>';
            WADMKC_options_str  += '<option value="Biduk-Biduk">Biduk-Biduk</option>';
            WADMKC_options_str  += '<option value="Gunung Tabur">Gunung Tabur</option>';
            WADMKC_options_str  += '<option value="Karangan">Karangan</option>';
            WADMKC_options_str  += '<option value="Kelay">Kelay</option>';
            WADMKC_options_str  += '<option value="Maratua">Maratua</option>';
            WADMKC_options_str  += '<option value="Muara Wahau">Muara Wahau</option>';
            WADMKC_options_str  += '<option value="Pulau Derawan">Pulau Derawan</option>';
            WADMKC_options_str  += '<option value="Sambaliung">Sambaliung</option>';
            WADMKC_options_str  += '<option value="Sandaran">Sandaran</option>';
            WADMKC_options_str  += '<option value="Segah">Segah</option>';
            WADMKC_options_str  += '<option value="Tabalar">Tabalar</option>';
            WADMKC_options_str  += '<option value="Talisayan">Talisayan</option>';
            WADMKC_options_str  += '<option value="Tanjung Redeb">Tanjung Redeb</option>';
            WADMKC_options_str  += '<option value="Teluk Bayur">Teluk Bayur</option>';
            sel_WADMKC.innerHTML = WADMKC_options_str;
            div_WADMKC.appendChild(sel_WADMKC);
            var lab_WADMKC = document.createElement('div');
            lab_WADMKC.innerHTML = 'WADMKC';
            lab_WADMKC.className = 'filterlabel';
            div_WADMKC.appendChild(lab_WADMKC);
            var reset_WADMKC = document.createElement('div');
            reset_WADMKC.innerHTML = 'clear filter';
            reset_WADMKC.className = 'filterlabel';
            reset_WADMKC.onclick = function() {
                var options = document.getElementById("sel_WADMKC").options;
                for (var i=0; i < options.length; i++) {
                    options[i].selected = false;
                }
                filterFunc();
            };
            div_WADMKC.appendChild(reset_WADMKC);
        </script>        
    </body>
</html>
