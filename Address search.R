library(shiny)
library(leaflet)
library(ggmap)
library(sf)
library(jsonlite)
# Set Google API key for geocoding
Sys.setenv(GOOGLEGEOCODE_API_KEY = "AIzaSyAI9mTTZGXfNopOlLyybn4troC09LyB1Xk")
register_google(key = Sys.getenv("GOOGLEGEOCODE_API_KEY"))
ui <- fluidPage(
  # Add the text input bar in the UI
  textInput("map_search_input", "Enter Address"),
  # Display district result
  textOutput("district_result"),
  # Output the leaflet map
  leafletOutput("map")
)

server <- function(input, output, session) {

  # Load the GeoJSON file with assembly districts
  assembly_districts <- st_read("/Users/will/Documents/Address Search/nys_assembly_districts.geojson", quiet = TRUE)

  # Extract Assembly District 34
  ad34 <- assembly_districts[assembly_districts$District == 34, ]

  # Create the base map with AD 34 boundary
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addPolygons(data = ad34,
                  fillColor = "blue",
                  fillOpacity = 0.2,
                  color = "blue",
                  weight = 2,
                  popup = paste0("Assembly District 34<br>", ad34$Name)) %>%
      setView(lng = -74.0060, lat = 40.7128, zoom = 12) # Center map initially on New York
  })
  
  # Observe the text input and perform geocoding
  observeEvent(input$map_search_input, {
    search_term <- input$map_search_input

    if (search_term != "") {
      print(paste("User entered:", search_term))

      # Geocode the address using Google Maps API
      tryCatch({
        result <- geocode(location = search_term,
                         output = 'latlon',
                         source = 'google')

        # Check if geocoding was successful
        if (!is.null(result) && nrow(result) > 0 && !is.na(result$lat[1])) {
          new_lat <- result$lat[1]
          new_lng <- result$lon[1]

          # Create a spatial point from the geocoded coordinates
          point <- st_sfc(st_point(c(new_lng, new_lat)), crs = 4326)

          # Check which district the point falls in
          intersection <- st_intersects(point, assembly_districts, sparse = FALSE)

          # Find the district
          district_found <- which(intersection[1,])

          if (length(district_found) > 0) {
            district_number <- assembly_districts$District[district_found[1]]
            district_name <- assembly_districts$Name[district_found[1]]

            # Check if it's Assembly District 34
            if (district_number == 34) {
              district_message <- paste0("YES! This address is in Assembly District 34 (", district_name, ")")
              marker_color <- "green"
            } else {
              district_message <- paste0("NO. This address is in Assembly District ", district_number, " (", district_name, "), not AD 34")
              marker_color <- "red"
            }
          } else {
            district_message <- "Address is not within any NYS Assembly District"
            marker_color <- "gray"
          }

          # Update district result text
          output$district_result <- renderText({
            district_message
          })

          # Update the map view to the geocoded location
          leafletProxy("map") %>%
            clearMarkers() %>%
            clearShapes() %>%
            addPolygons(data = ad34,
                       fillColor = "blue",
                       fillOpacity = 0.2,
                       color = "blue",
                       weight = 2,
                       popup = paste0("Assembly District 34<br>", ad34$Name)) %>%
            setView(lng = new_lng, lat = new_lat, zoom = 14) %>%
            addAwesomeMarkers(lng = new_lng, lat = new_lat,
                             popup = paste0("<b>", search_term, "</b><br>", district_message),
                             icon = awesomeIcons(
                               icon = 'home',
                               iconColor = 'white',
                               library = 'fa',
                               markerColor = marker_color
                             ))

          print(paste("Geocoded to:", new_lat, new_lng, "-", district_message))
        } else {
          print("Geocoding failed: No results found")
          output$district_result <- renderText({
            "Geocoding failed: No results found"
          })
        }
      }, error = function(e) {
        print(paste("Geocoding error:", e$message))
        output$district_result <- renderText({
          paste("Error:", e$message)
        })
      })
    }
  })
}

shinyApp(ui, server)
