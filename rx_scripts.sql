-- 1a. Which prescriber had the highest total number of claims (totaled over all drugs)? 
-- Report the npi and the total number of claims. -- Use prescription tbl
-- SELECT 
-- npi,
-- SUM(total_claim_count) AS total_claim
-- FROM prescription
-- GROUP BY 1
-- ORDER BY total_claim DESC

-- 1b. Repeat the above, but this time report the nppes_provider_first_name, 
-- nppes_provider_last_org_name, specialty_description, and the total number of claims.

-- SELECT 

-- rx.npi,
-- p.nppes_provider_first_name,
-- p.nppes_provider_last_org_name,
-- p.specialty_description,
-- COUNT(total_claim_count) AS total_claim

-- FROM prescription rx
-- LEFT JOIN prescriber p
-- on rx.npi = p.npi
-- GROUP BY 1,2,3,4
-- ORDER BY total_claim DESC

-- 2a. Which specialty had the most total number of claims (totaled over all drugs)?
-- SELECT 
-- p.specialty_description,
-- COUNT(total_claim_count) AS total_claim

-- FROM prescription rx
-- LEFT JOIN prescriber p
-- on rx.npi = p.npi
-- GROUP BY 1
-- ORDER BY total_claim DESC


