setwd("Documents/medicare-physicians")
library(ggplot2)
library(dplyr)
library(tidyverse)


df <- read.csv("Medicare_Physician_2017.csv", stringsAsFactors = F)
str(df)
df$Middle.Initial.of.the.Provider <- NULL
df$Credentials.of.the.Provider <- as.factor(df$Credentials.of.the.Provider)
df$Gender.of.the.Provider <- as.factor(df$Gender.of.the.Provider)
df$Street.Address.1.of.the.Provider <- NULL
df$Street.Address.2.of.the.Provider <- NULL
#df$State.Code.of.the.Provider <- as.factor(df$State.Code.of.the.Provider)
df$Country.Code.of.the.Provider <- as.factor(df$Country.Code.of.the.Provider)
df$Provider.Type.of.the.Provider <- as.factor(df$Provider.Type.of.the.Provider)
df$Entity.Type.of.the.Provider <- as.factor(df$Entity.Type.of.the.Provider)

# Sanity Checks ---------------------------------------------------------------------------------------------------------------------
table(complete.cases(df))

nlevels(df$Gender.of.the.Provider)
levels(df$Gender.of.the.Provider)
summary(df$Gender.of.the.Provider)
# Gender empty for 61863 providers

levels(df$Country.Code.of.the.Provider)

nlevels(df$Provider.Type.of.the.Provider)
levels(df$Provider.Type.of.the.Provider)
levels(df$Entity.Type.of.the.Provider)
summary(df$Entity.Type.of.the.Provider)




## Subsetting only Individual Physicians -------------------------------------------------------------------------------------------
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
levels(dfi$Provider.Type.of.the.Provider)

dftprov <- dfi %>% group_by(Provider.Type.of.the.Provider) %>% summarize(n=n(), benef = sum(Number.of.Medicare.Beneficiaries))
tiff("test1.tiff", units="in", width=6, height=7, res=300)
ggplot(data=dftprov) + geom_col(aes(x=reorder(Provider.Type.of.the.Provider, n), y=n), width=0.5, fill="#FFBE00")+
  labs(x="Type of Provider", y= "Total Number Providers") + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 120000)) + # To remove that extra space
  theme(axis.text.y = element_text(color = "grey20", size = 5, angle = 0, face = "plain")) +
  coord_flip() 
dev.off()

tiff("test2.tiff", units="in", width=6, height=7, res=300)
ggplot(data=dftprov) + geom_col(aes(x=reorder(Provider.Type.of.the.Provider, n), y=benef), width=0.5, fill="#FF4500")+
  labs(x="Type of Provider", y= "Total Number Benficiaries") + 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 70000000)) + # To remove that extra space
  theme(axis.text.y = element_text(color = "grey20", size = 5, angle = 0, face = "plain")) +
  coord_flip() 
dev.off()

# A combined plot 




# CrossChecks -----------------------------------------------------------------------------------------------------------------------


# Segmenting ------------------------------------------------------------------------------------------------------------------------
summary(dfi$Number.of.Medicare.Beneficiaries)
z <- max(dfi$Number.of.Medicare.Beneficiaries)
dfi$medbenif[dfi$Number.of.Medicare.Beneficiaries <= z] <- 5
dfi$medbenif[dfi$Number.of.Medicare.Beneficiaries <= (0.8*z)] <- 4
dfi$medbenif[dfi$Number.of.Medicare.Beneficiaries <= (0.6*z)] <- 3
dfi$medbenif[dfi$Number.of.Medicare.Beneficiaries <= (0.4*z)] <- 2
dfi$medbenif[dfi$Number.of.Medicare.Beneficiaries <= (0.2*z)] <- 1
dfi$medbenif <- as.factor(dfi$medbenif)
summary(dfi$medbenif)

z <- quantile(dfi$Number.of.Medicare.Beneficiaries, c(0.2,0.4,0.6,0.8,1.0))
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[5]] <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
summary(dfi$mmedbenif)

summary(dfi$Number.of.Medicare.Beneficiaries[dfi$medbenif == 5])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$medbenif == 4])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$medbenif == 3])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$medbenif == 2])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$medbenif == 1])


summary(dfi$Total.Medicare.Standardized.Payment.Amount)
z <- max(dfi$Total.Medicare.Standardized.Payment.Amount)
dfi$medpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z] <- 5
dfi$medpay[dfi$Total.Medicare.Standardized.Payment.Amount <= (0.8*z)] <- 4
dfi$medpay[dfi$Total.Medicare.Standardized.Payment.Amount <= (0.6*z)] <- 3
dfi$medpay[dfi$Total.Medicare.Standardized.Payment.Amount <= (0.4*z)] <- 2
dfi$medpay[dfi$Total.Medicare.Standardized.Payment.Amount <= (0.2*z)] <- 1
dfi$medpay <- as.factor(dfi$medpay)
summary(dfi$medpay)

