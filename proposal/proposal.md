# Measuring the Efficiency of CI/CD Pipeline Automation for Cloud Application Deployment

## A Case Study Using the Star Words Application

**Student:** Laura Collins  
**Project Type:** Supervised Research Proposal  
**Application:** Star Words Korean Learning Application  

---

## Proposed Research Topic

One of the major challenges in modern software development is making applications available anytime and anywhere while keeping deployment processes low-cost, secure, repeatable, and reliable. This challenge is becoming even more important as organizations move applications to the cloud and as AI-enabled applications require faster, more frequent, and more reliable updates.

A common problem in software development is that deployment processes are often manual, inconsistent, and difficult to measure. Manual deployment may work for a small application at first, but it can introduce risk as the application grows. Human error, missed steps, lack of validation, unclear rollback procedures, and limited deployment records can reduce confidence in the release process.

This research project will evaluate how CI/CD pipeline automation can improve the efficiency, reliability, and repeatability of deploying a cloud-hosted web application. The Star Words Korean learning application will be used as the case study.

The project will compare two deployment approaches:

1. Manual deployment process
2. Automated CI/CD deployment pipeline

The goal is to determine how much efficiency is gained when deployment is automated and supported by Python-based validation scripts.

---

## Research Question

How does an automated CI/CD pipeline improve the efficiency, reliability, and repeatability of deploying a cloud-hosted web application compared with a manual deployment process?

---

## Background and Motivation

Modern cloud-hosted applications require reliable deployment processes. Users expect applications to be available anytime and anywhere. At the same time, organizations must control cost, maintain security, and reduce operational risk.

Manual deployment can create several problems:

- Deployment steps may be inconsistent.
- Human error may cause incorrect files to be deployed.
- Cache invalidation may be forgotten.
- Development and production environments may be confused.
- Post-deployment testing may be incomplete.
- Deployment history may not be clearly documented.
- Recovery from failed deployment may take longer.

CI/CD pipelines help solve these problems by automating build, validation, deployment, testing, and logging. However, the benefit of CI/CD automation should be measured rather than assumed.

This research will use the Star Words application to measure the difference between manual deployment and automated CI/CD deployment.

---

## Application Used for Research

Star Words is a Korean language learning web application designed to help users learn Korean vocabulary through a gamified educational experience. It includes web pages, lesson content, audio features, and user-facing learning material.

Star Words is a suitable case study because it is a real application with production and development environments. This allows the research to evaluate deployment automation using a practical application rather than a sample-only project.

---

## Application Environments

The research will use two environments:

| Environment | URL | Purpose |
|---|---|---|
| Production | https://starwordskorean.com | Public-facing production environment |
| Development | https://dev.starworkdskorean.com | Testing environment for CI/CD validation before production deployment |

The development environment will be used first for testing and validation. After successful validation, the production environment can be updated.

---

## Research Objectives

The objectives of this project are to:

1. Document the current manual deployment workflow for Star Words.
2. Identify manual steps, decision points, and possible error points.
3. Build or improve an automated CI/CD deployment pipeline.
4. Use Python scripts to validate deployments and collect measurable results.
5. Compare manual deployment and automated CI/CD deployment.
6. Analyze deployment time, manual effort, repeatability, reliability, and validation quality.
7. Produce a final report with charts, data, findings, and recommendations.

---

## Proposed Methodology

### 1. Manual Deployment Baseline

The first phase will document the current manual deployment process.

This may include:

- Preparing updated application files
- Uploading files manually
- Updating the hosting environment
- Clearing or invalidating cache
- Opening the application in a browser
- Checking important pages manually
- Recording whether the deployment succeeded

The manual process will be measured using:

- Total deployment time
- Number of manual steps
- Number of possible human error points
- Time required for post-deployment validation
- Quality of deployment records

---

### 2. Automated CI/CD Pipeline

The second phase will build or improve an automated CI/CD deployment pipeline.

The proposed pipeline flow is:

Git push -> validation -> deploy to development -> Python checks -> production deployment -> Python checks -> deployment record

The pipeline may include:

