#!/usr/bin/env node
const { execSync } = require('child_process');
const path = require('path');

const scriptPath = path.join(__dirname, 'gptbash.sh');
execSync(`bash ${scriptPath}`, { stdio: 'inherit' });
