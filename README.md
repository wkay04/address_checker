# NYS Assembly District 34 Address Checker

A web application to check if an address is located within New York State Assembly District 34.

## Features

- **Address Geocoding**: Enter any address and get its exact coordinates
- **District Verification**: Instantly check if the address falls within Assembly District 34
- **Interactive Map**: Visual display of AD 34 boundaries with color-coded markers
- **User-friendly Interface**: Simple search bar with clear Yes/No results

## Files

- `index.html` - Standalone HTML web application (JavaScript + Leaflet.js)
- `Address search.R` - R Shiny application version
- `nys_assembly_districts.geojson` - GeoJSON file with NYS Assembly District boundaries

## Usage

### Web Version (HTML)

1. Open `index.html` in a web browser
2. Enter an address in the search box
3. Click "Search" or press Enter
4. View the results:
   - **Green marker**: Address is in AD 34 ✓
   - **Red marker**: Address is in a different district ✗
   - **Gray marker**: Not in any NYS Assembly District

### R Shiny Version

1. Install required packages:
```r
install.packages(c("shiny", "leaflet", "ggmap", "sf", "jsonlite"))
```

2. Set your Google Geocoding API key in the script

3. Run the app:
```r
shiny::runApp()
```

## Requirements

- Google Geocoding API key (for geocoding addresses)
- Modern web browser (for HTML version)
- R 4.0+ with required packages (for Shiny version)

## Data Source

Assembly District boundaries are from the official NYS GeoJSON dataset.

## License

This project is open source and available under the MIT License.
