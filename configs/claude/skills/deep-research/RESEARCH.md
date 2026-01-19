# Deep Research Skill — Design Rationale

This document summarizes the research that informed the deep research skill's architecture. The skill was developed through multiple research rounds in January 2026, with each design decision grounded in empirical findings.

## Architecture: Independent Heterogeneous Sub-Agents

The skill uses 3-5 parallel sub-agents, each investigating a different research angle, with an orchestrator that synthesizes their findings.

### Why This Works

**Heterogeneous agents outperform homogeneous by 4-6%** (Zhou & Chen, 2025). Assigning agents distinct angles (core concepts, criticisms, alternatives, etc.) produces better results than giving them identical prompts.

**Independent execution avoids sycophancy failures** (Wynn et al., ICML 2025). When agents can see each other's work, they shift from correct to incorrect answers to maintain consensus. Our sub-agents work in isolation, returning only structured summaries.

**Ensemble diversity accounts for 87% of multi-agent gains** (Choi et al., NeurIPS 2025). The value comes from having multiple independent perspectives, not from agents debating or deliberating. This validates our "parallel investigation → triangulation" pattern over debate-based approaches.

**3-4 agents is optimal** (Google scaling research). Diminishing returns beyond this point. We use 3 (quick), 4 (standard), or 5 (deep) based on thoroughness needs.

### Why Not Debate?

We researched multi-agent debate protocols extensively and decided against implementation:

- Majority voting alone provides 87% of debate's benefits
- Debate can *decrease* accuracy through sycophancy and problem drift
- Adversarial "devil's advocate" framing often underperforms single-agent baselines
- Computational cost (3-5x) doesn't justify marginal gains
- Our architecture already captures the validated patterns

## Verification: Selective, Factored, Claim-Level

Phase 4.5 implements selective verification for deep mode only, using an independent sub-agent to check specific claims.

### Why Selective Verification

**Universal verification is wasteful** — verification requires 8x-128x compute for marginal gains (Singhi et al., COLM 2025). Confidence-guided triggering reduces unnecessary verification by 30%+ while maintaining accuracy (ConfRAG, Meta 2025).

**Triggers that justify verification:**
- Single-source claims with high impact
- Conflicting findings from triangulation
- Specialized/obscure topics (citation error rates 3-5x higher: 28-46% vs 6-10%)
- Claims you're uncertain about despite having sources

**Skip verification when:**
- Triangulation shows 3+ independent sources
- Quick or standard mode (overhead not justified)
- User prioritized speed

### Why Factored (Independent Context)

**Self-verification collapses with post-trained models** (Lu et al., 2025). Models already perform "spontaneous self-verification" during training; additional self-critique adds nothing. However, cross-context verification (using a separate agent) remains effective.

**Factored approaches prevent error repetition** (Dhuliawala et al., ACL 2024 — CoVe research). When verification sees the original output, it tends to repeat hallucinations. Independent verification that only sees claims + sources avoids this bias. Our verification agent sees claims and their citations, not the orchestrator's synthesis.

### Why Claim-Level Granularity

**Document-level is too coarse** — can't identify specific errors. **Sub-claim decomposition adds noise** — helps weak verifiers but hurts strong ones (Hu et al., NAACL 2025). Claim-level is the sweet spot: precise enough to catch errors, not so granular that decomposition introduces problems.

Professional fact-checkers (PolitiFact, FactCheck.org) use claim-level decomposition, validating this as established practice.

## Query Strategy: Semantic with Reformulation

Sub-agents use Exa's semantic search with natural language queries and multiple reformulation techniques.

### Why Semantic Over Keywords

**Exa uses neural embeddings trained on link prediction, not term matching**. Natural language questions dramatically outperform keyword lists. "What are the main challenges organizations face when implementing X?" finds better results than "X implementation challenges problems issues."

### Reformulation Techniques

**3-5 query variations is optimal** — diminishing returns beyond. Five techniques that work:

1. **Paraphrase** — same question, different words
2. **Decompose** — break complex question into sub-questions
3. **Scope shift** — broader context or narrower focus
4. **Perspective shift** — different stakeholder viewpoints
5. **Temporal framing** — recent developments, historical context

