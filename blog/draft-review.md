# The year in LLM security (2025): confusable deputies, poisoned context, and the limits of “guardrails”

2025 was the year LLM security stopped being a niche “prompt hacking” curiosity and became a mainstream systems-security problem. The center of gravity shifted from **chatbot misbehavior** to **agentic systems**: models that read untrusted content, retrieve internal documents, and call tools that can change state.

Two threads from late 2025 capture the mood:

- Security practitioners increasingly argue that **prompt injection isn’t “SQL injection for LLMs”**—it’s closer to a *confused deputy* problem where the model cannot reliably separate instructions from data, and so “fixing” it in the classic sense may be unrealistic. :contentReference[oaicite:0]{index=0}  
- A parallel cultural drift is underway: organizations are normalizing unreliable or insecure behaviors because “it hasn’t caused a catastrophe yet,” even as autonomy is pushed into higher-stakes workflows. :contentReference[oaicite:1]{index=1}  

This post is a curated tour of the most useful research and practitioner writing I saw in 2025 about LLM security—favoring papers, benchmarks, and high-signal security researchers over vendor hype.

---

## The meta-lesson: no single mitigation closes this class of risk

A theme that keeps recurring—across research, incident writeups, and late-year commentary—is that **there is no single control that “solves” LLM security**.

Sander Schulhoff summarized the practical consequence bluntly: many “guardrails” being sold as comprehensive protection don’t hold up, and we’ve largely avoided major harm so far because many agents still aren’t capable enough to reliably execute end-to-end malicious objectives. :contentReference[oaicite:2]{index=2}

This isn’t a counsel of despair. It’s a push toward **defense in depth** with a clear goal: make failures **non-catastrophic, observable, and recoverable**.

---

## What changed in 2025

### 1) The threat model expanded from “user prompts” to “everything the model can read”
By 2025, the relevant inputs weren’t just user messages. They included:

- Retrieved documents (RAG corpora)
- Web pages and emails ingested by browsing/assistant features
- Tool outputs (API responses)
- Tool *metadata* (descriptions, schemas)
- Persistent “memory” or system instructions

OWASP’s 2025 guidance reflects this broadened view: indirect prompt injection explicitly includes **external sources like websites or files** that can influence model behavior. :contentReference[oaicite:3]{index=3}

### 2) “Prompt injection” became an agent-security problem, not a content-safety problem
Once an LLM can call tools, prompt injection is less about generating disallowed text and more about:
- **unauthorized data access**
- **credential harvesting**
- **exfiltration via legitimate tool calls**
- **unsafe state changes** (CRUD actions, workflow triggers, outbound messaging)

MITRE ATLAS’ 2025 updates tracked this shift by adding and refining techniques focused on **agent context poisoning, configuration discovery, credential harvesting, and exfiltration via tool invocation**. :contentReference[oaicite:4]{index=4}

---

## A month-by-month tour of high-signal 2025 work

### January 2025: RAG security got its own benchmark
**SafeRAG** framed retrieval-augmented generation as a security surface and built a benchmark of attack types that degrade or subvert RAG pipelines (noise, conflicts, “soft ads,” and DoS-style behaviors). It’s useful because it treats RAG failure as a *system* problem: retriever, filters, and generator interactions. :contentReference[oaicite:5]{index=5}

**Why it mattered:** It pushed teams to stop treating “better models” as a sufficient mitigation. If your retrieval layer can be manipulated, you will eventually retrieve something adversarial.

### March 2025: adaptive attackers broke “prompt injection defenses”
A particularly important (and sobering) result: **Adaptive Attacks Break Defenses Against Indirect Prompt Injection** evaluated multiple defenses and reported that adaptive strategies bypassed them at high rates—making the point that “defense works on our test suite” is not the same as “defense works against a motivated attacker.” :contentReference[oaicite:6]{index=6}

**Why it mattered:** It raised the evaluation bar. If your security argument doesn’t include **adaptive evaluation**, you may be benchmarking wishful thinking.

### March 2025: a “by design” direction for agent security
**Defeating Prompt Injections by Design** proposed *CaMeL*, which tries to force a separation between trusted control flow and untrusted data flow, adding capability constraints to reduce unauthorized exfiltration paths. It also used **AgentDojo** as a benchmark environment to evaluate agentic security properties. :contentReference[oaicite:7]{index=7}

**Why it mattered:** It represented an explicit move toward *systems security* primitives (control/data-flow separation, capabilities) rather than “write better prompts.”

### April 2025: tool metadata became an injection surface (MCP)
A clear practitioner example: **MCP tool poisoning** showed how *tool descriptions*—ostensibly passive metadata—function as injected instructions in many clients. This is a classic “new input channel” problem: the user may never even see the text that steers the model. :contentReference[oaicite:8]{index=8}

**Why it mattered:** It highlighted a supply-chain shaped risk: even “legitimate” tools can be updated, swapped, or rug-pulled, and the model may ingest new “instructions” without user visibility.

