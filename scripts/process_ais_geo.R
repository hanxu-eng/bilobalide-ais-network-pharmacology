suppressPackageStartupMessages({
  library(limma)
  library(AnnotationDbi)
  library(hgu133plus2.db)
})

args <- commandArgs(trailingOnly=FALSE)
script_arg <- grep("^--file=", args, value=TRUE)
script_file <- if (length(script_arg)) sub("^--file=", "", script_arg[1]) else "scripts/process_ais_geo.R"
root <- normalizePath(file.path(dirname(script_file), ".."), mustWork=FALSE)
raw_dir <- file.path(root, "2_GEO", "raw")
out_dir <- file.path(root, "2_GEO", "processed")
dir.create(out_dir, recursive=TRUE, showWarnings=FALSE)

read_sample_metadata <- function(path) {
  lines <- readLines(gzfile(path), warn=FALSE)
  get_values <- function(prefix) {
    z <- lines[startsWith(lines, prefix)]
    if (!length(z)) return(character())
    vals <- strsplit(z[1], "\t", fixed=TRUE)[[1]][-1]
    gsub('^"|"$', '', vals)
  }
  geo <- get_values("!Sample_geo_accession")
  title <- get_values("!Sample_title")
  desc <- get_values("!Sample_description")
  n <- length(geo)
  if (!length(title)) title <- rep(NA_character_, n)
  if (!length(desc)) desc <- rep(NA_character_, n)
  meta <- data.frame(geo_accession=geo, title=title, description=desc,
                     stringsAsFactors=FALSE)
  chars <- lines[startsWith(lines, "!Sample_characteristics_ch1")]
  for (line in chars) {
    vals <- gsub('^"|"$', '', strsplit(line, "\t", fixed=TRUE)[[1]][-1])
    key <- sub(":.*$", "", vals)
    value <- sub("^[^:]*:\\s*", "", vals)
    for (k in unique(key)) {
      if (!k %in% names(meta)) meta[[k]] <- rep(NA_character_, n)
      hit <- which(key == k)
      meta[hit, k] <- value[hit]
    }
  }
  meta
}

read_matrix <- function(path) {
  x <- read.delim(gzfile(path), comment.char="!", header=TRUE, quote="\"",
                  check.names=FALSE, stringsAsFactors=FALSE, na.strings=c("null", "NA"))
  ids <- x[[1]]
  m <- as.matrix(x[, -1, drop=FALSE])
  storage.mode(m) <- "numeric"
  rownames(m) <- ids
  m
}

map_gpl6883 <- function(ids) {
  ann_lines <- readLines(gzfile(file.path(raw_dir, "GPL6883.annot.gz")), warn=FALSE)
  header_i <- which(startsWith(ann_lines, "ID\t"))[1]
  ann <- read.delim(textConnection(ann_lines[header_i:length(ann_lines)]), comment.char="!",
                    header=TRUE, quote="\"", check.names=FALSE, stringsAsFactors=FALSE,
                    fill=TRUE)
  names(ann) <- make.names(names(ann))
  sym_col <- names(ann)[tolower(names(ann)) == "gene.symbol"]
  if (!length(sym_col)) stop("GPL6883 Gene symbol column not found")
  map <- setNames(trimws(ann[[sym_col[1]]]), ann$ID)
  unname(map[ids])
}

map_gpl570 <- function(ids) {
  z <- AnnotationDbi::select(hgu133plus2.db, keys=ids, keytype="PROBEID", columns="SYMBOL")
  z <- z[!is.na(z$SYMBOL) & z$SYMBOL != "", ]
  probe_n <- table(z$PROBEID)
  z <- z[z$PROBEID %in% names(probe_n[probe_n == 1]), ]
  map <- setNames(z$SYMBOL, z$PROBEID)
  unname(map[ids])
}

