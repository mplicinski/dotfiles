cat > .gitignore << 'EOF'
.DS_Store
*.swp
*.swo
*.log

# Neovim generated runtime/state
nvim/.config/nvim/plugin/
nvim/.config/nvim/lua_generated/
EOF
