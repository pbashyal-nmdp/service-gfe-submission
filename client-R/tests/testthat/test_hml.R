SERVER_URL <- 'http://gfe.b12x.org/'


test_that("Get GFE from fasta file",{

  host <- SERVER_URL
  
 # marrowcount  <- seq2gfe(host, locus, seq)


  expect_false(is.null(host))
  #expect_true(is.list(searchmarrow))

  #expect_that(nrow(searchmarrow), equals(marrowcount))


})
