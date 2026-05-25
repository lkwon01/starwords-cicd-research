# StarWords Korean

StarWords Korean is a cloud-hosted Korean language learning web application designed to make beginner Korean practice more interactive, mission-based, and engaging.

The project combines language learning, AI-assisted content, cloud deployment, infrastructure automation, and CI/CD practices. It is being developed as both a learning platform and a technical portfolio project focused on cloud-native application design.

## Live Site

- Production: https://starwordskorean.com
- Development: https://dev.starwordskorean.com

## Project Overview

StarWords Korean is designed for beginner Korean learners, heritage learners, and students who want a more engaging way to practice vocabulary, phrases, and short missions.

The long-term vision is to create a game-inspired Korean learning platform where users can complete missions, review vocabulary, hear Korean pronunciation, and track progress over time.

## Key Features

Current and planned features include:

- Beginner Korean learning missions
- Vocabulary and phrase practice
- Interactive lesson content
- Korean language learning pages
- Frontend hosted through AWS S3 and CloudFront
- Development and production deployment environments
- Backend API planning with AWS Lambda and API Gateway
- Progress tracking design using DynamoDB
- Infrastructure-as-Code using Terraform
- Automated deployment using GitHub Actions

## Technical Highlights

This project demonstrates hands-on experience with:

- Static website hosting on AWS S3
- CloudFront CDN distribution
- Custom domain routing
- HTTPS/TLS certificate setup
- GitHub Actions CI/CD workflow
- AWS IAM permissions and least-privilege deployment roles
- Terraform infrastructure planning
- Serverless backend architecture
- Frontend/backend project organization
- Dev and production environment separation

## Tech Stack

### Frontend

- HTML
- CSS
- JavaScript
- Static website architecture

### Backend

- Python
- AWS Lambda
- API Gateway
- DynamoDB

### Cloud and DevOps

- AWS S3
- AWS CloudFront
- AWS IAM
- AWS Route 53 / DNS
- AWS Certificate Manager
- Terraform
- GitHub Actions
- CI/CD deployment pipelines

## Repository Structure

```text
StarWords/
│
├── .github/
│   └── workflows/
│       └── GitHub Actions deployment workflows
│
├── backend/
│   └── Backend API and serverless application code
│
├── content/
│   └── Lesson and learning content
│
├── frontend/
│   └── Frontend website files
│
├── infra/
│   └── Terraform infrastructure files
│
├── .gitignore
├── main.py
└── README.md
```

## Cloud Architecture

StarWords Korean uses a cloud-native architecture designed for scalability, low maintenance, and secure deployment.

```text
User
 │
 ▼
CloudFront CDN
 │
 ▼
S3 Static Website Frontend
 │
 ▼
API Gateway
 │
 ▼
AWS Lambda
 │
 ▼
DynamoDB
```

## CI/CD Workflow

The project uses GitHub Actions to automate deployment.

Planned deployment flow:

```text
Push to GitHub
      │
      ▼
GitHub Actions Workflow
      │
      ▼
Assume AWS IAM Role using OIDC
      │
      ▼
Deploy frontend files to S3
      │
      ▼
Create CloudFront invalidation
      │
      ▼
Updated site is available online
```

This demonstrates a real-world DevOps workflow using source control, automated deployment, AWS permissions, and environment-based release management.

## Infrastructure as Code

The `infra` folder contains Terraform configuration for managing cloud resources.

Infrastructure-as-Code helps make the project:

- Repeatable
- Documented
- Easier to maintain
- Safer to update
- More aligned with professional cloud engineering practices

## Security Practices

Security considerations in this project include:

- HTTPS with AWS Certificate Manager
- CloudFront in front of the frontend application
- IAM roles for GitHub Actions deployment
- OIDC authentication instead of long-term AWS access keys
- Separation between development and production environments
- Least-privilege permissions for deployment workflows

## Why I Built This Project

I built StarWords Korean to combine my interests in language learning, cloud engineering, automation, and software development.

The project allows me to practice real-world platform engineering skills, including:

- Designing a cloud-hosted application
- Building CI/CD deployment workflows
- Managing AWS infrastructure
- Organizing frontend, backend, and infrastructure code
- Thinking about scalability, security, and maintainability
- Applying software engineering concepts to a meaningful product

## Research and Portfolio Focus

StarWords Korean is also being used as a platform for studying cloud-native application design.

Areas of focus include:

- Cloud vs. traditional hosting tradeoffs
- Serverless architecture benefits
- Deployment automation
- Infrastructure reliability
- Performance through CDN caching
- Security improvements through managed cloud services
- Operational efficiency using managed AWS services

## Future Improvements

Planned improvements include:

- Add user progress tracking
- Add DynamoDB-backed lesson completion records
- Expand backend API functionality
- Add Korean text-to-speech support
- Add more interactive missions
- Improve UI/UX for younger learners
- Add observability with CloudWatch metrics and logs
- Add automated testing before deployment
- Improve Terraform environment separation
- Add screenshots and architecture diagrams




