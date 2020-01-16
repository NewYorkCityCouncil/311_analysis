library(tidyverse)
library(ggplot2)
library(reshape2)

# Compare Agencies with Most Service Requests --------------------------------

top_agencies_2019 <- read_csv("2019_top_agencies.csv") %>% 
  select(-X1) %>% 
  rename(y19 = number_complaints)
top_agencies_2018 <- read_csv("2018_top_agencies.csv") %>% 
  select(-X1) %>% 
  rename(y18 = number_complaints)


top_agencies <- left_join(top_agencies_2018, top_agencies_2019)

# place values in same column for easier ggplot analysis
agencies_ggplot <- as_tibble(melt(top_agencies[, c('agency', 'y18', 'y19')], id.vars = 1, value.name = "service_requests")) %>% 
  mutate(variable = replace(as.character(variable), variable == "y18", "2018")) %>% 
  mutate(variable = replace(as.character(variable), variable == "y19", "2019"))


sum(top_agencies$y18)
sum(top_agencies$y19)

ggplot(agencies_ggplot, aes(x = agency,y = service_requests)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") + 
  scale_y_continuous(labels = scales::comma) + 
  labs(title = "Service Requests 2018-19", x = "Agency", y = "Number of Requests", fill = "Year\n") +
  theme(axis.text.x = element_text(size = 12, angle = 22.5, margin = margin(t = 8)), axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 20, face = "bold"))


## SUMMARY - There are more service requests overall in 2018 than 2019, with 
# DSNY and HPD showing the most significant drop in created service requests.
# NYPD is the only agency to have seen increased requests.


# Response Time Analysis --------------------------------------------------

## by Minute Response Times

## REQUIREMENTS: Complaint Type must have more than 1,000 service requests in the past year.

minutes_response_2018 <- read_csv("2018_shortest_response_time.csv") %>% 
  select(-X1) %>% 
  mutate(mean_minutes = round(mean_minutes, 2))

minutes_response_2019 <- read_csv("2019_shortest_response_time.csv") %>% 
  select(-X1) %>% 
  mutate(mean_minutes = round(mean_minutes, 2))


## by Day Response Times

days_response_2018 <- read_csv("2018_longest_response_time.csv") %>% 
  select(-X1) %>% 
  mutate(mean_days = round(mean_days, 2),
         year = '2018')

days_response_2019 <- read_csv("2019_longest_response_time.csv") %>% 
  select(-X1) %>% 
  mutate(mean_days = round(mean_days, 2),
         year = '2019') 


days_response <- rbind(days_response_2018, days_response_2019)

ggplot(days_response[days_response$mean_days > 10,], aes(x = complaint_type,y = mean_days)) + 
  geom_bar(aes(fill = year),stat = "identity",position = "dodge")


# mutate datasets to prepare for join instead of bind

days_response_2018_join <- days_response_2018 %>% 
  rename(mean_days_18 = mean_days,
         count_18 = count)

days_response_2019_join <- days_response_2019 %>% 
  rename(mean_days_19 = mean_days,
         count_19 = count) %>% 
  arrange(desc(mean_days_19))


# Prep top 10 for barplot

days_response_2019_join[days_response_2019_join$complaint_type == "Unsanitary Animal Pvt Property",]$complaint_type <- "Unsanitary Animal\nPvt Property"
days_response_2019_join[days_response_2019_join$complaint_type == "Construction Safety Enforcement",]$complaint_type <- "Construction Safety\nEnforcement"
days_response_2019_join[days_response_2019_join$complaint_type == "For Hire Vehicle Complaint",]$complaint_type <- "For Hire\nVehicle Complaint"



# Quick plot of longest 10 complaints for 2019, for paper ---------------------

ggplot(days_response_2019_join[1:10,], aes(x = reorder(complaint_type, mean_days_19), y = mean_days_19)) +
  geom_bar(stat = "identity", position = "dodge", fill = "#F8766D")  + 
  theme(axis.text.x = element_text(size = 12, angle = 30, margin = margin(t = 30, b = -35)), 
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 20, face = "bold")) +
  labs(title = "Longest Service Request Times, 2019", x = "Request Type", y = "Average Time (Days)")

# Join and calculate difference between average response times for 2019 & 2018 
# to see whick complaints are answered faster, which slower

