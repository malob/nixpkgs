---
name: deep-research
description: This skill should be used when the user asks for "deep research", "comprehensive analysis", "research report", "investigate thoroughly", "compare X vs Y in depth", or needs synthesis across 10+ sources with verification. Use for complex questions requiring multiple search rounds and source triangulation. Do NOT use for simple lookups, debugging, or questions answerable with 1-2 searches.
---

# Deep Research (Orchestrator)

Conduct thorough, iterative research by orchestrating parallel sub-agents, then synthesizing their findings. This architecture prevents context explosion by isolating search/scrape operations in sub-agent context windows.

## Architecture Overview

```
┌────────────────────────────────────────────────────────────┐
│  You (Orchestrator) - Main Context                         │
│  - Clarify & scope the question                            │
│  - Decompose into 3-5 research angles                      │
│  - Spawn parallel deep-researcher sub-agents               │
│  - Receive structured summaries (~60-80 lines each)        │
│  - Triangulate and synthesize final report                 │
└────────────────────────────────────────────────────────────┘
         │             │             │             │
         ▼             ▼             ▼             ▼
    ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
    │Research │   │Research │   │Research │   │Research │
    │Angle 1  │   │Angle 2  │   │Angle 3  │   │Angle 4  │
    │(haiku/  │   │(haiku/  │   │(haiku/  │   │(haiku/  │
    │ sonnet) │   │ sonnet) │   │ sonnet) │   │ sonnet) │
    └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

## When to Use

**Use this skill for:**
- Comprehensive analysis requiring 10+ sources
- Comparing options, approaches, or competing views
- State-of-the-art reviews and trend analysis
- Questions requiring multiple perspectives
- Topics where source verification matters
- Consumer research, technical deep dives, policy analysis

**Do NOT use for:**
- Simple factual lookups (use regular web search)
- Questions answerable with 1-2 searches
- Debugging or code questions (use appropriate tools directly)

## Research Modes

| Mode         | Sub-Agents | Model  | Sources/Agent | Best For                               |
|--------------|------------|--------|---------------|----------------------------------------|
| **quick**    | 3          | haiku  | 3-4           | Initial exploration, time-sensitive    |
| **standard** | 4          | haiku  | 4-5           | Most research questions                |
| **deep**     | 5          | sonnet | 5-6           | Important decisions, thorough analysis |

Default to **standard** unless user specifies otherwise.

**Model selection rationale:** Haiku 4.5 is explicitly recommended by Anthropic for sub-agent tasks and achieves near-Sonnet performance (73% vs 77% on SWE-bench) at 1/3 the cost. For deep mode where quality matters most, Sonnet provides better instruction following and synthesis.

## Process

### Phase 1: Clarify and Scope

Before researching, ensure deep understanding. Use `AskUserQuestion` to clarify:
- **Depth preference**: Quick overview, standard analysis, or deep dive?
- **Specific focus**: Any particular angles, constraints, or priorities?
- **Context**: What will this research inform?

Skip clarification only if the request is already highly specific.

**Assess topic familiarity** (informs verification decisions later):
- **Well-documented**: Common technology, major events, established science → expect good source coverage, lower verification need
- **Specialized/Niche**: Emerging tech, obscure domains, recent developments → expect citation issues, trigger verification more readily in Phase 4.5
- **Contested**: Political, controversial, actively debated → expect conflicts, plan for presenting multiple perspectives

**Then decompose the question:**
1. Identify 3-5 independent research angles (adapt to mode and domain)
2. Each angle should be investigable in parallel
3. Together, angles should provide comprehensive coverage

**Example decomposition for "What's the best approach for X?"** (adapt temporal markers to current date):
- Angle 1: Core concepts and background
- Angle 2: Current state and recent developments
- Angle 3: Critical analysis - limitations, problems, criticisms
- Angle 4: Alternatives and comparisons
- Angle 5: Expert perspectives and authoritative sources
- Angle 6: Practical considerations and real-world usage

### Phase 2: Parallel Sub-Agent Dispatch

**CRITICAL: Launch ALL sub-agents in a SINGLE message using the Task tool.**

Use the `deep-researcher` sub-agent for each angle. Each Task call requires:
- `subagent_type`: "deep-researcher"
- `description`: Short (3-5 word) summary like "Research X topic"
- `prompt`: The full research instructions
- `model`: (optional) "sonnet" for deep mode, omit for quick/standard (defaults to haiku)

**Example: Spawn 4 sub-agents in parallel (standard mode, haiku):**

```
Task 1:
  subagent_type: "deep-researcher"
  description: "Research core concepts"
  prompt: "Research angle: Core concepts and background for [topic]. Investigate foundational principles, key terminology, and how it works. Return structured findings following your output format."

