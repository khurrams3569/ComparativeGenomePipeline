#!/bin/bash

set -e

echo "============================="
echo " ComparativeGenomePipeline "
echo "============================="

# Load config
source config/config.sh

echo "Project: $PROJECT"
echo "Threads: $THREADS"

mkdir -p logs results

echo "Pipeline initialized successfully"
