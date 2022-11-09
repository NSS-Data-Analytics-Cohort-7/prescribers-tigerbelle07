-- 1a. Which prescriber had the highest total number of claims (totaled over all drugs)? 
-- Report the npi and the total number of claims. -- Use prescription tbl
-- SELECT 
-- npi,
-- SUM(total_claim_count) AS total_claim
-- FROM prescription 
-- GROUP BY 1
-- ORDER BY total_claim DESC

--Answer: NPI- 1881634483, had the higest total number of claims of 99,707

-- 1b. Repeat the above, but this time report the nppes_provider_first_name, 
-- nppes_provider_last_org_name, specialty_description, and the total number of claims.

-- SELECT 
-- rx.npi,
-- p.nppes_provider_first_name,
-- p.nppes_provider_last_org_name,
-- p.specialty_description,
-- SUM(total_claim_count) AS total_claim

-- FROM prescription rx
-- LEFT JOIN prescriber p
-- on rx.npi = p.npi
-- GROUP BY 1,2,3,4
-- ORDER BY total_claim DESC
--Answer: Dr. Bruce Pendley- Family Practice had the most claims at 99,707

-- 2a. Which specialty had the most total number of claims (totaled over all drugs)?
--notes: specialty description column is on prescriber tbl
-- SELECT 
-- p.specialty_description,
-- SUM(rx.total_claim_count) AS total_claim

-- FROM prescription rx
-- LEFT JOIN prescriber p
-- on rx.npi = p.npi
-- GROUP BY 1
-- ORDER BY total_claim DESC
--Family Practice had the highest number of claims at 97,52347

-- 2b. Which specialty had the most total number of claims for opioids? --CTE

-- WITH DRG AS  (SELECT 
--       rx.drug_name,
--       rx.npi, 
--       d.opioid_drug_flag,
--       SUM(rx.total_claim_count) AS total_claim 
 
--       FROM prescription rx
--       INNER JOIN drug d
--       on rx.drug_name = d.drug_name
--       WHERE d.opioid_drug_flag = 'Y'
--       GROUP BY 1,2,3) 

-- SELECT 
-- p.specialty_description,
-- --drg.drug_name,
-- SUM(drg.total_claim) AS TOT_AMT       
-- FROM prescriber p
-- INNER JOIN DRG
-- ON p.npi = drg.npi
-- GROUP BY 1
-- ORDER BY TOT_AMT DESC
--Speciality -"Nurse Practitioner" had the most total number of claims for opioids at 90,0845


-- 2c.Challenge Question: Are there any specialties that appear 
-- in the prescriber table that have no associated prescriptions in the prescription table?
-- SELECT DISTINCT
-- p.specialty_description, 
-- rx.total_claim_count

-- FROM prescriber p
-- LEFT JOIN prescription rx
-- ON p.npi = rx.npi
-- WHERE rx.total_claim_count IS NULL
--Answer: yes rows 92

-- 2d Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the 
-- percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?
--1st attempt
-- SELECT DISTINCT
-- p.specialty_description,
-- drg.drug_name,
-- drg.total_claim
-- FROM prescriber p
-- LEFT JOIN 
-- (SELECT 
-- rx.drug_name,
-- rx.npi, 
-- d.opioid_drug_flag,
-- SUM(rx.total_claim_count) AS total_claim 
-- FROM prescription rx
-- LEFT JOIN drug d
-- on rx.drug_name = d.drug_name
-- WHERE d.opioid_drug_flag = 'Y'
-- AND d.drug_name IS NOT NULL
-- AND rx.total_claim_count IS NOT NULL 
-- GROUP BY 1,2,3 
-- ) as drg
-- ON p.npi = drg.npi
-- WHERE
-- p.specialty_description IS NOT NULL


--***2nd attempt - using CTE***
--Note: first lets find total claims pct by drugs/opioids.

