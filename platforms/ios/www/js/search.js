<!-- Begin copyright - This must be retained and posted as is to use this script -->

// This Script was created by Satadip Dutta. 
// Email: sat_dutta@post1.com  / satadipd@inf.com 
// URL:http://www.angelfire.com/sd/dutta
// Please honor my hard work, if you use a variant of this in your page, 
// then please email me :) and keep these comments in the Script.
// This code is Copyright (c) 1997 Satadip Dutta
// all rights reserved.
// License is granted to user to reuse this code on their own Web site 
// if, and only if, this entire copyright notice is included. The Web Site
// containing this  script   must be a not-for-profit ( non-commercial ) web site. If the script is to be used in a commercial   
// website exclusive permission must be obtained before using it.
// Joe Burns of htmlgoodies.com has been authorised to use this code in the
// site htmlgoodies.com.

<!-- End copyright - This must be retained and posted as is to use this script -->

title = new Object();
desc = new Object();
links= new Object();
matched= new Object();
keywords= new Object();
found= new Object();
var temp=0;
// actual location or the item to be searched
// description of he location
// actual link
// percentage match found
// keywords as parsed from the input
// # of titles present in the database
title[0]=10
//no of keywords after parsing
keywords[0]=0
//no of  matches found.
found[0]=0

<!-- Begin List of Searchable Items -->


title[1]="award awards"
desc[1]="The HTML Goodies Site Awards"
links[1]="http://dutta.home.ml.org"
matched[1]=0

title[2]="yahoo search engine"
desc[2]=" the yahoo search engine "
links[2]=" http://www.yahoo.com"
matched[2]=0

title[3]=" lycos search engine"
desc[3]="The lycos search engine  "
links[3]=" http://www.lycos.com"
matched[3]=0

title[4]=" infoseek search Engine"
desc[4]="The Infoseek Search Engine  "
links[4]=" http://www.infoseek.com"
matched[4]=0

title[5]="goodies java script video html scanning links academic joe burns"
desc[5]="The HTML Goodies Domain - Home Page"
links[5]="http://www.htmlgoodies.com"
matched[5]=0

title[6]="java scripts submit html goodies color text scrolling text display javascript"
desc[6]="Java Goodies - Striving to be the largest collection of Java Scripts on the World Wide Web"
links[6]="http://www.htmlgoodies.com/javagoodies/"
matched[6]=0


<!-- End list of Searchable items -->

function search(){
// get the input from the input by the user and strip it into keywords
//+
var skeyword=document.searchengine.keywords.value.toLowerCase();
var check=1;
var pos=0;
var i=0;
var j=0;
var  itemp=0;
var config='';

while (true)
	{
	if (skeyword.indexOf("+") == -1 )
		{
		keywords[check]=skeyword;
		break;
		}
	pos=skeyword.indexOf("+");
	if (skeyword !="+")	
	{
	keywords[check]=skeyword.substring(0,pos);
	check++;
	}
	else
	{
	check--;
	break;
	}
	skeyword=skeyword.substring(pos+1, skeyword.length);	
	if (skeyword.length ==0)
		{
		check--;
		break;
		}
			 
	}
// the keywords have been put in keywords object.
keywords[0]=check;
//alert(check);
// matching and storing the matches in matched
for ( i=1; i<=keywords[0];i++)
	{
	for (j=1;j<=title[0];j++)
		{
		if (title[j].toLowerCase().indexOf(keywords[i]) > -1 )
			{
			  matched[j]++;
			}
		}	
	}
// putting all the indexes of the matched records  in found

for (i=1;i<=title[0];i++)
{
	if (matched[i] > 0 )
		{
		  found[0]++;
		// increment the found 	
		  found[found[0]]=i;
			
		}	
}
//alert("found 0 " +  found[0]);
// sort the list as per max percentage of matches


for (i=1;i<=found[0]-1;i++)
	{
	for(j=i+1;j<=found[0];j++)
		{
		if ( matched[found[i]]< matched[found[j]] )
			{
			temp= found[j];
			found[j]=found[i];
			found[i]=temp;
			}
		}
	}



// end of sort

// prepare for document write.
config='toolbar=no,location=no,directories=no,status=no,menubar=no,' 
config += 'scrollbars=yes,resizable=yes' 
output = window.open ("","outputwindow",config) 
output.document.write('<title> Goodies Search Results </title>');
output.document.write('<BODY bgcolor=#ffffff  text=#000000  link=#990099 vlink =#339966 >');

output.document.write('<center> <h1>Goodies Search Results </h1></center>');    
output.document.write('<hr>');
output.document.write(' The Keyword(s) you searched :: '.big() )
for (i=1;  i<=keywords[0]; i++)
	{
	output.document.write( keywords[i].bold() +"   ");
	}
output.document.write('<br>');

if (found[0]==0)
	{
	//alert(found[0]);
	 output.document.write('<hr>');
	 output.document.write("<b>No matches resulted in this search </b> <br>");
	output.document.write("You may close the results and reduce the length/number  of the keywords  <br>");
	}
else
	{
	// data has been found
	output.document.write(" <hr> <b> The Results of the search are  : </b>  ");
	output.document.write( found[0] +"  Entries found  ".italics());
	output.document.write("<table border=1 width=100%>");
	for (i=1; i<=found[0];i++)
		{
		output.document.write("<tr><td valign=top bgcolor=#9999ff>");
		output.document.write("<h3>" +i +"</h3>");
		output.document.write("<td valign=top>");
		itemp=found[i];
		output.document.write(desc[itemp].bold() +"<br>" +
links[itemp].link(links[itemp])+"<br>");
		temp= (matched[itemp]/keywords[0])*100
		output.document.write("<i> Matched  with keywords  :: " +temp+" %  </i>" );
		matched[itemp]=0
		} 
	found[0]=0;
	output.document.write("</table>");
	}
output.document.write ('This search was created by   &copy <a href="http:\\dutta.home.ml.org"> Satadip Dutta</a>    1997');
output.document.write ("<hr>");
output.document.write ("<form><center>") 
output.document.write ("<input type='button' value='Start Another Search' onClick = 'self.close()'>") 
output.document.write ("</center></form>") 
}
</script>