z <- quantile(dfi$Total.Medicare.Standardized.Payment.Amount, c(0.2,0.4,0.6,0.8,1.0))
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[5]] <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
summary(dfi$mmedpay)

summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$medpay == 5])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$medpay == 4])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$medpay == 3])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$medpay == 2])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$medpay == 1])



ggplot(data = dfi) + geom_histogram(aes(x = Number.of.Medicare.Beneficiaries),bins=5) + scale_x_log10()
# Percentile of the number of medicare benificiaries scale

summary(df$Total.Medicare.Standardized.Payment.Amount)
ggplot(data = dfi) + geom_histogram(aes(x = Total.Medicare.Standardized.Payment.Amount)) + scale_x_log10()


# Cross Tab ---------------------------------------------------------------------------------------------------

dfcross <- dfi %>% group_by(mmedpay, mmedbenif) %>% 
  summarise(n=n(), d2=sum(Percent.....of.Beneficiaries.Identified.With.Cancer * Number.of.Medicare.Beneficiaries,na.rm = T), 
            d1=mean(Percent.....of.Beneficiaries.Identified.With.Alzheimer.s.Disease.or.Dementia* Number.of.Medicare.Beneficiaries, na.rm = T), 
            d3=mean(Percent.....of.Beneficiaries.Identified.With.Asthma* Number.of.Medicare.Beneficiaries,na.rm = T))

dfi %>% group_by(mmedpay, mmedbenif) %>% summarise(n=n()) %>% spread( mmedpay, n)

png("test4.png", units="in", width=7, height=5, res=300)
ggplot(data = dfcross, aes(x = mmedpay, y = mmedbenif, fill = n)) + geom_tile() + 
  scale_fill_distiller(name = "Legend title", palette = "Reds", direction = 1, na.value = "transparent") +
  labs(x="Number of Beneficiaries", y= "Standardized Payments")  +
  scale_y_discrete(expand = c(0, 0),labels = c(1,2,3,4,5), limits=c(1:5)) + 
  scale_x_discrete(expand = c(0, 0),labels = c(1,2,3,4,5), limits=c(1:5)) 
dev.off()


png("test5.png", units="in", width=7, height=5, res=300)
hm <- ggplot(data = dfcross, aes(x = mmedpay, y = mmedbenif, fill = d2)) + geom_tile() + 
  scale_fill_distiller(name = "Legend title", palette = "Reds", direction = 1, na.value = "transparent") +
  labs(x="Number of Beneficiaries", y= "Standardized Payments")  +
  scale_y_discrete(expand = c(0, 0),labels = c(1,2,3,4,5), limits=c(1:5)) + 
  scale_x_discrete(expand = c(0, 0),labels = c(1,2,3,4,5), limits=c(1:5)) +
  theme(legend.position = "left")
dev.off()

dfi$ones <- 1
dftemp <- dfi[,c("National.Provider.Identifier","Provider.Type.of.the.Provider","mmedbenif","mmedpay","ones","Gender.of.the.Provider")]
dftemp1 <- dftemp %>% spread(Provider.Type.of.the.Provider, ones, fill=0) 
dftemp1$Gender.of.the.Provider <- as.character(dftemp1$Gender.of.the.Provider)
dftemp1$ones <- 1
dftemp1 <- dftemp1 %>% spread(Gender.of.the.Provider,ones, fill=0)
dftemp1 <- dftemp1 %>% group_by(mmedpay,mmedbenif) %>% summarise_all(funs(sum(as.numeric(.), na.rm = TRUE)))

write.csv(dftemp1,"dfsegment.csv")

