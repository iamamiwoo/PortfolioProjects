select *
from coviddeaths
where nullif(continent, '') is not null
order by 3,4

select "location", date, total_cases, new_cases, total_deaths, population
from coviddeaths
where nullif(continent, '') is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country

select "location", date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "death_percentage"
from coviddeaths
where "location" like '%Korea%'
--where nullif(continent, '') is not null
order by 1,2

-- Looking at Total Caases vs Population
-- Shows what percentage of population got Covid

select "location", date, population, total_cases, (total_cases/population)*100 as "PercentPopulation"
from coviddeaths
where "location" like '%Korea%'
--where nullif(continent, '') is not null
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

select "location", population, max(total_cases) as "HighestInfectionCount", MAX((total_cases/population))*100 as "PercentPopulationInfected"
from coviddeaths
where (total_cases/population) is not null
and nullif(continent, '') is not null
group by "location", population
order by "PercentPopulationInfected" desc

-- Showing Countires with Highest Death Count per Population

select "location", max(total_deaths) as TotalDeathCount
from coviddeaths
where total_deaths is not null
and nullif(continent, '') is not null
group by "location"
order by TotalDeathCount desc

-- Let's break things down by Continent

-- Showing Continents with the Highest Death Count per Population

select "location", max(total_deaths) as TotalDeathCount
from coviddeaths
--where total_deaths is not null
where nullif(continent, '') is null
and "location" not like '%income' and "location" not like 'International'
group by "location"
order by TotalDeathCount desc

-- GLOBAL NUMBERS

select sum(new_cases) as "Total Cases", sum(new_deaths) as "Total Deaths", sum(new_deaths)/sum(new_cases)*100 as "DeathPercentage"
from coviddeaths
--where "location" like '%Korea%'
where nullif(continent, '') is not null
--group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea."location", dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea."location" order by dea."location", dea.date) as "RollingPeopleVaccinated"
--, ("RollingPeopleVaccinated"/population)*100
from coviddeaths dea
join covidvaccinations vac 
	on dea.location = vac.location 
	and dea.date = vac.date
where nullif(dea.continent, '') is not null
group by 1,2,3,4,5
order by 1,2,3

-- Use CTE

with PopvsVac (Continent, "location", date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(select dea.continent, dea."location", dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea."location" order by dea."location", dea.date) as "RollingPeopleVaccinated"
--, ("RollingPeopleVaccinated"/population)*100
from coviddeaths dea
join covidvaccinations vac 
	on dea.location = vac.location 
	and dea.date = vac.date
where nullif(dea.continent, '') is not null
--order by 1,2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from popvsvac




