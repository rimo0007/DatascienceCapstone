library(shiny)
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel (
      
      div(h2(code(strong("Data Science Capstone")), style = "color:#DF3D82",align = "center"))),
    sidebarPanel (
      img(src="3.png", height = 200, width = 400),
      textInput('Text', div('Enter the Text Here:', style = "color:#4A96AD"),value =)  
    ),
    mainPanel (
      img(src="1.png", height = 250, width = 500),
      img(src="2.png", height = 40, width = 800),
      hr(),
      p(
        h3 (div((h3(code(strong('1st :')), style = "color:#DF3D82") )) , 
        h3(textOutput("NextWord"), style = "color:green")),
        h3 (div((h3(code(strong('2nd :')), style = "color:#DF3D82"))),
            h3(textOutput("NextWord2"), style = "color:green")),
        h3 (div((h3(code(strong('3rd :')), style = "color:#DF3D82")))),
        h3(textOutput("NextWord3"), style = "color:green"))
    )
    
  )
)