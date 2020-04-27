# Pewlett-Hackard-Analysis

## Adding 7th table named retirement_info that is a list of 41,381 employees born in years 1952-1955 AND hired in years 1982-1985

## Also adding a .txt file of my queries.

## Deliverables:
## ERD previously attached as Annotation 2020-04-21 under Module Saves folder
## Query list updated.  Filename: queries.sql.

## Attaching Excel file detailing the tables provided and created broken up by task
## Question #1 csv is retire_title_salary.csv
## Question #1A csv is title_count.csv
## Question #2 csv is mentor_eligible.csv
## All are found under the Data folder

### Pewlett-Hackard, "PH", is a mature company with an aging workforce.  Management anticipates a "silver tsunami" of retirements occuring in the near-term.  Our task was to identify a subset of the employee force that we anticipate will be ready to retire in the near-term.  If the expected abnormally large wave of retirements catches us offguard it could have devastating effects on the continuity of the company.  Quantifying this group of near-retirees would not only illustrate the amplitude of the silver tsunami at PH, but would provide us the ability to do further data analysis to determine which areas are most impacted and what strategies we would employ to address it.

### We started off with 6 employee data sets.  
#### A master Employee data set
#### Department level Employee data
#### Department Manager data set
#### Titles
#### Salaries
#### Departments
### We used PostgreSQL to manipulate and enhace our datasets and added data analysis techniques to produce 3 reports, or tables to establish our findings.  One challenge overcome was the sheer size of the data.  Using SQL as opposed to a tool like Excel that is ill-equiped to manage such large data sets was integral to ur success.  Another challenge we overcame was tracking down the timeline of the individual employee as they are promoted, trasnferred, retire, or have their title changed over time.  We conquered this task using Common Table Expression code that could isolate a given employee's current position, title, and department.  Embedding a second SELECT statement inside the SELECT statement with the following code acheives this result.

#####(SELECT emp_no,
#####first_name,
#####last_name,
#####title,
#####from_date,
#####to_date,
#####ROW_NUMBER() OVER
#####(PARTITION BY (emp_no)
#####ORDER BY from_date DESC) rn
#####FROM mentors_list
#####) tmp WHERE rn = 1
#####ORDER BY emp_no;

### Our first task was to identify all the employees company-wide we believed stood the highest likelyhood of retiring shortly.  We believed employees born in the period 1952-1955 and hired in the period 1985 and 1988 satisfied this requirement.  Next we removed employees fitting that criteria which are no longer with PH.  We were left with 33,119 current employees we believe are near retirement.  Next, we broke those 33,119 down by current title.  The 2 titles most affected are Senior Engineer (41.2%), and Senior Staff (38.9%).  Interestingly, we identified only 2 Managers we expect to retire shortly.  

### Our next task was to identify potential participants in a company-wide mentorship program.  Out starting assumption was that employees born in 1965 were most attractive for this program.  We identified 1,549 employees currently employed thst were born in 1965.  Should management choose to pursue this mentorship program it could be expanded beyond 1965 births easily.  In fact, given the disparity between the 30,000 plus potential near-term retirees and the 1500 plus eligible for the program it is my recomendation we consider expanding our target range for the mentor program.


## Please not that I could not figure out any methond to attach a png file into the README file.  But please find my ERD at ...\Pewlett-Hackard-Analysis\Module saves

