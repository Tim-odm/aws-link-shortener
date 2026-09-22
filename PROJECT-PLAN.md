# Portfolio Project Plan: Self-Healing, Observable Microservices Platform on AWS EKS

**Time budget:** 6 hours/week for 12 weeks (~72 hours total)
**Target sector:** Cloud infrastructure / platform engineering / SRE (graduate-level)
**Cloud provider:** AWS

---

## 1. Project Overview

### 1.1 The Pitch

> Designed and deployed a production-style Kubernetes platform on AWS EKS with full infrastructure-as-code provisioning, GitOps-based deployments, and a Prometheus/Grafana observability stack including custom alerting and SLO dashboards.

### 1.2 Why This Project

Most new-grad portfolios contain either (a) a single tutorial-cloned app with no infrastructure story, or (b) a scattered collection of unrelated one-off demos. This project avoids both traps by combining several core cloud infrastructure competencies into a single coherent narrative:

- **Infrastructure as Code** — Terraform, modules, remote state
- **Container orchestration** — Kubernetes on EKS
- **GitOps / CD** — ArgoCD-driven deployments
- **CI** — automated build, test, and image publishing
- **Observability** — Prometheus, Grafana, Loki, Alertmanager
- **Resilience engineering** — deliberate failure injection and recovery

The end result should read, to a hiring manager, like a miniature version of what a platform team actually builds and operates.

### 1.3 Why This Beats Alternative Project Ideas

- It mirrors real platform/SRE work rather than a tutorial clone.
- Kubernetes and observability together tell a coherent story: "I don't just deploy things — I know when they break and why."
- It scales with available time. Weeks can be extended into "bonus" depth (see Section 6) without requiring a new project or repo.

---

## 2. Prerequisites and Assumptions

