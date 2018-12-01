

create function [bureau].[f_multivalueparam](@String nvarchar(4000), @Delimiter char(1))
RETURNS @Results TABLE (value nvarchar(4000))
AS

  --this function takes two parameters; the first is the delimited string, the second is the delimiter
    BEGIN
    DECLARE @INDEX INT
    DECLARE @SLICE nvarchar(4000)
    -- HAVE TO SET TO 1 SO IT DOESNT EQUAL Z
    --     ERO FIRST TIME IN LOOP
    SELECT @INDEX = 1
  
    IF @String IS NULL RETURN
    WHILE @INDEX !=0


        BEGIN    
            -- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER
            SELECT @INDEX = CHARINDEX(@Delimiter,@STRING)
            -- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE
            IF @INDEX !=0
                SELECT @SLICE = LEFT(@STRING,@INDEX - 1)
            ELSE
                SELECT @SLICE = @STRING
            -- PUT THE ITEM INTO THE RESULTS SET
            INSERT INTO @Results(value) VALUES(@SLICE)
            -- CHOP THE ITEM REMOVED OFF THE MAIN STRING
            SELECT @STRING = RIGHT(@STRING,LEN(@STRING) - @INDEX)
            -- BREAK OUT IF WE ARE DONE
            IF LEN(@STRING) = 0 BREAK
    END

    RETURN
END