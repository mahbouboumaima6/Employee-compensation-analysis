# Employee Compensation Fairness & Talent Risk Analytics
HR Analytics — Compensation Fairness & Talent Risk dashboard | (MySQL and Power BI)

## Project Overview
HR analytics dashboard identifying pay inequities and 
retention risks across 1,470 employees using SQL window 
functions and Power BI.

**Tools:** MySQL · Power BI Desktop  
**Dataset:** IBM HR Analytics (public dataset, 1,470 employees)  
**Skills:** Window Functions · DAX · Star Schema · Data Modeling

---

## Business Questions Answered
1. Are employees paid fairly relative to role peers?
2. Is there a gender pay gap — and where is it worst?
3. Which high performers are underpaid and at flight risk?
4. Do undervalued employees leave at higher rates?

---

## Key Findings

| Finding | Number |
|---|---|
| Employees classified as Underpaid | 495 (33.67%) |
| Largest gender pay gap by department | HR at 14.02% |
| Undervalued High Performers identified | 79 employees |
| Undervalued attrition rate | 20.25% |
| Normal employee attrition rate | 15.89% |
| Gender pay difference (monthly) | $306 in favor of men |

**Headline insight:** Undervalued high performers leave at 
20.25% vs 15.89% for fairly compensated peers — a 27% 
higher departure rate. Research & Development concentrates 
64% of all at-risk talent (51 of 79 employees).

---

## Dashboard Pages

### Page 1 — Compensation Overview
<img width="606" height="335" alt="page1_compensation_overview" src="https://github.com/user-attachments/assets/01a77716-a535-4910-914e-d6759c11a0c2" />


### Page 2 — Pay Equity Analysis
<img width="602" height="338" alt="page2_pay_equity_analysis" src="https://github.com/user-attachments/assets/0c9a3d5a-79f3-4a24-870d-27c6d74ba5e0" />


### Page 3 — Talent Risk & Retention Analysis
<img width="602" height="341" alt="page3_talent_risk" src="https://github.com/user-attachments/assets/fc77be29-2ca8-4b60-a18f-a4f991cdfecc" />


---

## SQL Skills Demonstrated

| Technique | Used For |
|---|---|
| `PERCENT_RANK() OVER (PARTITION BY)` | Salary percentile within role |
| `AVG() OVER (PARTITION BY)` | Role average for pay classification |
| `NTILE(4) OVER (PARTITION BY)` | Salary quartile segmentation |
| `CASE WHEN` | Pay status & talent flag classification |
| `GROUP BY` + `COUNT` + `AVG` | Department & role KPIs |

---

## Power BI Skills Demonstrated
- Star Schema: HR_Compensation fact table + SalaryBands 
  dimension + dim_date
- DAX: CALCULATE, DIVIDE, RELATED, PERCENT_RANK measures
- 3-page dashboard with synced slicers and page navigation
- Conditional formatting on matrix and detail table
- Custom dark theme with consistent color language:
  red = risk, teal = healthy, orange = warning

---

## Repository Structure
```
├── compensation_master.sql   # All SQL queries
├── compensation_dashboard.pbix  # Power BI file
├── screenshots/
│   ├── page1_compensation_overview.png
│   ├── page2_pay_equity_analysis.png
│   └── page3_talent_risk.png
└── README.md
```
