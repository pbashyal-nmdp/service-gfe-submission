


httpHeaders <- c(Accept = "application/json",
                 'Content-Type' = 'application/json;charset=UTF-8')


library('httr')
library('rjson')
library('RCurl')

#' seq2gfe
#'
#' @param data.frame
#' @export
#' @examples
#' seq2gfe()
seq2gfe <- function(host, locus, sequence,verbose = 0, structures = 0) {
  
  
  url     <- paste0(host, 'api/v1/gfe')
  patient <- list(locus=locus, sequence=sequence, verbose=verbose,structures=structures)
  
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
fasta2gfe <- function(host, locus, fastaFile,verbose = 0, structures = 0) {
  
  url           <- paste0(host, 'api/v1/fasta')
  response      <- POST(url, body = list(file = upload_file(fastaFile),locus = locus, structures = structures, verbose = verbose))
  data.response <- content(response)
  status.code   <- response$status_code

  return(data.response)
  
}

#' hml2gfe
#'
#' @param data.frame
#' @export
#' @examples
#' hml2gfe()
hml2gfe <- function(host, hmlFile,verbose = 0, structures = 0) {
  
  url           <- paste0(host, 'api/v1/hml')
  response      <- POST(url, body = list(file = upload_file(hmlFile), structures = structures, verbose = verbose))
  data.response <- content(response)
  status.code   <- response$status_code
  
  return(data.response)
}


#' gfe2seq
#'
#' @param data.frame
#' @export
#' @examples
#' gfe2seq()
gfe2seq <- function(host, locus, gfe,verbose = 0, structures = 0) {
  
  
  url <- paste0(host, 'api/v1/sequence')
  patient <- list(locus=locus, gfe=gfe, verbose=verbose, structures=structures)
  
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
