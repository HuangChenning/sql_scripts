PROMPT +------------------------------------------------------------------------| 
PROMPT |     Level 1    PGA汇总信息                                                  |
PROMPT |     Level 2    SGA汇总信息                                                  |
PROMPT |     Level 4    UGA汇总信息                                                  |
PROMPT |     Level 8    当前调用的汇总信息（CGA）                                    |
PROMPT |     Level 16    用户调用的汇总信息（CGA）                                   |
PROMPT |     Level 32    Large Pool的汇总信息                                        |
PROMPT |     Level 1025    PGA详细信息                                               |
PROMPT |     Level 2050    SGA详细信息                                               |
PROMPT |     Level 5000    UGA详细信息                                               |
PROMPT |     Level 8200    当前调用的详细信息                                        |
PROMPT |     Level 16400    用户调用的详细信息                                       |
PROMPT |     Level 32800    Large Pool的详细信息                                     |
PROMPT +------------------------------------------------------------------------| 

ACCEPT level prompt 'Enter Search Level (i.e. 1) : '  
Alter session set events  'immediate trace name heapdump level &level';
@gettrcname
