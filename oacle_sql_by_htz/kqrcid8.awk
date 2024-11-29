# kqrcid8.awk 
# tested using RHAS 4.1 and gawk-3.1.3-10.1
BEGIN {
 ON=1;
 OFF=0;
 cnt=0;
 cid=0;
 BG=1;
 ED=0;
 BIGEN=1;
 LITEN=0;

 endset=BIGEN;
 }

# Get Row Cache Id
function GetCacheId(ln){
 gsub("\\("," ",ln);
 gsub("\\)"," ",ln);
 gsub("="," ",ln);
 split(ln,cx);
 return(cx[8]);
}

# Print b4
function PrintB4(bfour)
{
 for(k=0 ; k<=3; k++)
 {
 PrintC(GetBytes(bfour,k));
 }
}

# Get Object Name
function GetObjName(ln,idx)
{
 # first line
 if ( idx == 0 )
 {
 split(ln,cx);
 NameLen=GetNameLen(cx[2]);

 for( i=2 ; i<8 ; i++ )
 {

 if( DEBUG )
 printf("[%s]",cx[i]);

 b4=swap(cx[i],endset);

 if( i == 2 )
 {
 if( DEBUG )
 printf("[0x%s][0x%s]",GetBytes(b4,2),GetBytes(b4,3));

 bc=2;
 PrintC(GetBytes(b4,2));
 PrintC(GetBytes(b4,3));
 }
 else
 PrintB4(b4);
 bc+=4;
 }
 }

 # second line
 if( idx == 1 )
 {
 split(ln,cx);

 if( cx[1] != "00000000" )
 {
 b4=swap(cx[1],endset);
 PrintB4(b4);

 }

 if( cx[3] != "00000000" )
 {
 printf("\n\t\t +\n");
 printf("\t\t |\n");
 printf("\t\t +----> part/subpart: ");
 for( i=3 ; i<8 ; i++ )
 {
 b4=swap(cx[i],endset);
 PrintB4(b4);
 }
 }
 }
}

# Print Single Char
function PrintC(ub1)
{
 h1=sprintf("0x%s",ub1);
 if ( h1 != "0x00" )
 printf("%c",strtonum(h1));
}

# Get Byte
function GetBytes(b4,idx)
{
 b1=substr(b4,(2*idx)+1,2);
 return(b1);
}

# Get Object Name Len
function GetNameLen(ln)
{
 NameLen=sprintf("0x%s",substr(swap(ln,endset),1,2));
 return(strtonum(NameLen));
}

function GetObjId(ln)
{
 split(ln,obid);
 id=sprintf("0x%s",obid[4]);
 did=sprintf("0x%s",obid[6]);
 printf(" obj: %i dataobj: %i\n",strtonum(id),strtonum(did));
}

# Endian Conversion
function swap(b4,en)
{
 if( en == LITEN )
 {
 f1=substr(b4,7,2)
 f2=substr(b4,5,2)
 f3=substr(b4,3,2)
 f4=substr(b4,1,2)
 bo=sprintf("%s%s%s%s",f1,f2,f3,f4);
 }

 if( en == BIGEN )
 bo=b4; # NOP
 return(bo);
}

( $0 ~ / row cache parent object/ ) { cid=GetCacheId($0) }

( f1 == BG ) && ( $1 != "data=" ) && ( $1 != "BUCKET" ) {
 buffer[cnt]=$0;
 cnt++;
 }

( $1 == "data=") && ( cid == 8 ) { f1=BG }

# The end of object name
( f1 == BG ) && ( $1 ~ /BUCKET/ ) {
 f1=ED;

 gsub(":"," ",$2);
 bucket=$2

 printf("bucket: %i ",bucket);
 GetObjName( buffer[0] , 0 );
 GetObjName( buffer[1] , 1 );
 GetObjId( buffer[7] );
 # reset buffer counter
 cnt=0;
}