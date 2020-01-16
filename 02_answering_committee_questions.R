library(tidyverse)
library(tidyselect)
library(RSocrata)
library(ggplot2)

## BACKGROUND - 311 switched to a new system starting in September 2019.
# I've been asked to compare data for particular complaint types between
# the months leading up to this change and the months after this change - 
# specifically, May-August vs September-December.

#read in timeframe

raw_311 <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$limit=99999999999&$where=created_date%20between%20%272019-05-01T00:00:00.000%27%20and%20%272020-01-01T00:00:00.000%27%20")


year_311 <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.json?$limit=9999999999&$select=created_date,agency,open_data_channel_type&$where=created_date%20between%20%272017-01-01T00:00:00.000%27%20and%20%272020-01-10T00:00:00.000%27%20")

# how many complaints were submitted for missing garbage/ recycling pick and illegal dumping?
#   From May 2019 to August 2019 (including May and August) and
# From September 2019 to December 2019 (including September and December)  

# "Missed Collection","Missed Collection (All Materials)"

ggplot(data = raw_311[raw_311$agency == "DSNY",], aes(x = created_date)) +
  geom_histogram()

ggplot(data = year_311[year_311$agency == "DSNY",], aes(x = created_date, fill = open_data_channel_type)) +
  geom_histogram(binwidth = 1*3600*24*7) +
  labs(title = "DSNY Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))

ggplot(data = year_311, aes(x = created_date, fill = open_data_channel_type)) +
  geom_histogram(binwidth = 1*3600*24*7) +
  labs(title = "311 Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))



# same periods from May 2019 to August 2019 (including May and August) and 
# from September 2019 to December 2019 (including September and December) to 


ggplot(data = year_311[year_311$open_data_channel_type == "MOBILE",], aes(x = created_date, fill = open_data_channel_type)) +
  geom_histogram(binwidth = 1*3600*24*7, fill = "#F8766D") +
  labs(title = "311 Mobile Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))

ggplot(data = year_311[year_311$open_data_channel_type == "ONLINE",], aes(x = created_date)) +
  geom_histogram(binwidth = 1*3600*24*7, fill = "#7CAE00") +
  labs(title = "311 Online Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))

ggplot(data = year_311[year_311$open_data_channel_type == "PHONE",], aes(x = created_date, fill = open_data_channel_type)) +
  geom_histogram(binwidth = 1*3600*24*7, fill = "#619CFF") +
  labs(title = "311 Phone Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))
  labs(title = "DSNY Service Requests, 2017-Present", xlab("Date"), ylab("Count of Requests"))# see how many complaints were submitted by phone vs. text vs. mobile app