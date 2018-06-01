#Group Assignment 2 - TA
#Group Members - Rupal Damani
#                Bharat Batra

library(shiny)

shinyUI(
  fluidPage(theme = shinytheme("united"),
    
    tags$head(
      tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
    "))
    ),
  
    titlePanel(h1("UDPIPE Group Assignment 2 - Text Analysis", 
                   style = "font-family: 'Lobster', cursive;
                   font-weight: 400; line-height: 1.1; 
                   color: #d86636;")),
    sidebarLayout(
      sidebarPanel(
        fileInput("file1","Please upload text file"),
        
        checkboxGroupInput("upos",
                           label = h3("select UPS for co-occurrences filtering"),
                           choices = list("Adjective" = 'ADJ',
                                          "Noun" = "NOUN",
                                          "Proper Noun" = "PROPN",
                                          "Adverb" = 'ADV',
                                          "Verb" = 'VERB'),
                           selected = c("ADJ","NOUN","PROPN"))
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    
                    tabPanel("overview",
                             h4(p("Data Input")),
                             p("This app currently supports only text files.",align = "justify"),
                             h4('Please find below How to use this app'),
                             p('To use this app, click on ->',
                               span(strong("upload text file")),
                               '-> and upload the textfile')),
                    tabPanel("Annotation",
                             dataTableOutput('dout1'),
                             h4('Please click below button to download the annotated data'),
                             downloadButton("downloadData","Download Annotated Data")),
                    tabPanel("plots",
                             h3("Nouns"),
                             plotOutput('plot1'),
                             h3("verbs"),
                             plotOutput('plot2')),
                    tabPanel("co-occurences",
                             plotOutput('plot3'))
                    
        )
      )
    )
  )
)
