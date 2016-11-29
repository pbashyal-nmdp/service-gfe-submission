#!/usr/bin/env nextflow

params.hml           = ""
params.output        = ""
params.name          = ""
outputDir            = file("${params.output}")

// Extracting consensus sequences
process extractConsensus{

  input:
    set file(expected) from file("${params.hml}")

  output:
    set file(expected), file('*.gz') into fastqFiles mode flatten

  """
    ngs-extract-consensus -i ${expected}
  """
}

subjectIdFiles = fastqFiles.map{ hml, fileIn ->
  tuple(subjectId(fileIn), fileIn, hml ) 
}

//Get GFE For each sequence
process getGFE{
  errorStrategy 'ignore'

  tag{ subject }

  input:
    set subject, file(subjectFastq), file(hmlFailed) from subjectIdFiles

  output:
    set file {"${subject}.txt"}  into gfeResults mode flatten

  """
    gzcat ${subjectFastq} | fasta2gfe -s ${subject} 
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






