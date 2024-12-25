# TTC Bus Delays Analysis (2021)

## Project Scope
I chose the TTC Bus Delay dataset from [open.toronto.ca](https://open.toronto.ca) because of my frequent use of TTC buses and firsthand experience with significant delays. This dataset provides detailed insights into bus delays reported in Toronto throughout 2021, helping to explore patterns and identify causes for delays that could inform operational improvements.

## Dataset
- **Source**: [TTC Bus Delay Data 2021](https://open.toronto.ca/dataset/ttc-bus-delay-data/)
- **Size**: 2,832 records
- **Key Variables**:
  - `Date` and `Time`: Timestamp of reported delays.
  - `Incident Type`: Cause of delay (e.g., Mechanical, Security).
  - `Min.Delay`: Duration of the delay in minutes.
  - `Route`: Bus route where the delay occurred.
- Preprocessing:
  - Filtered for the top five most common incident types.
  - Cleaned and formatted data for effective analysis.

## Analysis
The project addresses three key questions:

### Q1: What is the predominant factor contributing to delays in the Toronto Transit Commission (TTC) bus system?
- **Findings**:
  - The most common reason for a delay is **Mechanical**, with the majority of delays being under 125 minutes.
  - **Diversion** causes the longest delays, followed by **Mechanical** and **Operation - Operator** issues.

### Q2: Are there noticeable patterns in specific routes and days of the week that experience substantial delays?
- **Findings**:
  - The **Finch West** route experiences the most delays, primarily due to diversions.
  - **Westbound** buses are delayed more frequently.
  - Weekdays experience more delays compared to weekends.

### Q3: To what extent are delays in the TTC bus system influenced by seasonal variations?
- **Findings**:
  - Delays decrease in February and April but increase in May and August.
  - Delays in January could be influenced by harsh weather, while August delays might be due to construction and tourism.

## Visualizations
1. **Boxplots**:
   - Highlight variability and central tendencies of delays by incident type and route.
2. **Jitter Plots**:
   - Show granular delay patterns for different incidents.
3. **Scatterplots**:
   - Display relationships between factors like time of day and delay duration.

## Conclusion
The analysis highlights:
- **Diversions** and **Mechanical issues** are the main contributors to delays.
- January and August experience the highest delays, likely influenced by weather and tourism.
- Routes like **Finch West** and **westbound directions** show higher delays, identifying areas for operational improvements.

### Recommendations:
- Focus on mitigating **Diversions** and **Mechanical issues** to reduce delays.
- Allocate additional resources during January and August to manage seasonal delays effectively.

## Future Considerations
While the analysis provided valuable insights, there are areas for further exploration:
1. **Incorporating Weather and Traffic Data**:
   - Adding external factors like weather conditions or traffic patterns could reveal additional causes for delays, particularly in January and August.
2. **Granular Time Analysis**:
   - Analyzing delays by specific times of the day (morning rush, midday, evening) could highlight additional patterns that impact service reliability.

By acknowledging these areas, the analysis remains open to further refinement and exploration, enhancing its relevance for decision-making.


