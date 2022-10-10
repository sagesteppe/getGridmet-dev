# Create a function to download data

Get_Gridmet <- function(product_type, start_year, end_year, destination){
  
  #' 'This function takes data from Gridmet and downloads it to your device   
  #' 'Arguments'
  #' product types = a vector or one of : "bi","erc","etr","fm100", "fm1000", pet","pr","rmax","rmin"
  #' start year = needs to be > 1979
  #' end year = current year or less
  #' destination = location where raw data is downloaded 


  # bowling with bumpers
  start_year <- as.numeric(as.numeric(start_year))
  end_year <- as.numeric(as.numeric(end_year))
  start_year <- replace(start_year, start_year < 1979, 1979)
  end_year <- replace(end_year, end_year > gsub('-[0-9]{2}', "", Sys.Date()), 
                      gsub('-[0-9]{2}', "", Sys.Date()))
  #make a vector of valid data products 
  product_output <- c("bi","eddi,", "erc","etr","fm100", "fm1000", 
                      "hash", "pet","pr","rmax","rmin", "spei", 
                      "sph","spi","srad", "th",  "tmmn","tmmx",
                      "vpd","vs","z") 
  #If product does not exist, stop the function 
  stopifnot(product_type %in% product_output)
  
  # variable declaration
  URL = "https://www.northwestknowledge.net/metdata/data"
  target_years <-  seq.int(from = start_year, to = end_year)
  product_types <- rep(product_type, each = length(target_years))
  fname <- paste0(product_types, "_", target_years, ".nc")
  test_URL = paste0(URL,'/', fname)
  
  mainDir <- file.path(destination, "Gridmet")
  subDir <- product_type
  destinations <- file.path(mainDir, subDir, fname)
  
  initial_timeout <- getOption('timeout')
  options(timeout=7200)
  
  ifelse(!dir.exists(file.path(mainDir)), 
         dir.create(file.path(mainDir)), FALSE)
  ifelse(!dir.exists(file.path(mainDir, subDir)), 
         dir.create(file.path(mainDir, subDir)), FALSE)
  
 download.file(test_URL, destinations)

  Sys.sleep(3)
  options(timeout = initial_timeout)

}

Get_Gridmet(product_type = "fm100", start_year = 1999, end_year = 2001,
            destination = "/media/sagesteppe/External HD/Get_Gridmet/Data/Raw")