### May 2025: system prompt poisoning as a persistent attack vector
**System Prompt Poisoning** moved attention to a high-value component that many teams still treat informally: the system prompt and surrounding configuration. The core idea is persistence: if you can poison system-level instructions, you can influence *all* subsequent interactions.  [oai_citation:9‡arXiv](https://arxiv.org/abs/2505.06493)

**Why it mattered:** It reframed “prompt security” as configuration integrity, access control, and change management—not just input filtering.

### August 2025: tool poisoning scaled into a benchmark
**MCPTox** extended MCP tool poisoning into a benchmark built on many “live” MCP servers and tools, reporting broad susceptibility across tested agents and noting that stronger instruction-following can correlate with higher vulnerability.  [oai_citation:10‡arXiv](https://arxiv.org/abs/2508.14925)

**Why it mattered:** It made tool poisoning less anecdotal and more measurable—pushing toward repeatable, regression-tested security evaluation.

### September–October 2025: governance frameworks caught up to agentic reality
MITRE ATLAS’ 2025 updates (notably September) emphasized agentic TTPs and added technique maturity concepts to differentiate “feasible” vs “demonstrated” vs “realized” techniques.  [oai_citation:11‡Michael Bargury](https://www.mbgsec.com/archive/2025-10-22-updates-mitre-atlastm/)

Meanwhile, OWASP’s GenAI Security Project consolidated community guidance and kept **prompt injection** at the top of the list of practical risks.  [oai_citation:12‡OWASP](https://owasp.org/www-project-top-10-for-large-language-model-applications/)

**Why it mattered:** These efforts don’t “solve” anything directly, but they help organizations speak precisely about threats and mitigations instead of inventing ad hoc taxonomies per team.

### November 2025: second-order prompt injection showed why multi-agent systems are different
The ServiceNow / Now Assist writeup (via AppOmni research) illustrated a class of risk that becomes more salient with agent ecosystems: one agent can be induced to **recruit more powerful agents** via discovery mechanisms and delegated action—leading to high-impact CRUD and outbound messaging even when some protection features are enabled.  [oai_citation:13‡AppOmni](https://appomni.com/ao-labs/ai-agent-to-agent-discovery-prompt-injection/)

**Why it mattered:** It demonstrated that “prompt injection protection” is not a single toggle. Multi-agent architectures introduce *interaction* and *delegation* surfaces that resemble lateral movement.

### December 2025: big vendors started publishing real security architecture for agents
Google’s Chrome team published a concrete, layered architecture for agentic browsing, including:
- A **user alignment critic** (separate model, isolated from untrusted content) that vets actions
- **Origin isolation** constraints (“Agent Origin Sets”) that limit which sites/origins an agent can interact with
- User confirmations, detection, red-teaming, and response loops  [oai_citation:14‡Google Online Security Blog](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)  

Separately, the UK NCSC argument—that prompt injection is not analogous to SQL injection and may require an “impact reduction” mindset—went mainstream.  [oai_citation:15‡ncsc.gov.uk](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection?utm_source=chatgpt.com)

**Why it mattered:** It was a visible pivot from “prompt rules” to **layered security design**: isolation boundaries, gating functions, approvals, and logging.

---

## The cultural failure mode: normalization of deviance
Johann Rehberger’s “Normalization of Deviance” essay is valuable because it points at the non-technical layer: organizations rationalize insecure behavior over time, especially under automation and competitive pressure, and disclaimers (“AI can make mistakes”) become a substitute for engineering rigor.  [oai_citation:16‡Embrace The Red](https://embracethered.com/blog/posts/2025/the-normalization-of-deviance-in-ai/)

This connects directly to LLM security because many early failures are *near misses*: partial leakage, confusing tool behavior, odd retrievals that don’t immediately trigger an incident response. Those near misses can quietly become accepted operating conditions—right up until the day they aren’t.

---

## What we learned (2025’s distilled lessons)

### 1) You can’t reliably force an LLM to separate instructions from data
This is why prompt injection keeps reappearing in new forms as capabilities expand. Industry and standards bodies are converging on: treat LLMs as “confusable” and architect accordingly.  [oai_citation:17‡OWASP Gen AI Security Project](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)

### 2) If your evaluation doesn’t include adaptive attackers, it’s incomplete
Static “red team prompts” are not a sufficient security argument. Adaptive work showed broad bypasses against multiple defenses.  [oai_citation:18‡arXiv](https://arxiv.org/abs/2503.00061?utm_source=chatgpt.com)

### 3) The new supply chain is: documents, tools, and metadata
RAG corpora, MCP servers, tool descriptions, and system prompts all became first-class injection surfaces in 2025.  [oai_citation:19‡Personal Blog](https://lbeurerkellner.github.io/jekyll/update/2025/04/01/mcp-tool-poisoning.html)

### 4) The “model” is rarely where the highest leverage control lives
The most credible 2025 defenses looked like *systems design*: isolation, gating, capabilities, provenance, approvals, audit logs, and regression-tested evaluation.  [oai_citation:20‡Google Online Security Blog](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)

### 5) Org readiness is now a bottleneck: you need hybrid talent and operational ownership
Schulhoff’s point that classical security teams may not be prepared for how AI fails is important—not as a critique, but as an operating reality. The skill gap is in bridging security engineering with ML/agent behavior and evaluation.  [oai_citation:21‡Business Insider](https://www.businessinsider.com/ai-security-gap-companies-researcher-sander-schulhoff-2025-12)

---

## Practical takeaways for teams shipping LLM-backed systems (2026 planning)

**0) Premise: assume partial compromise somewhere in the stack.**  
You are building a system that ingests untrusted text and tries to translate it into action. Some fraction of attacks and failures will land. Your goal is to make those failures bounded, observable, and recoverable.

1) **Permissioning / data authorization is the anchor because it defines blast radius.**  
This is not “the solution” to adversarial attacks. It is the most reliable way to prevent inevitable failures from becoming a silent enterprise data breach. Treat retrieval and tool access as privileged operations; authorize *before* retrieve/summarize; and keep an explicit model of “effective exposure vs expected access.”  [oai_citation:22‡OWASP Gen AI Security Project](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)

2) **Use capability security for tools (and separate read vs write).**  
Assume the model can be manipulated into calling tools. Minimize what tools can do, require higher assurance for state changes, and gate high-risk actions (sharing/exporting/emailing/posting). This aligns with real agent-security architecture trends.  [oai_citation:23‡Google Online Security Blog](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)

3) **Isolate untrusted content and add independent action vetting.**  
The Chrome “alignment critic” pattern is notable: evaluate actions based on structured metadata in a context isolated from untrusted content, and use isolation boundaries (origins) to prevent broad interaction.  [oai_citation:24‡Google Online Security Blog](https://security.googleblog.com/2025/12/architecting-security-for-agentic.html)

4) **Treat RAG as an adversarial surface area with provenance and regression tests.**  
Benchmarks like SafeRAG are useful precisely because they let you test your full pipeline. Combine that with operational controls: provenance, sensitive-domain handling, filtering, and monitoring.  [oai_citation:25‡arXiv](https://arxiv.org/abs/2501.18636)

5) **Measure against adaptive attacks, not just curated prompts.**  
If you deploy defenses against indirect prompt injection, evaluate with adaptive methods and keep those tests in CI as models and prompts change.  [oai_citation:26‡arXiv](https://arxiv.org/abs/2503.00061?utm_source=chatgpt.com)

6) **Instrument everything: retrieval traces, tool calls, and sensitive-domain access.**  
Treat agents like any other privileged system: logs, alerts, anomaly detection, and an incident response playbook that includes revocation and remediation.

---

## A subtle enterprise lens (relevant to Polar Sky, without over-claiming)
If I had to pick one “anchor” that reliably reduces real-world harm across all the 2025 failure modes, it would be:

> When (not if) something goes wrong, **permissioning and authorization determine whether it’s a minor policy violation or a material breach.**

2025’s research and incidents increasingly point to the same reality: LLMs and agents are accelerators. They accelerate useful work—but they also accelerate discovery and exploitation of whatever your **unstructured data access posture** already is.

That’s why “authorize-before-retrieve” and “least privilege for tools” are not niche product concerns. They are foundational blast-radius controls in an ecosystem where prompt injection and poisoned context are structural risks, not rare bugs.

---

## Reference URLs (for copying into your own notes)

(These are the primary sources I leaned on most heavily above.)

- NCSC: “Prompt injection is not SQL injection (it may be worse)”
- OWASP GenAI: LLM01:2025 Prompt Injection
- Google Security Blog: “Architecting Security for Agentic Capabilities in Chrome”
- “Defeating Prompt Injections by Design” (CaMeL) (arXiv 2503.18813)
- AgentDojo (NeurIPS 2024 benchmark environment for agent prompt injection)
- “Adaptive Attacks Break Defenses Against Indirect Prompt Injection Attacks on LLM Agents” (arXiv 2503.00061 / NAACL Findings 2025)
- “SafeRAG: Benchmarking Security in Retrieval-Augmented Generation” (arXiv 2501.18636)
- “System Prompt Poisoning” (arXiv 2505.06493)
- “MCP Tool Poisoning: Taking over your Favorite MCP Client” (Apr 2025)
- “MCPTox: A Benchmark for Tool Poisoning Attack on Real-World MCP Servers” (arXiv 2508.14925)
- AppOmni AO Labs: “Exploiting Agent-to-Agent Discovery via Prompt Injection” (ServiceNow / Now Assist)
- Embrace The Red: “The Normalization of Deviance in AI”
- Lenny’s Podcast: “The coming AI security crisis (and what to do about it) | Sander Schulhoff”