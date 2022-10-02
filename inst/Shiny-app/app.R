library(shiny)
library(tidyverse)
library(ggplot2)
library(sf)
library(spData)
library(glue)
library(DT)
library(plotly)
library(leaflet)

ramen_rating <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-04/ramen_ratings.csv") %>%
  drop_na(stars)

data(world, package = "spData")

ramen_rating <- ramen_rating %>%
  mutate(country = ifelse(country == "Hong Kong", "China", country),
         country = ifelse(country == "Russia", "Russian Federation", country),
         country = ifelse(country == "Holland", "Netherlands", country),
         country = ifelse(country == "Dubai", "United Arab Emirates", country),
         country = ifelse(country == "South Korea", "Republic of Korea", country),
         country = ifelse(country == "Singapore", "Malaysia", country),
         country = ifelse(country == "Sarawak", "Malaysia", country),
         country = ifelse(country == "USA", "United States", country),
         country = ifelse(country == "UK", "United Kingdom", country))

countries <- unique(ramen_rating$country)

asia <- c("Russia", "Thailand", "Japan", "Taiwan", "South Korea", "Hong Kong", "Malaysia", "China", "Philippines", "Vietnam", "Bangladesh", "Singapore", "Indonesia", "India", "Pakistan", "Nepal", "Myanmar", "Cambodia", "Dubai")
europe <- c("France", "Ukraine", "Netherlands", "Italy", "Poland", "Germany", "Hungary", "United Kingdom", "Finland", "Sweden", "Estonia")
oceania <- c("Australia", "New Zealand", "Fiji")
africa <- c("Nigeria", "Ghana")
america <- c("Canada", "United States", "Brazil", "Mexico", "Colombia")

ramen_rating <- ramen_rating %>%
  mutate(continent = case_when(
    country %in% asia ~ "Asia",
    country %in% europe ~ "Europe",
    country %in% oceania ~ "Oceania",
    country %in% america ~ "America",
    country %in% africa ~ "Africa")) %>%
  filter(continent != "NA")

# Define UI

ui <- navbarPage(
  "Ramen Rating",
  tabPanel(
    "HOMEPAGE",
    titlePanel(title=div(img(src="https://openclipart.org/image/800px/191828", width = "100%", height = "350px"))),

    tags$br(),

    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Overview",
        h3("Data overview"),
        mainPanel(
          dataTableOutput("mytable")),

        tags$br(),

        column(12,
               h3("Distribution of ramen across the world")),
        sidebarLayout(
          sidebarPanel(

            selectInput("country", "Choose a country",
                        choices = unique(ramen_rating$country))),
          mainPanel(
            leafletOutput("map"),
            textOutput("proportion")
          ))),

      tabPanel(
        "Visualization",
        h3("Average ramen rate comparison between countries"),
        sidebarLayout(
          sidebarPanel(
            selectInput("average", label = strong("Continent"),
                        choices = unique(ramen_rating$continent))
          ),
          mainPanel(
            plotlyOutput("averageplot")
          )
        ),
        h3("Top 10 best rated ramen brands"),
        sidebarLayout(
          sidebarPanel(
            selectizeInput("guess", "Country of origin",
                           choices = unique(ramen_rating$country))),
          mainPanel(
            plotOutput("top10"))),
        h3("Good verse bad ramens"),
        sidebarLayout(
          sidebarPanel(
            selectInput("test", "Country",
                        choices = unique(ramen_rating$country))),
          mainPanel(
            plotOutput("goodbadramen")
          )),
        h3("Countries verse most preferred ramen style"),
        mainPanel(plotlyOutput("ramenstyle")))),
  ),

  tabPanel(
    "ABOUT",
    fluidPage(
        fluidRow(
          column(10,
                 shiny::HTML(
                   "<br></h3>Data</h3><br>"),
                   shiny::HTML("<p><h5> This data includes over 3,100 ratings on different types of ramen around the world. The dataset contains 6 variables, including <br>2 numeric variables:<br>

                    <br><br>review_number: Ramen review number<br>

                   <br>stars: Rating of the ramen, 5 is best, 0 is worst<br>

                   <br>and 4 categorical variables:<br>

                     <br>brand: Brand of the ramen<br>

                   <br>variety: The ramen variety, e.g., a flavor, style, ingredient<br>

                   <br>style: Style of container (cup, pack, tray)<br>

                   <br>country: Origin country of the ramen brand<br>

                   <br>The data is collected from the Ramen Rater.<br></h5></p>"),
                   shiny::HTML(
                     "<br></h3>Purpose</h3><br>"),
                   shiny::HTML("<p><h5>
                     The purpose of the app is to:

                       <br><br>show an overview of how ramen varieties are distributed across selected countries,<br>
                     <br>show what are the highest rated ramen brands and how different ramen styles can affect raters' preference towards particular brands, and<br>
<br>allow users to freely explore in details and understand about different ramen brands, including the reviews, country of origin, etc.<br>
<br>The first part indicates that majority of ramen distribution are located in Asian countries, namely South Korea, Japan, Indonesia and Thailand. The second part provided a feature to let users learn more about the origin of various ramen varieties and how they are rated based on reviewers around the wold. From the last part, it can be seen that the most poular ramen styles that are highly preferred are bowl and pack. The app also utilized interactive components to show the changes in ramen ratings in response to different locations and different styles (e.g. world map and interactive graphs).<br></h5></p>"
                   )

                 ))
          )))

