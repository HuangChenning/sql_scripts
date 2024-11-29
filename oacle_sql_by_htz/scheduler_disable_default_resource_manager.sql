/*++ set the current resource manager plan to null (or another plan that is not restrictive): */
alter system set resource_manager_plan='' scope=both
/*change the active windows to use the null resource manager plan (or other nonrestrictive plan) using: */

execute dbms_scheduler.set_attribute('WEEKNIGHT_WINDOW','RESOURCE_PLAN','');
execute dbms_scheduler.set_attribute('WEEKEND_WINDOW','RESOURCE_PLAN','');

/*For 11g, you need to change those too:*/

execute dbms_scheduler.set_attribute('SATURDAY_WINDOW','RESOURCE_PLAN',''); 
execute dbms_scheduler.set_attribute('SUNDAY_WINDOW','RESOURCE_PLAN','');
execute dbms_scheduler.set_attribute('MONDAY_WINDOW','RESOURCE_PLAN',''); 
execute dbms_scheduler.set_attribute('TUESDAY_WINDOW','RESOURCE_PLAN','');
execute dbms_scheduler.set_attribute('WEDNESDAY_WINDOW','RESOURCE_PLAN',''); 
execute dbms_scheduler.set_attribute('THURSDAY_WINDOW','RESOURCE_PLAN','');
execute dbms_scheduler.set_attribute('FRIDAY_WINDOW','RESOURCE_PLAN','');	