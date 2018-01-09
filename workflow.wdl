workflow mgs_sop {
  String sample_id
  String raw_fastq_dir
  Int threads

  call screen_and_trim_paired {
    input:
      sample_id=sample_id,
      forward_reads="${raw_fastq_dir}/${sample_id}_1.fastq",
      reverse_reads="${raw_fastq_dir}/${sample_id}_2.fastq",
      threads=threads,
  }

  call concatenate_paired {
    input:
      sample_id=sample_id,
      forward_reads=screen_and_trim_paired.paired_1,
      reverse_reads=screen_and_trim_paired.paired_2,
  }
}

task screen_and_trim_paired {
  String sample_id
  File forward_reads
  File reverse_reads
  Int threads

  command {
    kneaddata \
      -i ${forward_reads} \
      -i ${reverse_reads} \
      -o kneaddata_out/ \
      -db /Users/karl/Development/dbs/bowtie/GRCh38_PhiX \
      -t ${threads} \
      --trimmomatic-options "SLIDINGWINDOW:4:20 MINLEN:50" \
      --trimmomatic $CONDA_PREFIX/share/trimmomatic-* \
      --bowtie2-options "--very-sensitive --dovetail" \
      --remove-intermediate-output
  }

  output {
    File log="kneaddata_out/${sample_id}_1_kneaddata.log"
    File paired_contam_1="kneaddata_out/${sample_id}_1_kneaddata_GRCh38_PhiX_bowtie2_paired_contam_1.fastq"
    File paired_contam_2="kneaddata_out/${sample_id}_1_kneaddata_GRCh38_PhiX_bowtie2_paired_contam_2.fastq"
    File unmatched_1_contam="kneaddata_out/${sample_id}_1_kneaddata_GRCh38_PhiX_bowtie2_unmatched_1_contam.fastq"
    File unmatched_2_contam="kneaddata_out/${sample_id}_1_kneaddata_GRCh38_PhiX_bowtie2_unmatched_2_contam.fastq"
    File paired_1="kneaddata_out/${sample_id}_1_kneaddata_paired_1.fastq"
    File paired_2="kneaddata_out/${sample_id}_1_kneaddata_paired_2.fastq"
    File unmatched_1="kneaddata_out/${sample_id}_1_kneaddata_unmatched_1.fastq"
    File unmatched_2="kneaddata_out/${sample_id}_1_kneaddata_unmatched_2.fastq"
  }
}

task concatenate_paired {
  String sample_id
  File forward_reads
  File reverse_reads

  command {
    cat ${forward_reads} ${reverse_reads} > ${sample_id}.fastq
  }

  output {
    File fastq="${sample_id}.fastq"
  }
}
