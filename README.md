# EC2-API-PROJECT

## Project Overview
This project involves developing a simple API using a preferred programming language and a relational database management system (RDBMS). The API is deployed on an AWS EC2 instance and provides endpoints for student information retrieval.

## Features
- **Endpoint 1: `/students`**
  - Returns a JSON response containing a minimum of 10 students.
  - Each student includes their **name** and **enrolled program**.

- **Endpoint 2: `/students`**
  - Returns JSON data for a specific student identified by their **ID**.
  - Data includes **name**, **enrolled program**, and **scores** for each subject.

## Technologies Used    
- **Backend:** (Express Node.js)
- **Version Control:** Git, GitHub
- **Deployment:** AWS EC2, Nginx/Apache

## Setup & Installation
1. **Clone the repository:**
   git clone https://github.com/RACHEL-MAZE/DEPLOYMENT-PROJECT
   cd DEPLOYMENT-PROJECT

2. Install dependencies (if applicable):
   npm install  # For Node.js projects

3. run the project
   locally: node index.js
   live: endpoint1(http://13.60.240.254:5001/students) && endpoint2(http://13.60.240.254:5001/subjects)
