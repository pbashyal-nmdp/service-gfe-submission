#!/usr/bin/env nextflow

params.hml           = "${baseDir}/tutorial/ex00_ngsp_expected.xml"
params.output        = "${baseDir}/tutorial/output"

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
    set file {"${subject}.ld.txt"}  into gfeResults mode flatten

  """
    gzcat ${subjectFastq} | /Users/mhalagan/web_apps/devel/dancer-apps/service-gfe-submission/GFE_Submission/bin/fasta2gfe -s ${subject} 2> ${subject}.ld.txt > /dev/null
  """
}

gfeResults
.collectFile() {  validate ->
       [ "ld_results.txt", validate.text ]
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






