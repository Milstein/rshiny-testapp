library(shiny)

# Path to persistent log file on PVC
log_file <- "/srv/data/shiny_logs.txt"

# Helper function to append logs with timestamp
log_event <- function(message) {
  timestamp <- Sys.time()
  line <- paste0("[", timestamp, "] ", message, "\n")
  
  # Create the file if it doesn't exist (handles first run)
  if(!file.exists(log_file)) {
    file.create(log_file)
    Sys.chmod(log_file, mode = "0666") # Ensure OpenShift UID can write
  }
  
  cat(line, file = log_file, append = TRUE)
}

# Log app start
log_event("Shiny app started.")

# Define server logic
server <- function(input, output, session) {

  # Track slider changes and log them
  observeEvent(input$obs, {
    log_event(paste0("Slider changed: obs = ", input$obs))
  })

  # Render histogram
  output$distPlot <- renderPlot({
    dist <- rnorm(input$obs)
    log_event(paste0("Generated histogram with ", input$obs, " observations."))
    hist(dist)
  })

  # Log session end
  session$onSessionEnded(function() {
    log_event("User session ended.")
  })
}

# Define UI
ui <- fluidPage(
  titlePanel("Hello OpenShift Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", 
                  "Number of observations:", 
                  min = 1, 
                  max = 1000, 
                  value = 500)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Launch Shiny app
shinyApp(ui, server)