;
Select*
FROM dbo.CovidDeaths
Where continent is null
Order by 3,4

--Select*
--FROM dbo.CovidVaccination
--Order by 3,4

  
SELECT location,date,total_cases,new_cases,total_deaths, population
FROM dbo.CovidDeaths
Where continent is null
order by 1,2



SELECT  continent,location,date,population,total_cases,(total_cases/population)*100 AS casespercentage
FROM dbo.CovidDeaths
WHERE location Like'%states'
and continent is null
order by 1,2


SELECT location,population,Max(total_cases) AS highestinfectioncount,Max((total_cases/population)*100) AS infectionpercentage
FROM dbo.CovidDeaths
--WHERE location Like'M%r%co'
Group by location,population  
order by infectionpercentage desc





SELECT continent,Max(cast(total_deaths as int)) AS totaldeathcount
FROM dbo.CovidDeaths
--WHERE location Like'M%r%co'
Where continent is not null
Group by continent
order by totaldeathcount desc


Select SUM(new_cases)as totalCases,SUM(cast(new_deaths as int))as totalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
From [PortfolioProject ].dbo.CovidDeaths
where continent is not null
--Group by date 
order by  1,2

Select Dea.continent,Dea.location,Dea.date,Dea.population,Vac.new_vaccinations
,SUM(Cast(Vac.new_vaccinations as int)) OVER (Partition by Dea.location order by Dea.location,Dea.date )as RollingPeopleVaccinated
,(RollingPeopleVaccinated/Population )*100
From [PortfolioProject ].dbo.CovidDeaths Dea
Join [PortfolioProject ].dbo.CovidVaccination Vac
     ON  Dea.location=Vac.location 
	 AND Dea.date=Vac.date
	 Where Dea.continent is not Null
	 order by  1,2,3


	With PopvsVac (Continent,location,Date,Population,new_vaccinations,RollingPeopleVaccinated)
	As
	(
	Select Dea.continent,Dea.location,Dea.date,Dea.population,Vac.new_vaccinations
,SUM(Cast(Vac.new_vaccinations as int)) OVER (Partition by Dea.location order by Dea.location,Dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population )*100
From [PortfolioProject ].dbo.CovidDeaths Dea
Join [PortfolioProject ].dbo.CovidVaccination Vac
     ON  Dea.location=Vac.location 
	 AND Dea.date=Vac.date
	 Where Dea.continent is not Null
	-- order by  1,2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(225),
location nvarchar(225),
Date datetime,
Population numeric,
new_vaccinations  numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select Dea.continent,Dea.location,Dea.date,Dea.population,Vac.new_vaccinations
,SUM(Cast(Vac.new_vaccinations as int)) OVER (Partition by Dea.location order by Dea.location,Dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population )*100
From [PortfolioProject ].dbo.CovidDeaths Dea
Join [PortfolioProject ].dbo.CovidVaccination Vac
     ON  Dea.location=Vac.location 
	 AND Dea.date=Vac.date
	 --Where Dea.continent is not Null
	-- order by  1,2,3

	Select*,(RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated



	Create View PercentPopulationVaccinated as 
	Select Dea.continent,Dea.location,Dea.date,Dea.population,Vac.new_vaccinations
,SUM(Cast(Vac.new_vaccinations as int)) OVER (Partition by Dea.location order by Dea.location,Dea.date )as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population )*100
From [PortfolioProject ].dbo.CovidDeaths Dea
Join [PortfolioProject ].dbo.CovidVaccination Vac
     ON  Dea.location=Vac.location 
	 AND Dea.date=Vac.date
	 Where Dea.continent is not Null
	--order by  1,2,3

	Select*
	From PercentPopulationVaccinated