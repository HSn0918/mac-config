# Global Claude Code Instructions

## General Principles

- When the user reports a bug or asks to fix something, focus on the specific scope they mentioned. Don't remove or modify unrelated code unless explicitly asked.
- Don't add features, refactor code, or make "improvements" beyond what was asked. Keep solutions simple and focused.
- Don't add docstrings, comments, or type annotations to code you didn't change.
- Don't add error handling, fallbacks, or validation for scenarios beyond the current task.
- When in doubt about scope, do less and ask rather than doing more.

## Git

- Never include Co-Authored-By or AI attribution lines in git commits unless explicitly asked.
- When asked to commit, just do it. Don't hesitate, ask for confirmation, or question whether to commit.
- Follow the user's commit message style. Don't add extra files (like uv.lock) not related to the task.
- Stage only the files relevant to the current task.

## Code Changes

- When renaming or replacing a term across the codebase, do a final grep/search for ALL remaining references (including comments, strings, struct fields, JSON tags) before reporting completion.
- After making any change, verify: grep for old references, run the build/typecheck, list all files changed. Don't report done until verified.
- When asked to change something in multiple places, always search exhaustively — don't assume you found all occurrences.
- Use `fd` instead of `find` for file searching (e.g., `fd '\.go$'`, `fd -e ts`).
- Use `ast-grep` (or `sg`) for structural code search and refactoring — prefer it over regex grep when searching for functions, types, or code patterns (e.g., `sg -p 'func $NAME($$$)' -l go`, `sg -p 'import { $$$ } from "$MOD"' -l ts`).

## Go Conventions

- Use context.Context pattern for goroutine lifecycle management (not stopCh).
- Put request/response models in the model package, not inline with handlers.
- Use pure echo handler style — do not use connecthttp style.
- Never use panic for error fallbacks.
- Do not add unnecessary abstractions or helpers for one-time operations.

## Documentation

- When making changes to README or documentation, always check for and update ALL language versions (e.g., both Chinese and English READMEs).
- Don't create documentation files unless explicitly requested.

## Session Approach

- Prefer focused, single-goal sessions. If a task seems to bundle multiple goals, handle one at a time unless told otherwise.
- When starting a multi-file refactor, read existing patterns first and match them exactly before writing any new code.
- Before declaring a task complete, self-verify: search for remaining old references, confirm the build passes, list all changed files.