# Install the package manager
if (!require("pacman")) install.packages("pacman")

# Function to recursively install all packages and their dependencies
recursively_install <- function(packages) {
	completed <- c()
	recursively_install_sub <- function(packages, tree) {
		for (package in packages) {
			tree_sub <- paste0(tree, " -> ", package)
			if (!is.element(package, completed) & !require(package, character.only=TRUE)) {
				dependencies <- pacman::p_depends(package, character.only=TRUE)$Imports
				recursively_install_sub(dependencies,  tree_sub)
				pacman::p_install(package, character.only=TRUE)
				completed <<- c(completed, package)
				cat("\n>>>>>>>>>>>> Completed installation of package:", tree_sub, "\n")
			} else {
				cat("\n>>>>>>>>>>>> Already installed:", tree_sub, "\n")
			}
		}
	}
	recursively_install_sub(packages, "")
}

# List of packages to install
packages <- c("arules",
			  "cellranger",
			  "cluster",
			  "codetools",
			  "compiler",
			  "curl",
			  "devtools",
			  "digest",
			  "doParallel",
			  "FactoMineR",
			  "foreach",
			  "formatR",
			  "futile.logger",
			  "futile.options",
			  "fuzzyjoin",
			  "grid",
			  "HDoutliers",
			  "httr",
			  "igraph",
			  "iterators",
			  "jsonlite",
			  "lambda.r",
			  "lattice",
			  "lsa",
			  "LSAfun",
			  "Matrix",
			  "memoise",
			  "mlapi",
			  "NLP",
			  "parallel",
			  "partykit",
			  "plyr",
			  "purrr",
			  "randomForest",
			  "RcppParallel",
			  "RcppProgress",
			  "RCurl",
			  "readxl",
			  "RJDBC",
			  "Rlof",
			  "RSclient",
			  "settings",
			  "SnowballC",
			  "stats",
			  "stringdist",
			  "stringi",
			  "text2vec",
			  "textreuse",
			  "tidyr",
			  "tidyselect",
			  "tm",
	      		  "udpipe",
			  "validate",
			  "VGAM",
			  "WikidataR",
			  "WikipediR",
			  "withr",
			  "XML",
			  "yaml")

# Install all packages and their dependencies	
recursively_install(packages)

# Install AnomalyDetection from GitHub
pacman::p_install_gh(c("twitter/AnomalyDetection"))

# Write the install status to disk 
all.packages <- c(packages, "AnomalyDetection")
write.table(data.frame(sapply(all.packages, function(x) require(x, character.only=TRUE))), 
			file = "/opt/status/RExtra.csv", 
			quote = FALSE, 
			sep = ",", 
			row.names = TRUE, 
			col.names = FALSE)
