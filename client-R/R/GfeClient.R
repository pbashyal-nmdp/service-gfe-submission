


httpHeaders <- c(Accept = "application/json",
                 'Content-Type' = 'application/json;charset=UTF-8')
library(rjson)
library(RCurl)

#' seq2gfe
#'
#' @param data.frame
#' @export
#' @examples
#' seq2gfe()
seq2gfe <- function(host, locus, sequence) {
  
  
  url     <- paste0(host, 'api/v1/gfe')
  patient <- list(locus=locus, sequence=sequence, verbose=0,structures=0)
  
  request <- rjson::toJSON(patient)

  reader <- RCurl::basicTextGatherer()
  status <- RCurl::curlPerform(url = url,
                               httpheader = httpHeaders,
                               postfields = request,
                               writefunction = reader$update)
  
 
  if(status == 0) {

    jsonResponse <- reader$value()
    response <- rjson::fromJSON(jsonResponse)
    return(as.data.frame(response))
    
  }
  
  NULL
  
}


#' fasta2gfe
#'
#' @param data.frame
#' @export
#' @examples
#' fasta2gfe()
fasta2gfe <- function(host, locus, fastaFile) {
  
  
  url <- paste0(host, 'api/v1/fasta')
  print(paste0("URL: ",url))
  patient <- list(locus=locus, file=fastaFile, verbose=0,structures=0)
  
  request <- rjson::toJSON(patient)

  reader <- RCurl::basicTextGatherer()
  status <- RCurl::curlPerform(url = url,
                               httpheader = httpHeaders,
                               postfields = request,
                               writefunction = reader$update)
  
 
  if(status == 0) {

    jsonResponse <- reader$value()
    response <- rjson::fromJSON(jsonResponse)
    return(response)
    
  }
  
  NULL
  
}

#' hml2gfe
#'
#' @param data.frame
#' @export
#' @examples
#' hml2gfe()
hml2gfe <- function(host, locus, hmlFile) {
  
  
  url <- paste0(host, 'api/v1/hml')
  print(paste0("URL: ",url))
  patient <- list(file=hmlFile, verbose=0,structures=0)
  
  request <- rjson::toJSON(patient)

  reader <- RCurl::basicTextGatherer()
  status <- RCurl::curlPerform(url = url,
                               httpheader = httpHeaders,
                               postfields = request,
                               writefunction = reader$update)
  
 
  if(status == 0) {

    jsonResponse <- reader$value()
    response <- rjson::fromJSON(jsonResponse)
    return(response)
    
  }
  
  NULL
  
}


#' gfe2seq
#'
#' @param data.frame
#' @export
#' @examples
#' gfe2seq()
gfe2seq <- function(host, locus, gfe) {
  
  
  url <- paste0(host, 'api/v1/sequence')
  patient <- list(locus=locus, gfe=gfe, verbose=0, structures=0)
  
  request <- rjson::toJSON(patient)
  
  reader <- RCurl::basicTextGatherer()
  status <- RCurl::curlPerform(url = url,
                               httpheader = httpHeaders,
                               postfields = request,
                               writefunction = reader$update)

  if(status == 0) {

    jsonResponse <- reader$value()
    response <- rjson::fromJSON(jsonResponse)
    return(as.data.frame(response))
    
  }
  
  NULL
  
}
