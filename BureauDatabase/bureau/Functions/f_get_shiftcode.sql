
CREATE function [bureau].[f_get_shiftcode]
(
	 @starttime varchar(5)
)
	 returns char(1)
as

begin
	declare @shiftcode char(1)

	set @shiftcode = 
		 (select 
		 case
		 when @starttime >= '06:00' and @starttime < '12:00' then 'D'
		 when @starttime >= '12:00' and @starttime < '19:00' then 'E'
		 --when @starttime >= '19:00' and @starttime < '22:00' then 'E'
		 else 'N'
		 end) 
	return @shiftcode
end