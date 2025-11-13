#!/bin/bash

# Default values
REMOTE="origin"
PREFIX="foo"
TARGET_DATE=""
DRY_RUN=true

# Function to display usage
usage() {
    echo "Usage: $0 [--remote <remote>] --date <date> [--prefix <prefix>] [--force]"
    echo "  --remote   Specify remote name (default: origin)"
    echo "  --date     Target date (YYYY-MM-DD)"
    echo "  --prefix   Commit prefix to match (default: foo)"
    echo "  --force    Actually perform deletion (default: dry-run)"
	echo ""
	echo "Examples:"
	echo "./git_delete_closed_remote_branch.sh --date 2023-01-01 --prefix 'DEPRECATED'"
	echo "./git_delete_closed_remote_branch.sh --remote upstream --date 2023-01-01 --force"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remote)
            REMOTE="$2"
            shift 2
            ;;
        --date)
            TARGET_DATE="$2"
            shift 2
            ;;
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        --force)
            DRY_RUN=false
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$TARGET_DATE" ]]; then
    echo "Error: --date argument is required"
    usage
fi

# Convert target date to timestamp
TARGET_TS=$(date -d "$TARGET_DATE" +%s 2>/dev/null)
if [[ -z "$TARGET_TS" ]]; then
    echo "Error: Invalid date format. Use YYYY-MM-DD."
    exit 1
fi

# Check git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not a git repository"
    exit 1
fi

# Fetch all remote branches
echo "Fetching remote branches from $REMOTE..."
git fetch "$REMOTE" --prune

# Get default branch to protect it
DEFAULT_BRANCH=$(git remote show "$REMOTE" | awk '/HEAD branch/ {print $3}')
if [[ -z "$DEFAULT_BRANCH" ]]; then
    echo "Error: Could not determine default branch"
    exit 1
fi

# Process branches
git for-each-ref --format='%(refname:short)' "refs/remotes/$REMOTE" | while read -r branch; do
    # Remove remote prefix
    branch_name="${branch#$REMOTE/}"

    # Skip default branch
    if [[ "$branch_name" == "$DEFAULT_BRANCH" ]]; then
        continue
    fi

    # Get commit details
    commit_info=$(git log -1 --format="%s|%ct" "$branch")
    commit_subject="${commit_info%%|*}"
    commit_ts="${commit_info#*|}"

    # Check conditions
    if [[ "$commit_subject" == "$PREFIX"* ]] && [[ "$commit_ts" -lt "$TARGET_TS" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            echo "DRY-RUN: Would delete $branch_name (Last commit: '$commit_subject' on $(date -d @"$commit_ts"))"
        else
            echo "Deleting $branch_name (Last commit: '$commit_subject' on $(date -d @"$commit_ts"))"
            git push "$REMOTE" --delete "$branch_name"
        fi
    fi
done
