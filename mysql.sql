-- SQLite


-- First hint
SELECT * FROM crime_scene_report 
WHERE city = 'SQL City' AND date == '20180115' and type == 'murder';
--Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".	


--Now I'll look for the witnesses
-- 1rst witness result = license_id 118009 , name Morty Schapiro, ssn 111564949, id 14887
SELECT * FROM person 
WHERE address_street_name == 'Northwestern Dr' 
ORDER BY address_number DESC;

-- 2nd witness  result = license_id 490173, name Annabel Miller	, ssn 318771143, id 16371
SELECT * FROM person 
WHERE address_street_name == 'Franklin Ave' AND INSTR(name,'Annabel') > 0;


--- Ill look for the interviews

SELECT * FROM interview 
WHERE person_id = '16371' OR person_id = '14887';
-- 14887 : I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags.
-- The man got into a car with a plate that included "H42W".

--16371: I saw the murder happen, and I recognized the killer from my gym when 
--I was working out last week on January the 9th.


-- Now ill look for the information that the first witness told us
-- result = person_id 67318, name Jeremy Bowers, 
SELECT prsn.id as person_id,prsn.name,gfmember.membership_start_date,gfmember.membership_status,dvlic.plate_number,dvlic.car_model,dvlic.age,gfmember.id,checkin.check_in_date,checkin.check_in_time,checkin.check_out_time as id_gym FROM get_fit_now_member as gfmember
INNER JOIN person as prsn ON prsn.id = gfmember.person_id  
INNER JOIN drivers_license AS dvlic ON dvlic.id = prsn.license_id
INNER JOIN get_fit_now_check_in as checkin ON checkin.membership_id = gfmember.id
WHERE gfmember.membership_status == 'gold' 
AND gfmember.id LIKE '48Z%'
AND INSTR(dvlic.plate_number,'H42W') > 0;

-- Now ill look for the interview of this person
SELECT * from interview 
WHERE person_id == '67318';
-- I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
-- She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in 
-- December 2017.
SELECT DISTINCT * FROM drivers_license as drvLic
INNER JOIN person AS p ON p.license_id = drvLic.id 
INNER JOIN facebook_event_checkin AS fbEv ON fbEv.person_id = p.id 
WHERE CAST(drvLic.height AS INTEGER) > 65 AND CAST(drvLic.height AS INTEGER) < 67 AND drvLic.hair_color == 'red' AND drvLic.car_make == 'Tesla'
AND fbEv.event_name == 'SQL Symphony Concert' AND INSTR(date,'201712') > 0;

SELECT * FROM income
WHERE ssn == '987756388';

-- The murderer is Jeremy Bowers who was contracted by Miranda Priestly.