-- WITH DRG AS (
--       SELECT
--       rx.drug_name,
--       rx.npi, 
--       SUM(rx.total_claim_count) AS total_claims,
--       ROUND(COUNT(rx.total_claim_count) * 100/SUM(rx.total_claim_count), 2) AS total_claim_pct
 
--       FROM prescription rx
--       INNER JOIN drug d
--       on rx.drug_name = d.drug_name
--       WHERE d.opioid_drug_flag = 'Y'
--       GROUP BY 1,2
--       ORDER BY total_claim_pct DESC
--     )
-- --Note: now lets factor in speciality 
-- SELECT DISTINCT
-- p.specialty_description,
-- --drg.drug_name,
-- SUM(drg.total_claims) AS Tot_Claim_Amt,
-- ROUND(COUNT(drg.total_claim_pct) * 100/SUM(drg.total_claim_pct),2) as TOT_AMT

-- FROM prescriber p
-- INNER JOIN DRG
-- ON p.npi = drg.npi

-- GROUP BY 1 
-- ORDER BY tot_claim_amt DESC
-- **answer - Nurse Practitioner with 90,0845 which is about 27.86%


-- 3a.Which drug (generic_name) had the highest total drug cost?

-- SELECT
-- d.generic_name, --Drug_name
-- SUM(p.total_drug_cost) AS drug_cost

-- FROM drug d
-- INNER JOIN prescription p
-- ON d.drug_name = p.drug_name
-- GROUP BY 1 
-- ORDER BY drug_cost DESC
-- --1000 rows

-- 3b. Which drug (generic_name) has the hightest total cost per day? 
-- **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

-- SELECT
-- d.generic_name, --Drug_name
-- ROUND(SUM(p.total_drug_cost)/SUM(p.total_day_supply),2) AS drug_cost -- correct answer 

-- FROM drug d
-- INNER JOIN prescription p
-- ON d.drug_name = p.drug_name
-- GROUP BY 1 
-- ORDER BY drug_cost DESC

-- 4a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' 
-- for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
-- SELECT 
-- rx.drug_name,
-- CASE WHEN d.opioid_drug_flag = 'Y'THEN 'Opioid'
--      WHEN d.antibiotic_drug_flag = 'Y' THEN 'Antibiotic'
--      ELSE 'Neither' END AS drug_type

-- FROM prescription rx
-- LEFT JOIN drug d
-- on rx.drug_name = d.drug_name
-- ORDER BY drug_type ASC
--1000 rows

-- 4b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. 
-- Hint: Format the total costs as MONEY for easier comparision.
-- SELECT 
-- CASE WHEN d.opioid_drug_flag = 'Y'THEN 'Opioid'
--       WHEN d.antibiotic_drug_flag = 'Y' THEN 'Antibiotic'
--       ELSE 'Neither' END AS drug_type,
-- --CAST(SUM(rx.total_drug_cost) AS MONEY) AS Tot_Money   
-- MONEY(SUM(rx.total_drug_cost)) AS Tot_Money

-- FROM prescription rx
-- LEFT JOIN drug d
-- on rx.drug_name = d.drug_name
-- GROUP BY drug_type
-- ORDER BY Tot_Money DESC

-- 5a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
-- SELECT * 
-- FROM cbsa
-- limit 20

-- SELECT *
-- FROM cbsa
-- WHERE cbsaname LIKE '%TN'
-- --rows 33

-- 5b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
--fipcounty - shared column

-- SELECT 
-- c.cbsaname,
-- SUM(p.population) as Pop

-- FROM cbsa c
-- INNER JOIN population p
-- ON c.fipscounty = p.fipscounty
-- GROUP BY 1
-- ORDER BY pop DESC --ASC
--10 rows; Nashville - largest
--10 rows; Morristown - smallest

-- 5c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
-- SELECT --Help by Jonathon 
-- c.cbsa,
-- p.fipscounty,
-- p.population

-- FROM population p
-- LEFT JOIN  cbsa c
-- ON c.fipscounty = p.fipscounty

-- WHERE c.fipscounty is NULL
-- ORDER BY p.population DESC




