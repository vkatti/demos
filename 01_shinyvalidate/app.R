library(shiny)
library(bslib)
library(DT)

ui <- page_navbar(theme = theme_bootswatch("minty"), 
  title = "Venue Booking App",
  sidebar = sidebar( width = 400,
      textInput(inputId = "event_name",    label = "Event Name (ex. 'New Year Bash 2025')"),
      dateInput(inputId = "event_date",    label = "Event Date"),
      selectInput(inputId = "event_type",  label = "Event Type", choices = c("---", "Party", "Wedding", "Birthday", "Conference", "Camp Fire")),
      selectInput(inputId = "event_venue", label = "Event Venue", choices = c("---", "Main Hall", "Side Hall", "Open Area", "Pool Side")),
      numericInput(inputId = "num_guests", label = "Number of Guests", value = 0),
      actionButton(inputId = "submit",     label = "Submit", class = "btn-success")
    ),
  tabPanel(title = "Booking Table",
      DTOutput("booking_table")
  )
)

server <- function(input, output) {
  booking_data <- reactiveValues(data = data.frame())
  
  observeEvent(input$submit, {
    new_booking <- data.frame(
      Event_Name       = input$event_name,
      Event_Date       = input$event_date,
      Type             = input$event_type,
      Preferred_Venue  = input$event_venue,
      Number_of_Guests = input$num_guests
    )
    booking_data$data <- rbind(booking_data$data, new_booking)
  })
  
  output$booking_table <- renderDT({
    booking_data$data
  })
}

shinyApp(ui = ui, server = server)