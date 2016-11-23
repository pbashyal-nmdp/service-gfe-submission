#!/usr/bin/env nextflow

params.hml           = "${baseDir}/tutorial/ex00_ngsp_expected.xml"
params.output        = "${baseDir}/tutorial/output"
params.name          = ""

outputDir            = file("${params.output}")
expectedFile         = file("${params.hml}")

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

//Running the LD validation on the mugs
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






