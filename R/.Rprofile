# Custom RProfile
.First <- function() {
  # Auto Set Console width.
  options(setWidthOnResize = TRUE)
  options(width = 120)

  # Prompt
  options(
    prompt = "> "
  )

  if (interactive()) {
    Sys.setenv("R_HISTFILE" = "~/.Rhistory")
    try(utils::loadhistory("~/.Rhistory"))
  }
}

if (interactive()) {
  .Last <- function() {
    try(utils::savehistory("~/.Rhistory"))
  }
}