days_response_join <- left_join(days_response_2018_join[,c("agency", "complaint_type", "mean_days_18", "count_18")], 
                                days_response_2019_join[,c("agency", "complaint_type", "mean_days_19", "count_19")]) %>% 
  filter(!is.na(mean_days_19)) %>% 
  mutate(difference = mean_days_19 - mean_days_18)

days_response_join[days_response_join$complaint_type == "Unsanitary Animal Pvt Property",]$complaint_type <- "Unsanitary Animal\nPvt Property"
days_response_join[days_response_join$complaint_type == "Construction Safety Enforcement",]$complaint_type <- "Construction\nSafety\nEnf"
days_response_join[days_response_join$complaint_type == "For Hire Vehicle Complaint",]$complaint_type <- "For Hire\nVehicle Complaint"
days_response_join[days_response_join$complaint_type == "Request Large Bulky Item Collection",]$complaint_type <- "Bulky Item\nCollection"
days_response_join[days_response_join$complaint_type == "Noise",]$complaint_type <- "Noise - Env"
days_response_join[days_response_join$complaint_type == "Noise - Residential",]$complaint_type <- "Noise -\nResidential"
days_response_join[days_response_join$complaint_type == "Noise - Street/Sidewalk",]$complaint_type <- "Noise -\nStreet/Sidewalk"
days_response_join[days_response_join$complaint_type == "HEAT/HOT WATER",]$complaint_type <- "Heat/Hot\nWater"
days_response_join[days_response_join$complaint_type == "Root/Sewer/Sidewalk Condition",]$complaint_type <- "Root/Sewer/\nSidewalk Condition"
days_response_join[days_response_join$complaint_type == "Special Projects Inspection Team (SPIT)",]$complaint_type <- "Special Projects\nInspection Team (SPIT)"
days_response_join[days_response_join$complaint_type == "Overgrown Tree/Branches",]$complaint_type <- "Overgrown\nTree/Branches"
days_response_join[days_response_join$complaint_type == "DOF Parking - Payment Issue",]$complaint_type <- "DOF Parking -\nPayment Issue"




# Difference in Response Times --------------------------------------------



ggplot(days_response_join[days_response_join$difference > 20 | days_response_join$difference < -20,], 
       aes(x = reorder(complaint_type, difference),y = difference)) + 
  geom_bar(aes(fill = difference < 0), stat = "identity",position = "dodge") + 
  theme(axis.text.x = element_text(angle = 45)) +
  scale_fill_manual(guide = FALSE, breaks = c(TRUE, FALSE), values=c("#F8766D", "#00BFC4")) +
  theme(axis.text.x = element_text(size = 10, angle = 45, margin = margin(t = 30, b = -35)), 
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 20, face = "bold")) +
  labs(title = "Service Requests Time Difference, 2018-19", x = "Request Type", y = "Average Difference (Days)")




# Agency Response Analysis ------------------------------------------------


agency_rates_2018 <- read_csv("2018_agencies_rates.csv") %>% 
  select(-X1)

agency_rates_2019 <- read_csv("2019_agencies_rates.csv") %>% 
  select(-X1)


ggplot(agency_rates_2018, aes(x = agency, y = count, fill = res_desc)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())
         


# All Agency 2018 and 2019 Resolution Description Analysis -------------------------

ggplot(agency_rates_2018, aes(x = agency, y = count, fill = res_desc)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.text.x = element_text(size = 12, angle = 30, margin = margin(t = 12, b = -10)), 
        axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 13)) +
  labs(title = "Agency Response Quality, 2018", x = "Agency", y = "Percent") +
  scale_fill_discrete(name = "Resolution Description", 
                      labels = c("Ambiguous", "Did Not Observe", "Duplicate Request",
                                 "Fixed", "No Action Taken", "Ongoing", "Other", "Unknown",
                                 "Violations Issued", "Wrong Agency"))

