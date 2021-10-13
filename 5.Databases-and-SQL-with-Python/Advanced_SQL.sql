--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT S.NAME_OF_SCHOOL, C.COMMUNITY_AREA_NAME, S.AVERAGE_STUDENT_ATTENDANCE
FROM CHICAGO_PUBLIC_SCHOOLS AS S 
LEFT JOIN CENSUS_DATA AS C 
ON C.COMMUNITY_AREA_NUMBER = S.COMMUNITY_AREA_NUMBER
WHERE HARDSHIP_INDEX = 98;

--Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name
SELECT CRI.CASE_NUMBER, CRI.PRIMARY_TYPE, CEN.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA AS CRI
LEFT JOIN CENSUS_DATA AS CEN ON CRI.COMMUNITY_AREA_NUMBER = CEN.COMMUNITY_AREA_NUMBER
WHERE CRI.LOCATION_DESCRIPTION LIKE 'SCHOOL%';

CREATE VIEW schools_view (School_Name, Safety_Rating, Family_Rating, 
			Environment_Rating, Instruction_Rating, Leaders_Rating, Teachers_Rating)
AS SELECT NAME_OF_SCHOOL, Safety_Icon, Family_Involvement_Icon, Environment_Icon,
			Instruction_Icon, Leaders_Icon, Teachers_Icon
FROM CHICAGO_PUBLIC_SCHOOLS;


SELECT * FROM schools_view;


SELECT school_name, leaders_rating FROM schools_view;

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE( 
    IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL                        -- Language used in this routine 
MODIFIES SQL DATA                      -- This routine will only read data from the table

BEGIN 

	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	WHERE School_ID = in_School_ID;
	
    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN                           -- Start of conditional statement
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very_weak'
        WHERE School_ID = in_School_ID;
    
    ELSEIF in_Leader_Score < 40 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Weak'
        WHERE School_ID = in_School_ID;
        
    ELSEIF in_Leader_Score < 60 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Average'
        WHERE School_ID = in_School_ID;   
        
    ELSEIF in_Leader_Score < 80 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Strong'
        WHERE School_ID = in_School_ID;  
        
    ELSEIF in_Leader_Score < 100 THEN
        UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET Leaders_Icon = 'Very strong'
        WHERE School_ID = in_School_ID; 
        
    ELSE 
    	ROLLBACK WORK;

    END IF;  
    
    COMMIT WORK;

END
@                                   -- Routine termination character
