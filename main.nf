$HOSTNAME = ""
params.outdir = 'results'  


if (!params.targetBed){params.targetBed = ""} 
if (!params.vcfFile){params.vcfFile = ""} 
if (!params.genome){params.genome = ""} 

g_1_bed0_g_0 = file(params.targetBed, type: 'any')
Channel.fromPath(params.vcfFile, type: 'any').map{ file -> tuple(file.baseName, file) }.set{g_2_VCFset1_g_0}
Channel.value(params.genome).set{g_4_genome1_g_3}


if (!((params.run_FilterTarget && (params.run_FilterTarget == "yes")) || !params.run_FilterTarget)){
g_2_VCFset1_g_0.set{g_0_VCFset00_g_3}
} else {

process targetFilter {

input:
 file targetBed from g_1_bed0_g_0
 set val(name),file(vcfile) from g_2_VCFset1_g_0

output:
 set '*.vcf'  into g_0_VCFset00_g_3

errorStrategy 'retry'
maxRetries 1

when:
(params.run_FilterTarget && (params.run_FilterTarget == "yes")) || !params.run_FilterTarget
script:
"""
	bedtools -wa -a ${vcfile} -b ${vcfile} > ${name}.vcf
"""
}
}



process sigProfiler {

input:
 set val(name),file(vcfFile) from g_0_VCFset00_g_3
 val genome from g_4_genome1_g_3

output:
 val 'output/plots/*.pdf'  into g_3_pdfdir00

"""
#!/opt/conda/envs/dolphinnext/bin/python

from SigProfilerMatrixGenerator.scripts import SigProfilerMatrixGeneratorFunc as matGen
matrices = matGen.SigProfilerMatrixGeneratorFunc(${name}, ${genome} , ".")
"""
}


workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
