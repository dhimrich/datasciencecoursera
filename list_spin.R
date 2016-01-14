#'# List experimentation
load("life1_fit.RData")
load("life2_fit.RData")

life.list <- vector("list", length = 2)

life.list[[1]] <- life1.fit
life.list[[2]] <- life2.fit

library(survival)
summary(life.list[[1]])

#+ loop, results='asis'

for (i in seq_along(life.list)) {
  cat("## Subsection", i)
  cat("\n")
  print(summary(life.list[[i]]))
  cat("\n")
  print(plot(life.list[[i]]))
  cat("\n")
  cat("***")
  cat("\n")
}


