#!/bin/bash
# install:
# 1. save it to /usr/local/bin/gptbash
# 2. make it executable: chmod +x /usr/local/bin/gptb
# 3. add environment OPENAI_API_KEY=sk-...
#
# usage: POSTFIX="on ubuntu" gptb what you need for from bash

set -eu

# check is OPENAI_API_KEY set
if [ -z "${OPENAI_API_KEY:-}" ]; then
    echo "OPENAI_API_KEY is not set"
    echo ""
    echo "Get it from https://platform.openai.com/api-keys"
    echo "And add to your ~/.bashrc or ~/.zshrc"
    echo "export OPENAI_API_KEY=sk-..."
    echo ""
    echo "Or run this script with OPENAI_API_KEY=sk-... prefix"
    exit 1
fi

# if help command

if [ "$1" = "help" ]; then
    echo "Usage: npx gptbash what you need for from bash"
    exit 0
fi

PREFIX="${PREFIX:-how to}"
POSTFIX="${POSTFIX:-in bash, one-liner}"
out_file=$(mktemp -t gptb-XXXX)
trap 'rm -f "$out_file"' EXIT

p="$PREFIX $@ $POSTFIX"
p="You are bash script. Command you will return should be possible to execute in one confirmation click without changes and replacements. Use current \".\" directory in examples if another is not provided. Users request: \"$p\" Bash one line command:"
echo "$p"
npx chatgpt "$p" | tee -a "$out_file"
cmd="$(cat $out_file | grep '```' -A1 | sed -n 2p)"

echo -e "\033[0;37m${cmd}\033[0m"

while true; do
    read -p "Run this command? (y/n) " yn
    case $yn in
        [Yy]* ) eval "cd $PWD && $cmd"; break;;
        [Nn]* ) echo "No, exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# 1 of 100 random usages - print out greeting

if [ $((RANDOM % 100)) -eq 0 ]; then
  echo "Made with love by Solving LLC: https://solving.llc/"
  echo ""
  echo "Follow us on LinkedIn: https://www.linkedin.com/company/solving-llc/"
  echo ""
  echo "Connect with author: http://ceo.solving.llc"
  echo ""
  echo "Welcome to contribute: https://github.com/Solving-LLC/gptbash"
fi