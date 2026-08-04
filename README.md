# Star Words CI/CD Research

## Project Title

Measuring the Efficiency of CI/CD Pipeline Automation for Cloud Application Deployment: A Case Study Using the Star Words Application

## Project Overview

This repository contains the research materials for a supervised cloud and DevOps research project focused on measuring the efficiency of CI/CD pipeline automation.

The project uses the Star Words Korean learning application as a case study to compare manual deployment with automated CI/CD deployment. The research focuses on deployment time, number of manual steps, repeatability, validation, reliability, operational effort, and basic security checks.

## Application Environments

* Production environment: `https://starwordskorean.com`
* Development environment: `https://dev.starworkdskorean.com`

The development environment will be used for CI/CD testing before promotion to production.

## Research Question

How does an automated CI/CD pipeline improve the efficiency, reliability, and repeatability of deploying a cloud-hosted web application compared with a manual deployment process?

## Research Objectives

1. Document the manual deployment workflow for Star Words.
2. Build or improve a CI/CD deployment pipeline.
3. Use Python scripts to validate deployments and collect measurable results.
4. Compare manual deployment and automated deployment using defined metrics.
5. Analyze deployment time, manual effort, repeatability, validation, and reliability.
6. Produce a final report and presentation of findings.

## Repository Structure

```text
starwords-cicd-research/
├── proposal/           # Research proposal drafts and final proposal
├── experiment-plan/    # Metrics, test plan, and experiment design
├── data/               # CSV or JSON files from deployment tests
├── scripts/            # Python scripts for analysis and reporting
├── charts/             # Generated charts and visual results
├── final-report/       # Final research paper/report
├── presentation/       # Slides for supervisor, UVA, or work presentation
├── screenshots/        # Pipeline screenshots and deployment evidence
└── docs/               # Supporting notes and documentation
```

## Planned Metrics

The project will compare manual deployment and CI/CD deployment using metrics such as:

* Total deployment time
* Number of manual steps
* Number of manual error points
* Deployment success rate
* Post-deployment validation results
* Application availability after deployment
* Response time after deployment
* Basic security validation
* Estimated operational effort saved

## Python Script Plan

Planned Python scripts may include:

* `deployment_timer.py`
* `availability_checker.py`
* `post_deploy_validator.py`
* `latency_checker.py`
* `security_header_checker.py`
* `cost_time_calculator.py`
* `report_generator.py`

## Expected Deliverables

* Research proposal
* Manual deployment baseline
* CI/CD deployment workflow
* Python validation scripts
* Deployment test data
* Charts and comparison tables
* Final report
* Presentation slides
