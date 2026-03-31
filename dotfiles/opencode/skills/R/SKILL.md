---
name: R
description: Load this skill before any task that will write, edit, refactor, debug, review, or explain R code, Quarto/R Markdown, or R package files.
---

# R Skill

Load this skill before doing any work that will touch R code or R project files.
If the response will contain R code, this skill must be active first.

These instructions override generic coding habits that would otherwise add too
many helper functions, wrappers, or unnecessary verbosity to one-off R work.

This includes:

- `.R`, `.Rmd`, `.qmd`
- `DESCRIPTION`, `NAMESPACE`, `.Rprofile`
- `R/`, `tests/testthat/`, `man/`
- refactors, debugging, explanations, analyses, and report renders

## Goals

- Prefer concise, idiomatic R.
- Preserve the project's existing style, dependency choices, and workflow.
- Keep analysis code direct, reproducible, and easy to rerun.
- Validate changes with the lightest relevant command before finishing.

## Decide The Work Mode

Choose one mode before writing code.

If the task is one-off R work and not clearly package internals, prefer Script /
Analysis Mode.

### Package Mode

Use this when the repo is an R package or the change affects reusable package
code.

- Signals: `DESCRIPTION`, `NAMESPACE`, `R/`, `man/`, `tests/testthat/`.
- Small helper functions are fine when they improve reuse, API design, or
  testability.
- Keep documentation, examples, and tests aligned with the implementation.
- Avoid changing exported functions, signatures, or dependencies unless the task
  calls for it.

### Script / Analysis Mode

Use this for standalone scripts, one-off analyses, report preparation,
notebooks, and most `.R` files outside a package.

- Default to a top-to-bottom script in execution order.
- Prefer one clear pipeline or a few named intermediate objects.
- Do not split one-off work into many small functions.
- Only extract a helper when logic is reused, conceptually important, or needs
  isolated testing.
- Optimize for clarity and brevity, not abstraction or reuse theater.
- Avoid package-style scaffolding, `main()` wrappers, `utils.R`, classes, and
  CLI or config plumbing unless the user asks for them.

## Detect The Project Shape

Check for these files first and adapt your workflow:

- `DESCRIPTION`, `NAMESPACE`, `man/`, `R/`: R package.
- `*.nix`: dependencies managed via Nix; respect that environment.
- `.Rprofile`: respect startup behavior and options.
- `*.qmd`: Quarto report.
- `*.Rmd`: R Markdown report.
- Standalone `*.R`: validate with `Rscript`.

## Rules That Always Apply

- Follow existing repository conventions first. If there is no strong local
  convention, prefer idiomatic base R.
- Use `pkg::fun()` for installed packages; do not namespace base functions.
- Do not introduce new packages unless they materially simplify the task.
- Do not add, remove, or upgrade packages without the user's consent. You may
  suggest package changes when they would help.
- Prefer direct vectorized expressions, `|>`, and a few named objects over
  verbose ceremony.
- Prefer short, conventional local variable names over long descriptive phrases.
  Use longer names only when they materially improve clarity, especially in
  reusable or public code.
- Add comments only when they clarify non-obvious logic.
- Keep side effects at obvious boundaries such as read, write, and render
  steps.
- Be explicit about column names, types, grouping, ordering, and missing-value
  handling in data work.
- Preserve existing formatting conventions for user-facing output.

## Package Workflow

For package changes:

1. Read `DESCRIPTION` and the touched files under `R/`, `man/`, and
   `tests/testthat/`.
2. Keep function docs, examples, and tests aligned with the implementation.
3. Regenerate `NAMESPACE` or `man/` only when the project already uses roxygen.
4. Run the narrowest relevant test or check first, then broaden only if needed.

## Script And Analysis Workflow

Use this default structure when the repository does not already define
something else:

- `src/`: R scripts and reusable project code.
- `data/raw`, `data/external`, `data/processed`, `data/survey`: raw inputs,
  downloads, finished products, and metadata.
- `reports/`: model outputs, rendered artifacts, and one-off CSVs.

When writing analysis code:

1. Identify inputs, outputs, and environment assumptions first.
2. Make paths project-root-aware; avoid hidden working-directory dependencies
   and hard-coded absolute paths.
3. Write the analysis in execution order so a reader can run it from top to
   bottom.
4. Keep the code compact. Do not create tiny helpers just to name each step.
5. Re-run the specific script or render step affected by the change.

## Validation

Use the least expensive command that validates the change:

```bash
Rscript path/to/script.R
Rscript -e "source('path/to/file.R')"
quarto render path/to/report.qmd
R CMD check
```

## What To Report Back

When finishing an R task, summarize:

- which mode you used (`package` or `script / analysis`),
- what changed and why,
- which files were touched,
- which validation command ran,
- and any follow-up the user may still want.