### Stopping Criteria

**Citation convergence signals completeness** — when the same sources appear across independent queries, you've found the core material. Additional searching wastes tokens without adding information.

Explicit stopping criteria:
- 3+ credible sources for each major claim
- Both supporting and critical perspectives found
- Same sources repeating across queries (convergence)

## Anti-Hallucination Measures

Multiple mechanisms address the persistent problem of AI hallucination and citation errors.

### Topic Familiarity Assessment

**Citation error rates vary dramatically by topic** — 6% for common topics, 28-46% for obscure ones (Nov 2025 study). Phase 1 assesses whether a topic is well-documented, specialized, or contested, informing how aggressively to verify.

### Abstention Prompting

**Models fail to say "I don't know"** — adding RAG context paradoxically increases confident wrong answers (Google ICLR 2025). Sub-agents are explicitly instructed to state "Insufficient evidence found" rather than synthesizing plausible content, and to flag gaps prominently.

### End-of-Sequence Awareness

**Hallucination concentrates in later portions of long outputs** ("hallucinate at the last" phenomenon). The orchestrator drafts Confidence and Limitations sections early, not last, and reviews final paragraphs specifically for unsourced claims.

### Conflict Handling

**Forcing consensus produces wrong answers** (debate research). When triangulation finds genuine conflicts, the skill reports "sources disagree on X" rather than fabricating resolution. This is the right outcome, not a failure.

## Rate Limiting and Reliability

### Exa Rate Limits

**Fixed at 5 QPS across all tiers** — upgrading plans doesn't help; only enterprise gets higher limits. Sub-agents use exponential backoff (sleep 2s → 4s → 8s) when rate limited.

### Graceful Degradation

Partial results are valuable. If some queries fail due to rate limits, the skill triangulates what it has rather than failing entirely. Follow-up agents can fill critical gaps once the rate limit window passes.

### Optional Wave-Based Launching

For maximum reliability after experiencing rate limits, agents can launch in waves (2-3 at a time) instead of all parallel. This increases total time but smooths the request pattern.

## Model Selection

### Haiku for Quick/Standard, Sonnet for Deep

**Anthropic explicitly recommends Haiku 4.5 for sub-agent tasks**. It achieves near-Sonnet performance (73% vs 77% on SWE-bench) at 1/3 the cost. Token usage explains 80% of performance variance — model choice is secondary.

For deep mode where quality matters most, Sonnet provides better instruction following and synthesis, justifying the additional cost.

## Future Considerations

### Confidence Calibration

Having sub-agents rate their own confidence and calibrating against actual accuracy over time could improve triggering decisions. However, research shows models hallucinate with high certainty (CHOKE phenomenon), so self-reported confidence may not add signal. This remains a future consideration pending practical experience with the skill.

### Progress Observability

Surfacing intermediate state to users during long research tasks would improve UX but requires Claude Code infrastructure changes, not just skill modifications.

### Verification with Improving Models

As models improve through post-training, self-verification shows diminishing returns. The value of Phase 4.5 verification may decrease over time. Monitor and potentially simplify.

---

## Key Research Sources

**Multi-Agent Architecture:**
- Choi et al. (NeurIPS 2025) — Voting accounts for 87% of debate gains
- Wynn et al. (ICML 2025) — Sycophancy failure mode in multi-agent systems
- Zhou & Chen (2025) — Heterogeneous agents outperform homogeneous by 4-6%
- Google scaling research — 3-4 agents optimal

**Verification Pipelines:**
- Singhi et al. (COLM 2025) — Verification requires 8x-128x compute
- Lu et al. (2025) — Self-verification collapses; cross-context works
- Dhuliawala et al. (ACL 2024) — CoVe factored approach
- Hu et al. (NAACL 2025) — Claim-level granularity optimal

**Failure Modes:**
- Simhi et al. (2025) — CHOKE: hallucination with certainty
- Stroebl et al. (2024) — Imperfect verifiers create accuracy ceilings
- Google ICLR 2025 — Abstention failures

**Query Strategy:**
- Exa documentation — Semantic search methodology
- Citation convergence research — Stopping criteria
