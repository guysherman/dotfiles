#!/bin/bash

devcontainer up --workspace-folder . --remove-existing-container
devcontainer exec --workspace-folder . claude --dangerously-skip-permissions --model claude-sonnet-4-6

