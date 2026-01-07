---
title: "LLM security in 2025: confusable deputies, indirect injection, and controls that reduce blast radius"
date: 2025-01-07
layout: post
---
In 2025, LLM capabilities advanced quickly. “Reasoning” models (starting with OpenAI’s o1/o3) helped make agentic workflows meaningfully more useful, and security started to look less like content moderation and more like systems security for a component that **reads untrusted text, reasons over it, and can take action**.

So, looking back on 2025: what did we learn about LLM security?

## Summary

- **Deployment is outpacing mature security controls.** Organizations can normalize insecure or unreliable AI behavior because “nothing catastrophic has happened yet,” even as assistants gain access to more data and more actions—what Johann Rehberger calls “[normalization of deviance](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/).”
- **Indirect prompt injection is the operational threat model** for enterprise assistants: adversarial instructions arrive via content the model is asked to read (web pages, emails, files), not just via user prompts, as described by [Microsoft MSRC](https://www.microsoft.com/en-us/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks).
- **Agentic browsing made “drive-by” failures plausible.** The Comet prompt injection issue is a concrete illustration of untrusted web content being treated as instructions in [Brave’s write-up](https://brave.com/blog/comet-prompt-injection/).
- **2025 guidance converged on deterministic boundary controls.** Isolation of untrusted content, gating high-impact actions, and downstream authorization checks are replacing “prompt-only” security arguments, as reflected in Chrome’s published [agent security architecture](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html).

## Big problem: AI security is normalizing before controls are mature

A recurring theme in 2025 writing was that organizations can drift into accepting insecure behavior because “nothing catastrophic has happened yet.” Johann Rehberger describes this dynamic for AI systems as a “[normalization of deviance](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/)” failure mode.

At the same time, deployments are getting more capable:

- assistants ingest more untrusted input (web/email/docs/tickets)
- retrieval-augmented generation (RAG) connects models to sensitive internal corpora
- agents increasingly call tools that can change state

That combination shifts impact from reputational harm (“chatbot said something wrong”) toward conventional security outcomes such as data exposure and unauthorized actions (especially when the system operates with user credentials).

One concrete illustration is the Comet prompt injection issue described by [Brave](https://brave.com/blog/comet-prompt-injection/): webpage content was treated as instructions in a way that could drive unintended behavior and disclosure.

## The AI threat model: “confusable deputy,” semantic input, and untrusted output

Classical cybersecurity is built around deterministic systems: you can trace a failure to code paths, configuration, or protocol behavior—and you can often remediate by patching. LLM applications break some of those assumptions:

- **The attack surface is semantic.** “Instructions” and “data” share the same medium (natural language), and adversarial instructions can be embedded in content the model is asked to process.
- **You can’t assume you can enumerate and block all bad inputs.** Because the attack surface is natural language, the space of adversarial inputs is effectively unbounded—input filtering is inherently incomplete (“99% of infinity is still infinity”). Indirect injection is specifically about instructions arriving via normal enterprise content flows (files, emails, web pages).
- **You can’t treat model behavior as a security boundary.** Outputs are probabilistic and can be steered; prompt “guardrails” are a layer, not a substitute for authorization checks and isolation boundaries.

The UK NCSC framing is useful for security decision-making: treat prompt injection less like SQL injection and more like exploiting an inherently “confusable deputy,” which pushes design toward impact reduction and boundary controls ([UK NCSC](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)).

## What’s the solution? Build controls that reduce blast radius when injection succeeds

The most defensible 2025 posture was not “we prevented injection,” but “when injection happens, it can’t silently exfiltrate data or perform high-impact actions.” In practice, that means emphasizing deterministic boundary controls over probabilistic behavior (see Chrome’s [agent security architecture](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

Practically, that means:

- **Authorize access to data and tools outside the model.** Don’t rely on the model to decide what it’s allowed to retrieve or do (“complete mediation” in downstream systems).
- **Separate read paths from write paths.** Treat retrieval as privileged; treat state-changing tool calls as higher risk; require approvals for high-impact actions.
- **Treat model output as untrusted.** Validate/sanitize before passing output into interpreters (HTML/JS/SQL/shell/config); prefer structured outputs and strict parsing.
- **Instrument and respond like any other privileged system.** Log retrieval decisions and tool invocations; build detection and incident response around anomalous export/tool use.

## Seven 2025 takeaways for CISOs on LLM security

### 1) “AI that reads” created the dominant injection path (indirect injection)
If a workflow asks an LLM to summarize or analyze untrusted content (web/email/docs/tickets), it creates a practical injection path.

### 2) Security culture is a control: normalization of deviance became a practical failure mode
As AI systems are integrated into workflows, teams can normalize near-misses and “mostly works” behaviors, especially when harm is intermittent or hard to attribute—a [normalization of deviance](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/) dynamic.

### 3) Prompt injection is not “SQL injection for prompts” — treat the model as a confusable deputy
The UK NCSC’s “confusable deputy” framing is useful because it pushes designs toward impact reduction and boundary controls instead of betting on perfect prompt discipline ([UK NCSC](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)).

### 4) Agentic browsing made “drive-by” data exposure plausible in real workflows
Once “reading the web” is connected to user state (accounts, sessions, autofill, internal data access), untrusted pages become an operational security boundary. The Comet prompt injection issue is a useful illustration ([Brave](https://brave.com/blog/comet-prompt-injection/).

### 5) Vendors started publishing concrete defense-in-depth architectures (deterministic boundaries)
The direction of travel is consistent across published agent security architecture work: isolate untrusted content, gate high-impact actions, and rely on deterministic controls rather than probabilistic “the model will comply” assumptions ([Chrome Security](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).

### 6) Authorization and least privilege became the core blast-radius control for retrieval and tools
This is the practical interpretation of “assume injection succeeds”: permissioning and complete mediation in downstream systems determine whether a manipulation becomes a minor policy violation or a material breach.

### 7) “AI-orchestrated ops” signals emerged, but risk should be calibrated from primary sources
There is credible reporting of agentic usage in cyber operations and also credible skepticism about what is actually new; this is a case where CISOs should read primary sources and update assumptions incrementally ([Anthropic](https://www.anthropic.com/news/disrupting-AI-espionage)).

## What changed for controls in 2025 (what to carry into 2026 plans)

Most “best practice” controls for access control, least privilege, and logging were not invented in 2025. What changed in 2025 is that major examples and guidance started converging on a smaller set of priorities for agentic systems:

- **Treat untrusted content as hostile by default (especially web browsing).** The Comet prompt injection issue is a concrete reminder that content can be interpreted as instructions and drive unintended behavior or disclosure ([Brave](https://brave.com/blog/comet-prompt-injection/)).
- **Use deterministic boundaries for action-taking systems.** Published approaches emphasize segregation/isolation of untrusted content, gating high-impact actions, and relying on enforced policy checks rather than “the model will comply” ([Chrome Security](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)).
- **Keep OWASP as shared governance vocabulary, not the strategy.** Its 2025 taxonomy is useful for coverage checks and communication, but the engineering story should still be boundaries, authorization, and blast radius.

## Closing: the posture that held up in 2025

The core lesson from 2025 was a shift from “prevent prompt injection” to “assume injection succeeds sometimes, and make failures non-catastrophic through boundaries, authorization, and isolation.”

> “... any data that AI has access to, the user can make it leak it. Any actions that it can possibly take, the user can make it take. So make sure to have those things locked down.” — Sander Schulhoff, leading AI cybersecurity researcher ([Lenny’s Newsletter podcast](https://www.lennysnewsletter.com/p/the-coming-ai-security-crisis))

## Sources

- [Microsoft MSRC: “How Microsoft defends against indirect prompt injection attacks” (Jul 29, 2025)](https://www.microsoft.com/en-us/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks)
- [UK NCSC: “Prompt injection is not SQL injection” (Dec 2025)](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)
- [Google Online Security Blog: “Architecting Security for Agentic Capabilities in Chrome” (Dec 2025)](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)
- [Anthropic: “Disrupting AI-espionage” (Nov 2025)](https://www.anthropic.com/news/disrupting-AI-espionage)
- [Embrace The Red: “The Normalization of Deviance in AI” (2025)](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/)
- [Brave: “Comet prompt injection”](https://brave.com/blog/comet-prompt-injection/)
- [Lenny’s Newsletter / podcast episode: “The coming AI security crisis”](https://www.lennysnewsletter.com/p/the-coming-ai-security-crisis?utm_source=post-email-title&publication_id=10845&post_id=181089452&utm_campaign=email-post-title&isFreemail=true&r=2vtaj&triedRedirect=true)
