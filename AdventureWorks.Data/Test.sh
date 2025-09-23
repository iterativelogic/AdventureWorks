#!/bin/sh

# Git hook: prepare-commit-msg
# Purpose: Pre-fill JIRA ID from branch name into commit message

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3

# Get current branch name
BRANCH_NAME=$(git symbolic-ref --short HEAD 2>/dev/null)

# Extract JIRA ID (pattern like ABC-12345)
# In your case: feature/C166801-12344/some-desc  → C166801-12344
JIRA_ID=$(echo "$BRANCH_NAME" | grep -oE '[A-Z0-9]+-[0-9]+')

# Only add if JIRA ID found and not already in message
if [ -n "$JIRA_ID" ]; then
    if ! grep -q "$JIRA_ID" "$COMMIT_MSG_FILE"; then
        sed -i.bak "1s/^/$JIRA_ID: /" "$COMMIT_MSG_FILE"
    fi
fi
