#!/usr/bin/env nextflow

params.fasta         = ""
params.output        = ""
params.name          = ""
outputDir            = file("${params.output}")

// Extracting consensus sequences
process extractConsensus{
  
  tag{ expected }

  input:
    set file(expected) from file("${params.fasta}")

  output:
    set file('*.txt') into fastaFiles mode flatten

  """
    breakup-fasta < ${expected}
  """
}


//Get GFE For each sequence
process getGFE{
  errorStrategy 'ignore'

  tag{ fastafile }

  input:
    set file(fastafile) from fastaFiles

  output:
    set file {"*.txt"}  into gfeResults mode flatten

  """
    cat ${fastafile} | fasta2structure
  """
}

gfeResults
.collectFile() {  gfe ->
       [ "${params.name}.txt", gfe.text ]
   }
.subscribe { file -> copyToFailedDir(file) }


//Copy file to output directory
def copyToFailedDir (file) { 
  log.info "Copying ${file.name} into: $outputDir"
  file.copyTo(outputDir)
  def copiedFile = new File( "${params.output}/${file.name}" )
  log.info copiedFile.name
  if( !copiedFile.exists() ) {
    log.info "Failed to copy file copiedFile.name ${file.name} into: $outputDir"
  }else{
    log.info "Copied $copiedFile ${file.name} into: $outputDir"
  }
}

//Get subject id from fasta file
def subjectId(Path path) {
  def name      = path.getFileName().toString()
  def subject   = name.split('_')
  return subject[0]
}

//Get subject id from fasta file
def blastSubjectId(Path path) {
  def fileName  = path.getFileName().toString()
  def subject   = fileName.split('.txt')
  return subject[0]
}






