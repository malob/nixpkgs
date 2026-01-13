#!/bin/bash
# query-models.sh - Query Vercel AI Gateway models
# Usage:
#   query-models.sh list              - List all model IDs with provider
#   query-models.sh providers         - List all providers
#   query-models.sh tags              - List all unique tags
#   query-models.sh --provider NAME   - List models from a specific provider
#   query-models.sh --tag TAG         - List models with a specific tag
#   query-models.sh --details ID      - Show full details for a model

set -euo pipefail

MODELS_URL="https://ai-gateway.vercel.sh/v1/models"
ACTION="${1:-list}"

# Fetch models data
models_json=$(curl -s "$MODELS_URL")

case "$ACTION" in
  list)
    # List all models with provider
    echo "$models_json" | jq -r '.data[] | "\(.id) (\(.owned_by))"' | sort
    ;;

  providers)
    # List unique providers
    echo "$models_json" | jq -r '.data[].owned_by' | sort -u
    ;;

  tags)
    # List unique tags
    echo "$models_json" | jq -r '.data[].tags[]?' | sort -u
    ;;

  --provider)
    if [[ $# -lt 2 ]]; then
      echo "Usage: query-models.sh --provider NAME"
      exit 1
    fi
    PROVIDER="$2"
    echo "$models_json" | jq -r --arg p "$PROVIDER" '.data[] | select(.owned_by == $p) | "\(.id)"' | sort
    ;;

  --tag)
    if [[ $# -lt 2 ]]; then
      echo "Usage: query-models.sh --tag TAG"
      exit 1
    fi
    TAG="$2"
    echo "$models_json" | jq -r --arg t "$TAG" '.data[] | select(.tags[]? == $t) | "\(.id) (\(.owned_by))"' | sort
    ;;

  --details)
    if [[ $# -lt 2 ]]; then
      echo "Usage: query-models.sh --details MODEL_ID"
      exit 1
    fi
    MODEL_ID="$2"
    echo "$models_json" | jq --arg id "$MODEL_ID" '.data[] | select(.id == $id)'
    ;;

  *)
    echo "Unknown action: $ACTION"
    echo "Usage:"
    echo "  query-models.sh list              - List all model IDs with provider"
    echo "  query-models.sh providers         - List all providers"
    echo "  query-models.sh tags              - List all unique tags"
    echo "  query-models.sh --provider NAME   - List models from a specific provider"
    echo "  query-models.sh --tag TAG         - List models with a specific tag"
    echo "  query-models.sh --details ID      - Show full details for a model"
    exit 1
    ;;
esac