# Across years ------------------------------------------------------------------------------------------------
df <- read.csv("Medicare_Physician_2017.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
z <- quantile(dfi$Number.of.Medicare.Beneficiaries, c(0.2,0.4,0.6,0.8,1.0))
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
z <- quantile(dfi$Total.Medicare.Standardized.Payment.Amount, c(0.2,0.4,0.6,0.8,1.0))
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross7 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2017'=n())
rm(df)
rm(dfi)

df <- read.csv("Medicare_Physician_2016.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross6 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2016'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2015.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross5 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2015'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2014.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross4 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2014'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2013.csv", stringsAsFactors = F)
dfi <- df[df$NPPES.Entity.Code == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross3 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2013'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2012.csv", stringsAsFactors = F)
dfi <- df[df$NPPES.Entity.Code == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
rm(df)
rm(dfi)

dfcross <- dfcross7 %>% full_join(dfcross6) %>% full_join(dfcross5) %>% full_join(dfcross4) %>% full_join(dfcross3) %>% full_join(dfcross2)
dfcross[is.na(dfcross)] <- 0


library(streamgraph)
dfcross$mmedbenif <- NULL
dfstream <- dfcross %>% group_by(mmedpay) %>% summarise_all(funs(sum))
dfstream <- dfstream %>% gather("year","n",2:7)
streamgraph(dfstream, key="mmedpay", value="n", date="year", offset="zero") %>%
  sg_axis_x(1, "year", "%Y") %>%
  sg_fill_brewer("Blues")


# Across years ------------------------------------------------------------------------------------------------
df <- read.csv("Medicare_Physician_2017.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
m <- max(dfi$Number.of.Medicare.Beneficiaries)
z <- c(0.2*m,0.4*m,0.6*m,0.8*m)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
m <- max(dfi$Total.Medicare.Standardized.Payment.Amount)
z <- c(0.2*m,0.4*m,0.6*m,0.8*m)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross7 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2017'=n())
rm(df)
rm(dfi)

df <- read.csv("Medicare_Physician_2016.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross6 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2016'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2015.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross5 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2015'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2014.csv", stringsAsFactors = F)
dfi <- df[df$Entity.Type.of.the.Provider == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Standardized.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross4 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2014'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2013.csv", stringsAsFactors = F)
dfi <- df[df$NPPES.Entity.Code == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
dfi$mmedpay <- 5
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[4]] <- 4
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[3]] <- 3
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[2]] <- 2
dfi$mmedpay[dfi$Total.Medicare.Payment.Amount <= z[1]] <- 1
dfi$mmedpay <- as.factor(dfi$mmedpay)
dfcross3 <- dfi %>% group_by(mmedpay, mmedbenif) %>% summarise('2013'=n())
rm(df)
rm(dfi)


df <- read.csv("Medicare_Physician_2012.csv", stringsAsFactors = F)
dfi <- df[df$NPPES.Entity.Code == "I",]
dfi <- droplevels(dfi)
dfi$mmedbenif <- 5
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[4]] <- 4
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[3]] <- 3
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[2]] <- 2
dfi$mmedbenif[dfi$Number.of.Medicare.Beneficiaries <= z[1]] <- 1
dfi$mmedbenif <- as.factor(dfi$mmedbenif)
rm(df)
rm(dfi)

dfcross <- dfcross7 %>% full_join(dfcross6) %>% full_join(dfcross5) %>% full_join(dfcross4) %>% full_join(dfcross3) %>% full_join(dfcross2)
dfcross[is.na(dfcross)] <- 0

library(streamgraph)
dfcross$mmedpay <- NULL
dfstream <- dfcross %>% group_by(mmedbenif) %>% summarise_all(funs(sum))
dfstream <- dfstream %>% gather("year","n",2:7)
streamgraph(dfstream, key="mmedbenif", value="n", date="year", offset="zero") %>%
  sg_fill_brewer("Blues")

library(streamgraph)
dfcross$mmedbenif <- NULL
dfstream <- dfcross %>% group_by(mmedpay) %>% summarise_all(funs(sum))
dfstream <- dfstream %>% gather("year","n",2:7)
streamgraph(dfstream, key="mmedpay", value="n", date="year", offset="zero") %>%
  sg_axis_x(1, "year", "%Y") %>%
  sg_fill_brewer("Blues")



# My Stuff --------------------------------------------------------------------------------------------------------------------------
simpleCap <- function(x) {
     s <- strsplit(x, " ")[[1]]
     paste(toupper(substring(s, 1,1)), substring(s, 2),
           sep="", collapse=" ")
}

dfiu <- dfi[dfi$Country.Code.of.the.Provider=="US",]
#dfiu <- dfiu[-which(dfiu$Provider.Type.of.the.Provider == c("All Other Suppliers", "Unknown Supplier/Provider Specialty")),]
dfiu <- droplevels(dfiu)
dfius <- dfiu %>% group_by(State.Code.of.the.Provider) %>% summarize(n=n())

us_states <- map_data("state")
us_states$regionC <- sapply(us_states$region, simpleCap)
us_states$regionA <- state.abb[match(us_states$regionC,state.name)]

us_states$regionA[is.na(us_states$regionA)] <- "DC"
us_dfius <- left_join(us_states, dfius, by=c("regionA" = "State.Code.of.the.Provider"))

png("test3.png", units="in", width=7, height=5, res=300)
ggplot(data = us_dfius) + 
  geom_polygon( aes(x = long, y = lat, group = group, fill = n), color="white") + 
  scale_fill_distiller(palette = "Blues", direction = 0) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme_void()
dev.off()


# Data for Bokeh ----------------------------------------------------------------------------------------------
dfpandas <- dfi %>% group_by(State.Code.of.the.Provider) %>% 
  summarise(providers=n(), benificiaries = sum(Number.of.Medicare.Beneficiaries), 
            male_benif=sum(Number.of.Male.Beneficiaries, na.rm = T), 
            female_benif=sum(Number.of.Female.Beneficiaries, na.rm = T),
            payment=sum(Total.Medicare.Standardized.Payment.Amount),
            male_prov = sum(Gender.of.the.Provider == "M"),
            female_pro = sum(Gender.of.the.Provider == "F"))

dfpandas <- dfpandas %>% spread(Gender.of.the.Provider)

write.csv(dfpandas, file="dfpandas.csv")