Task 2:
  subagent_type: "deep-researcher"
  description: "Research recent developments"
  prompt: "Research angle: Current state and recent developments for [topic]. Focus on latest changes, updates, and emerging trends. Return structured findings following your output format."

Task 3:
  subagent_type: "deep-researcher"
  description: "Research limitations criticisms"
  prompt: "Research angle: Critical analysis of [topic]. Investigate limitations, problems, criticisms, and common complaints. Return structured findings following your output format."

Task 4:
  subagent_type: "deep-researcher"
  description: "Research alternatives comparisons"
  prompt: "Research angle: Alternatives and comparisons for [topic]. Investigate competing options and how they compare. Return structured findings following your output format."
```

**For deep mode, add `model: "sonnet"` to each Task call:**

```
Task 1:
  subagent_type: "deep-researcher"
  model: "sonnet"
  description: "Research core concepts"
  prompt: "..."
```

**Why parallel?** Each sub-agent:
- Gets its own fresh ~170k token context
- Can search and scrape extensively without polluting main context
- Returns only structured summary (~60-80 lines)
- Uses haiku (quick/standard) or sonnet (deep) based on mode

**Optional: Wave-based launching**

For maximum reliability when you've recently experienced rate limits, you can launch agents in waves instead of all at once:

1. Launch first 2-3 agents in parallel
2. Wait for them to complete
3. Launch remaining agents

This smooths the request pattern but increases total research time. The default (all parallel) is preferred for speed; use waves only when reliability is critical or after experiencing significant rate limit issues.

### Phase 3: Receive and Validate

As sub-agents complete, you receive their structured findings. For each:
1. Verify the output follows the expected structure
2. Note high-confidence vs low-confidence findings
3. Flag any gaps or angles that need follow-up
4. Check GAPS sections for rate limit notes

If critical gaps exist, spawn targeted follow-up sub-agents.

**Handling Rate Limits and Partial Results:**

Sub-agents may hit Exa's rate limits (5 QPS) when research runs in parallel. Sub-agents are instructed to retry with exponential backoff (sleep 2s, 4s, 8s between retries), but some requests may still fail. This is expected behavior, not failure.

When reviewing sub-agent outputs:
- Check GAPS sections for rate limit notes (e.g., "Rate limited on 1 of 4 searches")
- Partial results are still valuable — triangulate what you have
- If a critical angle is missing due to rate limits, spawn a targeted follow-up agent

**Spawning follow-up agents for rate-limited gaps:**

If multiple agents report rate limit issues on critical angles:
1. Wait a moment (the initial burst will have subsided)
2. Spawn 1-2 targeted follow-up agents sequentially (not parallel) for the specific gaps
3. These follow-up requests will typically succeed since the rate limit window has passed

Don't preemptively reduce agent counts or query counts — launch the optimal number and handle partial results gracefully. Research quality matters more than avoiding occasional rate limit retries.

### Phase 4: Triangulate

**Systematically cross-validate findings before synthesis.** This is where research quality is determined.

**Step 1: Extract claims**
List all factual claims from sub-agent findings (not opinions or synthesis).

**Step 2: Cross-reference**
For each significant claim, check: which sub-agents found it? From how many independent sources?

**Step 3: Classify confidence**
- **HIGH**: Claim appears in 2+ sub-agents OR has 3+ independent sources
- **MEDIUM**: Claim from 1 sub-agent with 2+ credible sources
- **LOW**: Single sub-agent, single source — flag explicitly

**Step 4: Handle conflicts**
When sub-agents report contradictory findings:
- Check source dates (newer may reflect changed reality)
- Check source authority (primary > secondary)
- Check scope (may be discussing different contexts)
- If explainable, note the reason (e.g., "older source predates policy change")
- If genuinely contested, report both sides — do not force resolution

**Step 5: Identify gaps**
What questions remain unanswered? Consider spawning targeted follow-up sub-agents for critical gaps.

### Phase 4.5: Selective Verification (Deep Mode Only)

After triangulation, optionally spawn a verification sub-agent to stress-test claims that meet **any** of these criteria:

1. **Single-source claims** with high impact on the final answer
2. **Claims where sub-agents conflict** (unresolved in triangulation)
3. **Claims you're uncertain about** despite having sources
4. **Citations for specialized/obscure topics** — research shows citation error rates are 3-5x higher (28-46%) for niche topics vs common ones (6-10%)

**Citation-specific verification:** When verifying citations (not just claims), ask the verification agent to:
- Confirm the source exists and says what's attributed to it
- Check if the source is authoritative for this specific topic
- Note whether it's a primary source vs secondary/aggregated

**Skip verification if:**
- Using quick or standard mode (overhead not justified)
- Triangulation produced high confidence across the board (3+ sources per major claim)
- User prioritized speed over thoroughness

**Verification design principles:**
- **Independence**: Verification agent must not see your synthesis—only the claims and their sources
- **Specificity**: Concrete claims to check, not "verify the whole thing"
- **Neutrality**: Research shows adversarial "disprove" framing has no proven advantage; focus on independent re-checking

**Spawn ONE verification sub-agent:**

```
Task:
  subagent_type: "deep-researcher"
  model: "sonnet"
  description: "Verify critical claims"
  prompt: |
    Verification task — use this format instead of your standard output:

    For each claim below, search for ADDITIONAL sources (not the original) and determine
    if they support, contradict, or add nuance to the claim.

    ### CLAIM 1: [claim text]
    ORIGINAL SOURCE: [URL]
    - VERDICT: SUPPORTED | CONTESTED | UNCHANGED
    - EVIDENCE: [what you found, with source URLs]
    - NUANCE: [important context the original missed, if any]

    ### CLAIM 2: [claim text]
    ORIGINAL SOURCE: [URL]
    - VERDICT: ...

    [Continue for each claim — verify 3-5 claims maximum]

    ---
    Claims to verify:

    1. CLAIM: [specific factual claim]
       ORIGINAL SOURCE: [URL/citation from sub-agent findings]

    2. CLAIM: [specific factual claim]
       ORIGINAL SOURCE: [URL/citation]

    [etc.]
