#!/bin/ksh
#
fn_addr_value(){
echo $1|awk -F\: '{ printf ("\taddress:%s ",$3);  }'
echo $1|awk -F\: '{ printf (" value:0x%s \n",$NF);}'
}

shift=0x1
#Skip the header file
cat $1|grep "M\:" |while read _line
do
[ $(echo $_line|cut  -d \: -f 1 ) == "M"  ] && { 

   _field_counter=5
   _stack_counter=1
   _stack_depth=$(echo $_line|awk -F\: '{ print NF-5 }')
   fn_addr_value $_line

   printf "\tstack\n"
   printf "\t=====\n"

   while [ $_stack_counter -le $_stack_depth  ]
   do
   ((_stack_counter=$_stack_counter+1))
                #
                # see also : addr2line --help
                #
                addr=$(echo $_line |cut -d \: -f $_field_counter)
                set -A function $(addr2line -e $(which oracle) $addr -f )
                printf "\t%s\t    %s\n" $addr ${function[0]}

    ((_field_counter=$_field_counter+1))
    done
    printf "\n"
}
done