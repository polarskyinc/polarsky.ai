---
title: "LLM security in 2025: the confusable deputy problem and deterministic boundaries"
date: 2025-01-07
layout: post
---

In 2025, LLM capabilities advanced quickly. “Reasoning” models (starting with OpenAI’s o1/o3) helped make agentic workflows meaningfully more useful, and security started to look less like content moderation and more like systems security for a component that **reads untrusted text, reasons over it, and can take action**.

So, looking back on 2025: what did we learn about LLM security?

## Takeaways

1. **Deployment is outpacing mature security controls.** As assistants gain access to more data and more actions, “mostly works” becomes a risky default.
2. **Prompt injection is better thought of as a [confusable deputy](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection) problem.** Models can’t reliably separate instructions from data, so prevention-by-filtering is inherently incomplete.
3. **Use deterministic boundaries.** Treat untrusted inputs and untrusted outputs as hostile by default; enforce isolation, authorization checks, and gated actions outside the model.

## Big problem: AI security is normalizing before controls are mature

A recurring theme in 2025 writing was that organizations can drift into accepting insecure behavior because “nothing catastrophic has happened yet.” Johann Rehberger describes this dynamic for AI systems as a “[normalization of deviance](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/)” failure mode.

At the same time, deployments are getting more capable:

- assistants ingest more untrusted input (web/email/docs/tickets)
- retrieval-augmented generation (RAG) connects models to sensitive internal corpora
- agents increasingly call tools that can change state

That combination shifts impact from reputational harm (“chatbot said something wrong”) toward conventional security outcomes such as data exposure and unauthorized actions (especially when the system operates with user credentials).

One concrete illustration is the [Comet prompt injection issue](https://brave.com/blog/comet-prompt-injection/): webpage content was treated as instructions in a way that could drive unintended behavior and disclosure.

## The AI threat model: semantic, unbounded, stochastic

Classical cybersecurity is built around deterministic systems: you can trace a failure to code paths, configuration, or protocol behavior—and you can often remediate by patching. LLM applications break some of those assumptions:

- **The attack surface is semantic.** “Instructions” and “data” share the same medium (natural language), and adversarial instructions can be embedded in content the model is asked to process.
- **You can’t assume you can enumerate and block all bad inputs.** Because the attack surface is natural language, the space of adversarial inputs is effectively unbounded—input filtering is inherently incomplete (“99% of infinity is still infinity”). Indirect injection is specifically about instructions arriving via normal enterprise content flows (files, emails, web pages).
- **You can’t treat model behavior as a security boundary.** Outputs are probabilistic and can be steered; prompt “guardrails” are a layer, not a substitute for authorization checks and isolation boundaries.

The “confusable deputy” framing is useful for security decision-making: treat this less like a classic injection bug you can patch away and more like exploitation of an inherently confusable system—pushing design toward impact reduction and boundary controls.

## Deterministic Boundaries: Put Controls Outside the Model

The most defensible 2025 posture was not “we prevented injection,” but “when injection happens, it can’t silently exfiltrate data or perform high-impact actions.” In practice, that means emphasizing deterministic boundary controls over probabilistic behavior (see Chrome’s published [agent security architecture](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

Practically, that means:

- **Authorize access to data and tools outside the model.** Don’t rely on the model to decide what it’s allowed to retrieve or do (“complete mediation” in downstream systems).
- **Separate read paths from write paths.** Treat retrieval as privileged; treat state-changing tool calls as higher risk; require approvals for high-impact actions.
- **Treat model output as untrusted.** Validate/sanitize before passing output into interpreters (HTML/JS/SQL/shell/config); prefer structured outputs and strict parsing.
- **Instrument and respond like any other privileged system.** Log retrieval decisions and tool invocations; build detection and incident response around anomalous export/tool use.

## 2025: Control Priorities for Agentic Systems

Most “best practice” controls for access control, least privilege, and logging were not invented in 2025. What changed in 2025 is that major examples and guidance started converging on a clear set of priorities for agentic systems:

- **Treat untrusted content as hostile by default.** The [Comet prompt injection issue](https://brave.com/blog/comet-prompt-injection/) is a concrete reminder that content can be interpreted as instructions and drive unintended behavior or disclosure.
- **Treat LLM outputs as untrusted by default.** Don’t execute or forward raw generations into interpreters (HTML/JS/SQL/shell) without strict validation/sanitization; prefer structured outputs and “policy checks outside the model.”
- **Make the security boundary deterministic.** Isolate untrusted content, gate high-impact actions, and enforce authorization downstream rather than relying on “the model will comply.”

## Conclusion: Assume Injection, Reduce Blast Radius

The core lesson from 2025 was that deployment is outpacing mature security controls. The emerging mindset shifted from “prevent prompt injection” to “assume injection succeeds sometimes, and make failures non-catastrophic through boundaries, authorization, and isolation.”

> “... any data that AI has access to, the user can make it leak it. Any actions that it can possibly take, the user can make it take. So make sure to have those things locked down.” — Sander Schulhoff, leading AI cybersecurity researcher ([Lenny’s Newsletter podcast](https://www.lennysnewsletter.com/p/the-coming-ai-security-crisis))