ramen_distribution <- ramen_rating %>%
  count(country) %>%
  mutate(prop = n/sum(n)*100)

server <- function(input, output){

  table <- ramen_rating %>%
    rename(Country = country) %>%
    group_by(Country) %>%
    summarise(Average = mean(stars),
              Min = min(stars),
              Median = median(stars),
              Max = max(stars)) %>%
    mutate_if(is.numeric, round, digits = 1)

  output$mytable <- renderDataTable({
    table %>%
      datatable(
        .,
        rownames = FALSE,
        class = "table",
        options = list(paging = TRUE),
        colnames = c("Country", "Average", "Min", "Median", "Max"))
  })

  output$map <- renderLeaflet({

    ramen_distribution <- ramen_rating %>%
      count(country) %>%
      mutate(prop = n/sum(n)*100)

    world <- world %>%
      select(c(name_long, geom)) %>%
      filter(name_long %in% countries)

    cpal <- colorNumeric(palette = "Accent", domain = ramen_distribution$prop)

    leaflet(world) %>%
      addTiles() %>%
      addPolygons(
        color = ~cpal(ramen_distribution$prop),
        stroke = FALSE,
        smoothFactor = 0.3,
        fillOpacity = 0.6) %>%
      addLegend(pal = cpal,
                values = ramen_distribution$prop,
                position = "bottomright")
  })


  output$proportion <- renderText({

    names <- ramen_distribution %>%
      filter(country==input$country)

    prop <- names %>%
      pull(prop) %>%
      round(digits = 2)

    glue("{input$country} accounts for {prop}% of ramen distribution internationally.")
  })

  output$averageplot <- renderPlotly({
    average <- ramen_rating %>%
      filter(continent %in% input$average)

    average <- average %>%
      group_by(country) %>%
      ggplot(aes(x = country, y = stars, fill = country)) +
      geom_boxplot(color = "black",
                   size = 1,
                   width = 0.3) +
      scale_y_continuous(labels = scales::comma)+
      theme(
        legend.title = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
      ylab("Rating") +
      coord_flip()
  })

  output$top10 <- renderPlot({

    top <- ramen_rating %>%
      filter(country == input$guess)

    top <- top %>%
      group_by(brand) %>%
      summarise(average_rate = mean(stars)) %>%
      arrange(desc(average_rate)) %>%
      head(10)

    ggplot(top, aes(x = average_rate,
                    y = reorder(brand, average_rate))) +
      geom_bar(stat = "identity", fill = "#ea6834") +
      labs(x = "Average rate", y = "Brand") +
      ggtitle("Top 10 highest rated ramen brands") +
      theme_classic()
  })

  output$goodbadramen <- renderPlot({
    worst <- ramen_rating %>%
      filter(country == input$test)

    worst <- worst %>%
      mutate(Type = case_when(
        stars < 3 ~ "Bad",
        stars >= 3 ~ "Good")) %>%
      group_by(country, Type) %>%
      count(country, Type) %>%
      group_by(country) %>%
      mutate(total = sum(n)) %>%
      mutate(percentage = n/total * 100) %>%
      mutate_if(is.numeric, round, digits = 2) %>%
      select(country, Type, percentage)

    slices <- worst$percentage
    lbls <- worst$Type
    pct <- round(slices)
    lbls <- paste(lbls, pct)
    lbls <- paste(lbls,"%",sep="")

    pie(slices,labels = lbls, col= c("#eec6a7", "#9f1618"),
        main="Percentage of good and bad ramen")
  })

  output$ramenstyle <- renderPlotly({

    cor <- ramen_rating %>%
      group_by(country, style) %>%
      count(country, style)

    ggplotly(ggplot(cor, aes(x = style, y = country)) +
               geom_point(aes(size = n, colour = country), size = 2, shape = 21) +
               labs(x = "Styles",
                    y = "Country") +
               theme_classic() +
               theme(legend.position="bottom",
                     legend.text = element_text(size = 10)))
  })
}


shinyApp(ui = ui, server = server)

