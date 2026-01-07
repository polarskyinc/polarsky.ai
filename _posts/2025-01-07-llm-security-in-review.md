---
title: "LLM security in 2025: confusable deputies, indirect injection, and controls that reduce blast radius"
date: 2025-01-07
layout: post
---

In 2025, LLM capabilities advanced quickly. “Reasoning” models (starting with OpenAI’s o1/o3) helped make agentic workflows meaningfully more useful, and security started to look less like content moderation and more like systems security for a component that **reads untrusted text, reasons over it, and can take action**.

So, looking back on 2025: what did we learn about LLM security?

## Summary

- **Deployment is outpacing mature security controls.** As assistants gain access to more data and more actions, “mostly works” becomes a risky default.
- **Prompt injection is better modeled as a confusable deputy problem.** The model can’t reliably separate instructions from data, and that pushes designs toward boundaries and impact reduction ([UK NCSC](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)).
- **The practical answer is deterministic boundary controls.** Isolation of untrusted content, explicit authorization checks, and gating high-impact actions are replacing “prompt-only” security arguments ([Chrome Security](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

## Big problem: AI security is normalizing before controls are mature

A recurring theme in 2025 writing was that organizations can drift into accepting insecure behavior because “nothing catastrophic has happened yet.” Johann Rehberger describes this dynamic for AI systems as a “[normalization of deviance](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/)” failure mode.

At the same time, deployments are getting more capable:

- assistants ingest more untrusted input (web/email/docs/tickets)
- retrieval-augmented generation (RAG) connects models to sensitive internal corpora
- agents increasingly call tools that can change state

That combination shifts impact from reputational harm (“chatbot said something wrong”) toward conventional security outcomes such as data exposure and unauthorized actions (especially when the system operates with user credentials).

One concrete illustration is the Comet prompt injection issue described by [Brave](https://brave.com/blog/comet-prompt-injection/): webpage content was treated as instructions in a way that could drive unintended behavior and disclosure.

## Confusable deputy, not “prompt injection”: the AI threat model

Classical cybersecurity is built around deterministic systems: you can trace a failure to code paths, configuration, or protocol behavior—and you can often remediate by patching. LLM applications break some of those assumptions:

- **The attack surface is semantic.** “Instructions” and “data” share the same medium (natural language), and adversarial instructions can be embedded in content the model is asked to process.
- **You can’t assume you can enumerate and block all bad inputs.** Because the attack surface is natural language, the space of adversarial inputs is effectively unbounded—input filtering is inherently incomplete (“99% of infinity is still infinity”). Indirect injection is specifically about instructions arriving via normal enterprise content flows (files, emails, web pages).
- **You can’t treat model behavior as a security boundary.** Outputs are probabilistic and can be steered; prompt “guardrails” are a layer, not a substitute for authorization checks and isolation boundaries.

The “confusable deputy” framing is useful for security decision-making: treat prompt injection less like SQL injection and more like exploitation of an inherently confusable system, pushing design toward impact reduction and boundary controls (as discussed above).

## What’s the solution? Build controls that reduce blast radius when injection succeeds

The most defensible 2025 posture was not “we prevented injection,” but “when injection happens, it can’t silently exfiltrate data or perform high-impact actions.” In practice, that means emphasizing deterministic boundary controls over probabilistic behavior (see Chrome’s [agent security architecture](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

Practically, that means:

- **Authorize access to data and tools outside the model.** Don’t rely on the model to decide what it’s allowed to retrieve or do (“complete mediation” in downstream systems).
- **Separate read paths from write paths.** Treat retrieval as privileged; treat state-changing tool calls as higher risk; require approvals for high-impact actions.
- **Treat model output as untrusted.** Validate/sanitize before passing output into interpreters (HTML/JS/SQL/shell/config); prefer structured outputs and strict parsing.
- **Instrument and respond like any other privileged system.** Log retrieval decisions and tool invocations; build detection and incident response around anomalous export/tool use.

## Six 2025 takeaways for CISOs on LLM security

### 1) Deployment outpaced controls (design for failure, not perfection)
As capabilities expanded, near-misses and “mostly works” behaviors became easier to normalize and harder to reason about.

### 2) Prompt injection is a confusable deputy problem, not a bug class you can patch away
The model can’t reliably separate instructions from data, which pushes designs toward impact reduction and boundary controls ([UK NCSC](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)).

### 3) Indirect injection is the enterprise delivery path for “AI that reads”
If a workflow asks an LLM to summarize or analyze untrusted content (web/email/docs/tickets), you have a practical injection path. Microsoft’s MSRC write-up is a useful, concrete description of indirect prompt injection delivery paths and associated defenses (see [Microsoft MSRC](https://www.microsoft.com/en-us/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks)). Agentic browsing makes this risk especially concrete (see [Brave](https://brave.com/blog/comet-prompt-injection/)).

### 4) Deterministic boundary controls became the default direction of travel
Published architectures emphasize isolating untrusted content, gating high-impact actions, and enforcing downstream authorization checks ([Chrome Security](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

### 5) Delegation and multi-agent systems create second-order escalation paths
Agent-to-agent discovery and delegation can create interactions that look like lateral movement ([AppOmni](https://appomni.com/ao-labs/ai-agent-to-agent-discovery-prompt-injection/)).

### 6) “AI-orchestrated ops” signals emerged, but risk should be calibrated from primary sources
There is credible reporting of agentic usage in cyber operations; CISOs should read primary sources and update assumptions incrementally ([Anthropic](https://www.anthropic.com/news/disrupting-AI-espionage)).

## What changed for controls in 2025

Most “best practice” controls for access control, least privilege, and logging were not invented in 2025. What changed in 2025 is that major examples and guidance started converging on a smaller set of priorities for agentic systems:

- **Treat untrusted content as hostile by default.** The Comet prompt injection issue is a concrete reminder that content can be interpreted as instructions and drive unintended behavior or disclosure ([Brave](https://brave.com/blog/comet-prompt-injection/)).
- **Treat LLM outputs as untrusted by default.** Don’t execute or forward raw generations into interpreters (HTML/JS/SQL/shell) without strict validation/sanitization; prefer structured outputs and “policy checks outside the model.”
- **Make the security boundary deterministic.** Isolate untrusted content, gate high-impact actions, and enforce authorization downstream rather than relying on “the model will comply” ([Chrome Security](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

## Closing: the posture that held up in 2025

The core lesson from 2025 was a shift from “prevent prompt injection” to “assume injection succeeds sometimes, and make failures non-catastrophic through boundaries, authorization, and isolation.”

> “... any data that AI has access to, the user can make it leak it. Any actions that it can possibly take, the user can make it take. So make sure to have those things locked down.” — Sander Schulhoff, leading AI cybersecurity researcher ([Lenny’s Newsletter podcast](https://www.lennysnewsletter.com/p/the-coming-ai-security-crisis))