ggplot(agency_rates_2019, aes(x = agency, y = count, fill = res_desc)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.text.x = element_text(size = 12, angle = 30, margin = margin(t = 12, b = -10)), 
      axis.title.x = element_text(size = 16),
      axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
      plot.title = element_text(size = 20, face = "bold"),
      legend.text = element_text(size = 10),
      legend.title = element_text(size = 13)) +
  labs(title = "Agency Response Quality, 2019", x = "Agency", y = "Percent") +
  scale_fill_discrete(name = "Resolution Description", 
                      labels = c("Ambiguous", "Did Not Observe", "Duplicate Request",
                                 "Fixed", "No Action Taken", "Ongoing", "Other", "Unknown",
                                 "Violations Issued", "Wrong Agency"))

## Melt to compare side-by-side

#adding prefix for melt
colnames(agency_rates_2018)[3:5] <- paste(colnames(agency_rates_2018[,c(3:5)]), "_18", sep = "")
colnames(agency_rates_2019)[3:5] <- paste(colnames(agency_rates_2019[,c(3:5)]), "_19", sep = "")

agency_rates <- left_join(agency_rates_2018[,1:3], agency_rates_2019[,1:3]) %>% 
  mutate(agency_res_desc = paste(agency, res_desc))
agencies_rates_compare <- melt(agency_rates[, c("agency_res_desc",'count_18', 'count_19')], id.vars = 1, value.name = "resolution_counts") %>% 
  separate(agency_res_desc, into = c("agency", "resolution"), sep = " ") %>% 
  rename(year = variable)

nypd <- agencies_rates_compare %>% 
  filter(agency == 'NYPD')

ggplot(nypd, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dep <- agencies_rates_compare %>% 
  filter(agency == 'DEP')

ggplot(dep, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dob <- agencies_rates_compare %>% 
  filter(agency == 'DOB')

ggplot(dob, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dof <- agencies_rates_compare %>% 
  filter(agency == 'DOF')

ggplot(dof, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dohmh <- agencies_rates_compare %>% 
  filter(agency == 'DOHMH')

ggplot(dohmh, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dot <- agencies_rates_compare %>% 
  filter(agency == 'DOT')

ggplot(dot, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dpr <- agencies_rates_compare %>% 
  filter(agency == 'DPR')

ggplot(dpr, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


dsny <- agencies_rates_compare %>% 
  filter(agency == 'DSNY')

ggplot(dsny, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


hpd <- agencies_rates_compare %>% 
  filter(agency == 'HPD')

ggplot(hpd, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())


tlc <- agencies_rates_compare %>% 
  filter(agency == 'TLC')

ggplot(tlc, aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = scales::percent_format())





  

categorization_2018 <- read_csv("2018_categorization_counts.csv") %>% 
  select(-X1)

signs_18 <- read_csv("2018_signs_times.csv")


agg_complaint_times_18 <- read_csv('2018_agg_complaint_times_data.csv')

complaints_18 <- read_csv("top_complaints.csv")


complaints_19 <- read_csv("top_complaints_19.csv") %>% 
  select(-X1)


ggplot(complaints_19[1:10,], aes(x = year, y = resolution_counts, fill = resolution)) + 
  geom_bar(position = "fill",stat = "identity")


complaints_19[complaints_19$Complaint == "Request Large Bulky Item Collection",]$Complaint <- "Bulky Item\nCollection"
complaints_19[complaints_19$Complaint == "Noise",]$Complaint <- "Noise - Env"
complaints_19[complaints_19$Complaint == "Noise - Residential",]$Complaint <- "Noise -\nResidential"
complaints_19[complaints_19$Complaint == "Noise - Street/Sidewalk",]$Complaint <- "Noise -\nStreet/Sidewalk"
complaints_19[complaints_19$Complaint == "HEAT/HOT WATER",]$Complaint <- "Heat/Hot\nWater"






# Top Service Requests Visual ---------------------------------------------


ggplot(complaints_19[1:10,], aes(x = reorder(Complaint, Count),y = Count)) +   #F8766D", "#00BFC4"
  geom_bar(stat = "identity",position = "dodge", fill = "#00BFC4") + 
  labs(title = "Top Service Requests, 2019", x = "Request Type", y = "Number of Requests") +
  theme(axis.text.x = element_text(size = 12, angle = 30, margin = margin(t = 30, b = -25)), axis.title.x = element_text(size = 16),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 16),
        plot.title = element_text(size = 20, face = "bold"),
        legend.position = 'none')
#F8766D", "#00BFC4"