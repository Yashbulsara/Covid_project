select *
from CovidDeaths$
where continent is not  null
order by 3,4

--select *
--from CovidVaccinations$
--order by 3,4

--Select Data we are using
select Location, date, total_cases, new_cases, total_deaths,population
from CovidDeaths$
order by 1,2

--Total Cases vs Total Deaths
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location = 'India'
order by 1,2

--Total Cases vs Population
--Percentage of population got covid

select Location, date, total_cases, population, (total_deaths/population)*100 as DeathPercentage
from CovidDeaths$
where location = 'India'
order by 1,2

--Contries with Highest infection rate compared to population


select Location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentOfPopulation
from CovidDeaths$
group by Location,Population
order by 4 desc

--Countries with highest deathcount per population

select Location,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths$
where continent is not  null
group by Location
order by 2 desc


--By continent

select continent,max(cast(Total_deaths as int)) as TotalDeathCount
from CovidDeaths$
where continent is not null
group by continent
order by 2 desc


-- Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int )) as total_deaths, sum(cast(new_deaths as int ))/sum(new_cases)*100   as DeathPercentage
from CovidDeaths$ 
where continent is not null
--group by date
order by 1,2

--global numbers by date
select date ,sum(new_cases) as total_cases, sum(cast(new_deaths as int )) as total_deaths, sum(cast(new_deaths as int ))/sum(new_cases)*100   as DeathPercentage
from CovidDeaths$ 
where continent is not null
group by date
order by 1,2


--total population vs vaccination
select *
from CovidVaccinations$

select *
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date

with popvac(continent, location, date, Population, new_vacctionations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not  null
--order by 2,3
)
--using CTE
select *, (RollingPeopleVaccinated/Population)*100
from popvac


--temp table

Drop table if exists #PercentagePopulationvaccinated
create table #PercentagePopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)



Insert into #PercentagePopulationvaccinated

select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not  null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentagePopulationvaccinated

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date ) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not  null
--order by 2,3