- Comfort with Linux command line, Git, and basic networking concepts (expected given master's-level coursework).
- An AWS account with billing alerts configured (see Section 5.2 — cost control is part of the deliverable, not an afterthought).
- Local tools: `terraform`, `kubectl`, `helm`, `aws-cli`, `git`, a code editor.
- No prior hands-on EKS or ArgoCD experience is assumed — these are learned as part of the project.

---

## 3. Week-by-Week Plan

### Weeks 1–2: Foundations & Infrastructure as Code (12 hrs)

**Goal:** Stand up a working EKS cluster entirely through Terraform.

- Write Terraform configuration for:
  - VPC with public/private subnets across at least two availability zones
  - IAM roles and policies for the cluster and node groups
  - An EKS cluster with a managed node group
- Deliberately avoid `eksctl` — provisioning this by hand in Terraform is where the actual learning happens (VPC/subnet design, IAM trust relationships, security groups).
- Structure the configuration as reusable Terraform **modules** (e.g., `modules/vpc`, `modules/eks`) rather than one flat file.
- Configure **remote state** in S3 with state locking via DynamoDB.

**Deliverable:** Running `terraform apply` from a clean checkout stands up a working, reachable EKS cluster from scratch. `terraform destroy` cleanly tears it down.

---

### Weeks 3–4: Deploy a Real (Small) Application (12 hrs)

**Goal:** Get a realistic multi-service application running on the cluster.

- Select or assemble a small multi-service application — for example, a frontend, an API service, and a datastore (Postgres or Redis). It does not need to be original; a well-known sample application is acceptable, since the infrastructure is the point of the project, not the application logic.
- Write Kubernetes manifests or Helm charts for each service.
- Configure properly, not minimally:
  - Resource **requests and limits** for every container
  - **Liveness and readiness probes**
  - Sensible **replica counts** and a basic **HorizontalPodAutoscaler**

**Deliverable:** The application runs on the cluster, survives a pod restart without manual intervention, and scales under basic load.

---

### Weeks 5–6: GitOps and Continuous Delivery (12 hrs)

**Goal:** Move from manual `kubectl apply` to a Git-driven deployment workflow.

- Install **ArgoCD** on the cluster.
- Point ArgoCD at a Git repository containing the Kubernetes manifests/Helm charts from Weeks 3–4; confirm ArgoCD auto-syncs changes.
- Set up a basic **CI pipeline** with GitHub Actions:
  1. Build the application image
  2. Run tests
  3. Push the image to a container registry (e.g., ECR)
  4. Update the manifest/Helm values so ArgoCD picks up the new version
- Document the full path from `git push` to a running change on the cluster.

**Deliverable:** A code change pushed to the application repository results in an automatic, auditable deployment — no manual `kubectl` commands required.

---

### Weeks 7–9: Observability (18 hrs)

**Goal:** Build real visibility into the platform's health and behaviour. This is the deepest section of the project, reflecting your stated interest.

- Deploy the `kube-prometheus-stack` Helm chart (Prometheus + Grafana + Alertmanager).
- **Instrument the application** with custom metrics — not just default node/pod metrics. Expose something meaningful from the application itself (e.g., request count, request duration, error rate).
- Deploy **Loki** (or an equivalent) for centralized log aggregation.
- Build at least two Grafana dashboards:
  1. **Infrastructure health** — node/pod resource usage, cluster capacity
  2. **Application SLOs** — latency, error rate, and saturation (the RED or USE method)
- Configure **Alertmanager** to route at least one meaningful alert (e.g., elevated error rate or pod crash-looping) to Slack or email.

**Deliverable:** A working observability stack that would let an on-call engineer diagnose a real incident using dashboards and logs, not `kubectl describe` guesswork.

---

### Weeks 10–11: Chaos and Resilience (12 hrs)

**Goal:** Prove the platform behaves correctly under failure, and that the observability stack catches it.

- Deliberately induce failures:
  - Kill pods manually and observe recovery
  - Saturate CPU/memory on a service and observe HPA scaling
  - Ship a deliberately broken deployment and observe the failure surfaced through dashboards/alerts
- Use the Grafana dashboards and alerts built in Weeks 7–9 to **diagnose** each induced failure — this is the "self-healing" narrative made concrete.
- Optional (time permitting): introduce **Chaos Mesh** for more structured fault injection.

**Deliverable:** A documented failure scenario, with screenshots or a short recording, showing detection → diagnosis → recovery.

---

### Week 12: Polish and Documentation (6 hrs)

**Goal:** Make the project legible to someone who has never seen it before.

- Produce an **architecture diagram** (e.g., draw.io, Excalidraw) covering the VPC/EKS layout, GitOps flow, and observability stack.
- Write a thorough **README** that explains *why* decisions were made, not only *what* was built (see Section 5.1 for structure).
- Write a **short technical write-up or blog post** walking through one interesting failure diagnosed using the observability stack. This is one of the highest-value artifacts for interviews — it demonstrates real diagnostic thinking rather than recitation of tools used.

**Deliverable:** A repository (or small set of repositories) that a reviewer can understand in under ten minutes, plus one piece of writing suitable for linking directly in a CV or cover letter.

---

## 4. Suggested Repository Structure

```
platform-infra/
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   └── eks/
│   ├── environments/
│   │   └── dev/
│   └── backend.tf          # remote state config
├── k8s/
│   ├── charts/              # Helm charts or raw manifests
│   └── argocd/               # ArgoCD Application definitions
├── app/                     # sample application source (if self-written)
├── observability/
│   ├── dashboards/           # exported Grafana JSON
│   └── alerts/                # Alertmanager rules
├── docs/
│   ├── architecture-diagram.png
│   ├── failure-scenario-writeup.md
│   └── cost-notes.md
└── README.md
```

Keeping infrastructure, application, and observability config clearly separated (but in one coherent project) makes the repository easy to navigate in a portfolio review.

---

## 5. What Makes This Stand Out to Reviewers

### 5.1 Documentation Quality

Many candidates will have a broadly similar project on paper. Documentation is frequently the actual differentiator. The README should include:

- A one-paragraph summary (the "pitch" from Section 1.1)
- The architecture diagram
- Setup/teardown instructions that genuinely work from a clean checkout
- A short "design decisions" section explaining trade-offs (e.g., why Terraform modules over a monolith, why ArgoCD over manual deploys)
- A link to the failure-scenario write-up

### 5.2 Cost Awareness

Add a short `cost-notes.md` documenting:

- Approximate AWS cost incurred over the project
- Steps taken to control it (spot instances, scaling to zero between sessions, disciplined `terraform destroy` habits, billing alarms)

Cost awareness is something many junior candidates never demonstrate, and it signals operational maturity to reviewers.

### 5.3 A Deliberate Failure Story

A clean, uneventful demo is far less compelling than: "Here is a bug or failure I deliberately introduced, here is how the dashboards and alerts surfaced it, and here is how the system (or I) recovered." This is the single most interview-friendly artifact this project produces — plan to be able to talk through it in detail.

---

## 6. Extensions if Time Allows

If the 12-week plan is completed with time to spare, or for a future iteration:

- **Policy as code** — Add OPA/Gatekeeper to enforce cluster guardrails (e.g., no containers running as root).
- **Cost dashboards** — Integrate Kubecost, or build a custom Grafana panel pulling from AWS Cost Explorer.
- **Multi-environment setup** — Add a staging environment using Terraform workspaces or separate state files, and extend the GitOps flow to promote between environments.

---

## 7. Time Budget Summary

| Phase | Weeks | Hours |
|---|---|---|
| Foundations & IaC | 1–2 | 12 |
| Application deployment | 3–4 | 12 |
| GitOps & CI/CD | 5–6 | 12 |
| Observability | 7–9 | 18 |
| Chaos & resilience | 10–11 | 12 |
| Polish & documentation | 12 | 6 |
| **Total** | **12 weeks** | **72 hours** |
