setwd("Documents/medicare-phycisians")
library(ggplot2)
library(dplyr)

df <- read.csv("medicare_physician.csv", stringsAsFactors = F)
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

summary(dfi$Number.of.Medicare.Beneficiaries[dfi$mmedbenif == 5])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$mmedbenif == 4])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$mmedbenif == 3])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$mmedbenif == 2])
summary(dfi$Number.of.Medicare.Beneficiaries[dfi$mmedbenif == 1])


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

summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$mmedpay == 5])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$mmedpay == 4])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$mmedpay == 3])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$mmedpay == 2])
summary(dfi$Total.Medicare.Standardized.Payment.Amount[dfi$mmedpay == 1])



ggplot(data = dfi) + geom_histogram(aes(x = Number.of.Medicare.Beneficiaries),bins=5) + scale_x_log10()
# Percentile of the number of medicare benificiaries scale

summary(df$Total.Medicare.Standardized.Payment.Amount)
ggplot(data = dfi) + geom_histogram(aes(x = Total.Medicare.Standardized.Payment.Amount)) + scale_x_log10()


# Cross Tab ---------------------------------------------------------------------------------------------------

dfcross <- dfi %>% group_by(mmedpay, mmedbenif) %>% 
  summarise(n=n(), pay = sum(Total.Medicare.Standardized.Payment.Amount), benef= sum(Number.of.Medicare.Beneficiaries))

ggplot(data = dfcross, aes(x = mmedpay, y = mmedbenif, fill = n)) + geom_tile() + 
  scale_fill_distiller(name = "Legend title", palette = "Reds", direction = 1, na.value = "transparent") +
  theme(legend.position = "bottom", legend.direction = "horizontal",
        legend.title = element_text(size = 15), legend.key.size = unit(1,"cm"),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5))

ggplot(data = dfcross, aes(x = mmedpay, y = mmedbenif, fill = benef)) + geom_tile() + 
  scale_fill_distiller(name = "Legend title", palette = "Reds", direction = 1, na.value = "transparent") +
  theme(legend.position = "bottom", legend.direction = "horizontal",
        legend.title = element_text(size = 15), legend.key.size = unit(1,"cm"),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5))

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

p <- ggplot(data = us_dfius,
            aes(x = long, y = lat,
                group = group, fill = n))

p + geom_polygon(color = "gray90", size = 0.1) 




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
