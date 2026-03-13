# Bioinformatics: Leaving the science of coat and pipette

### A course by Albert Tafur Rangel, Ph.D.

------------------------------------------------------------------------

:spiral_calendar: ----, 20--  
:alarm_clock:  
:hotel: --------  
:writing_hand: )

------------------------------------------------------------------------

# Course Overview

This course introduces the foundations of **bioinformatics and computational biology** from a practical perspective: you'll learn where biological data come from, how they're stored and shared, and how to analyze them using a Unix-like environment and scripting.

Throughout the modules, we'll connect core concepts (sequence data, alignments, assemblies, annotation, phylogenetics, and multiple "omics") to real-world workflows used in research and industry.

**By the end of the course, you should be able to:**

- Navigate biological databases and download sequence data in standard formats
- Work comfortably in a **Unix/Linux** terminal (also applicable to macOS)
- Automate repetitive tasks with small scripts (Bash and Python)
- Understand the principles behind sequencing, alignment, assembly and genome annotation
- Build phylogenetic trees and interpret evolutionary relationships
- Interpret results in context: quality, limitations, and biological meaning

## Learning objectives

- Understanding the general concepts of bioinformatics and computational biology
- Learning to navigate, retrieve and interpret biological data from public databases
- Gaining practical skills in Unix command-line tools and Python scripting for biological data analysis
- Being able to generate and interpret complex analyses: alignments, phylogenies, assemblies and annotations

## Is this course for me?

This course will be appropriate for you if you answer yes to these questions:

-   Are you a student or researcher in biology, microbiology, biotechnology or related fields?

-   Do you want to understand how bioinformatics tools work, not just run them?

-   Would you like to learn to automate analyses and work with biological data programmatically?


## Instructor

