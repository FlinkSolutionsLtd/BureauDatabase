create procedure [bureau].[sp_get_lookup_value]
	 @lkid varchar(10)
as

select description from TLookup where lk_id = cast(@lkid as int)