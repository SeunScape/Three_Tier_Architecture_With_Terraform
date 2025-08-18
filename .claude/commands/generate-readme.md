# Slash Command Steps for README Generation

## Step 1: Create the slash command file
Create `.claude/write-readme.md` in your repository:

```markdown
---
name: write-readme
description: Generate a README.md file for the Terraform project
---

Generate a README.md file for this Terraform project with these sections:

1. **Project Title and Description** (2-3 lines)
   - What it does
   - Tech stack (Terraform, AWS)

2. **Architecture** (brief overview)
   - Two-tier application structure
   - Key AWS services used

3. **Prerequisites**
   - Terraform version
   - AWS CLI
   - AWS account requirements

4. **Project Structure** (tree view)
   - Brief explanation of main folders

5. **Quick Start**
   - Clone repo
   - Configure AWS credentials
   - Deploy to staging
   - Access application

6. **Available Environments**
   - Stage
   - Prod

Keep it concise and practical. Use code blocks for commands. No elaborate explanations.
```

## Step 2: Run the command
```bash
# In your project root
claude code --use .claude/write-readme.md
```

## Step 3: Review and customize
The command will generate a README.md with:
- Clear project overview
- Simple setup instructions  
- Essential commands only
- No unnecessary details


## Step 4: 
Create a descriptive commit message
Push and create a PR


## Tips for the slash command:
1. Keep sections short and actionable
2. Include only commands users will actually use
3. Focus on getting started quickly
4. Add warnings only for critical items (like destroy in prod)
5. Use the existing CLAUDE.md for detailed documentation reference