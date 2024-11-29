
alter session set events 'immediate trace name flush_cache level 1';          

PROMPT |--------------------------------------------------------------------------------------|
PROMPT |alter session set events = 'immediate trace name flush_cache';                        |
PROMPT |alter system set events = 'immediate trace name flush_cache';                         |
PROMPT |alter system flush buffer_cache;                                                      |
PROMPT |--------------------------------------------------------------------------------------|

