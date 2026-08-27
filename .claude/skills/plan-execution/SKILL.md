---
name: plan-execution
description: "Standard workflow when executing a plan. TRIGGER when: user asks to execute/implement/realize a plan from .claude/.plans/, user says 'zrealizuj plan', 'execute plan', 'implement plan', or references a plan file path."
---

# Plan Execution Workflow

You are the **supervisor** of this workflow. You plan, delegate, verify and report — you do
**not** write feature code yourself. Implementation goes to the `implementer` agent, review goes
to the `vue-code-reviewer` agent (see §3).

## 0. Determine scope

Identify which part of the project the plan targets:

- **Frontend** — Vue components, stores, TypeScript, styles, routing → work in `harmonify-frontend/`
- **Backend** — C# endpoints, services, models, .csproj → work in `harmonify-music-server/`
- **Both** — changes span both repos

If it's clearly one or the other from the plan content or user's wording, proceed. If unclear, ask using AskUserQuestion:

> "Którego projektu dotyczy ten plan?"
> Options: Frontend / Backend / Obu

Scope determines:
- Which directory to `cd` into for commands
- Which lint/build/test commands to run (see below)
- Where `.claude/.plans/` files live
- Whether the review step runs (`vue-code-reviewer` is frontend-only — see §3.2)

**Frontend commands:** `pnpm lint:fix`, `pnpm type-check`, `pnpm vitest run`
**Backend commands:** `dotnet build`, `dotnet test`

## 1. Ensure a detailed plan exists

- Plans are located in `.claude/.plans/` inside the relevant sub-repo. **Never** use `~/.claude/plans/` or the plan-mode default path as the final home of the plan.
- **Do not write any code without a detailed implementation plan.** A plan must specify:
  - Concrete phases/steps with clear scope
  - Which files to create, modify, or delete
  - Key implementation details (data structures, APIs, component interfaces)
  - Dependencies between phases
- If the user provides a plan file — read it fully and verify it has enough detail. If anything is ambiguous or under-specified, **ask the user to clarify before proceeding**.

### 1.1 Writing or expanding a plan — use plan mode

If no plan exists, or the existing one is high-level/vague (only goals, no implementation details),
build it in **plan mode** rather than free-hand:

1. Call **`EnterPlanMode`**.
2. Explore the codebase (Glob/Grep/Read) and design the implementation. Use `AskUserQuestion` for
   any decision that would materially change the plan.
3. Write the plan into the plan file plan mode gave you, then call **`ExitPlanMode`** — this is the
   approval gate. Do not ask "czy plan OK?" separately; `ExitPlanMode` *is* that question.
4. **Only after approval, once plan mode has exited**, persist the plan to its real home. Plan mode
   blocks `Write`/`Edit`, so this step cannot happen earlier.

### 1.2 Where the plan is persisted

- If the user pointed at a starter file — write the expanded plan back into **that same file**,
  preserving the original brief at the top as context.
- Otherwise — create a new file in the sub-repo's `.claude/.plans/`.
- Never leave the plan only in the plan-mode default location, and never save it elsewhere even if
  plan mode suggests a different path.

## 2. Branch check

Check with `git status` what branch you're on:
- If it matches the plan scope — proceed
- If not — ask the user whether to create a new branch or switch to an existing one
- **Never work on main** unless explicitly told otherwise

## 3. Execution — delegate to agents

Work through the plan's phases **in order**, respecting their dependencies. You do not implement
anything yourself; you brief agents, read their reports, and decide what happens next.

### 3.1 Implementation — `implementer`

For each phase, spawn one agent with the `Agent` tool, `subagent_type: "implementer"`. The skill
authorizes these spawns — you do not need to ask the user first.

The brief must be self-contained; the agent starts cold and cannot see this conversation:

- Absolute path to the plan file **and** which phase it is executing
- Scope (frontend/backend) and the project root to run commands from
- What earlier phases already changed, if it affects this one
- Any decision the user made during planning that isn't written in the plan
- A reminder that it must run the project's checks and must not commit or branch

Run phases **sequentially**, not in parallel — later phases usually build on earlier ones. Only
parallelize phases the plan itself marks as independent and that touch disjoint files.

**Reuse the agent across consecutive phases** that touch the same area: continue it with
`SendMessage` instead of spawning a new one. It keeps its context — the docs, the conventions and
the tree it already established, plus the code it just wrote — so the next brief can be short and
the phase gets done by someone who knows what it builds on. Spawn a fresh `implementer` only when
the next phase is in a different scope or a clearly different part of the tree. (`SendMessage` may
be a deferred tool — load it with `ToolSearch("select:SendMessage")` before the first continuation.)

After each report: if the agent flags a blocker, a deviation you did not sanction, or a failing
check it could not fix, **stop and surface it to the user** instead of starting the next phase.

### 3.2 Review — `vue-code-reviewer`

When all phases are implemented (**frontend scope only**), spawn one agent with `subagent_type:
"vue-code-reviewer"` for a **diff review** of everything the plan produced. Give it:

- The path to the plan file, so it knows the intent
- The project root (`harmonify-frontend/`)
- The scope: normally the whole change is still uncommitted, so plain `git diff` + `--cached` +
  untracked files *is* the plan's diff. Name an explicit base only if the user asked for per-phase
  commits and part of the work is already committed.

Then act on the findings:

- 🔴 and 🟡 findings you agree with → send them back to an `implementer` agent as a fix brief —
  preferably the one that wrote the code, via `SendMessage`.
- Findings you disagree with, or that would widen scope beyond the plan → do not fix; list them for
  the user with your reasoning.
- **At most two review→fix rounds.** Whatever is still open after that goes into the summary for
  the user to decide on — never keep cycling.

**Backend scope:** there is no C# reviewer agent. Skip the review step, rely on `dotnet build` /
`dotnet test`, and say plainly in the summary that no code review was performed.

**Both scopes:** review the frontend part only, and note that in the summary.

### 3.3 Reporting to the user

Agent reports go to you, not to the user. Relay them: after each phase, a short Polish summary of
what changed and anything worth the user's attention. Do not paste an agent's full report verbatim
unless it is genuinely the clearest thing to show.

## 4. Final verification

Run the project's own checks yourself, over the whole project — the agents only verified the areas
they touched.

**Frontend:**
- `pnpm lint:fix` on the full project
- `pnpm type-check`
- `pnpm vitest run`

**Backend:**
- `dotnet build`
- `dotnet test` if there are relevant tests

Anything failing here goes back to an `implementer` agent, not into a hand fix by you.

## 5. Commit — once, at the end

**One commit at the end of the whole plan**, unless the user explicitly asked for a different
cadence (e.g. a commit per phase).

**Always stop and ask the user before creating the commit.** Never commit automatically. Present:

- what was implemented (per phase)
- the result of the final checks from §4
- deviations from the plan, and any review findings left unfixed

Then wait for approval.
