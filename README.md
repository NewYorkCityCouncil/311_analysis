# 311 Resolution Analysis

## Objective

Utilize 311 data, publicly available via New York City's Open Data Portal, to analyze the efficiency in agency's responses to service requests

## Notes

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

For example, any resolution that includes the phrase "violations were issued" is recorded as a violation. Any resolution that simply states "see notes" is recorded as ambiguous.


## Visualizations

Visualizations were conducted in both R and Python. Both code files are present in this repo.
