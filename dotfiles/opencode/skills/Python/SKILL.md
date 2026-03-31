---
name: Python
description: Load this skill before any task that will write, edit, refactor, debug, review, or explain Python code, notebooks, tests, or Python project files.
---

# Python Skill

Load this skill before doing any work that will touch Python code or Python
project files. If the response will contain Python code, this skill must be
active first.

These instructions override generic coding habits that would otherwise add too
many helper functions, wrappers, classes, unnecessary verbosity, or non-Nix
Python environment setup to ordinary Python work.

This includes:

- `.py`, `.pyi`, `.ipynb`
- `pyproject.toml`, `setup.py`, `setup.cfg`, `flake.nix`, `flake.lock`, `shell.nix`
- `pytest.ini`, `tox.ini`, `noxfile.py`, `ruff.toml`, `mypy.ini`
- refactors, debugging, explanations, automation scripts, notebooks, tests, and CLIs

## Goals

- Prefer concise, idiomatic Python.
- Preserve the project's existing style, tooling, dependency choices, and workflow.
- Keep simple scripts and analysis code direct, reproducible, and easy to rerun.
- Validate changes with the lightest relevant command before finishing.

## Decide The Work Mode

Choose one mode before writing code.

If the task is one-off Python work and not clearly reusable library or framework
code, prefer Script / Analysis Mode.

### Package / Library Mode

Use this when the repo ships reusable Python code or the change affects shared
modules, public APIs, packages, or tests.

- Signals: `pyproject.toml`, `setup.py`, `setup.cfg`, `src/`, package dirs, `tests/`.
- Helper functions and small classes are fine when they improve reuse, API
  design, or testability.
- Keep docstrings, typing, and tests aligned with the implementation.
- Avoid changing public interfaces or dependency sets unless the task calls for it.

### Script / Analysis Mode

Use this for standalone scripts, automation, one-off analyses, notebooks, and
most single-file Python outside a package.

- Default to a top-to-bottom script in execution order.
- Prefer one clear flow or a few named intermediate values.
- Do not split one-off work into many tiny functions or classes.
- Only extract a helper when logic is reused, conceptually important, or needs
  isolated testing.
- Optimize for clarity and brevity, not abstraction or reuse theater.
- Avoid package-style scaffolding, factory layers, base classes, or extra config
  plumbing unless the user asks for them.
- Only add `main()` and `if __name__ == "__main__":` when the file is meant to
  be a real entrypoint or the repository already follows that pattern.

## Detect The Project Shape

Check for these files first and adapt your workflow:

- `pyproject.toml`: packaging, tool config, and project metadata.
- `flake.nix`, `flake.lock`, `shell.nix`, `default.nix`, `*.nix`: environment,
  dependencies, and runner hints. If these are present, prefer Nix-managed
  commands and do not introduce `uv`, Poetry, or `requirements.txt` workflows
  unless the repo already uses them.
- `src/`, package directories, `tests/`: library or application layout.
- `.venv`, `.python-version`: interpreter expectations.
- `*.ipynb`: notebook workflow.
- `pytest.ini`, `tox.ini`, `noxfile.py`, `ruff.toml`, `mypy.ini`: validation and quality gates.

## Rules That Always Apply

- Follow existing repository conventions first. If there is no strong local
  convention, prefer idiomatic Python.
- Respect Nix-managed environments when present. Do not add `requirements.txt`,
  `uv`, Poetry, or ad hoc virtualenv workflow unless the project already uses
  them or the user asks for them.
- Prefer the standard library and existing dependencies before adding new packages.
- Do not add, remove, or upgrade dependencies without the user's consent. You
  may suggest dependency changes when they would help.
- Keep imports explicit and minimal.
- Prefer simple data structures and direct control flow over generic abstractions.
- Prefer short, conventional local variable names over long descriptive phrases.
  Use longer names only when they materially improve clarity, especially in
  reusable or public code.
- Add comments and docstrings only when they clarify non-obvious behavior.
- Keep side effects at obvious boundaries such as read, write, network, and CLI
  steps.
- Use type hints when the repository already uses them or when they materially
  clarify reusable or public code. Do not add exhaustive typing to a small script
  just for formality.
- Raise and handle errors at the right boundary. Do not add defensive boilerplate
  everywhere.
- Preserve existing formatting conventions for user-facing output.

## Package / Library Workflow

For package or reusable module changes:

1. Read `pyproject.toml` or the relevant packaging files and the touched modules
   under `src/`, package directories, and `tests/`. If present, also read the
   relevant Nix files that define the environment.
2. Keep public APIs, docstrings, typing, and tests aligned with the implementation.
3. Follow the existing test, lint, and type-check tools instead of introducing new ones.
   If the environment is Nix-managed, run them through Nix.
4. Run the narrowest relevant test or check first, then broaden only if needed.

## Script And Analysis Workflow

Use this default structure when the repository does not already define
something else:

- `scripts/` or `src/`: executable scripts and reusable project code.
- `notebooks/`: exploratory work when notebooks are already part of the project.
- `data/`, `reports/`, `artifacts/`: inputs and generated outputs.

When writing script or analysis code:

1. Identify inputs, outputs, and environment assumptions first.
2. Make paths project-root-aware; avoid hidden working-directory dependencies
   and hard-coded absolute paths.
3. Write the code in execution order so a reader can run it from top to bottom.
4. Keep the code compact. Do not create tiny helpers just to name each step.
5. Re-run the specific script, notebook cell path, or targeted test affected by the change.

## Validation

Use the least expensive command that validates the change.

```bash
python path/to/script.py
python -m py_compile path/to/file.py
python -m pytest path/to/test_file.py
python -m pytest
ruff check path/to/file.py
mypy path/to/file.py
jupyter nbconvert --execute path/to/notebook.ipynb
```

## What To Report Back

When finishing a Python task, summarize:

- which mode you used (`package / library` or `script / analysis`),
- what changed and why,
- which files were touched,
- which validation command ran,
- and any follow-up the user may still want.
