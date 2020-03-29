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
  
**uk** my library for providing an outline of UK  
`haxelib git uk http://github.com/nanjizal/uk.git`  
  
**latLongUK** my library for providng latitude and longitude to ordnance survey conversion.  
`haxelib git latLongUK http://github.com/nanjizal/latLongUK.git`  
  
**pallette** my library for providing colors  
`haxelib git pallette http://github.com/nanjizal/pallette.git`  
  
get the **covid19** github source  
`git clone https://github.com/nanjizal/covid19.git`  

## Compile locally
comment out with hash, the last line of *compile.hxml* if your on linux/pc, as it's setup to open browser on mac.    
`#-cmd open bin/index.html`
from terminal get haxe to compile the code:  
`haxe compile.hxml`
  
the index will be in the **bin** folder to run locally you need to adjust firefox to allow local files to run ( so it will load csv data ), or setup a local server or put online.

  
You can see it running here:
[https://nanjizal.github.io/covid19/bin/index.html?test5](https://nanjizal.github.io/covid19/bin/index.html?test5)
