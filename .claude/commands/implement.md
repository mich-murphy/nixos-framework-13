Implement a change to this NixOS configuration using the planner, builder, and validator agent pipeline.

The user's request: $ARGUMENTS

## Workflow

You are the orchestrator. Drive the full planner -> builder -> validator pipeline for the user's request. Follow these steps exactly:

### Phase 1: Plan

Spawn the **planner** agent with the user's request. The planner will:
- Research NixOS/home-manager options and verify they exist in nixpkgs-unstable
- Write a plan to `.claude/artifacts/plan.md` with deliverables and acceptance criteria

**Planner prompt template:**
> Research and plan the following change to this NixOS configuration: {user's request}
> Write your plan to `.claude/artifacts/plan.md` following your output format.

After the planner finishes, read `.claude/artifacts/plan.md` and present a summary to the user. Wait for the user to approve or request changes before proceeding. If the user requests changes, re-run the planner with the updated requirements.

### Phase 2: Build and Validate

Once the plan is approved, spawn the **builder** agent with the plan. The builder will:
- Read the plan from `.claude/artifacts/plan.md`
- Implement changes in batches of 2-3 files
- Write sprint criteria to `.claude/artifacts/sprint-criteria.md` before each batch
- Spawn the **validator** agent after each batch
- Iterate on failures until all acceptance criteria pass (max 3 retries per issue)
- Escalate to the user if blocked

**Builder prompt template:**
> Implement the plan in `.claude/artifacts/plan.md`. Follow your sprint contract workflow:
> read plan, write sprint criteria, implement batch, spawn validator, iterate until pass.
> Report back with a summary of all changes and final validation status.

### Phase 3: Report

After the builder finishes, summarize:
- What files were created or modified
- What each change accomplishes
- Final validation results (all tests passing or any remaining issues)
- Any items requiring human review (from REQUIRES_HUMAN_CHECK)

If the builder escalated any issues, present them to the user with the builder's suggested next steps.

## Rules

- Always run the planner first. Do not skip to building.
- Always wait for user approval of the plan before spawning the builder.
- If the user provides feedback on the plan, re-run the planner with the updated context.
- Do not modify files yourself. All implementation is done by the builder agent.
- If $ARGUMENTS is empty, ask the user what change they want to implement.
