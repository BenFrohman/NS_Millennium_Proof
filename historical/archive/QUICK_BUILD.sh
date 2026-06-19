#!/bin/bash

# Quick build script for NS_Millennium_Proof (Frohmanian Symplectic Tether)

echo "Building Frohmanian Symplectic Tether formalization..."
echo ""

# Navigate to the local clean copy
cd ~/lean-projects/NS_Millennium_Proof

# Show current directory
echo "Working directory: $(pwd)"
echo ""

# Show files
echo "Project structure:"
ls -la | grep -E '\.lean|lakefile|lean-toolchain|Modules'
echo ""

# Build
echo "Running: lake build"
echo ""
lake build


