CREATE TABLE node_formula (node VARCHAR(80), rating  DECIMAL(5,3), uptime_rate  DECIMAL(4,3), days_online_ratio  DECIMAL(4,3), asn_type VARCHAR(20), asn_score  TINYINT, formula DECIMAL(6,3), PRIMARY KEY(node)); 


--- INSERT ALL NODES THAT HAVE RATINGS. WILL SHOW NULL FOR NODES WITHOUT NODE SCORE
--- ONCE A NODE GETS A USER SUBMITTED RATING, IT WILL BE GIVEN A NODE FORMULA
   
INSERT IGNORE INTO node_formula(node)
SELECT node_address
FROM ratings_nodes;


--- UPDATE NODE'S RATING 
UPDATE node_formula
SET rating=(SELECT score FROM ratings_nodes WHERE node_formula.node=ratings_nodes.node_address);
   

--- UPDATE UPTIME RATE 
UPDATE node_formula
SET uptime_rate=(SELECT success_rate FROM node_uptime WHERE node_formula.node=node_uptime.node_address);


--- FIX NULL UPTIME RATE
UPDATE node_formula
SET uptime_rate=IF(uptime_rate IS NULL, 1, uptime_rate);

CREATE TABLE node_days_ratio (node_address VARCHAR(80), tries BIGINT, days_ratio DECIMAL(4,3), PRIMARY KEY(node_address));


--- INSERT NEW NODES INTO node_days_ratio TABLE 
INSERT IGNORE INTO node_days_ratio(node_address,tries,days_ratio)
SELECT node_address, tries, tries / (SELECT MAX(tries) FROM node_uptime) as days_online_ratio
FROM node_uptime
GROUP BY node_address, tries;

--- UPDATE node_days_ratio TABLE from node_uptime
UPDATE node_days_ratio
JOIN (
  SELECT node_address, tries, tries / (SELECT MAX(tries) FROM node_uptime) AS days_ratio
  FROM node_uptime
) AS derived
ON node_days_ratio.node_address = derived.node_address
SET node_days_ratio.days_ratio = derived.days_ratio, node_days_ratio.tries = derived.tries;


--- UPTIME DAYS ONLINE RATIO
UPDATE node_formula
SET days_online_ratio=(SELECT days_ratio FROM node_days_ratio WHERE node_formula.node=node_days_ratio.node_address);

--- FIX NULL RATIO
UPDATE node_formula
SET days_online_ratio=IF(days_online_ratio IS NULL, 1, days_online_ratio);


--- UPDATE asn_score 
UPDATE node_formula
SET asn_score = 
(SELECT
  CASE
    WHEN isp_type = 'business' THEN 3
    WHEN isp_type = 'hosting' THEN 1
    ELSE 5
  END AS score
FROM node_score
WHERE node_formula.node=node_score.node_address);

--- FIX NULL asn_score
UPDATE node_formula
SET asn_score=IF(asn_score IS NULL, 1, asn_score);


--- SET FORMULA OF NODE

UPDATE node_formula
SET formula = 5*rating+25*uptime_rate+20*days_online_ratio+asn_score
