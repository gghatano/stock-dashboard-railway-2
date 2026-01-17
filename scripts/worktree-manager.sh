#!/bin/bash

# Worktree統合管理スクリプト

set -e

COMMAND=$1
FEATURE_NAME=$2

show_usage() {
    cat << USAGE
Usage: $0 <command> [feature-name]

Commands:
  create <name>     - 新しいWorktreeを作成
  list              - Worktree一覧を表示
  status <name>     - Worktreeの状態を表示
  sync <name>       - mainブランチの変更を取り込む
  cleanup <name>    - Worktreeを削除
  prune             - 不要なWorktreeをクリーンアップ
  help              - このヘルプを表示
  
Examples:
  $0 create user-auth
  $0 list
  $0 status user-auth
  $0 sync user-auth
  $0 cleanup user-auth
  $0 prune
USAGE
}

create_worktree() {
    local name=$1
    local branch="feature/${name}"
    local path="worktrees/${name}"
    
    if [ -d "${path}" ]; then
        echo "❌ Worktree already exists: ${path}"
        exit 1
    fi
    
    echo "📁 Creating worktree: ${path}"
    echo "🌿 Branch: ${branch}"
    echo ""
    
    mkdir -p worktrees
    git worktree add "${path}" -b "${branch}"
    
    echo ""
    echo "✅ Worktree created successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. cd ${path}"
    echo "  2. code ."
    echo "  3. /arch ${name} の詳細設計を作成"
    echo "  4. /eng 実装を開始"
}

list_worktrees() {
    echo "📋 Current worktrees:"
    echo ""
    git worktree list
    echo ""
    
    local count=$(git worktree list | wc -l)
    echo "Total: $((count - 1)) worktree(s) (excluding main)"
}

status_worktree() {
    local name=$1
    local path="worktrees/${name}"
    
    if [ ! -d "${path}" ]; then
        echo "❌ Worktree not found: ${path}"
        exit 1
    fi
    
    echo "📊 Worktree status: ${name}"
    echo ""
    
    cd "${path}"
    
    echo "📍 Location: ${path}"
    echo ""
    
    echo "🌿 Branch:"
    git branch --show-current
    echo ""
    
    echo "📝 Status:"
    git status --short
    if [ -z "$(git status --short)" ]; then
        echo "  (no changes)"
    fi
    echo ""
    
    echo "📜 Recent commits:"
    git log --oneline -5
    echo ""
    
    echo "🔄 Sync status:"
    git fetch origin main --quiet
    local behind=$(git rev-list --count HEAD..origin/main)
    local ahead=$(git rev-list --count origin/main..HEAD)
    
    if [ "$behind" -gt 0 ]; then
        echo "  ⚠️  Behind main by ${behind} commit(s)"
        echo "  Run: ./scripts/worktree-manager.sh sync ${name}"
    else
        echo "  ✅ Up to date with main"
    fi
    
    if [ "$ahead" -gt 0 ]; then
        echo "  📤 Ahead of main by ${ahead} commit(s)"
    fi
}

sync_worktree() {
    local name=$1
    local path="worktrees/${name}"
    local branch="feature/${name}"
    
    if [ ! -d "${path}" ]; then
        echo "❌ Worktree not found: ${path}"
        exit 1
    fi
    
    echo "🔄 Syncing ${name} with main..."
    echo ""
    
    cd "${path}"
    
    # 変更があるか確認
    if ! git diff-index --quiet HEAD --; then
        echo "⚠️  Uncommitted changes detected."
        echo ""
        git status --short
        echo ""
        echo "Please commit or stash your changes first:"
        echo "  git add ."
        echo "  git commit -m 'WIP: ...'"
        echo "  or"
        echo "  git stash"
        exit 1
    fi
    
    # mainから変更を取り込む
    echo "Fetching latest main..."
    git fetch origin main
    
    echo "Rebasing on main..."
    if git rebase origin/main; then
        echo ""
        echo "✅ Sync completed successfully!"
    else
        echo ""
        echo "❌ Rebase conflicts detected."
        echo "Please resolve conflicts and run:"
        echo "  git rebase --continue"
        echo "or abort with:"
        echo "  git rebase --abort"
        exit 1
    fi
}

cleanup_worktree() {
    local name=$1
    local path="worktrees/${name}"
    local branch="feature/${name}"
    
    if [ ! -d "${path}" ]; then
        echo "❌ Worktree not found: ${path}"
        exit 1
    fi
    
    echo "🗑️  Cleanup worktree: ${name}"
    echo ""
    
    # 変更があるか確認
    cd "${path}"
    if ! git diff-index --quiet HEAD --; then
        echo "⚠️  Uncommitted changes detected:"
        echo ""
        git status --short
        echo ""
        read -p "Are you sure you want to remove this worktree? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cancelled."
            exit 0
        fi
    fi
    
    cd ../..
    
    echo "Removing worktree: ${path}"
    git worktree remove "${path}"
    echo "✅ Worktree removed"
    echo ""
    
    # ブランチ削除確認
    read -p "Delete branch ${branch}? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if git branch -d "${branch}" 2>/dev/null; then
            echo "✅ Branch deleted: ${branch}"
        else
            echo "⚠️  Branch has unmerged changes."
            read -p "Force delete? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git branch -D "${branch}"
                echo "✅ Branch force deleted: ${branch}"
            else
                echo "ℹ️  Branch kept: ${branch}"
            fi
        fi
    else
        echo "ℹ️  Branch kept: ${branch}"
    fi
    
    echo ""
    echo "✅ Cleanup completed!"
}

prune_worktrees() {
    echo "🧹 Pruning worktrees..."
    echo ""
    
    git worktree prune --verbose
    
    echo ""
    echo "✅ Prune completed!"
}

# メインロジック
case $COMMAND in
    create)
        if [ -z "$FEATURE_NAME" ]; then
            echo "❌ Feature name required"
            echo ""
            show_usage
            exit 1
        fi
        create_worktree "$FEATURE_NAME"
        ;;
    list)
        list_worktrees
        ;;
    status)
        if [ -z "$FEATURE_NAME" ]; then
            echo "❌ Feature name required"
            echo ""
            show_usage
            exit 1
        fi
        status_worktree "$FEATURE_NAME"
        ;;
    sync)
        if [ -z "$FEATURE_NAME" ]; then
            echo "❌ Feature name required"
            echo ""
            show_usage
            exit 1
        fi
        sync_worktree "$FEATURE_NAME"
        ;;
    cleanup)
        if [ -z "$FEATURE_NAME" ]; then
            echo "❌ Feature name required"
            echo ""
            show_usage
            exit 1
        fi
        cleanup_worktree "$FEATURE_NAME"
        ;;
    prune)
        prune_worktrees
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_usage
        exit 1
        ;;
esac
