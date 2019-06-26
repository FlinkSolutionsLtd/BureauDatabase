/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

--create emergency as a hospital
if not exists (select * from bureau.TLookup where description = 'Emergency dept' and domain_id = 7)
    begin
	   insert into bureau.TLookup(domain_id, code , description, sort_order)
	   values (7, '???????', 'Emergency dept', 4)
    end

--update locations in emergency to be under the emergency hospital
declare @emergencyLookupId int ;
set @emergencyLookupId = (select top 1 lk_id from bureau.TLookup where domain_id = 7 and description = 'Emergency dept');

if @emergencyLookupId is not null 
    begin
	   update bureau.TLocation set hospital_lk_id = @emergencyLookupId
	   where config_rpt_group = 'EMERGENCY DEPT';
    end

--remove MSS
delete from bureau.TLocation where loc_id = 22 and loc_description = 'MSS'; --this will leave orphans in the test system

--fix spelling
update bureau.TLocation set loc_description = 'Botany' where loc_description = 'Botony' and loc_id = 2;

--add new locations
--?

--update colours
update bureau.TLocation set config_rpt_colour = 'DarkOrange', config_rpt_font_colour = 'White' where config_rpt_group = 'Surgical';
update bureau.TLocation set config_rpt_colour = 'Tomato', config_rpt_font_colour = 'White' where config_rpt_group = 'Theatre';

update bureau.TLocation set config_rpt_colour = 'MediumOrchid', config_rpt_font_colour = 'White' where config_rpt_group = 'Maternity';

update bureau.TLocation set config_rpt_colour = 'PowderBlue', config_rpt_font_colour = 'Black' where config_rpt_group = 'Medical';
update bureau.TLocation set config_rpt_colour = 'CornflowerBlue', config_rpt_font_colour = 'White' where config_rpt_group = 'PAEDS';

update bureau.TLocation set config_rpt_colour = 'MediumAquamarine', config_rpt_font_colour = 'White' where config_rpt_group = 'Mental Health';

update bureau.TLocation set config_rpt_colour = 'LightGrey', config_rpt_font_colour = 'Black' where config_rpt_group = 'AHOP';

update bureau.TLocation set config_rpt_colour = 'Gold', config_rpt_font_colour = 'Black' where config_rpt_group = 'Emergency dept';
update bureau.TLocation set config_rpt_colour = 'PaleGoldenRod', config_rpt_font_colour = 'Black' where config_rpt_group = 'MMC';


--add new more locations
if not exists(select '' from bureau.TLocation where loc_description = 'Ritto Dialysis Western Campus' or loc_description = 'Theatre') 
    begin
	   insert into bureau.TLocation (loc_description, rc_code, hospital_lk_id, day_start, evening_start, night_start, config_rpt_colour, config_rpt_group, config_rpt_group_order, config_rpt_font_colour)
	   select 'Ritto Dialysis Western Campus','???-????',28,'06:00','14:00','21:00','PowderBlue','Medical',22,'Black'
	   union select 'Theatre','???-????',28,'06:00','14:00','21:00','Tomato','Theatre',42,'Black'
    end

--rename RECOVERY ROOM to PACU
update bureau.TLocation set loc_description = 'PACU' where loc_description = 'RECOVERY ROOM' and loc_id = 52;



--add even more locations
if not exists(select '' from bureau.TLocation where loc_description = 'MSC Satellite Dialysis' or loc_description = 'Scott Dialysis') 
    begin
	   insert into bureau.TLocation (loc_description, rc_code, hospital_lk_id, day_start, evening_start, night_start, config_rpt_colour, config_rpt_group, config_rpt_group_order, config_rpt_font_colour)
	   select 'MSC Satellite Dialysis','???-????',28,'06:00','14:00','21:00','PowderBlue','Medical',43,'Black'
	   union select 'Scott Dialysis','???-????',28,'06:00','14:00','21:00','PowderBlue','Medical',44,'Black'
    end



--change processing to be viewed instead
update bureau.TLookup set description = 'Viewed' where lk_id = 25 


--remove previous optiosn for bureau response
update bureau.TLookup 
set is_deleted = 1, modif_dttm = getdate(), modif_user = 'bureau_system'
where lk_id in(20,21,22,23,24)
and is_deleted = 0;

if not exists (select '' from bureau.TLookup where domain_id = 5 and description in('Resource Team','Casual Bureau','External') and is_deleted = 0) 
    begin
	   --new options
	   insert into bureau.TLookup (domain_id, code, description, sort_order)
	   select 5,'RSTM','Resource Team',1
	   union select 5,'CASL','Casual Bureau',2
	   union select 5,'EXTL','External',3;
    end