```

**After verification returns:**
- **SUPPORTED**: Upgrade confidence; note additional sources in final report
- **CONTESTED**: Flag explicitly in report; present both sides with evidence
- **UNCHANGED**: Keep original confidence level
- **NUANCE**: Incorporate into your synthesis

### Phase 5: Synthesize Final Report

Combine sub-agent findings into a coherent report. Structure:

```markdown
## Executive Summary
[2-3 sentences: key finding, confidence level, scope]

## Key Findings

### Finding 1: [Title]
[Substantive prose with inline citations [1], [2]]

### Finding 2: [Title]
[Continue for each major finding]

## Synthesis
[Your analysis connecting findings - clearly marked as synthesis, not sourced fact]

## Confidence Assessment
- **High confidence**: [findings verified across multiple sub-agents/sources]
- **Medium confidence**: [findings from single sub-agent with good sources]
- **Lower confidence**: [single-source claims, conflicting information]

## Limitations & Gaps
[What's uncertain, missing, or contested]

## Sources
[1] Author/Org. "Title". Publication. URL
[2] ...
```

**End-of-sequence awareness:** Research shows hallucination concentrates in later portions of long outputs. For reports over 2500 words:
- Draft Confidence Assessment and Limitations sections **early**, not last
- Review your final paragraphs specifically for unsourced claims
- When uncertain, end with acknowledged gaps rather than speculative synthesis

## Writing Standards

- Prose paragraphs, not bullet lists (bullets only for distinct enumerations)
- Specific data: "increased 23%" not "increased significantly"
- Cite inline: "The market grew 15% [1]" not "The market grew. [1]"
- Each finding: 2-4 paragraphs with evidence
- Distinguish FACTS (cited) from ANALYSIS (your synthesis)

## Anti-Hallucination Protocol

- Every factual claim must cite a source immediately
- Mark synthesis distinctly: "This suggests..." or "Synthesizing these findings..."
- If uncertain, say so: "Sources disagree on..." or "Limited evidence for..."
- Never fabricate sources - all citations come from sub-agent findings

## Quick Reference

**Starting research:**
1. Clarify with user (depth, focus, context)
2. Announce mode: "Starting standard research with 4 parallel sub-agents"
3. Decompose into angles
4. Launch sub-agents IN PARALLEL (single message with multiple Task calls; add `model: "sonnet"` for deep mode)
5. Triangulate findings (systematic cross-validation)
6. **Deep mode only**: Selective verification of low-confidence or contested claims
7. Synthesize and deliver

**Context budget:**
- Your main context: reserve for orchestration + synthesis
- Sub-agent contexts: handle all search/scrape operations
- Final output: comprehensive but not bloated

