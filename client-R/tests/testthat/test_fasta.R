SERVER_URL <- 'http://gfe.b12x.org/'


test_that("Get GFE from fasta file",{

  host      <- SERVER_URL
  fastafile <- "fastatest1.fasta"
  locus     <- "HLA-A"
  gfe       <- fasta2gfe(host, locus, fastafile)

  print(gfe)
  expect_false(is.null(gfe))
  expect_true(is.list(gfe))

  expect_that(as.character(unlist(gfe$subjects[[1]]$id[[1]])), equals("AA44444"))
  expect_that(as.character(unlist(gfe$subjects[[1]]$typingData[[1]]$typing[[1]]$gfe[[1]])), equals("HLA-Aw1-1-7-20-10-32-7-1-1-1-6-1-5-3-5-1-1"))

})

