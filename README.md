
# EKR converter



## Getting Started

The package is not yet released. You can download the package and install it locally. Here is how you can do it:  
1.	Click on the Code button and then click on Download ZIP.
2.	Save the ZIP file to your local folder.
3.	Use the line below to install the package from local directory.
```
install.packages("path_to_you_folder/ekrConverter_0.0.0.9000.tar.gz", repos = NULL, type = "source")
```    

#### Install directly from GitHub is not yet available.  


### Prerequisites

Packages tidyverse and data.table are required to run the functions in this package. If you do not have these packages installed, you can install them using the following code:

```
install.packages(c("tidyverse", "data.table"))
library(ekrConverter)
library(data.table)
library(tidyverse)
```

### How to use the functions

check what functions are available in the package

```
lsf.str(package:ekrConverter)
```

### Demo

```
# convert 10.99 ug/L Chlorophyll-a (water type M10) to EKR
  to_ekr(10.99, "M10", "chlfa")

# convert EKR 0.84 Chlorophyll-a (water type M10) to concentration in ug/L
  van_ekr(0.84, "M10", "chlfa")

# convert 73% coverage submers plant (water type M14) to EKR
  to_ekr(73, "M14", "submerse")

# convert EKR 0.2 coverage submerse (water type M14) to coverage submers plant in %
  van_ekr(1, "M14", "submerse")

# convert 73% coverage floating leaf (water type M14) to EKR
  to_ekr(73, "M14", "drijvblad")

# convert EKR 0.2 coverage floating leaf (water type M14) to coverage floating leaf in %
  van_ekr(0.2, "M6", "drijvblad")

```




### remove the package
    
```
detach("package:ekrConverter", unload=TRUE)
remove.packages("ekrConverter")
```

## Built With

* [Rshiny](https://shiny.rstudio.com/) - The web framework used

## Contributing

Please read [CONTRIBUTING.md](add link later) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](add link later). 

## Authors

* **Liang Yu** - *Initial work and development* - [lyu-project]
* **Gerard ter Heerdt** - *Initial work*


See also the list of [contributors](add link later) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Marleen van Dusseldorp, Waternet
