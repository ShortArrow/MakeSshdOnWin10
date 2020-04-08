@echo off
echo "Make SSHD!!"
pushd %~dp0
pwsh -Noprofile -ExecutionPolicy RemoteSigned -File ./main.ps1
pause > nul
exit