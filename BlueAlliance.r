library(httr)
library(jsonlite)
library(png)
library(tidyverse)
url = "https://frc-api.firstinspires.org/v3.0/2022"
FRC_Username = "groliver95"
Auth_Token = "c5379378-eee4-4384-acf7-d3c95f7a70f7"

output<-GET(url,authenticate(FRC_Username, Auth_Token))

a <- content(output, as="text")
fromJSON(a)


#events (replace season year as needed)
#?eventCode=&teamNumber=&districtCode=&excludeDistrict=&weekNumber&tournamentType
url = "https://frc-api.firstinspires.org/v3.0/2022/events"

output<-GET(url,authenticate(FRC_Username, Auth_Token))

a <- content(output, as="text")
a<-fromJSON(a)

a %>% filter(str_detect(code,pattern="0"))
a$Events %>% filter(stateprov   =='TX') %>% select(code )


url = "https://frc-api.firstinspires.org/v3.0/2019/teams?page="
output<-GET(url,authenticate(FRC_Username, Auth_Token))

a <- content(output, as="text")
a<-fromJSON(a)


#need to iterate through pages to get full list or filter by desired subset
a$pageCurrent
a$pageTotal


## team image
url = "https://frc-api.firstinspires.org/v3.0/2019/avatars?teamNumber=6672"
output<-GET(url,authenticate(FRC_Username, Auth_Token))
library(png)
a <- content(output, as="raw")


############### scores required year, event level
# 1. "None"
# 2. "Practice"
# 3. "Qualification"
# 4. "Playoff"
##match data as csv in alliances field
url = "https://frc-api.firstinspires.org/v3.0/2022/scores/WEEK0/qual"
output<-GET(url,authenticate(FRC_Username, Auth_Token))
a <- content(output, as="text")
a<-fromJSON(a)
a$MatchScores$alliances
a$MatchScores$alliances[[1]][1]

url = "https://frc-api.firstinspires.org/v3.0/2019/matches/TXPLA/Playoff"
output<-GET(url,authenticate(FRC_Username, Auth_Token))
a <- content(output, as="text")
a<-fromJSON(a)
a$Matches
col_rapidrelay<-c(  "alliance"               ,"taxiRobot1"             ,"endgameRobot1"          ,"taxiRobot2"             ,"endgameRobot2"          
    ,"taxiRobot3"             ,"endgameRobot3"          ,"autoCargoLowerNear"     ,"autoCargoLowerFar"      ,"autoCargoLowerBlue"     
    ,"autoCargoLowerRed"      ,"autoCargoUpperNear"     ,"autoCargoUpperFar"      ,"autoCargoUpperBlue"     ,"autoCargoUpperRed"      
    ,"autoCargoTotal"         ,"teleopCargoLowerNear"   ,"teleopCargoLowerFar"    ,"teleopCargoLowerBlue"   ,"teleopCargoLowerRed"    
    ,"teleopCargoUpperNear"   ,"teleopCargoUpperFar"    ,"teleopCargoUpperBlue"   ,"teleopCargoUpperRed"    ,"teleopCargoTotal"       
    ,"matchCargoTotal"        ,"autoTaxiPoints"         ,"autoPoints"             ,"autoCargoPoints"        ,"quintetAchieved"        
    ,"teleopPoints"           ,"teleopCargoPoints"      ,"endgamePoints"          ,"cargoBonusRankingPoint" ,"hangarBonusRankingPoint"
    ,"foulCount"              ,"techFoulCount"          ,"adjustPoints"           ,"foulPoints"             ,"rp"                     
    ,"totalPoints"      )


a<-GET("https://www.thebluealliance.com/event/2022week0")

a %>% html_table  
tmp <- matrix(nrow = 1,ncol = 41)
tmp = as.data.frame(tmp)

colnames(tmp)<-col_rapidrelay

for(i in 1:length(a$MatchScores$alliances){
    print(i);
    tmp = rbind(tmp,a$MatchScores$alliances[[i]])
    }
     