- Automatic trigger from code changes
- Basic validation
- Deployment to development environment
- Post-deployment Python checks
- Optional production deployment after successful development validation
- Deployment logging

The goal is not to build a large enterprise pipeline. The goal is to build a realistic, measurable, and repeatable deployment workflow.

---

### 3. Python-Based Validation and Measurement

Python scripting will be used as the measurement and validation layer.

Planned Python scripts may include:

| Script | Purpose |
|---|---|
| deployment_timer.py | Measures deployment duration |
| availability_checker.py | Checks whether the app is reachable |
| post_deploy_validator.py | Validates important pages after deployment |
| latency_checker.py | Measures response time |
| security_header_checker.py | Checks basic HTTPS and security headers |
| cost_time_calculator.py | Estimates time and labor savings |
| report_generator.py | Generates charts and summary reports |

Python will help make the project measurable and repeatable.

---

## Deployment Efficiency Metrics

The project will compare manual deployment and CI/CD deployment using the following metrics:

| Category | Example Metrics |
|---|---|
| Deployment Time | Time from code change to live application |
| Manual Effort | Number of manual steps required |
| Repeatability | Whether the process runs the same way each time |
| Reliability | Deployment success rate |
| Error Risk | Number of possible manual error points |
| Verification | Manual checking vs automated validation |
| Logging | Availability of deployment history and results |
| Recovery | Ability to identify and correct failed deployment |
| Cost Efficiency | Estimated value of time saved through automation |

---

## Basic Security and Quality Checks

The CI/CD pipeline may include basic security and quality checks, such as:

- HTTPS availability
- Important pages returning HTTP 200 status
- Broken link detection for selected pages
- Basic security header review
- No exposed sensitive files
- Confirmation that required application files exist
- Confirmation that the deployment target is reachable

This research will not perform advanced penetration testing. The security portion will focus on practical deployment validation.

---

## One-Month Project Timeline

### Week 1: Baseline and Setup

- Review the current Star Words deployment process.
- Document manual deployment steps.
- Measure manual deployment time.
- Identify possible error points.
- Prepare repository structure.

### Week 2: CI/CD Pipeline Development

- Build or improve the automated CI/CD pipeline.
- Configure deployment to the development environment.
- Add deployment validation steps.
- Test pipeline execution.

### Week 3: Python Validation and Data Collection

- Create Python validation scripts.
- Run manual deployment tests.
- Run CI/CD deployment tests.
- Collect timing, validation, and reliability data.

### Week 4: Analysis and Final Report

- Analyze manual vs automated deployment results.
- Create charts and comparison tables.
- Summarize findings.
- Write the final report.
- Prepare presentation materials.

---

## Expected Deliverables

The expected deliverables are:

1. Documented manual deployment workflow
2. Automated CI/CD deployment workflow
3. Python validation scripts
4. Deployment test data in CSV or JSON format
5. Charts comparing manual and automated deployment
6. Final research report
7. Presentation materials
8. GitHub research repository documenting the project

---

## Expected Outcome

This research is expected to show that CI/CD pipeline automation can improve deployment efficiency by reducing manual steps, lowering human error risk, improving repeatability, and providing consistent post-deployment validation.

The project may also provide a practical framework for evaluating deployment automation in larger software development, cloud migration, SaaS, and AI application environments.

---

## Project Value

This project will demonstrate practical skills in:

- Cloud application deployment
- CI/CD pipeline automation
- Python scripting
- DevOps workflow design
- Deployment validation
- Availability checking
- Basic security checks
- Data collection and analysis
- Cost and effort comparison
- Systems engineering evaluation

This project is realistic for a one-month supervised research period because it focuses on a controlled comparison between manual deployment and automated deployment using an existing application.

---

## Limitations

This project will focus on CI/CD deployment efficiency for a small cloud-hosted web application. It will not include a full enterprise SaaS architecture, Kubernetes, multi-region deployment, or complex production release management.

The security checks will be basic and focused on deployment validation rather than advanced security testing. The results will represent a controlled case study using Star Words and may need further testing before applying the conclusions to larger enterprise systems.

---

