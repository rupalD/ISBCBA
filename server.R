#Group Assignment 2 - TA
#Group Members - Rupal Damani
#                Bharat Batra

library(shiny)
shinyServer(function(input,output){
  Dataset <- reactive({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      text <- readLines(input$file1$datapath)
      text = str_replace_all(text,"<.*?>","")
      text = text[text != ""]
      
      return(text)
    }
  })
  english_model = reactive({
    english_model = udpipe_load_model("G:\\ISB\\TA Group Assignment 2\\Text_Analysis_App\\english-ud-2.0-170801.udpipe")
    return(english_model)
  })
  annot.obj = reactive({
    x <- udpipe_annotate(english_model(),x = Dataset())
    x <- as.data.frame(x)
    return(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      "annotated_data.csv"
    },
    content = function(file) {
      write.csv(annot.obj()[,-4],file,row.names = FALSE)
    }
  )
  
  output$dout1 = renderDataTable({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      out = annot.obj()[,-4]
      return(out)
    }
  })
  
  output$plot1 = renderPlot({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      all_nouns = annot.obj() %>% subset(., upos %in% "NOUN")
      top_nouns = txt_freq(all_nouns$lemma)
      
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3, colors = 1:10)
    }
  })
  
  output$plot2 = renderPlot({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      all_verbs = annot.obj() %>% subset(., upos %in% "VERB")
      top_verbs = txt_freq(all_verbs$lemma)
      
      wordcloud(top_verbs$key,top_verbs$freq,min.freq = 3, colors = 1:10)
    }
  })
  
  output$plot3 = renderPlot({
    if(is.null(input$file1)){
      return(NULL)
    }
    else{
      india_cooc <- cooccurrence(
        x = subset(annot.obj(),upos %in% input$upos),
        term = "lemma",
        group = c("doc_id","paragraph_id","sentence_id"))
      
      wordnetwork <- head(india_cooc,50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      
      ggraph(wordnetwork, layout = "fr") +
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        
        labs(title = "Cooccurence plot", subtitle = "Nouns & Adjective")
      
    }
  })
})