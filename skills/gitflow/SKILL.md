---
name: gitflow
description: >-
  Git workflow management skill for the Fábula TCG project.
  Use this skill whenever you need to create feature branches, organize
  delivery commits, rebase against main, or perform squash merges into main.
  Activate when the user requests branch creation, feature delivery,
  code merging, or Git history cleanup.
---

# Gitflow — Project Git Workflow

## 1. Core Principles

| Principle | Rule |
| :--- | :--- |
| **Main branch** | `main` — always stable, release-ready. |
| **Development** | Always on isolated **feature branches**. |
| **History** | Atomic, semantic commits inside the feature. |
| **Sync** | Via **rebase** against `main` (never merge to sync). |
| **Delivery** | Via **squash merge** from feature into `main`. |

> [!CAUTION]
> **Never commit directly to `main`**. All code enters via feature branch → squash merge.

---

## 2. Branch Naming

Format: `<type>/<kebab-case-description>`

| Type | Purpose |
| :--- | :--- |
| `feat/` | New feature |
| `fix/` | Bug fix |
| `refactor/` | Non-functional refactor |
| `docs/` | Documentation |
| `test/` | Test additions or fixes |
| `chore/` | Infra, CI, dependencies |

---

## 3. Feature Branch Lifecycle

### 3.1. Create

```bash
git checkout main
git pull origin main
git checkout -b feat/<name>
```

### 3.2. Commit

Use **Conventional Commits**. Each commit must be atomic and self-contained.

```
<type>(<scope>): <imperative short description>

[optional body — what and why, not how]
```

> [!IMPORTANT]
> Every commit must compile and pass tests. No broken intermediate commits.

### 3.3. Rebase against `main`

```bash
git fetch origin main
git rebase origin/main
```

On conflicts: resolve files → `git add <files>` → `git rebase --continue`.
Abort if needed: `git rebase --abort`.

> [!WARNING]
> After rebase on a pushed branch, force push is required:
> ```bash
> git push --force-with-lease origin feat/<name>
> ```
> Always use `--force-with-lease`, never bare `--force`.

### 3.4. Squash Merge into `main`

```bash
git checkout main
git pull origin main
git merge --squash feat/<name>
git commit -m "feat(<scope>): <complete feature description>"
git push origin main
```

The squash commit message must follow Conventional Commits and summarize the entire delivery.

### 3.5. Cleanup

```bash
git branch -d feat/<name>
git push origin --delete feat/<name>
```

---

## 4. Delivery Checklist

- [ ] All commits follow Conventional Commits.
- [ ] `flutter analyze` passes with no warnings.
- [ ] `flutter test` passes.
- [ ] Rebased against `main` with no pending conflicts.
- [ ] Squash commit message is descriptive.
- [ ] Feature branch deleted after merge.

---

## 5. Quick Reference

| Action | Command |
| :--- | :--- |
| Create feature branch | `git checkout -b feat/<name>` |
| Semantic commit | `git commit -m "feat(scope): description"` |
| Rebase against main | `git fetch origin main && git rebase origin/main` |
| Force push after rebase | `git push --force-with-lease origin feat/<name>` |
| Squash merge into main | `git checkout main && git merge --squash feat/<name>` |
| Delete local branch | `git branch -d feat/<name>` |
| Delete remote branch | `git push origin --delete feat/<name>` |
