--select *
--from CovidProject..covidvaccines

--select *
--from CovidProject..coviddeaths
--order by 3,4

--Select data we are going to be using
--select location, date, total_cases, new_cases, total_deaths, population 
--from CovidProject..coviddeaths
--order by 1,2

-- Looking at total cases vs total deaths in US
--select location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 as death_percentage
--from CovidProject..coviddeaths
--where location like '%states%'
--order by 1,2

-- Looking at Total Cases vs Population in US
-- Shows what percentage of population got Covid
--select location, date, population, total_cases, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0)) * 100 as covid_infect_percentage
--from CovidProject..coviddeaths
--where location like '%states%'
--order by 1,5

-- Looking at Countries with Highest Infection Rate compared to Population
--select location, population, Max(total_cases) as highest_infection_count, Max(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS highest_infect_percentage
--from CovidProject..coviddeaths
--group by location, population
--order by highest_infect_percentage desc

-- Countries with Highest Death Count per Population

--Select Location, MAX(cast(Total_deaths as int)) as total_death_count
--From CovidProject..coviddeaths
--Where continent is not null 
--Group by Location
--order by TotalDeathCount desc

-- --Contients with highest death per pop
--Select continent, MAX(cast(Total_deaths as int)) as total_death_count
--From CovidProject..coviddeaths
----Where location like '%states%'
--Where continent is not null 
--Group by continent
--order by TotalDeathCount desc

--Select SUM(CONVERT(float, new_cases)) as total_cases, 
--       SUM(CONVERT(float, new_deaths)) as total_deaths, 
--	   SUM(CONVERT(float, new_deaths) / NULLIF(CONVERT(float, new_cases), 0)) * 100 as death_percentage
--From CovidProject..coviddeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) AS RollingPeopleVaccinated
From CovidProject..coviddeaths dea
Join CovidProject..covidvaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

---- Using CTE to perform Calculation on Partition By in previous query

;With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float ,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..coviddeaths dea
Join CovidProject..covidvaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



---- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..coviddeaths dea
Join CovidProject..covidvaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




---- Creating View to store data for later visualizations

--GO 
--Create View PercentPopulationVaccinated as
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(float ,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
--From CovidProject..coviddeaths dea
--Join CovidProject..covidvaccines vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 



