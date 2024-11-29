alter session set timed_statistics = true;
alter session set max_dump_file_size = unlimited;

alter session set events '10046 trace name context forever, level 12';


PROMPT |alter session set events '10046 trace name context off';                              |

