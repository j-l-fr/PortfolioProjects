--Check That the Tables are correct
--Select*
--From PortfolioProject..CovidDeaths$

--Select *
--From PortfolioProject..CovidVaccination$

--Select relevant data
--Select location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths$
--Where continent <>location
--order by 1,2

--Total Cases vs Total Deaths
--Likelihood of dying from Covid (specifically in Germany)
--Select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 As PercentageCovidDeaths
--From PortfolioProject..CovidDeaths$
--Order By 1,2

--Select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 As PercentageCovidDeaths
--From PortfolioProject..CovidDeaths$
--Where location = 'Germany'
--Order By 1,2

--Total Case vs Population (Percentage of People who had Covid)
--Select location, date, total_cases, population, (total_cases/population)*100 As PercentageOfPeopleHavingCovid
--From PortfolioProject..CovidDeaths$
--Where location = 'Germany'
--Order By 1,2


--Which Country has highest infection rate 
--Select location, population, Max(new_cases) as HighestInfectionRate, Max((new_cases/population))*100 As MaxInfectionRate
--From PortfolioProject..CovidDeaths$
--Where continent <>location
--Group by location, population
--Order by 4 Desc

--Which Country has the highest Percentage infected
--Select location, population, Max(Total_cases) as HighestTotalInfected, Max((Total_cases/population))*100 As MaxInfectionRate
--From PortfolioProject..CovidDeaths$
--Where continent <>location
--Group by location, population
--Order by 4 Desc

--Which Country has the most Covid related deaths
--Select location, population, Max(cast(total_deaths as int)) as TotalDeaths, Max((cast(total_deaths as int)/Population))*100 As DeathPerPopulation
--From PortfolioProject..CovidDeaths$
--Where continent <>location
--Group by location, population
--Order by 4 Desc

--Which Continent has most Covid related Deaths
--Select Continent, Max(cast(total_deaths as int)) as TotalDeaths, Max((cast(total_deaths as int)/Population))*100 As DeathPerPopulation
--From PortfolioProject..CovidDeaths$
--where continent is not null
--Group by Continent
--Order by 2 Desc

--Global Numbers
--Select location, Max(total_cases) as TotalCases, Max(cast(total_deaths as int)) as TotalDeaths, Max((cast(total_deaths as int)/Population))*100 As DeathPerPopulation, Max((cast(total_deaths as int)/total_cases))*100 as DeathRate
--From PortfolioProject..CovidDeaths$
--where location = 'World'
--group by location

--Global Numbers per date
--Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum((cast(total_deaths as int)/Population))*100 As DeathPerPopulation, Sum((cast(total_deaths as int)/total_cases))*100 as DeathRate
--From PortfolioProject..CovidDeaths$
--where location = 'World'
--group by date


--Joining tables: Looking at total population vs vaccinations
--Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, vaccines.new_vaccinations 
--, sum(convert(int, Vaccines.new_vaccinations)) 
--over (Partition by Deaths.location Order by deaths.location, deaths.date) as TotalVaccinations
--From PortfolioProject..CovidDeaths$ as Deaths
--Join PortfolioProject..CovidVaccination$ as Vaccines
--	on Deaths.date = Vaccines.date and Deaths.Location = Vaccines.location
--Where deaths.continent is not Null
--Order by 2,3

--Use CTE
--With PopvsVAC (continent, location, date, population, new_vaccinations , TotalVaccinations)
--as
--(
--Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, vaccines.new_vaccinations 
--, sum(convert(int, Vaccines.new_vaccinations)) 
--over (Partition by Deaths.location Order by deaths.location, deaths.date) as TotalVaccinations
--From PortfolioProject..CovidDeaths$ as Deaths
--Join PortfolioProject..CovidVaccination$ as Vaccines
--	on Deaths.date = Vaccines.date and Deaths.Location = Vaccines.location
--Where deaths.continent is not Null
--)
--Select *, (TotalVaccinations/Population)*100 as PercentageVaccinated
--From PopvsVAC

--UseTemp Table
--Drop Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--Date datetime,
--population numeric,
--new_vaccinations numeric,
--TotalVaccinations numeric,
--)
--Insert Into #PercentPopulationVaccinated
--Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, vaccines.new_vaccinations 
--, sum(convert(int, Vaccines.new_vaccinations)) 
--over (Partition by Deaths.location Order by deaths.location, deaths.date) as TotalVaccinations
--From PortfolioProject..CovidDeaths$ as Deaths
--Join PortfolioProject..CovidVaccination$ as Vaccines
--	on Deaths.date = Vaccines.date and Deaths.Location = Vaccines.location
--Where deaths.continent is not Null
--Order by 2,3

--Select *, (TotalVaccinations/Population)*100 as PercentageVaccinated
--From #PercentPopulationVaccinated

--Create a View To store data for visualization
Create view PercentPopulationVaccinated as
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, vaccines.new_vaccinations 
, sum(convert(int, Vaccines.new_vaccinations)) 
over (Partition by Deaths.location Order by deaths.location, deaths.date) as TotalVaccinations
From PortfolioProject..CovidDeaths$ as Deaths
Join PortfolioProject..CovidVaccination$ as Vaccines
	on Deaths.date = Vaccines.date and Deaths.Location = Vaccines.location
Where deaths.continent is not Null

Select*
From PercentPopulationVaccinated