# covid19
Experimenting with plotting data and parsing csv.
 
[ To compile you need following dependancies ](/compileCode.md)

You can see it running here:
[https://nanjizal.github.io/covid19/bin/index.html?test1](https://nanjizal.github.io/covid19/bin/index.html?test3)

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

and the **gov's** approach to visualizations, Manchester is slightly misleading the hotspot is London!!  
*( Not related to my visualization. )*

https://www.arcgis.com/apps/opsdashboard/index.html

But hopefully my project can allow for more flexible possible generation for any user wanting to experiment, and extensions utilizing Tom Whites collated data, in many more ways than the direct gov links they currently provide.
