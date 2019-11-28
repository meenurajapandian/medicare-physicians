df <- read.csv("medicare_physician.csv", stringsAsFactors = F)
str(df)
df$Middle.Initial.of.the.Provider <- NULL
df$Credentials.of.the.Provider <- as.factor(df$Credentials.of.the.Provider)
df$Gender.of.the.Provider <- as.factor(df$Gender.of.the.Provider)
df$Street.Address.1.of.the.Provider <- NULL
df$Street.Address.2.of.the.Provider <- NULL
df$State.Code.of.the.Provider <- as.factor(df$State.Code.of.the.Provider)
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
ggplot(data=dftprov) + geom_col(aes(x=reorder(Provider.Type.of.the.Provider, n), y=n))+
  coord_flip() 

ggplot(data=dftprov) + geom_col(aes(x=reorder(Provider.Type.of.the.Provider, n), y=benef))+
  coord_flip() 




# CrossChecks -----------------------------------------------------------------------------------------------------------------------


# Segmenting ------------------------------------------------------------------------------------------------------------------------
summary(df$Number.of.Medicare.Beneficiaries)
ggplot(data = dfi) + geom_histogram(aes(x = Number.of.Medicare.Beneficiaries),bins=5) + scale_x_log10()
# Percentile of the number of medicare benificiaries scale

summary(df$Total.Medicare.Standardized.Payment.Amount)
ggplot(data = dfi) + geom_histogram(aes(x = Total.Medicare.Standardized.Payment.Amount)) + scale_x_log10()


# My Stuff --------------------------------------------------------------------------------------------------------------------------