run_limma <- function(dataset, group, platform, contrast_name, metadata, selected, age_correct=FALSE) {
  path <- file.path(raw_dir, paste0(dataset, "_series_matrix.txt.gz"))
  m <- read_matrix(path)
  metadata <- metadata[selected, , drop=FALSE]
  group <- factor(group[selected], levels=c("Control", "AIS"))
  if (length(group) != ncol(m[, selected, drop=FALSE])) stop(dataset, ": group length mismatch")
  m <- m[, selected, drop=FALSE]
  metadata$group <- group
  sym <- if (platform == "GPL6883") map_gpl6883(rownames(m)) else map_gpl570(rownames(m))
  keep <- !is.na(sym) & sym != ""
  m <- m[keep, , drop=FALSE]
  sym <- sym[keep]
  m <- limma::avereps(m, ID=sym)
  design <- if (age_correct) {
    metadata$age <- as.numeric(metadata$age)
    metadata$age_centered <- as.numeric(scale(metadata$age, center=TRUE, scale=FALSE))
    metadata$sex <- factor(metadata$gender)
    model.matrix(~0 + group + age_centered + sex, data=metadata)
  } else {
    model.matrix(~0 + group, data=metadata)
  }
  colnames(design)[grep("^groupControl$", colnames(design))] <- "Control"
  colnames(design)[grep("^groupAIS$", colnames(design))] <- "AIS"
  fit <- eBayes(contrasts.fit(lmFit(m, design), makeContrasts(AIS-Control, levels=design)), robust=TRUE, trend=FALSE)
  tab <- topTable(fit, number=Inf, sort.by="P")
  tab$Gene_Symbol <- rownames(tab)
  tab$Dataset <- dataset
  tab$Contrast <- contrast_name
  tab$Platform <- platform
  tab$Age_Sex_Corrected <- age_correct
  tab$FDR_lt_0.05 <- tab$adj.P.Val < 0.05
  tab$Strict_abs_log2FC_ge_1 <- tab$FDR_lt_0.05 & abs(tab$logFC) >= 1
  tab$Extended_abs_log2FC_ge_0.5 <- tab$FDR_lt_0.05 & abs(tab$logFC) >= 0.5
  write.csv(tab, file.path(out_dir, paste0(dataset, "_", contrast_name, "_limma_all.csv")), row.names=FALSE)
  write.csv(tab[tab$Strict_abs_log2FC_ge_1, ], file.path(out_dir, paste0(dataset, "_", contrast_name, "_DEG_strict_FDR005_abslog2FC1.csv")), row.names=FALSE)
  write.csv(tab[tab$Extended_abs_log2FC_ge_0.5, ], file.path(out_dir, paste0(dataset, "_", contrast_name, "_DEG_extended_FDR005_abslog2FC05.csv")), row.names=FALSE)
  tab
}

meta1 <- read_sample_metadata(file.path(raw_dir, "GSE16561_series_matrix.txt.gz"))
meta2 <- read_sample_metadata(file.path(raw_dir, "GSE58294_series_matrix.txt.gz"))
g1 <- ifelse(grepl("Stroke", meta1$description, ignore.case=TRUE), "AIS", "Control")
g2 <- ifelse(grepl("Control", meta2$group, ignore.case=TRUE), "Control", "AIS")
sel1 <- seq_len(nrow(meta1))
sel2 <- grepl("Control", meta2$group, ignore.case=TRUE) | meta2$`time after stroke (h)` == "3"
t1 <- run_limma("GSE16561", g1, "GPL6883", "AIS_vs_Control_age_sex_adjusted", meta1, sel1, age_correct=TRUE)
t2 <- run_limma("GSE58294", g2, "GPL570", "AIS_lt3h_vs_Control", meta2, sel2, age_correct=FALSE)

e1 <- t1[t1$Extended_abs_log2FC_ge_0.5, c("Gene_Symbol", "logFC", "adj.P.Val")]
e2 <- t2[t2$Extended_abs_log2FC_ge_0.5, c("Gene_Symbol", "logFC", "adj.P.Val")]
rep <- merge(e1, e2, by="Gene_Symbol", suffixes=c("_GSE16561", "_GSE58294"))
rep <- rep[sign(rep$logFC_GSE16561) == sign(rep$logFC_GSE58294), ]
rep$Evidence_Class <- "Acute_Transcriptomics"
rep$Replication_Rule <- "FDR<0.05; abs(log2FC)>=0.5; same direction in GSE16561 and GSE58294"
write.csv(rep, file.path(out_dir, "AIS_acute_replicated_DEG_extended.csv"), row.names=FALSE)
writeLines(sort(rep$Gene_Symbol), file.path(out_dir, "AIS_acute_replicated_DEG_extended_gene_symbols.txt"))

s1 <- t1[t1$Strict_abs_log2FC_ge_1, c("Gene_Symbol", "logFC", "adj.P.Val")]
s2 <- t2[t2$Strict_abs_log2FC_ge_1, c("Gene_Symbol", "logFC", "adj.P.Val")]
rep_s <- merge(s1, s2, by="Gene_Symbol", suffixes=c("_GSE16561", "_GSE58294"))
rep_s <- rep_s[sign(rep_s$logFC_GSE16561) == sign(rep_s$logFC_GSE58294), ]
rep_s$Evidence_Class <- "Acute_Transcriptomics"
rep_s$Replication_Rule <- "FDR<0.05; abs(log2FC)>=1; same direction in GSE16561 and GSE58294"
write.csv(rep_s, file.path(out_dir, "AIS_acute_replicated_DEG_strict.csv"), row.names=FALSE)
writeLines(sort(rep_s$Gene_Symbol), file.path(out_dir, "AIS_acute_replicated_DEG_strict_gene_symbols.txt"))

qc <- data.frame(
  Dataset=c("GSE16561", "GSE58294", "Replicated_extended", "Replicated_strict"),
  Contrast=c("AIS vs Control", "AIS <3h vs Control", "same direction", "same direction"),
  Samples_AIS=c(39, 23, NA, NA), Samples_Control=c(24, 23, NA, NA),
  Extended_DEG_n=c(sum(t1$Extended_abs_log2FC_ge_0.5), sum(t2$Extended_abs_log2FC_ge_0.5), nrow(rep), NA),
  Strict_DEG_n=c(sum(t1$Strict_abs_log2FC_ge_1), sum(t2$Strict_abs_log2FC_ge_1), NA, nrow(rep_s))
)
write.csv(qc, file.path(out_dir, "AIS_GEO_QC.csv"), row.names=FALSE)
