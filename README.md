# 311 Resolution Analysis

## Objective

Utilize 311 data, publicly available via New York City's Open Data Portal, to analyze the efficiency in agency's responses to service requests

## Notes

### Getting the Data

Data for this project was obtained via 311's Service Requests dataset available on New York City's [Open Data Portal](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9).

The data used for this particular analysis focuses on service requests created in 2018. This data can be obtained by filtering data within the website, or utilizing the following api call:

- [https://data.cityofnewyork.us/resource/fhrw-4uyv.csv?$where=created_date%3E=%272018-01-01%27%20%20and%20created_date%20%3C%20%272019-01-01%27%20%20&$order=created_date%20desc&$limit=10&$$app_token=8BBoyvf7GdAZBxMirmk7UygRW](https://data.cityofnewyork.us/resource/fhrw-4uyv.geojson?$where=created_date%3E=%272018-01-01%27%20%20and%20created_date%20%3C%20%272019-01-01%27%20%20&$order=created_date%20desc&$limit=10&$$app_token=8BBoyvf7GdAZBxMirmk7UygRW)


### Visualizations

Visualizations were conducted in both R and Python. Both code files are present in this repo.

### Resolution Categorization

In order to best gauge the efficiency of service across hundreds of resolution possibilities, this code attempts to classify resolutions into a series of smaller categories. This is done by matching strings to categories.

The categories are:

- No action taken
- Ongoing
- Did not observe
- Violations issued
- Fixed
- Ambiguous
- Wrong agency
- Duplicate

For example, any resolution that includes the phrase "violations were issued" is recorded as a violation. Any resolution that simply states "see notes" is recorded as ambiguous. This accounts for more than 98% of all service requests from 2018.


- Did Not Observe
'did not observe', 'not able to gain access','could not find the problem', 'were gone','found no condition', 'no indication', 'no evidence', 'not find', 'unable to gain entry','no graffiti was found', 'could not locate', 'unable to find','attempted to investigate this complaint'

- No Action Taken:
'determined that no further action was necessary','condition meets its standards','no sewer back up', 'at this time', 'no action', 'not necessary','had been restored','found it to be a temporary','inspected the location more than six months ago','conflicts with surrounding infrastructure','did not have enough information','an inside condition','closed or canceled this complaint','insufficient information','does not meet the criteria','no further action is required','did not have sufficient information','no work order was necessary','did not meet the criteria','unable to schedule a sidewalk', 'no violation','not have sufficient', 'ineligible', 'was cancelled', 'in compliance with standards', 'was in compliance','not enough information'

- Ongoing:
'will review your complaint',' will contact you', 'asked the department of', 'further investigation is required','timeframe for repair work depends','has been scheduled', 'will inspect', 'will contact you','a report was prepared','complaint conditions are still open','will perform work to correct the condition','has sent official written','please check back later for status','and will visit the location','will investigate the issue','usually requires 7 days to inspect','usually requires 30 days to inspect','referred this complaint','a location of concern','your report has been sent','has received and processed your complaint','the literature will be emailed', 'will review this service request','in the process of investigating','scheduled an inspection','garage or bureau for further action','will investigate the issue','approved the sidewalk re-inspection request','usually requires 10 days to review a request','will clean the graffiti','has been forwarded','please note your service request number for future reference','requires contact with the complainant','will be notified','will investigate','will fulfill','will receive','an inspection is warranted','to respond to this type of complaint','to evaluate this type of request','opened a repair order','will be planned','long term and vary','will  investigate', 'temporarily', 'partially rectified', 'will review','will notify','has been filed', 'further investigation','will note','under investigation','mailed you a complaint form'

- Violations:
'violations were issued', 'board violation', 'notice of violation','stop work order violation(s) issued', 'violation was issued'

- Fixed:
'repaired the problem','department of sanitation removed the items','corrected the','correct the', 'repaired', 'cleaned', 'addressed the issue','provided the assistance','removed the graffiti','will be addressed', 'offered services', 'conditions were corrected','shut the running hydrant', 'were corrected', 'you will receive', 'collected', 'resolved', 'researched this complaint', 'took action','issued a','the problem was fixed', 'work was performed','removed the stop work order','the literature has been mailed', 'complaint was not warranted','performed repair work','made a repair','outreach assistance was offered', 'opened fire hydrants','picked up the items','if the condition returns','salted the area','updated its records', 'to a hospital','has been completed', 'was addressed','owner refused', 'debris was obstructing', 'was mailed','have mailed', 'was placed','created a service request','created a service request','mailed the requested item', 'investigated this complaint and','sent a report'

- Ambiguous:
'see notes', 'find additional information', 'learn more','more information', 'researched your claim','asked the department', 'has notified the property owner','additional information below', 'violations were previously issued', 'currently not available','unknown'
- Wrong Agency:
'jurisdiction', 'referred it','referred it to'
- Duplicate:
'duplicate','previously reported by another','an open service request already exists'
