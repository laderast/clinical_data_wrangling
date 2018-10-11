---
title: Things we learned teaching clinical data wrangling
author: "Eilis Boudreau, Ted Laderas, and Nicole Weiskopf"
date: '2018-10-15'
slug: clinical-data-wrangling
categories: [visualization,R]
tags: [visualization, interactive visualization, rstats, R, shiny]
header:
  caption: '*shiny app to explore data*'
  image: 'appview.jpg'
---

Well, we just finished our clinical data wrangling workshop. This was a 12 hour workshop (spread over 4 days) where students got to work with a real research dataset (the [Sleep Heart Health Study](http://sleepdata.org) data). This is a workshop that we developed as part of an National Library of Medicine T15 training supplement in Data Science. The following is a short report describing the workshop and its outcomes.

## Intended Audience

We designed the workshop for our incoming informatics students (both on the clinical and biological majors) in order to introduce them to the difficulties of working with clinical data.

## Learning Objectives

These were our learning objectives for the workshop:

1. Understand the biology of sleep and sleep apnea and how the biology informs the covariates measured in the Sleep Heart Health Study
2. Understand why clinical data is useful and also why it's difficult to work with
3. Learn Exploratory Data Analysis techniques and use them to inform model building.
4. Learn to assess logistic regression models using simple diagnostics.

## The Dataset

We used the [Sleep Heart Health Study](https://sleepdata.org/datasets/shhs) dataset from the [National Sleep Research Resource](https://sleepdata.org). This is a dataset of approximately 5800 patients that have over 3000 covariates. We limited our students to a smaller number of covariates (17), including our outcome of interest, cardiovascular disease.

## Workshop Format

We designed the workshop to be a mix of didactic lectures and active learning exercises. Where possible, we had students work in groups to answer questions about the data. These activities included a data scavenger hunt using our EDA exploration app, and a logistic modeling exercise.

### Day 1 Outline

1. Introduction, logistics, and groups assigned (30 minutes)
1. Biology of Sleep and Cardiovascular Disease (40 minutes, format: in-person lecture)
1. Break Time (15 minutes)
1. The Value of Clinical Data (15 minutes, in-person lecture)
1. Clinical Data Quality (40 minutes, in-person lecture)
1. Lunch (90 minutes, with optional R setup session)
1. Exploring the SHHS Dataset (60 minutes, format: Data Scavenger Hunt w/ Shiny App, each team gets a task and has to show the class how to find the information)
1. Applying the Clinical Wrangling Process: Diabetes (45 minutes, format: in-person lecture)
1. Logistic Regression Model Basics (60 minutes, format: walkthrough of R Notebook)

### Day 2

1. Question/Answer session about Logistic Regression and Modeling (50 minutes)
1. Assignment about `race` variable (assigned to groups, take-home assignment)

### Day 3

1. Discussion about `race` as a covariate, sharing of findings
1. Overview of hypertension and how it relates to cardiovascular disease and sleep apnea
1. Template/R Notebook given for final presentation in groups (in-class lab time, template is structured as a series of decisions.)

### Day 4

1. Group presentations about covariate decisions and resulting model (1 hour, present final version of R notebook). At each decision stage, teams must decide on whether or not to include covariates or not given what they have found from exploring the data and justify their decision using EDA visualizations.

## Lessons Learned

Overall, we believe the workshop went well, as it encouraged discussion about data and its appropriateness among the students. Students were engaged overall and asked lots of questions. 

The final reports for each group were generated from a R Notebook. All three groups showed a thoughtful narrative and justification for each of the covariates included in the model.

1. **Interactive visualization removes barriers to understanding issues in data**. Ted developed a Shiny App that allowed the students to visually browse and understand the data. Along with the EDA scavenger hunt (see below), this served as a good introduction for students to get their feet wet with the SHHS dataset.

2. **Our diverse backgrounds helped make the workshop accessible.** Nicole Weiskopf has a background in data quality of clinical data, Eilis Boudreau does sleep study work, and I'm a bit of a mongrel.

3. **Securing the cooperation of the data holders made the workshop possible**. The dataset comes from the National Sleep Study Resource. Eilis knows Susan Redline, who heads that group and pitched the idea (over two sessions) to her group. Susan’s group was very enthusiastic and helpful, especially in helping the students get their data use agreements in so they could access the dataset. 

4. **Group work is learning work**. We assigned each student to a group, and gave each group questions to answer and teach the class about the dataset. By pointing them to specific aspects of the data, we opened the door to discussion. 

5. **EDA scavenger hunt**. We had the students learn data exploration by giving them a [scavenger hunt]() to look at the relationship between variables. Each group was then required to talk about their findings and which visualization helped them discover that relationship. For example, there is a relationship between age and race in our dataset; the “Other” category of race has a lower median age than the other two categories, “White” and “Black”.

6. **Didactic Teaching is also important**. Nicole and Eilis covered both the biology of sleep apnea and the difficulty of understanding the implications of clinical data. Without this background, students would not be able to make informed decisions about their final model.

7. **Guide the Students, but don’t force discussion**. This was important. We think the students need to connect the dots to really understand the issues. The final product (a logistic regression model predicting cardiovascular disease with an R Notebook) had steps and choices. But the choices for each students was different.

8. **A Code of conduct is necessary and important**. We are big believers in psychological safety. If people don’t feel safe in the classroom environment (and let’s face it, grad school classrooms rarely are), they will be less likely to learn and contribute.

9. **Data restrictions made deploying difficult**. The activity materials were deployed as an RStudio project. However, we couldn't share the data within a GitHub repo. As OHSU's approved vendor is Box, we setup a box folder containing the material to be shared with students. 

We were grateful for the incoming informatics students’ enthusiasm and patience as we got this workshop going. Also thanks to the NLM T15 Supplement in Data Science, without which we would not have gotten the opportunity to conceptualize, put together, and deliver this workshop. Thanks again to Susan Redline and the [National Sleep Research Resource](http://sleepdata.org) group, especially Dan Mobley who helped us with the last-minute data use agreements.