update bureau.Tlocation set rc_code = '211-3302',loc_description='B&A' where loc_id = 1
update bureau.Tlocation set rc_code = '213-2350',loc_description='Botany' where loc_id = 2
update bureau.Tlocation set rc_code = '211-2462',loc_description='GCU' where loc_id = 3
update bureau.Tlocation set rc_code = '211-2460',loc_description='Maternity North ' where loc_id = 4
update bureau.Tlocation set rc_code = '211-2460',loc_description='Maternity South' where loc_id = 5
update bureau.Tlocation set rc_code = '211-2455',loc_description='Maternity Ward 21' where loc_id = 6
update bureau.Tlocation set rc_code = '217-2350',loc_description='Papakura ' where loc_id = 7
update bureau.Tlocation set rc_code = '214-2350',loc_description='Pukekohe ' where loc_id = 8
update bureau.Tlocation set rc_code = '211-2465',loc_description='35E KORIPIKO' where loc_id = 9
update bureau.Tlocation set rc_code = '211-2303',loc_description='HUIA' where loc_id = 10
update bureau.Tlocation set rc_code = '211-2302',loc_description='KUAKA' where loc_id = 11
update bureau.Tlocation set rc_code = '211-2304',loc_description='TUI' where loc_id = 12
update bureau.Tlocation set rc_code = '221-2353',loc_description='ASRU' where loc_id = 13
update bureau.Tlocation set rc_code = '211-2223',loc_description='WARD 23' where loc_id = 14
update bureau.Tlocation set rc_code = '211-2224',loc_description='WARD 24' where loc_id = 15
update bureau.Tlocation set rc_code = '211-2474',loc_description='WARD 31' where loc_id = 16
update bureau.Tlocation set rc_code = '211-2226',loc_description='WARD 4' where loc_id = 17
update bureau.Tlocation set rc_code = '211-2464',loc_description='WARD 5' where loc_id = 18
update bureau.Tlocation set rc_code = '211-3048',loc_description='ASSU' where loc_id = 19
update bureau.Tlocation set rc_code = '211-3048',loc_description='ED' where loc_id = 20
update bureau.Tlocation set rc_code = '211-3005',loc_description='MAU' where loc_id = 21
update bureau.Tlocation set rc_code = '211-3048',loc_description='PED' where loc_id = 23
update bureau.Tlocation set rc_code = '211-3049',loc_description='SAU' where loc_id = 24
update bureau.Tlocation set rc_code = '211-2356',loc_description='CCU' where loc_id = 25
update bureau.Tlocation set rc_code = '211-3505',loc_description='GASTRO' where loc_id = 26
update bureau.Tlocation set rc_code = '211-2201',loc_description='WARD 1' where loc_id = 27
update bureau.Tlocation set rc_code = '211-2203',loc_description='WARD 2' where loc_id = 28
update bureau.Tlocation set rc_code = '211-2208',loc_description='WARD 32N' where loc_id = 29
update bureau.Tlocation set rc_code = '211-2209',loc_description='WARD 33E' where loc_id = 30
update bureau.Tlocation set rc_code = '211-2202',loc_description='WARD 33N' where loc_id = 31
update bureau.Tlocation set rc_code = '211-2204',loc_description='WARD 6' where loc_id = 32
update bureau.Tlocation set rc_code = '211-2205',loc_description='WARD 7' where loc_id = 33
update bureau.Tlocation set rc_code = '211-5235',loc_description='DISCHARGE LOUNGE ' where loc_id = 34
update bureau.Tlocation set rc_code = '211-5207',loc_description='TRANSIT CARE ' where loc_id = 35
update bureau.Tlocation set rc_code = '211-2451',loc_description='KIDZ MED' where loc_id = 36
update bureau.Tlocation set rc_code = '211-2450',loc_description='KIDZ SURG' where loc_id = 37
update bureau.Tlocation set rc_code = '211-3037',loc_description='NNU' where loc_id = 38
update bureau.Tlocation set rc_code = '211-5208',loc_description='HDU' where loc_id = 39
update bureau.Tlocation set rc_code = '211-3002',loc_description='ICU' where loc_id = 40
update bureau.Tlocation set rc_code = '212-2463',loc_description='MSC1' where loc_id = 41
update bureau.Tlocation set rc_code = '212-3650',loc_description='MSC2' where loc_id = 42
update bureau.Tlocation set rc_code = '211-2214',loc_description='NAT BURNS UNIT' where loc_id = 43
update bureau.Tlocation set rc_code = '211-2219',loc_description='WARD 10' where loc_id = 44
update bureau.Tlocation set rc_code = '211-2218',loc_description='WARD 11' where loc_id = 45
update bureau.Tlocation set rc_code = '211-2211',loc_description='WARD 34E' where loc_id = 46
update bureau.Tlocation set rc_code = '211-2212',loc_description='WARD 34N' where loc_id = 47
update bureau.Tlocation set rc_code = '211-2215',loc_description='WARD 35N' where loc_id = 48
update bureau.Tlocation set rc_code = '211-2220',loc_description='WARD 8' where loc_id = 49
update bureau.Tlocation set rc_code = '211-2221',loc_description='WARD 9' where loc_id = 50
update bureau.Tlocation set rc_code = '211-3055',loc_description='PSU' where loc_id = 51
update bureau.Tlocation set rc_code = '211-3055',loc_description='PACU' where loc_id = 52
update bureau.Tlocation set rc_code = '211-3055',loc_description='TADU' where loc_id = 53
update bureau.Tlocation set rc_code = '212-3516',loc_description='MSC Ritto Dialysis ' where loc_id = 54
update bureau.Tlocation set rc_code = '211-3055',loc_description='Theatre' where loc_id = 55
update bureau.Tlocation set rc_code = '212-3014',loc_description='MSC Intercentre Dialysis' where loc_id = 56
update bureau.Tlocation set rc_code = '211-3517',loc_description='Scott Dialysis' where loc_id = 57







--new action options
if not exists (select '' from bureau.TLookup where domain_id = 4 and description in('Own Staff','Redeployed') and is_deleted = 0) 
    begin
	   --new options
	   insert into bureau.TLookup (domain_id, code, description, sort_order)
	   select 4,'RDPL','Redeployed',6
	   union select 4,'OWST','Own Staff',7	   
    end













--resequence location sort order

;with newSeqs as (
    select loc_id, ROW_NUMBER() over(order by config_rpt_group, loc_description) as newSeq
    from bureau.TLocation
)
update loc
set config_rpt_group_order = newSeqs.newSeq
from bureau.TLocation loc
    inner join newSeqs on loc.loc_id = newSeqs.loc_id;



