
# Get data ----------------------------------------------------------------

keep <- readLines("data/fred_permitted.txt")

# QD ---
# See https://research.stlouisfed.org/econ/mccracken/fred-databases/
link <- "https://s3.amazonaws.com/files.fred.stlouisfed.org/fred-md/quarterly/"
file <- "2020-01.csv" # Update this

fred_qd <- read.csv(paste(link, file, sep = ""), stringsAsFactors = FALSE)

# Rows to remove
fred_qd_trans <- fred_qd[2, -1] # Keep transformation codes
fred_qd[c(1:2, nrow(fred_qd)), ]
fred_qd <- fred_qd[-c(1:2, nrow(fred_qd)), ]

# Fill rownames with dates and remove date variable
dates <- as.Date(fred_qd$sasdate, "%m/%d/%Y")
rownames(fred_qd) <- dates
fred_qd$sasdate <- NULL

# Adjust S&P 500 names
names(fred_qd)[grep("S[.]P", names(fred_qd))]
names(fred_qd)[grep("S[.]P", names(fred_qd))] <-
  c("SP500", "SPINDUST", "SPDIVYIELD", "SPPERATIO")
names(fred_qd_trans)[grep("S[.]P", names(fred_qd_trans))] <-
  c("SP500", "SPINDUST", "SPDIVYIELD", "SPPERATIO")

# Test
all(vapply(fred_qd, is.numeric, logical(1)))
vapply(fred_qd, function(x) sum(is.na(x)), numeric(1))

# Save fred_qd
save(fred_qd, file = "data/fred_qd_full.rda", version = 2)
# Subset to series we are permitted to use
fred_qd <- fred_qd[, names(fred_qd) %in% keep]
save(fred_qd, file = "data/fred_qd.rda", version = 2)

# MD ---
# See https://research.stlouisfed.org/econ/mccracken/fred-databases/
link <- "https://s3.amazonaws.com/files.fred.stlouisfed.org/fred-md/monthly/"
file <- "2020-01.csv" # Update this

fred_md <- read.csv(paste(link, file, sep = ""), stringsAsFactors = FALSE)

# Rows to remove
fred_md_trans <- fred_md[1, -1] # Keep transformation codes
fred_md[c(1, nrow(fred_md)), ]
fred_md <- fred_md[-c(1, nrow(fred_md)), ]

# Fill rownames with dates and remove date variable
dates <- as.Date(fred_md$sasdate, "%m/%d/%Y")
rownames(fred_md) <- dates
fred_md$sasdate <- NULL

# Adjust S&P 500 names
names(fred_md)[grep("S[.]P", names(fred_md))]
names(fred_md)[grep("S[.]P", names(fred_md))] <-
  c("SP500", "SPINDUST", "SPDIVYIELD", "SPPERATIO")
names(fred_md_trans)[grep("S[.]P", names(fred_md_trans))] <-
  c("SP500", "SPINDUST", "SPDIVYIELD", "SPPERATIO")

# Test
all(vapply(fred_md, is.numeric, logical(1)))
vapply(fred_md, function(x) sum(is.na(x)), numeric(1))

# Save fred_md
save(fred_md, file = "data/fred_md_full.rda", version = 2)
# Subset to series we are permitted to use
fred_md <- fred_md[, names(fred_md) %in% keep]
save(fred_md, file = "data/fred_md.rda", version = 2)

# Transformation codes ---

names_md <- names(fred_md_trans)
vals_md <- c(t(fred_md_trans[1, ])); names(vals_md) <- names_md
names_qd <- names(fred_qd_trans)
vals_qd <- c(t(fred_qd_trans[1, ])); names(vals_qd) <- names_qd

# Transformations are not equal between MD and QD
md_overlap <- names_md[names_md %in% names_qd]
which(vals_md[md_overlap] != vals_qd[md_overlap])
qd_overlap <- names_qd[names_qd %in% names_md]
which(vals_qd[qd_overlap] != vals_md[qd_overlap])

# We provide two columns
fred_trans <- data.frame(variable = union(names_md, names_qd),
  md = NA, qd = NA, stringsAsFactors = FALSE)
fred_trans$md <- vals_md[fred_trans$variable]
fred_trans$qd <- vals_qd[fred_trans$variable]

saveRDS(fred_trans, file = "inst/fred_trans.rds", version = 2)


# Add transformations -------------------------------------------------------

load("inst/fred_trans.rda")
source("R/data.R")
source("R/11_input.R")

# QD ---

# load("data/fred_qd.rda")

# fred_qd_trans <- vapply(names(fred_qd), function(x) {
#     code <- fred_trans$qd[fred_trans$variable == x]
#     if(!code %in% 1L:7L) {stop("Code for", name, "not found!")}
#     get_transformation(code = code, lag = 1, scale = 100)(fred_qd[, x])
#   }, numeric(nrow(fred_qd)))[c(-1, -2), ]

# save(fred_qd_trans, file = "data/fred_qd_trans.rda", version = 2)

# MD ---

# load("data/fred_md.rda")

# fred_md_trans <- vapply(names(fred_md), function(x) {
#     code <- fred_trans$md[fred_trans$variable == x]
#     if(!code %in% 1L:7L) {stop("Code for", name, "not found!")}
#     get_transformation(code = code, lag = 1, scale = 100)(fred_md[, x])
#   }, numeric(nrow(fred_md)))[c(-1, -2), ]

# save(fred_md_trans, file = "data/fred_md_trans.rda", version = 2)
