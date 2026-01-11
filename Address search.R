# R Script to generate the AD 34 Address Checker HTML file

# API Key
api_key <- "AIzaSyAI9mTTZGXfNopOlLyybn4troC09LyB1Xk"

# Generate HTML content in parts
html_part1 <- '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Are you in AD 34?</title>

    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        @font-face {
            font-family: \'BW Haas Grotesk\';
            src: url(\'BW Haas Grotesk Text-55 Roman.otf\') format(\'opentype\');
            font-weight: normal;
            font-style: normal;
        }

        @font-face {
            font-family: \'BW Haas Grotesk\';
            src: url(\'BW Haas Grotesk Text-56 Italic.otf\') format(\'opentype\');
            font-weight: normal;
            font-style: italic;
        }

        @font-face {
            font-family: \'BW Haas Grotesk\';
            src: url(\'BW Haas Grotesk Head-55 Roman.otf\') format(\'opentype\');
            font-weight: 600;
            font-style: normal;
        }

        @font-face {
            font-family: \'BW Haas Grotesk\';
            src: url(\'BW Haas Grotesk Head-76 Bold Italic.otf\') format(\'opentype\');
            font-weight: bold;
            font-style: italic;
        }

        @font-face {
            font-family: \'Milliffigh\';
            src: url(\'Milliffigh.otf\') format(\'opentype\');
            font-weight: normal;
            font-style: normal;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: \'BW Haas Grotesk\', -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, \'Helvetica Neue\', Arial, sans-serif;
            background-color: #752D1F;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        h1 {
            font-family: \'Milliffigh\', \'BW Haas Grotesk\', sans-serif;
            color: white;
            margin-bottom: 20px;
            text-align: center;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .tab-content {
            display: block;
        }

        .search-box {
            background: transparent;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .input-group {
            display: flex;
            gap: 10px;
        }

        #addressInput {
            flex: 1;
            padding: 12px;
            border: 3px solid #42939E;
            border-radius: 4px;
            font-size: 16px;
            background-color: white;
        }

        #addressInput:focus {
            outline: none;
            border-color: #42939E;
            box-shadow: 0 0 0 3px rgba(66, 147, 158, 0.3);
        }

        #searchBtn {
            padding: 12px 24px;
            background-color: #42939E;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-weight: 600;
        }

        #searchBtn:hover {
            background-color: #357882;
        }

        #searchBtn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        #result {
            background: transparent;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            min-height: 50px;
            font-size: 18px;
            font-weight: 500;
        }

        #result.success {
            background-color: rgba(255, 255, 255, 0.9);
            color: #155724;
            border: 3px solid #28a745;
        }

        #result.error {
            background-color: rgba(255, 255, 255, 0.9);
            color: #721c24;
            border: 3px solid #dc3545;
        }

        #result.info {
            background-color: rgba(255, 255, 255, 0.9);
            color: #0c5460;
            border: 3px solid #17a2b8;
        }

        #map {
            height: 600px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .loading {
            display: none;
            text-align: center;
            padding: 10px;
            color: white;
            font-weight: 600;
        }

        .spinner {
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-top: 3px solid #42939E;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Are you in AD 34?</h1>

        <!-- Single Address Search -->
        <div id="single-tab" class="tab-content active">
            <div class="search-box">
                <div class="input-group">
                    <input type="text" id="addressInput" placeholder="Enter an address (e.g., 123 Main St, New York, NY)" />
                    <button id="searchBtn">Search</button>
                </div>
            </div>

            <div class="loading" id="loading">
                <div class="spinner"></div>
                <p>Searching...</p>
            </div>

            <div id="result"></div>

            <div id="map"></div>
        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

    <script>
        const API_KEY = \''

html_part2 <- paste0(api_key, '\';

        // Initialize map
        const map = L.map(\'map\').setView([40.7128, -74.0060], 12);

        // Add tile layer
        L.tileLayer(\'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png\', {
            attribution: \'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors\'
        }).addTo(map);

        let ad34Layer = null;
        let markerLayer = null;

        // Load Assembly District 34 GeoJSON
        fetch(\'nys_assembly_districts.geojson\')
            .then(response => {
                if (!response.ok) {
                    throw new Error(\'Failed to load GeoJSON file\');
                }
                return response.json();
            })
            .then(data => {
                console.log(\'GeoJSON loaded, features:\', data.features.length);

                // Find Assembly District 34
                const ad34Feature = data.features.find(f => f.properties.District === 34);

                if (ad34Feature) {
                    console.log(\'District 34 found\');

                    ad34Layer = L.geoJSON(ad34Feature, {
                        style: {
                            fillColor: \'#42939E\',
                            fillOpacity: 0.4,
                            color: \'#42939E\',
                            weight: 3
                        }
                    }).addTo(map);

                    // Fit map to AD 34 bounds
                    map.fitBounds(ad34Layer.getBounds());
                } else {
                    console.error(\'Assembly District 34 not found in GeoJSON data\');
                    alert(\'Error: Could not find Assembly District 34 in the data file.\');
                }
            })
            .catch(error => {
                console.error(\'Error loading GeoJSON:\', error);
                console.error(\'Full error details:\', error.message, error.stack);
            });

        // Geocode function
        async function geocodeAddress(address) {
            const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${API_KEY}`;

            try {
                const response = await fetch(url);
                const data = await response.json();

                if (data.status === \'OK\' && data.results.length > 0) {
                    const location = data.results[0].geometry.location;
                    return {
                        lat: location.lat,
                        lng: location.lng,
                        formattedAddress: data.results[0].formatted_address
                    };
                } else {
                    throw new Error(\'Address not found\');
                }
            } catch (error) {
                throw error;
            }
        }

        // Check if point is in polygon
        function pointInPolygon(point, polygon) {
            const x = point[0], y = point[1];
            let inside = false;

            for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
                const xi = polygon[i][0], yi = polygon[i][1];
                const xj = polygon[j][0], yj = polygon[j][1];

                const intersect = ((yi > y) !== (yj > y))
                    && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
                if (intersect) inside = !inside;
            }

            return inside;
        }

        // Check if point is in AD 34
        async function checkDistrict(lat, lng) {
            try {
                const response = await fetch(\'nys_assembly_districts.geojson\');
                const data = await response.json();

                // Only check for District 34
                const ad34Feature = data.features.find(f => f.properties.District === 34);
                if (ad34Feature) {
                    const coords = ad34Feature.geometry.coordinates;

                    // Handle MultiPolygon
                    for (const polygon of coords) {
                        for (const ring of polygon) {
                            if (pointInPolygon([lng, lat], ring)) {
                                return { inDistrict34: true };
                            }
                        }
                    }
                }

                return { inDistrict34: false };
            } catch (error) {
                console.error(\'Error checking district:\', error);
                return null;
            }
        }

        // Search button handler
        document.getElementById(\'searchBtn\').addEventListener(\'click\', async () => {
            const address = document.getElementById(\'addressInput\').value.trim();

            if (!address) {
                showResult(\'Please enter an address\', \'error\');
                return;
            }

            // Show loading
            document.getElementById(\'loading\').style.display = \'block\';
            document.getElementById(\'searchBtn\').disabled = true;
            document.getElementById(\'result\').textContent = \'\';
            document.getElementById(\'result\').className = \'\';

            try {
                // Geocode the address
                const location = await geocodeAddress(address);

                // Check which district
                const district = await checkDistrict(location.lat, location.lng);

                // Remove old marker
                if (markerLayer) {
                    map.removeLayer(markerLayer);
                }

                // Determine marker color and message
                let iconColor, message, resultClass;

                if (district && district.inDistrict34) {
                    iconColor = \'green\';
                    message = `YES! This address is in Assembly District 34`;
                    resultClass = \'success\';
                } else {
                    iconColor = \'red\';
                    message = `NO. This address is not in Assembly District 34`;
                    resultClass = \'error\';
                }

                // Add marker
                const icon = L.divIcon({
                    html: `<i class="fas fa-map-marker-alt" style="font-size: 36px; color: ${iconColor};"></i>`,
                    iconSize: [36, 36],
                    iconAnchor: [18, 36],
                    popupAnchor: [0, -36],
                    className: \'\'
                });

                markerLayer = L.marker([location.lat, location.lng], { icon: icon })
                    .addTo(map)
                    .bindPopup(`<b>${location.formattedAddress}</b><br>${message}`)
                    .openPopup();

                // Zoom to location
                map.setView([location.lat, location.lng], 14);

                // Show result
                showResult(message, resultClass);

            } catch (error) {
                showResult(\'Error: \' + error.message, \'error\');
            } finally {
                document.getElementById(\'loading\').style.display = \'none\';
                document.getElementById(\'searchBtn\').disabled = false;
            }
        });

        // Enter key to search
        document.getElementById(\'addressInput\').addEventListener(\'keypress\', (e) => {
            if (e.key === \'Enter\') {
                document.getElementById(\'searchBtn\').click();
            }
        });

        function showResult(message, type) {
            const resultDiv = document.getElementById(\'result\');
            resultDiv.textContent = message;
            resultDiv.className = type;
        }
    </script>
</body>
</html>')

# Combine parts
html_content <- paste0(html_part1, html_part2)

# Write to file
writeLines(html_content, "index.html")

cat("HTML file generated successfully: index.html\n")
