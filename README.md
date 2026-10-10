# Stroke Prediction Model 🧠

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![RMarkdown](https://img.shields.io/badge/RMarkdown-4c4c4c?style=for-the-badge&logo=rstudio&logoColor=white)
![Plumber API](https://img.shields.io/badge/Plumber_API-8A2BE2?style=for-the-badge&logo=api&logoColor=white)
![Vetiver](https://img.shields.io/badge/Vetiver-00a49c?style=for-the-badge&logo=target&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

This repository contains the code and analysis for building and deploying a machine learning model to predict the likelihood of a stroke in patients based on their clinical and demographic information.

The project covers the entire data science lifecycle: from data preprocessing and exploratory analysis to model training, evaluation, selection, and finally, deployment as a REST API.

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Methodology](#methodology)
    - [1. Data Preprocessing & Exploration](#1-data-preprocessing--exploration)
    - [2. Model Building](#2-model-building)
    - [3. Model Evaluation & Selection](#3-model-evaluation--selection)
- [Model Deployment & API Usage](#model-deployment--api-usage)
    - [API Endpoints](#api-endpoints)
    - [Making a Prediction](#making-a-prediction)
- [Repository Files](#repository-files)
- [Key Findings](#key-findings)
- [How to Run Locally](#how-to-run-locally)
- [Author](#author)

## Project Overview

According to the World Health Organization (WHO), stroke is the 2nd leading cause of death globally, responsible for approximately 11% of total deaths. Early prediction and identification of high-risk individuals are crucial for preventive care.

This project aims to build a reliable classification model that can accurately predict stroke risk, with a focus on **precision** and **balanced accuracy** to minimize false negatives in a clinical context. The final selected model is deployed as an API for real-time predictions.

## Dataset

The project uses the **"Stroke Prediction Dataset"**, which contains 5,110 observations and 11 clinical features.

The dataset includes the following features:
- **Demographic:** `gender`, `age`, `ever_married`, `work_type`, `Residence_type`
- **Clinical:** `hypertension`, `heart_disease`, `avg_glucose_level`, `bmi`
- **Lifestyle:** `smoking_status`
- **Target Variable:** `stroke`

The data was cleaned by treating "Unknown" smoking status as missing values and removing rows with `NA` values, resulting in a final dataset of **3,426 observations**.

## Methodology

The analysis and model building were conducted using R and are documented in the `Build-deploy-stroke-prediction-model-R.Rmd` file.

### 1. Data Preprocessing & Exploration

- **Cleaning:** The raw dataset was cleaned by replacing numerical codes (`0`/`1`) with descriptive labels ("No"/"Yes"), handling missing `bmi` values, and removing rows with "Unknown" smoking status.
- **Exploration:** Exploratory Data Analysis (EDA) was performed to understand feature distributions and relationships. This included creating frequency tables, bar plots, contingency tables, and conducting Chi-square tests. Key insights from the EDA include:
    - The dataset is highly imbalanced, with only **5.25%** of patients having experienced a stroke.
    - Patients with stroke are significantly older (avg. 68 years) than those without (avg. 48 years).
    - A higher percentage of patients with stroke have hypertension (32%) and heart disease (25%) compared to the stroke-free group.

### 2. Model Building

The data was split into a **70% training set** and a **30% testing set**. Four different classification algorithms were trained and evaluated:

1.  **Iterative Dichotomiser 3 (ID3):** A type of decision tree.
2.  **Naïve Bayes:** A probabilistic classifier based on Bayes' theorem.
3.  **Decision Tree (Ctree):** Conditional inference tree.
4.  **Random Forest:** An ensemble method combining multiple decision trees.

### 3. Model Evaluation & Selection

The models were evaluated on the test set. The primary metric for selection was **Balanced Accuracy** (or precision), as it's more reliable than overall accuracy in a clinical setting with imbalanced data.

| Model                 | Accuracy | Balanced Accuracy |
| --------------------- | -------- | ----------------- |
| ID3                   | 94.75%   | 50.00%            |
| Decision Tree (Ctree) | 94.75%   | 50.00%            |
| Random Forest         | 88.33%   | 50.11%            |
| **Naïve Bayes**       | **91.83%** | **60.70%**        |

The **Naïve Bayes** model was selected for deployment because it achieved the highest **balanced accuracy of 60.7%**, making it the most reliable classifier for identifying both stroke and non-stroke cases compared to the other models.

## Model Deployment & API Usage

The selected Naïve Bayes model is deployed as a REST API using the `vetiver` package in R. This allows the model to be served as a web service for making predictions.

### API Endpoints

The API exposes the following endpoints:

| Method | Endpoint        | Description                                     |
| ------ | --------------- | ----------------------------------------------- |
| `GET`  | `/`             | Welcome page with API documentation.            |
| `GET`  | `/health`       | Checks if the API is running and the model is loaded. |
| `GET`  | `/parameters`   | Provides valid values and descriptions for all input parameters. |
| `GET`  | `/predict`      | The main endpoint to get a stroke prediction.   |
| `GET`  | `/swagger`      | Interactive API documentation (Swagger UI).     |

### Making a Prediction

To get a prediction, you need to make a `GET` request to the `/predict` endpoint with the following query parameters. You can use a web browser or a tool like `curl` or `httr` in R.

**Example Request:**