[**Dr. Albert Tafur Rangel**](https://orcid.org/0000-0002-9428-183X) (he/him) is a computational biologist with a passion for teaching and design. After his PhD, he combined his expertise in bioinformatics, microbiology and data science to create educational materials that bridge wet-lab and dry-lab thinking.

---

# Content

> **Tip:** each module title links to its `README.md`. Practices are listed separately below each description.

---

## Module 1 — Introduction to Bioinformatics

📂 **[01-introduction/README.md](01-introduction/README.md)**

Core ideas: what bioinformatics is, why it matters, and the ecosystem of biological data.

**Topics:**
- The bioinformatics mindset: multidisciplinary science and computational thinking
- The central dogma, "omics" and how they generate data
- Biological databases (NCBI / ENA / UniProt), identifiers and metadata
- File formats used across the course: FASTA, FASTQ, GFF, GenBank, etc.

**Practices:**
- [Biological databases](01-introduction/exercises/01_databases.md) — search, navigate and download sequences from NCBI

---

## Module 2 — Coding Basics: Unix + Scripting

📂 **[02-coding-basics/README.md](02-coding-basics/README.md)**

You'll learn the "everyday tools" of bioinformatics: the command line and automation.

**Topics:**
- Unix/Linux foundations (also relevant for macOS): navigation, permissions, pipes and redirection
- Text processing for biological files (`grep`, `cut`, `sort`, `wc`, pipes)
- Scripting fundamentals in Python: variables, types, control flow, file I/O
- Application of scripting to FASTA/sequence manipulation and biological data analysis

**Practices:**
- [Creating a GitHub account](02-coding-basics/exercises/01_creating_an_github_account.md) — set up GitHub and Codespaces for the course
- [Using the Unix terminal](02-coding-basics/exercises/02_using_unix_terminal.md) — navigation, file manipulation and text processing with biological files
- [Scripting in Python](02-coding-basics/exercises/03_scripting_in_python.md) — variables, data types, conditionals, loops and scripts for biological analysis

---

## Module 3 — Sequence Analysis: BLAST, Alignments and Primer Design

📂 **[03-sequence_analysis/README.md](03-sequence_analysis/README.md)**

This is where you start doing what bioinformaticians do most: **comparing sequences**.

**Topics:**
- Similarity search with BLAST (`blastn`, `blastp`, `blastx`) and result interpretation (E-value, score, identity, coverage)
- Global vs local alignment: Needleman-Wunsch and Smith-Waterman algorithms with dynamic programming
- Identity vs similarity; scoring schemes and gap penalties
- Primer design criteria, Primer-BLAST and *in silico* PCR / electrophoresis

**Practices:**
- [Alignment with dynamic programming](03-sequence_analysis/exercises/code/alignment_dp.py) — Python implementation of Needleman-Wunsch and Smith-Waterman from scratch
- [Primer design](03-sequence_analysis/exercises/01_primer_design.md) — design primers with Primer-BLAST, validate amplicon size and simulate gel electrophoresis

---

## Module 4 — Phylogenetics and Evolutionary Inference

📂 **[04-phylogenetics/README.md](04-phylogenetics/README.md)**

You'll build and interpret evolutionary trees from molecular data.

**Topics:**
- Multiple sequence alignment (MSA) and model choice
- Distance-based vs character-based methods (Neighbor-Joining, Maximum Likelihood)
- Bootstrapping and statistical support values
- Interpreting phylogenies in biological and clinical context

**Practices:**
- [Phylogenetic analysis with 16S rRNA](04-phylogenetics/exercises/02_phylogenetics.md) — align 16S sequences, build NJ/ML trees in MEGA and identify an unknown bacterium

---

## Module 5 — DNA/RNA Sequencing: From Molecule to Assembled Genome

📂 **[05_sequencing/README.md](05_sequencing/README.md)**

Now you learn where the data actually come from — and how to reconstruct genomes from them.

**Topics:**
- Molecular foundations: nucleotide structure, 3'-OH, DNA replication and why Sanger/Illumina work
- Timeline of sequencing technologies: Sanger → 454 → Illumina → PacBio → Nanopore
- Quality scores (Phred), FASTQ format, coverage, depth, trimming
- Single-end vs paired-end reads
- Assembly strategies: mapping vs *de novo*; OLC and De Bruijn graphs; k-mers
- Assembly evaluation: N50, L50, NG50, BUSCO, contamination checks

**Practices:**
- [Genome assembly with FastQC + Velvet](05_sequencing/exercises/01_2_genome_assembly_fastqc_velvet.md)
- [Genome assembly with Falco + fastp + Shovill](05_sequencing/exercises/01_1_genome_assembly_falco_fastp_shovill.md)

---

 ## Module 6 — Genomics: From Assembled Genome to Biological Knowledge

📂 **[06-genomics/README.md](06-genomics/README.md)**

You give biological meaning to assembled genomes: annotation, variants, and comparative genomics.

**Topics:**
- Genome annotation: gene prediction (prokaryotes vs eukaryotes), functional assignment, GFF/GBK formats
- Variant detection: SNPs, indels, VCF format, mapping against a reference
- Comparative genomics: ANI, pan-genome (core/accessory), AMR/virulence gene detection, synteny

**Practices:**
- [Genome annotation](06-genomics/exercises/01_genome_annotation.md)

---

## Module 7 — Protein Bioinformatics

📂 **[06-proteins/README.md](06-proteins/README.md)**

**Topics:**
- Protein sequences, domains, motifs and families
- Searching and annotating proteins (BLASTp, Pfam/InterPro)
- Structure basics and functional inference

---

## Module 8 — Transcriptomics (RNA-Seq)

📂 **[07-transcriptomics/README.md](07-transcriptomics/README.md)**

**Topics:**
- What RNA-Seq measures, experimental design and key biases
- Quantification concepts (counts, TPM/FPKM) and normalization
- Differential expression and functional interpretation

---

## Module 9 — Proteomics

📂 **[08-proteomics/README.md](08-proteomics/README.md)**

**Topics:**
- Mass spectrometry basics and peptide identification
- Protein quantification and common analysis steps
- Linking proteomics to pathways and biological interpretation

---

## Module 10 — Metabolic Models

📂 **[09-metabolic-models/README.md](09-metabolic-models/README.md)**

**Topics:**
- Metabolic networks and genome-scale metabolic models (GEMs)
- Flux Balance Analysis (FBA): intuition, constraints and objective functions
- Interpreting predictions and connecting models to experiments

---

## Pre-work


## Required software and toolbox

- **GitHub account** — free, for Codespaces access ([github.com](https://github.com))
- **MEGA X** — phylogenetic analysis ([megasoftware.net](https://www.megasoftware.net/))
- **Web browser** — for NCBI, BLAST, Primer-BLAST and other online tools
- Any additional tools will be introduced in the corresponding module

------------------------------------------------------------------------

This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).<br>![](https://i.creativecommons.org/l/by/4.0/88x31.png)