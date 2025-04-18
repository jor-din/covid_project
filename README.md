# 🦠 COVID-19 Data Exploration Project

## 📊 Overview

This project uses **SQL Server** to explore global COVID-19 data, leveraging real-world datasets that include statistics on infections, deaths, population, and vaccinations. The goal is to derive meaningful insights by performing data transformations, aggregations, and analytical queries.

> **Skills Used:** Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Views, Data Type Conversion

---

## 🧰 Dataset Source

- [Our World in Data - COVID-19 Dataset](https://ourworldindata.org/coronavirus)
- Two primary tables used:
  - `CovidDeaths`
  - `CovidVaccinations`

---

## 📌 Key Analyses Performed

### 🔍 Data Preview
- Selected and filtered initial data from `CovidDeaths` excluding non-country level data (e.g., continents).

### 💀 Total Cases vs Total Deaths
- Calculated death percentage to show **likelihood of death** if infected by COVID-19 per location.

### 🧪 Total Cases vs Population
- Calculated **percentage of population infected** to understand outbreak severity by country.

### 🌍 Highest Infection & Death Rates
- Identified countries with:
  - Highest infection rate relative to population
  - Highest absolute death counts

### 🌐 Continent-Level Analysis
- Aggregated deaths by continent to show **which continents were impacted the most**.

### 📈 Global Summary
- Calculated total global cases, deaths, and **global death rate**.

### 💉 Vaccination Analysis
- Tracked **rolling number of people vaccinated** using window functions.
- Analyzed percentage of population vaccinated using:
  - Common Table Expressions (CTEs)
  - Temp Tables
  - Views for visualization-ready data

---

## 🧠 Techniques Used

- **Joins:** Combined COVID death and vaccination datasets by matching date and location
- **Window Functions:** Calculated rolling totals for vaccinations
- **CTEs:** Simplified complex logic and improved query readability
- **Temp Tables:** Stored intermediate results for further calculations
- **Views:** Created reusable datasets for future visualizations
- **Type Conversion:** Ensured numeric calculations were possible by casting/converting data

---

## 📤 Sample Queries

```sql
-- Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,
       MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;
