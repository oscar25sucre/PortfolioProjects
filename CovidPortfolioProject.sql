--Select *
--From [Covid Portfolio Project]..Deaths
--where continent is not null
--order by 3,4

--Select *
--From [Covid Portfolio Project]..CovidVaccinations


-- Select the data that we are going to be using

--Select location,date,total_cases,new_cases,total_deaths,population
--From [Covid Portfolio Project]..Deaths
--order by 1,2

--Looking at Total Cases vs Total Deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
From [Covid Portfolio Project]..Deaths
--Where location like '%states%'
order by 1,2

Select continent,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathRate
From [Covid Portfolio Project]..Deaths
where continent is not null
order by 1,2

--Looking at Total Cases VS Population
Select location,date,Population,total_cases,(total_cases/Population)*100 AS InfectedPercentage
From [Covid Portfolio Project]..Deaths
order by 1,2


--Looking at Countries with higest infection rate VS Population
Select location,Population,MAX(total_cases) AS HighInfectionCount,Max((total_cases/Population))*100 AS InfectedPercentage
From [Covid Portfolio Project]..Deaths
where continent is not null 
--AND location like '%states%'
group by location,Population
order by 4 desc

--Continent

Select continent,
MAX(total_cases) AS HighInfectionCount,Max((total_cases/Population))*100 AS InfectedPercentage
From [Covid Portfolio Project]..Deaths
where continent is not null
group by continent
order by 3 desc



 --Showing countries with the highest death count per population
Select location,Population,MAX(cast(total_deaths as int)) AS TotalDeathCount,Max((total_deaths/Population))*100 AS DeathPercentage
From [Covid Portfolio Project]..Deaths
where continent is not null
group by location,Population
order by 3 desc


----Showing Continents death count 

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Covid Portfolio Project]..Deaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Can do the drill down by going above and adding Continent Layer

-- World Calculations/ Global Numbers
Select date, SUM(new_cases)As TotalCases, SUM(new_deaths) As TotalDeaths,Sum(new_deaths)/Sum(new_cases)*100 As DeathPercentage
From [Covid Portfolio Project]..CovidDeaths
Where continent is not null
group by date
order by 1,2

-- looking at total populations vs vaccinations
Select da.continent,da.location,da.date,da.population,vac.new_vaccinations,
SUM(CONVERT(int,    vac.new_vaccinations) Over (Partition by da.location Order by da.location, da.date) AS rolling_total_vaccinations
From [Covid Portfolio Project]..CovidDeaths da
Join [Covid Portfolio Project]..CovidVaccinations vac
	On da.location=vac.location
	and da.date = vac.date
where da.continent is not null
order by 2,3

-- Use CTE to get total population percent vaccinated

with PopvsVac (continent, location, date, population,new_vaccinations, rolling_total_vaccinations)
as 
(
Select da.continent,da.location,da.date,da.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by da.location Order by da.location, da.date) AS rolling_total_vaccinations
From [Covid Portfolio Project]..CovidDeaths da
Join [Covid Portfolio Project]..CovidVaccinations vac
	On da.location=vac.location
	and da.date = vac.date
where da.continent is not null
--order by 2,3
)
select *,(rolling_total_vaccinations/population)*100 as 'total_vac%'
from PopvsVac


-- Temp Table

drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_total_vaccinations numeric
)

insert into #PercentPopulationVaccinated
Select da.continent,da.location,da.date,da.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by da.location Order by da.location, da.date) AS rolling_total_vaccinations
From [Covid Portfolio Project]..CovidDeaths da
Join [Covid Portfolio Project]..CovidVaccinations vac
	On da.location=vac.location
	and da.date = vac.date
where da.continent is not null
Order by 1,2

select *,(rolling_total_vaccinations/population)*100 as 'total_vac%'
from #PercentPopulationVaccinated

-- Views for visualizations in tableu
Create view PercentPopulationVaccinated as
Select da.continent,da.location,da.date,da.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by da.location Order by da.location, da.date) AS rolling_total_vaccinations
From [Covid Portfolio Project]..CovidDeaths da
Join [Covid Portfolio Project]..CovidVaccinations vac
	On da.location=vac.location
	and da.date = vac.date
where da.continent is not null

Create view WorldDeathCount as 
Select date, SUM(new_cases)As TotalCases, SUM(new_deaths) As TotalDeaths,Sum(new_deaths)/Sum(new_cases)*100 As DeathPercentage
From [Covid Portfolio Project]..CovidDeaths
Where continent is not null
group by date
