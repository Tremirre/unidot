#!/bin/bash

# GPU utilization script for Waybar
# Supports NVIDIA and Intel GPUs

# Check for NVIDIA GPU
if command -v nvidia-smi &>/dev/null; then
    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ' ')
    if [[ -n "$usage" && "$usage" != "" ]]; then
        echo "$usage"
        exit 0
    fi
fi

# Check for Intel GPU (via sysfs)
for card in /sys/class/drm/card*/device/gpu_busy_percent; do
    if [[ -f "$card" ]]; then
        cat "$card"
        exit 0
    fi
done

# Fallback - no supported GPU detected
echo "N/A"
