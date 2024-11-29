#BEGIN { print("\nStarting Systemstate %d\n");

/^Node/ { printf($2"\t"$4" "$5"\t") }
/^#cpus/ {
    for(i=1;i<=NF;i++)
    if($i ~ /cpu:/ )
        {cpu=0;cpu=i+1;}
    else if($i ~ /cpuq:/ )
        {cpuq=0;cpuq=i+1;}
    else if ($i ~ /physmemfree:/ )
        {physmemfree=0;physmemfree=i+1;}
    else if($i ~ /swapfree:/ )
        {swapfree=0;swapfree=i+1;}
        printf($cpu"\t"$cpuq"\t"$physmemfree"\t"$swapfree"\n")
    }
