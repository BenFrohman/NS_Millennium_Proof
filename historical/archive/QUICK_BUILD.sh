#!/bin/bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman

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


