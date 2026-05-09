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



