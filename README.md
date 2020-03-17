# covid19
Experimenting with plotting data and parsing csv.
 
To compile you need following dependancies  
## install haxe 
[install haxe from here:](https://haxe.org/download/  )
  
once installed you need to setup haxelib ( set path for library, default is fine ) from terminal:  
`haxelib setup'  

## install libraries
**datetime** ( hardly used )  
`haxelib git datetime https://github.com/RealyUniqueName/DateTime.git 
  
**htmlHelper** my library for setting up html visuals and processing csv's could be used for WebGL  
render.   
`haxelib git htmlHelper https://github.com/nanjizal/htmlHelper.git`  
  
get the **covid19** github source  
`git clone https://github.com/nanjizal/covid19.git`  

## Compile locally
comment out with hash, the last line of *compile.hxml* if your on linux/pc, as it's setup to open browser on mac.    
`#-cmd open bin/index.html`
from terminal get haxe to compile the code:  
`haxe compile.hxml`
  
the index will be in the **bin** folder to run locally you need to adjust firefox to allow local files to run ( so it will load csv data ), or setup a local server or put online.

Currently I am just showing **March 13** by choice, you can easily manually adjust the if statement. Some data is probably not rendered - rather experimental test.
  
You can see it running here:
[https://nanjizal.github.io/covid19/bin/index.html?test1](https://nanjizal.github.io/covid19/bin/index.html?test1)

visual here:
<img width="1156" alt="covid19" src="https://user-images.githubusercontent.com/20134338/76690769-8513ea80-663b-11ea-9fc8-e99e8bb4d8ec.png">

## Internal notes:  
  
You can find latest **Covid19 data** from  
https://github.com/tomwhite/covid-19-uk-data  
To use the data do a search and replace on tab and replace with a comma.  

You can find details of mapping **Lat/Longtitude** to **Ordinance Survay Data** from:  
https://www.movable-type.co.uk/scripts/latlong-vincenty.html  
his extensive library  
https://github.com/chrisveness/geodesy  

this python link was however more specific and easier to port:  
https://scipython.com/book/chapter-2-the-core-python-language-i/additional-problems/converting-between-an-os-grid-reference-and-longitudelatitude/  
  
Data linking admin areas ( 9 digit number starting with e ) to lat/long positions is best found on 
  
https://www.doogal.co.uk/  
  
( OpenMaps can provides KLM data related to the admin areas, but licences are not MIT and require lot more effort to integrate but would make for an interesting extension. )

## Official Covid19 details for UK:
  
You can find uk.gov data direct from 

https://www.gov.uk/guidance/coronavirus-covid-19-information-for-the-public

and visualizations

https://www.arcgis.com/apps/opsdashboard/index.html

But hopefully this project can allow for more flexible possible generation and extensions utilizing Tom Whites collated data, than the direct gov links currently provide.
